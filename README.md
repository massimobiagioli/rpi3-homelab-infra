# 🏠 HomeLab Infrastructure

> 🍓 Raspberry Pi cluster management with Ansible automation

## 🔐 SSH Setup - Connecting to Raspberry Pi

### 1. 🔑 Generate SSH Key Pair

```bash
ssh-keygen -t rsa -b 2048
```

💡 Save the key in a secure location (e.g., `~/.ssh/id_rsa`)

### 2. 📤 Copy Public Key to Raspberry Pi

```bash
ssh-copy-id massimo@raspberry_pi_ip_address
```

🔄 Replace `massimo` with your username and `raspberry_pi_ip_address` with your Pi's IP

### 3. 🚀 Connect Using Public Key

```bash
ssh massimo@raspberry_pi_ip_address
```

✅ You should now connect without entering a password!

## ⚙️ Configuration Setup

### 📋 Inventory Configuration

```bash
cp inventory.ini.example inventory.ini
```

🖊️ Edit `inventory.ini` with your Raspberry Pi details

### 📝 Playbook Variables

```bash
cd playbooks/vars
cp main.yml.example main.yml
```

🛠️ Customize `main.yml` with your specific variables

## 🎭 Ansible Playbook Management

> 🚀 Simple and direct Ansible automation without complexity

### ✨ Features

- 📊 **Native Ansible** execution
- 🗂️ **Simple playbook management** 
- 🔐 **SSH key integration** 
- 📅 **Command-line automation**
- 📈 **Direct execution** and logging
- 🎨 **Clean interface** via Makefile

### 🚀 Quick Start

1. **� Install Ansible collections:**
   ```bash
   make install-deps
   ```

2. **�🔐 Test SSH connection first:**
   ```bash
   make test-ssh
   ```

3. **🔍 Check Ansible connectivity:**
   ```bash
   make check-connection
   ```

4. **📚 List available playbooks:**
   ```bash
   make list-playbooks
   ```

5. **⚡ Run a specific playbook:**
   ```bash
   make run-playbook PLAYBOOK=update
   ```

### 🎮 Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `make install-deps` | Install required Ansible collections | 📦 Setup dependencies |
| `make test-ssh` | Test direct SSH connection | 🔐 Direct SSH test |
| `make check-connection` | Test Ansible connectivity to all hosts | 🔍 Ansible ping test |
| `make list-playbooks` | Show all available playbooks | 📚 List: update, mariadb, etc. |
| `make run-playbook PLAYBOOK=name` | Execute specific playbook | 🚀 `PLAYBOOK=mariadb` |
| `make run-playbook PLAYBOOK=name VERBOSE=true` | Execute playbook with verbose output | 🔍 Debug mode |
| `make run-playbook-verbose PLAYBOOK=name` | Execute playbook with verbose output | 🔊 Always verbose |
| `make setup-all` | **Install complete HomeLab stack** | 🏠 **All services at once** |
| `make setup-all CLEANUP=true` | **Clean install (remove + reinstall)** | 🧹 **Fresh installation** |
| `make help` | Show all commands | ❓ Full help menu |

### 📋 Example Playbooks

- **`update`** - Update and upgrade all packages
- **`mariadb`** - Install and configure MariaDB database
- **`mariadb-cleanup`** - Completely remove MariaDB installation
- **`mosquitto`** - Install and configure Mosquitto MQTT broker
- **`mosquitto-cleanup`** - Completely remove Mosquitto installation
- **`redis`** - Install and configure Redis cache server (ARM v7 optimized)
- **`redis-cleanup`** - Completely remove Redis installation
- **`uv`** - Install UV Python package manager (ultra-fast)
- **`uv-cleanup`** - Completely remove UV installation
- **`grafana`** - Install and configure Grafana monitoring dashboard
- **`grafana-cleanup`** - Completely remove Grafana installation
- **`loki`** - Install and configure Loki log aggregation system + Promtail
- **`loki-cleanup`** - Completely remove Loki and Promtail installation
- **`reboot`** - Safely reboot the cluster  
- **`backup`** - Backup important configurations
- **`monitoring`** - Deploy monitoring tools

### 🏠 Complete HomeLab Setup

#### 🚀 **One-Command Installation**

Install the entire HomeLab stack with a single command:

```bash
# Install all services (MariaDB, Mosquitto, Redis, UV, Grafana, Loki)
make setup-all
```

#### 🧹 **Fresh Installation**

For a completely clean installation (removes existing services first):

```bash
# Clean install: removes all existing installations and reinstalls fresh
make setup-all CLEANUP=true
```

#### 📊 **What Gets Installed**

The `setup-all` command installs these services in order:

1. **🗄️ MariaDB** - Database server (port 3306)
2. **📡 Mosquitto** - MQTT broker (port 1883) with authentication
3. **⚡ Redis** - Cache server (port 6379) 
4. **🐍 UV** - Ultra-fast Python package manager
5. **📈 Grafana** - Monitoring dashboard (port 3000)
6. **📝 Loki + Promtail** - Log aggregation system (port 3100)

#### ⏱️ **Installation Time**

- **Normal**: ~10-15 minutes (depending on Pi model and internet)
- **With CLEANUP**: ~15-20 minutes (includes removal phase)

#### 🎯 **When to Use CLEANUP=true**

- ✅ First-time setup on a fresh Pi
- ✅ Corrupted or partial installations 
- ✅ Major configuration changes
- ✅ Testing and development
- ✅ "Factory reset" of your HomeLab

### 🔧 Usage Examples & Troubleshooting

#### 🚨 **If you get connection errors:**

1. **Test SSH connection first:**
   ```bash
   make test-ssh
   ```

2. **If SSH fails, copy your SSH key:**
   ```bash
   ssh-copy-id massimo@raspberrypi.local
   ```

3. **Test Ansible connectivity:**
   ```bash
   make check-connection
   ```

#### 🚀 **Running Playbooks:**

```bash
# List available playbooks (without .yml extension)
make list-playbooks

# Run system updates (normal mode)
make run-playbook PLAYBOOK=update

# Run with verbose output (method 1)
make run-playbook PLAYBOOK=mariadb VERBOSE=true

# Run with verbose output (method 2)
make run-playbook-verbose PLAYBOOK=mariadb

# Install MariaDB database
make run-playbook PLAYBOOK=mariadb

# Remove MariaDB completely
make run-playbook PLAYBOOK=mariadb-cleanup

# Install Mosquitto MQTT broker (with authentication)
make run-playbook PLAYBOOK=mosquitto

# Remove Mosquitto completely
make run-playbook PLAYBOOK=mosquitto-cleanup

# Install Redis cache server (ARM v7 optimized)
make run-playbook PLAYBOOK=redis

# Remove Redis completely
make run-playbook PLAYBOOK=redis-cleanup

# Install UV Python package manager (ultra-fast)
make run-playbook PLAYBOOK=uv

# Remove UV completely
make run-playbook PLAYBOOK=uv-cleanup

# Install Grafana monitoring dashboard (web UI on port 3000)
make run-playbook PLAYBOOK=grafana

# Remove Grafana completely
make run-playbook PLAYBOOK=grafana-cleanup

# Install Loki log aggregation + Promtail log shipper
make run-playbook PLAYBOOK=loki

# Remove Loki and Promtail completely
make run-playbook PLAYBOOK=loki-cleanup

# Install complete HomeLab stack (all services at once)
make setup-all

# Clean installation (removes existing installations first)
make setup-all CLEANUP=true

# Run custom playbooks (when you create them)
make run-playbook PLAYBOOK=backup
make run-playbook PLAYBOOK=monitoring
```

#### 🔧 **Advanced Ansible Usage:**

```bash
# Dry run (check what would change)
ansible-playbook -i inventory.ini playbooks/update.yml --check

# Verbose output for debugging
ansible-playbook -i inventory.ini playbooks/update.yml -v

# Target specific hosts only
ansible-playbook -i inventory.ini playbooks/update.yml --limit raspberrypi

# Ask for sudo password if needed
ansible-playbook -i inventory.ini playbooks/update.yml --ask-become-pass
```

### 🏗️ Project Structure

```
📁 HomeLab Infrastructure
├── 📄 inventory.ini          # Host definitions
├── �️ playbooks/            # Ansible playbooks
│   ├── � update.yml         # System updates
│   └── � vars/             # Variables
│       └── � main.yml      # Configuration vars
├── 🔧 Makefile              # Automation commands
└── � README.md             # This file
```

### 🔧 Prerequisites

Make sure you have Ansible installed:

```bash
# macOS
brew install ansible

# Ubuntu/Debian
sudo apt update && sudo apt install ansible

# Other systems
pip3 install ansible
```

### � Pro Tips

- **� Dry run**: Add `--check` to test without changes
- **📊 Verbose**: Add `-v` (or `-vv`, `-vvv`) for detailed output
- **🎯 Specific hosts**: Use `--limit hostname` to target specific machines
- **� Vault**: Use `ansible-vault` for sensitive data encryption

## 📊 Monitoring & Logging Stack

### 🎨 Grafana Dashboard

**Installation:**
```bash
make run-playbook PLAYBOOK=grafana
```

**Access:**
- **URL**: `http://your_pi_ip:3000`
- **Login**: `admin` / `admin` (change on first login)
- **Features**: Dashboards, alerting, data visualization

**Configuration:**
- Config file: `/etc/grafana/grafana.ini`
- Data directory: `/var/lib/grafana/`
- Logs: `/var/log/grafana/`
- Service: `sudo systemctl status grafana-server`

### 📝 Loki Log Aggregation

**Installation:**
```bash
make run-playbook PLAYBOOK=loki
```

**Services:**
- **Loki API**: `http://your_pi_ip:3100` (log storage)
- **Promtail**: Log shipper (syslog, auth.log)

**Configuration:**
- Loki config: `/etc/loki/loki.yml`
- Promtail config: `/etc/loki/promtail.yml`
- Data storage: `/var/lib/loki/`
- Services: `sudo systemctl status loki promtail`

### 🔗 Grafana + Loki Integration

**1. Add Loki Data Source in Grafana:**
1. Open Grafana: `http://your_pi_ip:3000`
2. Go to **Configuration** → **Data Sources**
3. Click **"Add data source"** → Select **"Loki"**
4. Set URL: `http://localhost:3100`
5. Click **"Save & test"** ✅

**2. Query Logs in Grafana:**
- Go to **Explore** → Select Loki datasource
- Example queries:
  ```
  {job="syslog"}           # System logs
  {job="python-test"}      # Test script logs  
  {filename="/var/log/auth.log"}  # Authentication logs
  ```

### 🧪 Testing with Python Script

**Copy and run test script:**
```bash
# Copy script to Raspberry Pi
scp scripts/test_loki_grafana.py raspberrypi:~/

# On Pi: make executable and run
ssh raspberrypi
chmod +x test_loki_grafana.py
./test_loki_grafana.py --message "Hello from HomeLab!"
```

**Script options:**
```bash
./test_loki_grafana.py --loki-url http://localhost:3100 \
                       --job "my-test" \
                       --message "Custom log message" \
                       --count 5 \
                       --delay 1
```

**Verify in Grafana:**
1. Go to **Explore** in Grafana
2. Select Loki datasource
3. Query: `{job="python-test"}`
4. You should see your test logs! 🎉

**Manual curl test:**
```bash
ssh raspberrypi "curl -X POST http://localhost:3100/loki/api/v1/push \
  -H 'Content-Type: application/json' \
  --data '{\"streams\": [{\"stream\": {\"job\": \"manual-test\"}, \"values\": [[\"$(date +%s%N)\", \"Manual test log\"]]}]}'"
```

### 🚨 Troubleshooting

**Grafana not accessible:**
```bash
ssh raspberrypi "sudo systemctl status grafana-server"
ssh raspberrypi "sudo journalctl -u grafana-server -n 20"
```

**Loki not responding:**
```bash
ssh raspberrypi "sudo systemctl status loki"
ssh raspberrypi "curl http://localhost:3100/ready"
```

**Check logs:**
```bash
ssh raspberrypi "sudo journalctl -u loki -f"
ssh raspberrypi "sudo journalctl -u promtail -f"
```

---

<div align="center">

**🎯 Made with ❤️ for HomeLab enthusiasts**

*Keep it simple, keep it working* ⚡

</div>