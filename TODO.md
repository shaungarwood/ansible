# Current TODO Items for Ansible Docker Management
**Generated:** 2025-08-31  
**Status:** Service → Role mapping completed, ready for implementation

## IMMEDIATE PRIORITIES - Role Definition & Testing Strategy

### 🎯 Current Approach
1. **Define roles** for discovered services
2. **Run ansible dry-run** repeatedly until achieving "no changes" state
3. **Test service migration** between servers with simple services first

### Role Definition Tasks
- [ ] Define 3 new roles discovered during mapping:
  - [ ] `youtube-sync` (tubesync on papa-bear)
  - [ ] `signal-bridge` (signal-cli on mama-bear)  
  - [ ] `network-monitoring` (watchyourlan on mama-bear)

### Ansible Testing Workflow
- [ ] Create initial role implementation
- [ ] Run `ansible-playbook --check` (dry-run) against target host
- [ ] Iterate on role until dry-run shows "no changes"
- [ ] Apply role to production once stable

### Service Migration Testing
- [ ] Identify simple, low-risk service for migration testing
- [ ] Create migration playbook (stop on source, start on destination)
- [ ] Test migration between servers
- [ ] Document migration process for complex services

### Consolidation Decisions
- [ ] Make consolidation decisions for duplicate services:
  - [ ] **Mealie instances:** consolidate to one host or keep separate?
  - [ ] **Portainer instances:** centralize or keep distributed?
  - [ ] **SWAG instances:** primary/backup or specialized configs?

### Baby-Bear Planning
- [ ] Design baby-bear role assignments (currently unused capacity):
  - [ ] Plan production workloads for 3.6TB unused storage
  - [ ] Decide backup service strategy
  - [ ] Consider development environment hosting

## Role Architecture Setup

### Directory Structure
- [ ] Create Ansible role directory structure:
  - [ ] `roles/media-acquisition/` (transmission+jackett+radarr+sonarr)
  - [ ] `roles/plex-server/`
  - [ ] `roles/reverse-proxy/` 
  - [ ] `roles/ddns-pancakefight-com/`
  - [ ] `roles/ddns-duck-bar/`
  - [ ] `roles/monero-node/`
  - [ ] + all other mapped roles

### Implementation Steps
- [ ] Start with one role implementation (suggest: media-acquisition)
- [ ] Create role variable templates for each service type
- [ ] Plan service migration from current to optimized distribution

## INFRASTRUCTURE TASKS

### Hardware Planning (Independent)
[ ] SSD Hardware Planning:
    [ ] Plan SSD redistribution based on service requirements
    [ ] Document which services need SSD performance vs bulk storage
    [ ] Create SSD swap procedure using hardware identification (INFRA.md)

### Hostname Migration (Independent - Complete plan in NOTES.md)  
[ ] Plan hostname migration process:
    [ ] Create hostname change playbooks (overkill-1 → papa-bear, etc.)
    [ ] Update Ansible inventory with new names
    [ ] Test hostname changes with baby-bear first

### Critical Storage Issue
[ ] URGENT: mama-bear storage cleanup (97% full - system failure risk)
    [ ] Free up space immediately
    [ ] Move large services to other hosts
    [ ] Monitor disk usage

## CONFIGURATION MANAGEMENT

### Environment & Secrets
[ ] Create environment variable inventory per host
[ ] Design secrets management strategy (Ansible Vault)
[ ] Document external storage mount requirements

### Service Dependencies  
[ ] Create service dependency mapping
[ ] Build docker-compose management roles vs native container roles
[ ] Plan rolling deployment strategy for zero-downtime updates

### Backup & Recovery
[ ] Design backup automation for container configs and data
[ ] Document current backup/restore procedures for each service
[ ] Create disaster recovery runbook for complete stack recreation

## MONITORING & MAINTENANCE

### Service Health
[ ] Test network connectivity between services
[ ] Document current SSL certificate management (SWAG)
[ ] Plan monitoring and alerting integration with existing services

### Documentation
[ ] Investigate brisk-falcon intended usage and potential services
[ ] Update all documentation with role-based architecture
[ ] Create runbooks for common operations

## DISCOVERED DOMAIN MANAGEMENT
- pancakefight.com + www.pancakefight.com managed by papa-bear (overkill-1)
- duck.bar + ntfy.duck.bar managed by mama-bear (greasy-gold)
- Both use Namecheap as DNS provider

## SERVICE MAPPING STATUS
✅ 15 services mapped to existing roles
🆕 3 new roles needed (youtube-sync, signal-bridge, network-monitoring)  
🤔 Consolidation decisions needed for 6 duplicate services
📋 baby-bear available for new role assignments

## HARDWARE IDENTIFICATION (for SSD swaps)
- papa-bear: 192.168.1.100, MAC 5a:16:21:3a:45:18, E5-2697 v3 CPU
- mama-bear: 192.168.1.149, MAC 62:a6:e5:80:6a:c4, E5-1650 v2 CPU  
- baby-bear: 192.168.1.135, MAC 86:43:76:1a:a9:2e, E5-1620 CPU

## CURRENT SESSION PROGRESS

### ✅ COMPLETED
- **3 new roles created**: youtube-sync, signal-bridge, network-monitoring
- **Common environment variables**: Created `group_vars/all/docker-common.yml` for TZ, PUID, PGID, TERM
- **Portainer backup analysis**: Documented all Portainer-managed services
- **YouTube-sync role testing**: Dry-run successful, ready for deployment

### 🔧 PORTAINER FINDINGS (Critical Issues Found)
- **tubesync** (papa-bear): Named volumes only - data at risk! Ready to migrate.
- **watchyourlan** (mama-bear): WiFi interface `wlx482254ddc065` not `eth0` - needs role update
- **mealie** (mama-bear): **SECURITY ISSUE** - SMTP password exposed in plain text
- **Timezone inconsistency**: Services use `America/Denver`, our common config uses `America/Chicago`

### 🚨 CRITICAL INFRASTRUCTURE ISSUES
1. **Hostname confusion**: Constantly confusing greasy-gold vs mama-bear names
2. **Storage crisis**: mama-bear 97% full (system failure risk) 
3. **No centralized container tracking**: Need better inventory system

## IMMEDIATE NEXT ACTIONS
1. **Deploy youtube-sync role** - Replace Portainer-managed container with Ansible version
2. **Fix network-monitoring role** - Update interface name to `wlx482254ddc065`
3. **Create mealie role** - Handle SMTP credentials securely with Ansible Vault
4. **Change server hostnames** - URGENT: greasy-gold → mama-bear, etc.
5. **Create infrastructure documentation system** - AGENTS.md for physical/logical inventory

## NEXT SESSION PRIORITIES
1. Test service migration between servers (youtube-sync papa-bear → baby-bear)
2. Address mama-bear storage crisis (97% full - critical!)
3. Create consolidated inventory tracking system
4. Make consolidation decisions for duplicate services
5. Plan baby-bear production role assignments

## FILES TO REFERENCE
- NOTES.md: Complete planning, TODO lists, hostname migration plan
- INFRA.md: Hardware specs, storage analysis, performance data
- Current service analysis in NOTES.md: Service → Role mapping section