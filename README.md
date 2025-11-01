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

1. **🔐 Test SSH connection first:**
   ```bash
   make test-ssh
   ```

2. **🔍 Check Ansible connectivity:**
   ```bash
   make check-connection
   ```

3. **📚 List available playbooks:**
   ```bash
   make list-playbooks
   ```

4. **⚡ Run a specific playbook:**
   ```bash
   make run-playbook PLAYBOOK=update
   ```

### 🎮 Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `make test-ssh` | Test direct SSH connection | 🔐 Direct SSH test |
| `make check-connection` | Test Ansible connectivity to all hosts | 🔍 Ansible ping test |
| `make list-playbooks` | Show all available playbooks | 📚 List: update, deploy, etc. |
| `make run-playbook PLAYBOOK=name` | Execute specific playbook | 🚀 `PLAYBOOK=update` |
| `make help` | Show all commands | ❓ Full help menu |

### 📋 Example Playbooks

- **`update`** - Update and upgrade all packages
- **`reboot`** - Safely reboot the cluster  
- **`backup`** - Backup important configurations
- **`monitoring`** - Deploy monitoring tools

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

# Run system updates
make run-playbook PLAYBOOK=update

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

---

<div align="center">

**🎯 Made with ❤️ for HomeLab enthusiasts**

*Keep it simple, keep it working* ⚡

</div>