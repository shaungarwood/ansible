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

### Storage Architecture:
- **overkill-1**: Large 915GB storage, uses `/tmp/` and `/media/` mount points
- **greasy-gold**: References `/forest2/Media/` - external storage mount
- Suggests shared or distributed storage across the network

### Network Architecture:
- Services use different port allocations per host to avoid conflicts
- Both production hosts run SWAG reverse proxies
- Suggests domain-based routing or subdomain strategy

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
- Need to identify external mount points (/forest2/, /media/)
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