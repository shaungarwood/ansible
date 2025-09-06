# Portainer-Managed Services to Migrate

## Services Currently Managed by Portainer
Track services that need migration from Portainer to Ansible management.

### papa-bear (overkill-1)
- **tubesync** - Stack ID 8 - `/data/compose/8/`
  - Image: `ghcr.io/meeb/tubesync:latest`
  - Port: 4848:4848
  - Volumes: Named volumes `config`, `downloads` (NO EXTERNAL MOUNTS - data at risk!)
  - **Status: Role created, ready to replace**

### mama-bear (greasy-gold) 
- **watchyourlan** - Stack ID 6 - `/data/compose/6/`
  - Image: `aceberg/watchyourlan:v2`
  - Port: 8840:8840
  - Network: host mode
  - Volumes: Named volume `watchyourlan-data` mapped to `/data/WatchYourLAN`
  - Env: IFACES=`wlx482254ddc065`, TZ=`America/Denver`
  - **Status: Role created, needs deployment**

- **mealie** - Stack ID 13 - `/data/compose/13/`
  - Image: `ghcr.io/mealie-recipes/mealie:v1.12.0` 
  - Port: 9050:9000 (conflicts with Portainer!)
  - Memory limit: 1000M
  - Volume: Named volume `mealie-data` to `/app/data/`
  - **SECURITY ISSUE: SMTP credentials exposed in plain text**
  - Environment: SMTP config, TZ=America/Denver, BASE_URL=https://pancakefight.com
  - **Status: Needs role creation**

## Migration Strategy
1. Identify Portainer-managed service
2. Create Ansible role with proper volume mounts
3. Stop Portainer version
4. Deploy Ansible version
5. Remove from Portainer

## Notes
- Portainer compose files typically at `/data/compose/[number]/docker-compose.yml`
- May need sudo to access Portainer config files
- Check for `.env` or `stack.env` files for environment variables