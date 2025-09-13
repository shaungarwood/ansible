# Infrastructure Agents & Container Inventory

## Purpose
This document tracks all physical servers (agents) and their logical containers to provide a clear overview of the entire infrastructure. This helps with:
- Quick service location lookup
- Migration planning
- Resource utilization tracking
- Disaster recovery planning

## Physical Agents (Servers)

### papa-bear (overkill-1) - The Powerhouse
- **IP**: 192.168.1.100
- **MAC**: 5a:16:21:3a:45:18
- **Hardware**: E5-2697 v3 CPU (28 threads), 915GB SSD
- **Role**: High-performance workloads, media acquisition
- **Status**: Active, optimal performance
- **Storage**: Well-utilized, no immediate concerns
- **Drives**: 
  - OS Drive: `/` (main system)
  - Data Drive: `/mnt/storage` (container data, downloads)
- **NAS Access**: 
  - nas-deck (old): TBD mount point
  - cold-harbor (new): TBD mount point

#### Running Containers:
- **tubesync** (Port 4848) - YouTube sync service
  - **Management**: Currently Portainer → Migrating to Ansible
  - **Status**: ⚠️ Data at risk (named volumes only)
  - **Migration**: Ready to deploy with proper volume mounts

### mama-bear (greasy-gold) - The Nurturer  
- **IP**: 192.168.1.149
- **MAC**: 62:a6:e5:80:6a:c4
- **Hardware**: E5-1650 v2 CPU, serves media & home automation
- **Role**: Media server, home services
- **Status**: 🚨 **CRITICAL - 97% storage full**
- **Storage**: **IMMEDIATE ACTION REQUIRED**
- **Drives**: 
  - OS Drive: `/` (97% full - CRITICAL!)
  - Data Drive: TBD (secondary storage location)
- **NAS Access**: 
  - nas-deck (old): TBD mount point
  - cold-harbor (new): TBD mount point

#### Running Containers:
- **watchyourlan** (Port 8840) - Network device monitoring
  - **Management**: Portainer
  - **Network**: Host mode, WiFi interface `wlx482254ddc065`
  - **Migration**: Role created, needs interface fix

- **mealie** (Port 9050→9000) - Recipe management
  - **Management**: Portainer  
  - **Security**: ⚠️ **SMTP credentials exposed in plain text**
  - **Migration**: Needs new role + Ansible Vault for secrets

- **portainer** (Port 9000) - Container management UI
  - **Management**: Self-managed
  - **Status**: Managing 3 stacks across 2 hosts

### baby-bear (brisk-falcon) - The Future
- **IP**: 192.168.1.135
- **MAC**: 86:43:76:1a:a9:2e
- **Hardware**: E5-1620 CPU
- **Role**: Available for expansion
- **Status**: Underutilized, 3.6TB available storage
- **Opportunity**: Perfect for storage-heavy workloads
- **Drives**: 
  - OS Drive: `/` (main system)
  - Data Drive: TBD (3.6TB available - ideal for bulk storage)
- **NAS Access**: 
  - nas-deck (old): TBD mount point
  - cold-harbor (new): TBD mount point

#### Running Containers:
- **None currently** - Clean slate for new deployments

## Container Management Transition

### From Portainer to Ansible
| Service | Current Host | Status | Next Action |
|---------|-------------|---------|-------------|
| tubesync | papa-bear | ⚠️ Ready to migrate | Deploy Ansible role |
| watchyourlan | mama-bear | 🔧 Needs interface fix | Update role then deploy |
| mealie | mama-bear | 🚨 Security issue | Create secure role |

### Migration Strategy
1. **Phase 1**: Replace risky containers (tubesync - data at risk)
2. **Phase 2**: Fix configuration issues (watchyourlan interface)  
3. **Phase 3**: Secure sensitive services (mealie SMTP)
4. **Phase 4**: Test service mobility (move between agents)

## Current Task Status

### ✅ Completed This Session
- [x] Created 3 new Ansible roles (youtube-sync, signal-bridge, network-monitoring)
- [x] Established common environment variables system
- [x] Analyzed Portainer backup - discovered 3 managed services
- [x] YouTube-sync dry-run testing successful

### 🔧 In Progress
- [ ] Fix network-monitoring role interface name
- [ ] Deploy youtube-sync role (replace Portainer version)
- [ ] Create SMTP-secure mealie role

### 🚨 Critical Issues
1. **mama-bear storage**: 97% full - system failure risk
2. **Hostname confusion**: Need to rename servers to bear names
3. **Data at risk**: tubesync using named volumes only
4. **Security issue**: mealie SMTP credentials in plain text

### 📋 Planned
- [ ] Test service migration between agents
- [ ] Address storage crisis on mama-bear
- [ ] Consolidate duplicate services
- [ ] Plan baby-bear workload assignments

## Infrastructure Improvements Needed

### Hostname Migration (URGENT)
- **Current**: overkill-1, greasy-gold, brisk-falcon
- **Target**: papa-bear, mama-bear, baby-bear
- **Impact**: Reduces confusion, improves maintainability

### Container Tracking System
- **Current**: Manual discovery through Portainer/docker commands
- **Proposed**: Automated inventory in this document
- **Benefit**: Quick reference, migration planning, capacity tracking

### Storage Management  
- **Crisis**: mama-bear at 97% capacity
- **Solution**: Move storage-heavy workloads to baby-bear
- **Opportunity**: Utilize baby-bear's 3.6TB available space

## Network & Service Discovery

### Management Interfaces
- **Portainer**: http://greasy-gold:9000 (mama-bear)
- **TubeSync**: http://overkill-1:4848 (papa-bear)  
- **WatchYourLAN**: http://greasy-gold:8840 (mama-bear)
- **Mealie**: http://greasy-gold:9050 (mama-bear)

### Network Configuration
- **Subnet**: 192.168.1.0/24
- **Services**: Most use bridge networking
- **Exception**: WatchYourLAN uses host network for LAN scanning
- **WiFi Interface**: `wlx482254ddc065` (mama-bear)

---

*This document should be updated after each significant infrastructure change. Consider symlinking for Claude Code access if needed.*