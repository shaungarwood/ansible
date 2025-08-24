# Infrastructure Analysis

## Server Hardware Identification
*Use these identifiers to distinguish servers during hardware swaps/changes*

### **papa-bear** (overkill-1)
- **IP Address**: `192.168.1.100`
- **MAC Address**: `5a:16:21:3a:45:18` (ens1)
- **CPU Model**: Intel(R) Xeon(R) CPU E5-2697 v3 @ 2.60GHz (14 cores/28 threads)
- **Network Interface**: `ens1`

### **mama-bear** (greasy-gold)
- **IP Address**: `192.168.1.149` 
- **MAC Address**: `62:a6:e5:80:6a:c4` (enp0s25)
- **CPU Model**: Intel(R) Xeon(R) CPU E5-1650 v2 @ 3.50GHz (6 cores/12 threads)
- **Network Interface**: `enp0s25`

### **baby-bear** (brisk-falcon)  
- **IP Address**: `192.168.1.135`
- **MAC Address**: `86:43:76:1a:a9:2e` (enp7s0)
- **CPU Model**: Intel(R) Xeon(R) CPU E5-1620 0 @ 3.60GHz (4 cores/8 threads)
- **Network Interface**: `enp7s0`

### **Network Configuration**:
- **Gateway**: 192.168.1.1 (all servers)
- **Network**: 192.168.1.0/24
- **DHCP**: All servers using DHCP with stable IP assignments

---

## Server Hardware Specifications

### **papa-bear** (overkill-1)
**CPU**: Intel Xeon E5-2697 v3 @ 2.60GHz - 14 cores/28 threads  
**RAM**: 31.3GB  
**Storage**: 
- **SDA (931.5G SSD)** ✅ - Primary OS drive (915G available, 53% used)
- **SDB (931.5G HDD)** - Secondary storage (unmounted/available)
- **Network**: `/forest` (16TB NFS mount from 192.168.1.102) - 97% full
**Role**: Heavy compute and storage hub

### **mama-bear** (greasy-gold)  
**CPU**: Intel Xeon E5-1650 v2 @ 3.50GHz - 6 cores/12 threads  
**RAM**: 23.4GB  
**Storage**:
- **SDA (931.5G HDD)** - OS drive (98G available, 97% full) ⚠️ **STORAGE CRITICAL**
- **Network**: `/forest2` (22TB NFS mount from cold-harbor) - 72% full
**Role**: User experience and coordination hub
**Issues**: Severe local storage constraints

### **baby-bear** (brisk-falcon)
**CPU**: Intel Xeon E5-1620 @ 3.60GHz - 4 cores/8 threads  
**RAM**: 31.3GB  
**Storage**:
- **SDB (931.5G SSD)** ✅ - OS drive (98G available, 15% used)  
- **SDA (3.6TB HDD)** - Massive bulk storage (unmounted/available)
**Role**: Development, redundancy, and storage expansion
**Advantages**: SSD performance + huge storage capacity

## Storage Architecture Analysis

### **SSD Performance Hosts**:
- **papa-bear**: SSD primary, ideal for databases, Docker containers
- **baby-bear**: SSD primary, excellent for development and fast services

### **Storage Capacity**:
- **papa-bear**: 915GB SSD + 931GB HDD + 16TB network
- **mama-bear**: 98GB HDD (CRITICAL) + 22TB network  
- **baby-bear**: 98GB SSD + 3.6TB HDD (MASSIVE potential)

### **Network Storage**:
- **papa-bear** → `192.168.1.102:/volume1/forest` (16TB, 97% full)
- **mama-bear** → `cold-harbor:/forest2` (22TB, 72% full)
- Different NFS sources suggest distributed storage architecture

## Service Distribution Strategy (Storage-Optimized)

### **papa-bear** - High-Performance Computing Hub
**Advantages**: SSD + highest CPU + adequate storage
**Ideal Services**:
- Database services (PostgreSQL, MongoDB, Redis)
- Docker containers requiring fast I/O
- CPU-intensive processing (transcoding, AI/ML)
- Services with frequent writes (logs, metrics)

### **mama-bear** - Coordination Hub (Storage-Constrained)
**Constraints**: HDD performance + critical storage shortage
**Priority Actions**: 
1. **URGENT**: Clean up storage (90G used of 98G available)
2. Move large services to other hosts
3. Focus on coordination services with small footprints

**Ideal Services** (post-cleanup):
- Lightweight coordination services
- Reverse proxy (SWAG) - minimal storage
- Monitoring dashboards (small footprint)
- User-facing web interfaces

### **baby-bear** - Storage Powerhouse & Development
**Advantages**: SSD performance + massive HDD capacity + available resources
**Transformation Opportunity**: Underutilized → Storage and development hub
**Ideal Services**:
- Bulk storage services (media processing, backups)
- Development environments
- Service redundancy/failover
- Archive and backup services

## Network Infrastructure

### **Discovered Network Hosts**:
- **192.168.1.102** - NFS server serving papa-bear
- **cold-harbor** - NFS server serving mama-bear  
- Suggests larger network infrastructure with centralized storage

### **Service Networking**:
- Different port allocations per host prevent conflicts
- Both papa-bear and mama-bear run SWAG reverse proxies
- Inter-host service communication likely uses hostnames/IPs

## Storage Urgency Analysis

### **IMMEDIATE ACTION REQUIRED**:
**mama-bear storage crisis**: 90GB used / 98GB available (97% full)
- Risk of service failures
- Docker operations will fail
- Log rotation issues
- System stability at risk

### **Optimization Opportunities**:
1. **baby-bear**: 3.6TB HDD completely unused
2. **papa-bear**: 931GB HDD unmounted  
3. **Network storage**: Load balancing between NFS sources

## Infrastructure Migration Priorities

### **Phase 1 - Critical (IMMEDIATE)**:
1. **mama-bear storage cleanup** - prevent system failure
2. **baby-bear storage activation** - mount and utilize 3.6TB HDD
3. **Service relocation** - move storage-heavy services off mama-bear

### **Phase 2 - Optimization**:
1. **SSD optimization** - database services to papa-bear and baby-bear
2. **papa-bear secondary storage** - mount and utilize 931GB HDD
3. **Network storage balancing** - optimize NFS usage

### **Phase 3 - Architecture**:
1. **Service distribution** based on storage performance
2. **Backup strategy** utilizing baby-bear's massive storage
3. **Development environments** on baby-bear SSD

## Hostname Migration Impact

### **Storage Mount Points**:
- Network mounts use IP addresses → no hostname impact
- Local mounts use device names → no hostname impact
- **Safe to rename**: Storage architecture unaffected

### **Service Configs**:
- Docker volumes use local paths → no hostname impact
- Container networking uses internal names → minimal impact
- **Low risk**: Most services hostname-agnostic

## Performance Characteristics

### **I/O Performance Ranking**:
1. **papa-bear**: SSD + high CPU (best overall performance)
2. **baby-bear**: SSD + moderate CPU (good performance, great potential)  
3. **mama-bear**: HDD + storage constraints (performance limited)

### **Storage Capacity Ranking**:
1. **baby-bear**: 3.7TB total (3.6TB unused!)
2. **papa-bear**: 1.8TB local + network
3. **mama-bear**: 98GB local (critical) + network

### **Service Hosting Recommendations**:
- **Databases**: papa-bear SSD or baby-bear SSD
- **Bulk storage**: baby-bear 3.6TB HDD
- **User interfaces**: mama-bear (post-cleanup) or baby-bear
- **Background processing**: papa-bear (highest CPU)