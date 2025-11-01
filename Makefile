.PHONY: help list-playbooks run-playbook check-connection test-ssh

ANSIBLE_PLAYBOOK = ansible-playbook
ANSIBLE_INVENTORY = inventory.ini

default: help

help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

list-playbooks: # List all available playbooks
	@echo "📚 Available Playbooks:"
	@find playbooks -name "*.yml" -type f -not -path "playbooks/vars/*" | sed 's|playbooks/||' | sed 's|\.yml$$||' | sort | while read playbook; do echo "  📋 $$playbook"; done

run-playbook: # Run a playbook (usage: make run-playbook PLAYBOOK=update)
ifndef PLAYBOOK
	@echo "❌ Error: Please specify a playbook name"
	@echo "Usage: make run-playbook PLAYBOOK=update"
	@echo ""
	@make list-playbooks
else
	@echo "🚀 Running playbook: $(PLAYBOOK).yml"
	$(ANSIBLE_PLAYBOOK) -i $(ANSIBLE_INVENTORY) playbooks/$(PLAYBOOK).yml
endif

check-connection: # Test SSH connection to all hosts
	@echo "🔍 Testing connection to all hosts..."
	ansible -i $(ANSIBLE_INVENTORY) all -m ping

test-ssh: # Test direct SSH connection to raspberry pi
	@echo "🔐 Testing direct SSH connection..."
	ssh -o ConnectTimeout=5 massimo@raspberrypi.local "echo 'SSH connection successful!'"
