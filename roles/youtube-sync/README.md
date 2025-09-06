# YouTube Sync Role

Ansible role for deploying TubeSync - a YouTube channel synchronization service.

## Features
- Portable between servers (just change host_vars)
- Persistent storage with proper volume mounts
- Resource limits configured per host
- Health check after deployment
- Easy backup/restore capability

## Quick Start

### Deploy to a server
1. Set `youtube_sync_enabled: true` in host_vars
2. Run: `ansible-playbook playbooks/youtube-sync.yml -l <hostname>`

### Move to different server
1. Set `youtube_sync_enabled: false` on old server
2. Copy data from old server's path to new server
3. Set `youtube_sync_enabled: true` on new server
4. Run playbook on both servers

## Variables

### Required
- `youtube_sync_enabled` - Enable/disable the service

### Optional Storage
- `youtube_sync_base_path` - Base directory for all data (default: `/opt/containers/tubesync`)
- `youtube_sync_config_path` - Config directory (default: `{{ base_path }}/config`)
- `youtube_sync_downloads_path` - Downloads directory (default: `{{ base_path }}/downloads`)

### Optional Configuration
- `youtube_sync_ports` - Port mapping (default: `["4848:4848"]`)
- `youtube_sync_memory_limit` - Memory limit (default: `512M`)
- `youtube_sync_cpu_limit` - CPU limit (default: `1.0`)
- `youtube_sync_uid` - User ID (default: `1000`)
- `youtube_sync_gid` - Group ID (default: `1000`)

## Migration from Portainer

If migrating from Portainer-managed container:
1. Set `youtube_sync_backup_before_replace: true` to backup data
2. Set `youtube_sync_recreate: true` to replace existing container
3. Run playbook
4. Remove from Portainer after verification

## Example Playbook

```yaml
- hosts: papa-bear
  roles:
    - youtube-sync
```

## Testing
```bash
# Dry run
ansible-playbook playbooks/youtube-sync.yml --check --diff -K

# Deploy
ansible-playbook playbooks/youtube-sync.yml -K

# Verify
curl http://<server>:4848
```