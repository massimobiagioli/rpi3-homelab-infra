#!/usr/bin/env python3
"""
test_loki_grafana.py

Purpose
-------
Send a single log line to a Loki instance (HTTP push API) so you can verify end-to-end that
Loki ingests the log and that you can view it in Grafana.

This script tries to use `requests`. If it's not installed it will fall back to the
standard library `urllib.request`.

E2E TEST INSTRUCTIONS (step by step)
-----------------------------------
1) Preconditions (on the Raspberry Pi):
   - Loki must be running and reachable at http://localhost:3100 (default). If Loki runs on a
     different host/port set the LOKI_URL environment variable or use --loki-url.
   - Grafana must be running and have Loki configured as a data source:
       * In Grafana UI: Configuration -> Data Sources -> Add Loki
       * URL: http://<raspberrypi_ip>:3100 (or http://localhost:3100 when running locally)
       * Access: Server (default)
       * Click "Save & Test" - it should report success.

2) Run this script locally on the Raspberry Pi (or remotely if Loki accessible):
   - Make executable and run:
       chmod +x scripts/test_loki_grafana.py
       ./scripts/test_loki_grafana.py
   - Or run with python explicitly:
       python3 scripts/test_loki_grafana.py --loki-url http://localhost:3100 --message "Hello from test script"

   Optional args:
     --loki-url   : Loki push endpoint base URL (default: http://localhost:3100)
     --job         : Label `job` to attach to the stream (default: python-test)
     --message     : Log message to send (default: generated timestamped message)
     --count       : Number of messages to send (default: 1)
     --delay       : Delay in seconds between messages (default: 0)

3) Wait a few seconds for ingestion (Promtail or Loki will accept the push immediately).

4) Verify in Grafana (Explore -> Logs or "Logs" panel):
   - In Explore choose the Loki datasource.
   - Run a log query such as:
       {job="python-test"}
     or with your custom job label if you used --job.
   - Time range: select "Last 5 minutes" and click "Run query".
   - You should see the log line(s) sent by this script.

5) CURL alternative (quick test):
   - On the machine with Loki accessible you can run:
       curl -v -X POST http://localhost:3100/loki/api/v1/push \
         -H "Content-Type: application/json" \
         --data '{"streams": [{"stream": {"job": "python-test"}, "values": [["'$(date +%s%N)'", "curl test log"]]}]}'

Notes:
 - Loki push API expects timestamps in nanoseconds since epoch as strings.
 - Successful push normally returns HTTP 204 No Content.

"""

from __future__ import annotations

import argparse
import json
import socket
import sys
import time
from typing import Dict, Any


def build_payload(labels: Dict[str, str], message: str) -> Dict[str, Any]:
    """Build Loki push API payload.

    Loki expects values as array of [<ns_timestamp>, <log_line>] where timestamp is
    a string containing nanoseconds since epoch.
    """
    ts_ns = str(int(time.time() * 1_000_000_000))
    stream = {
        "stream": labels,
        "values": [[ts_ns, message]],
    }
    return {"streams": [stream]}


def send_with_requests(url: str, payload: Dict[str, Any]) -> int:
    import requests

    headers = {"Content-Type": "application/json"}
    r = requests.post(url.rstrip('/') + '/loki/api/v1/push', json=payload, headers=headers, timeout=10)
    print(f"requests: sent payload, status_code={r.status_code}")
    return r.status_code


def send_with_urllib(url: str, payload: Dict[str, Any]) -> int:
    # Fallback if requests is not installed
    import urllib.request

    data = json.dumps(payload).encode('utf-8')
    req = urllib.request.Request(url.rstrip('/') + '/loki/api/v1/push', data=data, headers={"Content-Type": "application/json"}, method='POST')
    with urllib.request.urlopen(req, timeout=10) as resp:
        status = resp.getcode()
        print(f"urllib: sent payload, status_code={status}")
        return status


def main() -> int:
    parser = argparse.ArgumentParser(description="Send a test log line to Loki push API")
    parser.add_argument('--loki-url', default='http://localhost:3100', help='Base URL of Loki (default: http://localhost:3100)')
    parser.add_argument('--job', default='python-test', help='Label `job` for the stream')
    parser.add_argument('--message', default=None, help='Log message to send')
    parser.add_argument('--count', type=int, default=1, help='Number of messages to send')
    parser.add_argument('--delay', type=float, default=0.0, help='Delay between messages in seconds')

    args = parser.parse_args()

    hostname = socket.gethostname()
    labels = {"job": args.job, "host": hostname}

    for i in range(args.count):
        msg = args.message or f"[test] loki-grafana test message from {hostname} ({i+1}/{args.count}) @ {time.strftime('%Y-%m-%d %H:%M:%S')}"
        payload = build_payload(labels, msg)

        # Try requests first
        try:
            import requests  # type: ignore
            status = send_with_requests(args.loki_url, payload)
        except Exception as e:
            print("requests not available or failed, falling back to urllib. Exception:", e)
            try:
                status = send_with_urllib(args.loki_url, payload)
            except Exception as e2:
                print("Failed to send payload with urllib as well. Exception:", e2)
                return 2

        # Loki typically responds with 204 No Content on success
        if status in (200, 204):
            query_example = json.dumps({"job": args.job})
            print(f"OK: message sent (status={status}). You should see it in Grafana Explore -> Logs with query: {query_example}")
        else:
            print(f"Unexpected status from Loki: {status}")

        if i < args.count - 1:
            time.sleep(args.delay)

    return 0


if __name__ == '__main__':
    sys.exit(main())
