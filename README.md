# Ansible Server Management

This repository contains Ansible playbooks and configuration for managing remote servers: `overkill-1`, `greasy-gold`, and `brisk-falcon`.

## Server Inventory

- **overkill-1**: Ubuntu 22.04, 31.3GB RAM, Intel Xeon E5-2697 v3, 14 cores/28 threads
- **greasy-gold**: Ubuntu 22.04, 23.4GB RAM, Intel Xeon E5-1650 v2, 6 cores/12 threads  
- **brisk-falcon**: Ubuntu 24.04, 31.3GB RAM, Intel Xeon E5-1620, 4 cores/8 threads

## Safety-First Configuration

This setup uses **dry-run mode by default** to prevent accidental changes. All playbooks will show what changes would be made without actually applying them.

### Usage

#### Dry-Run Mode (Default)
```bash
# Using the convenience script (recommended)
./run-ansible playbook.yml [options]

# Using ansible-playbook directly
ansible-playbook playbook.yml [options]
```

#### Apply Changes (Override)
```bash
# Using the convenience script
./run-ansible --apply playbook.yml [options]

# Using ansible-playbook directly  
ANSIBLE_CHECK_MODE=false ansible-playbook playbook.yml [options]
```

### Examples

```bash
# Check what changes would be made to all servers
./run-ansible site.yml

# Apply changes to a specific server
./run-ansible --apply docker-setup.yml --limit overkill-1

# Gather system stats in dry-run mode
./run-ansible system-stats.yml

# Actually apply Docker setup to all servers
./run-ansible --apply docker-setup.yml
```

## Available Playbooks

- `site.yml` - Main playbook for server management
- `docker-setup.yml` - Docker installation and configuration
- `system-stats.yml` - System information gathering

## Configuration Files

- `ansible.cfg` - Ansible configuration with dry-run defaults
- `inventory.yml` - Server inventory
- `run-ansible` - Convenience wrapper script
- Host variables in `host_vars/` for server-specific settings
- Group variables in `group_vars/` for shared settings

## Safety Features

- **Dry-run by default**: All commands run in check mode unless explicitly overridden
- **Diff output enabled**: Shows what files would be changed
- **Host key checking disabled**: For lab environment convenience
- **Vault password file**: Encrypted credential storage