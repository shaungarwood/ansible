# Ansible Docker Management - Analysis & Planning Notes

## Current Docker Infrastructure Analysis

### overkill-1 (Primary Media/Torrent Server)
**Role**: Automated media acquisition and management hub
**Hardware**: 31.3GB RAM, Intel Xeon E5-2697 v3, 14 cores/28 threads, 915GB storage
**Primary Stack**: Media automation via `/home/csw/jorts/docker-compose.yml`

**Active Services**:
- **transmission-openvpn**: VPN-protected torrenting (ports 9092, 8888) - CRITICAL
- **jackett**: Torrent indexer aggregator (port 9117)
- **radarr**: Movie management/automation (port 7878) 
- **sonarr**: TV show management/automation (port 8989)
- **mealie**: Recipe manager (port 9000)
- **tubesync**: YouTube content sync (port 4848)
- **portainer**: Docker management UI (port 9001)
- **tautulli**: Plex usage analytics (port 8181)
- **swag**: NGINX reverse proxy with SSL (ports 80, 443) - CRITICAL
- **ddns-updater**: Dynamic DNS management (port 8000)
- **monero**: Cryptocurrency node (ports 18080-18081)

**Key Observations**:
- Uses environment variables from `.env` file for VPN credentials
- Heavy volume mapping to `/tmp/` mount point and `/media/` for storage
- All containers use `restart: always` policy
- LinuxServer.io images predominant (standardized configs)

### greasy-gold (Media Server & Home Automation)
**Role**: Plex media server and home automation hub  
**Hardware**: 23.4GB RAM, Intel Xeon E5-1650 v2, 6 cores/12 threads, 98GB storage
**Primary Stack**: Distributed Docker Compose files in `/home/csw/docker/`

**Active Services**:
- **plex**: Media streaming server (host networking) - CRITICAL
- **minecraft**: Game server (port 25565)
- **swag**: NGINX reverse proxy (ports 80, 443) - CRITICAL 
- **mealie**: Recipe manager (port 9050) - different port than overkill-1
- **changedetection**: Website change monitoring (port 5000)
- **portainer**: Docker management (port 9000)
- **dashy**: Home dashboard (port 7070)
- **ntfy**: Push notification service (port 7000)  
- **uptime-kuma**: Service uptime monitoring (port 3001)
- **signal-cli**: Signal messaging API bridge (port 8080)
- **ddns-updater**: Dynamic DNS (port 8000)
- **watchyourlan**: Network monitoring (no exposed port)

**Key Observations**:
- Plex has extensive volume mounts: `/forest2/Media/TV`, `/forest2/Media/Movies`
- Uses `unless-stopped` restart policy vs `always`
- More diverse service ecosystem (monitoring, notifications, gaming)
- Different port allocations to avoid conflicts with overkill-1

### brisk-falcon (Testing/Minimal Setup)
**Role**: Testing environment or minimal services host
**Hardware**: 31.3GB RAM, Intel Xeon E5-1620, 4 cores/8 threads, 98GB storage
**Stack**: Minimal - only historical test containers

**Observations**:
- Only has old/exited hello-world and ubuntu test containers
- No active production services
- Potential target for new service deployment or testing
- Single DDNS compose file suggests minimal current usage

## Service Architecture Patterns

### Common Services Across Hosts:
- **SWAG (NGINX)**: Both overkill-1 and greasy-gold run reverse proxies
- **DDNS-Updater**: Dynamic DNS management on multiple hosts  
- **Portainer**: Docker management UIs (different ports)
- **Mealie**: Recipe management (different ports per host)

### Specialization by Host:
- **overkill-1**: Focused on media *acquisition* (torrents, indexers)
- **greasy-gold**: Focused on media *consumption* (Plex, gaming, monitoring)
- **brisk-falcon**: Available for expansion/testing

## Infrastructure Insights
*See INFRA.md for detailed hardware specifications, storage analysis, and performance characteristics*

### Security Patterns:
- VPN integration for torrent traffic (overkill-1)
- SSL termination via SWAG on both hosts
- Environment variable management for secrets
- LinuxServer.io images (security-focused community)

## Ansible Automation Opportunities

### High Priority Playbooks:
1. **Media Stack Deployment** (overkill-1 recreation)
2. **Plex Server Setup** (greasy-gold recreation)  
3. **Reverse Proxy Configuration** (SWAG setup both hosts)
4. **Monitoring Stack** (uptime-kuma, changedetection, etc.)

### Configuration Management Needs:
- Environment file templating and secrets management
- Volume/directory structure creation with proper permissions
- Docker network creation and management
- Service health checks and dependency ordering

### Backup/Recovery Opportunities:
- Configuration backup automation
- Container state management
- Volume backup strategies
- Service restart/rollback procedures

## Questions & Decisions Needed:

### Service Consolidation:
- Should duplicate services (mealie, ddns-updater) be consolidated?
- How to handle port conflicts if services move between hosts?
- Is brisk-falcon intended for production workloads?

### Environment Management:
- How to securely manage VPN credentials and API keys?
- Should environment files be templated per host or per service?
- Git strategy for sensitive vs non-sensitive configs?

### Deployment Strategy:
- Recreate exact current state vs optimize/modernize?
- Rolling updates vs full stack recreation?
- How to handle downtime for critical services (Plex, torrents)?

## Technical Implementation Notes:

### Docker Compose vs Ansible docker_container:
- Current setup uses compose files extensively
- Ansible could manage compose files or convert to native container tasks
- Compose preserves current architecture, native tasks offer more control

### Volume Management:
- External mount points documented in INFRA.md
- Directory creation and permission management required
- Backup implications for persistent data

### Network Dependencies:
- VPN container dependencies for torrent stack
- Database containers for some services
- Inter-service communication requirements

## Next Steps Priority:
1. Document environment variables and secrets per service
2. Map all volume dependencies and external storage
3. Create host-specific variable files
4. Build and test individual service roles
5. Integration testing with dry-run safety

---

## TODO Items:
- [ ] **SSD Hardware Planning** (INDEPENDENT - can do anytime)
  - [ ] Plan SSD redistribution based on service requirements
  - [ ] Document which services need SSD performance vs bulk storage
  - [ ] Create SSD swap procedure using hardware identification (INFRA.md)
- [ ] Create environment variable inventory per host
- [ ] Document external storage mount requirements  
- [ ] Design secrets management strategy (Ansible Vault)
- [ ] Create service dependency mapping
- [ ] Build docker-compose management roles vs native container roles
- [ ] Plan rolling deployment strategy for zero-downtime updates
- [ ] Design backup automation for container configs and data
- [ ] Test network connectivity between services
- [ ] Document current SSL certificate management (SWAG)
- [ ] Plan monitoring and alerting integration with existing services
- [ ] Investigate brisk-falcon intended usage and potential services
- [ ] Document current backup/restore procedures for each service
- [ ] Create disaster recovery runbook for complete stack recreation

## SERVICE MIGRATION & REORGANIZATION PLAN

### Key Constraints:
- Server hardware specs and names (papa-bear, mama-bear, baby-bear) are FIXED
- Services will be moved logically and physically between hosts
- Need to design optimal service distribution based on resource requirements

### Hostname Migration Plan:
- **overkill-1** → **papa-bear** (31.3GB RAM, 28 threads, 915GB storage)
- **greasy-gold** → **mama-bear** (23.4GB RAM, 12 threads, 98GB storage)  
- **brisk-falcon** → **baby-bear** (31.3GB RAM, 8 threads, 98GB storage)

### Service Migration TODO Items:
- [ ] **Design optimal service distribution strategy**
  - [ ] Analyze resource requirements per service (CPU, RAM, disk, network)
  - [ ] Map services to ideal host based on capability and role
  - [ ] Consider service dependencies and inter-host communication
  
- [ ] **Plan hostname migration process** (INDEPENDENT - can do anytime)
  - [ ] Create hostname change playbooks (overkill-1 → papa-bear, etc.)
  - [ ] Update Ansible inventory with new names
  - [ ] Test hostname changes with baby-bear first
  
- [ ] **Service Migration Planning**
  - [ ] Document current service-to-host mapping
  - [ ] Design target service-to-host mapping  
  - [ ] Plan migration order (dependencies first)
  - [ ] Create service backup/restore procedures for migration
  - [ ] Design zero-downtime migration strategy for critical services
  
- [ ] **Infrastructure Redesign Considerations**
  - [ ] Consolidate duplicate services (mealie, ddns-updater, portainer)?
  - [ ] Optimize resource utilization across all three hosts
  - [ ] Plan baby-bear production role and workload assignment
  - [ ] Design centralized vs distributed service architecture
  - [ ] Network optimization for inter-host service communication

### Strategic Questions for Service Distribution:
- Should papa-bear focus purely on compute-heavy tasks (transcoding, AI, crypto)?
- Should mama-bear become the central coordination hub (reverse proxy, monitoring, notifications)?
- What production role should baby-bear take (backup services, development, specialized workload)?
- Which services need to stay together vs can be distributed?

## PROPOSED SERVICE DISTRIBUTION STRATEGY
*Updated strategy based on storage analysis in INFRA.md*

### **papa-bear** (28 threads, SSD primary) - High-Performance Computing Hub
**Role**: Database services and compute-intensive workloads
**Proposed Services**:
- Database services (PostgreSQL, Redis, etc.) - leverage SSD performance
- CPU-intensive processing (transcoding, AI/ML, crypto mining)
- Docker containers requiring fast I/O and frequent writes
- Background automation with heavy compute requirements

### **mama-bear** (12 threads, HDD, STORAGE CRITICAL) - Coordination Hub  
**Role**: Lightweight coordination services (POST-CLEANUP)
**URGENT**: Storage cleanup required (97% full)
**Proposed Services**:
- Reverse proxy coordination (SWAG) - minimal footprint
- Lightweight web interfaces and dashboards  
- Monitoring coordination (small footprint services)
- User-facing services with minimal storage requirements

### **baby-bear** (8 threads, SSD + 3.6TB HDD) - Storage Powerhouse & Development
**Role**: Bulk storage, development, and redundancy hub
**Major Opportunity**: Massive unused storage capacity
**Proposed Services**:
- Bulk storage services (media libraries, backups)
- Development and testing environments
- Service redundancy and failover instances
- Archive services and long-term storage
- Media processing with large storage requirements