.PHONY: help list-playbooks run-playbook test-ssh install-deps setup-all

ANSIBLE_PLAYBOOK = ansible-playbook
ANSIBLE_INVENTORY = inventory.ini

default: help

help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

list-playbooks: # List all available playbooks
	@echo "📚 Available Playbooks:"
	@find playbooks -name "*.yml" -type f -not -path "playbooks/vars/*" | sed 's|playbooks/||' | sed 's|\.yml$$||' | sort | while read playbook; do echo "  📋 $$playbook"; done

run-playbook: # Run a playbook (usage: make run-playbook PLAYBOOK=update [VERBOSE=true])
ifndef PLAYBOOK
	@echo "❌ Error: Please specify a playbook name"
	@echo "Usage: make run-playbook PLAYBOOK=update [VERBOSE=true]"
	@echo ""
	@make list-playbooks
else
	@echo "🚀 Running playbook: $(PLAYBOOK).yml"
ifdef VERBOSE
	$(ANSIBLE_PLAYBOOK) -i $(ANSIBLE_INVENTORY) playbooks/$(PLAYBOOK).yml -vvv
else
	$(ANSIBLE_PLAYBOOK) -i $(ANSIBLE_INVENTORY) playbooks/$(PLAYBOOK).yml
endif
endif

test-ssh: # Test direct SSH connection to raspberry pi
	@echo "🔐 Testing direct SSH connection..."
	ssh -o ConnectTimeout=5 massimo@raspberrypi.local "echo 'SSH connection successful!'"

install-deps: # Install required Ansible collections
	@echo "📦 Installing Ansible collections..."
	ansible-galaxy collection install -r requirements.yml

setup-all: # Install complete HomeLab stack (usage: make setup-all [CLEANUP=true])
ifdef CLEANUP
	@echo "🧹 CLEANUP MODE: Removing existing installations first..."
	@echo "️  Cleaning up Loki..."
	$(ANSIBLE_PLAYBOOK) -i $(ANSIBLE_INVENTORY) playbooks/loki-cleanup.yml
	@echo "🗑️  Cleaning up Grafana..."
	$(ANSIBLE_PLAYBOOK) -i $(ANSIBLE_INVENTORY) playbooks/grafana-cleanup.yml
	@echo "🗑️  Cleaning up UV..."
	$(ANSIBLE_PLAYBOOK) -i $(ANSIBLE_INVENTORY) playbooks/uv-cleanup.yml
	@echo "🗑️  Cleaning up Redis..."
	$(ANSIBLE_PLAYBOOK) -i $(ANSIBLE_INVENTORY) playbooks/redis-cleanup.yml
	@echo "🗑️  Cleaning up Mosquitto..."
	$(ANSIBLE_PLAYBOOK) -i $(ANSIBLE_INVENTORY) playbooks/mosquitto-cleanup.yml
	@echo "🗑️  Cleaning up MariaDB..."
	$(ANSIBLE_PLAYBOOK) -i $(ANSIBLE_INVENTORY) playbooks/mariadb-cleanup.yml
	@echo "✅ Cleanup completed!"
	@echo ""
endif
	@echo "🚀 Installing complete HomeLab infrastructure..."
	@echo "📋 Installing: MariaDB, Mosquitto, Redis, UV, Grafana, Loki"
ifdef CLEANUP
	@echo "💡 Fresh installation mode (post-cleanup)"
else
	@echo "💡 Tip: Use 'make setup-all CLEANUP=true' for clean reinstall"
endif
	@echo ""
	@echo "⏳ Installing MariaDB database..."
	$(ANSIBLE_PLAYBOOK) -i $(ANSIBLE_INVENTORY) playbooks/mariadb.yml
	@echo "✅ MariaDB completed!"
	@echo ""
	@echo "⏳ Installing Mosquitto MQTT broker..."
	$(ANSIBLE_PLAYBOOK) -i $(ANSIBLE_INVENTORY) playbooks/mosquitto.yml
	@echo "✅ Mosquitto completed!"
	@echo ""
	@echo "⏳ Installing Redis cache server..."
	$(ANSIBLE_PLAYBOOK) -i $(ANSIBLE_INVENTORY) playbooks/redis.yml
	@echo "✅ Redis completed!"
	@echo ""
	@echo "⏳ Installing UV Python package manager..."
	$(ANSIBLE_PLAYBOOK) -i $(ANSIBLE_INVENTORY) playbooks/uv.yml
	@echo "✅ UV completed!"
	@echo ""
	@echo "⏳ Installing Grafana monitoring dashboard..."
	$(ANSIBLE_PLAYBOOK) -i $(ANSIBLE_INVENTORY) playbooks/grafana.yml
	@echo "✅ Grafana completed!"
	@echo ""
	@echo "⏳ Installing Loki log aggregation..."
	$(ANSIBLE_PLAYBOOK) -i $(ANSIBLE_INVENTORY) playbooks/loki.yml
	@echo "✅ Loki completed!"
	@echo ""
	@echo "🎉 HomeLab Setup Completed Successfully!"
	@echo ""
	@echo "📊 SERVICES INSTALLED:"
	@echo "  🗄️  MariaDB:   Database server"
	@echo "  📡 Mosquitto: MQTT broker"  
	@echo "  ⚡ Redis:     Cache server"
	@echo "  🐍 UV:       Python package manager"
	@echo "  📈 Grafana:  Monitoring (http://your_pi_ip:3000)"
	@echo "  📝 Loki:     Log aggregation (port 3100)"
	@echo ""
	@echo "🔗 NEXT STEPS:"
	@echo "1. Configure Loki data source in Grafana"
	@echo "2. Test with: scp scripts/test_loki_grafana.py raspberrypi:~/"
	@echo "3. Access Grafana: http://your_pi_ip:3000 (admin/admin)"
