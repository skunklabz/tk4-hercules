# TKX Migration Plan

## Overview

This document outlines the migration plan for transforming the `tk4-hercules` project into `tkx-hercules`, a multi-version MVS mainframe emulator supporting both TK4- and TK5- systems.

## Goals

1. **Repository Rename**: Migrate from `tk4-hercules` to `tkx-hercules`
2. **Multi-Version Support**: Support both TK4- and TK5- systems
3. **Backward Compatibility**: Maintain existing TK4- functionality
4. **Future-Proof Architecture**: Enable easy addition of future TK versions
5. **Educational Value**: Provide comparison between different MVS versions

## Repository Structure

### Current Structure
```
tk4-hercules/
├── Dockerfile
├── docker-compose.yml
├── scripts/
├── docs/
├── examples/
└── assets/
```

### Target Structure
```
tkx-hercules/
├── versions/
│   ├── tk4/
│   │   ├── Dockerfile
│   │   ├── docker-compose.yml
│   │   └── config/
│   └── tk5/
│       ├── Dockerfile
│       ├── docker-compose.yml
│       └── config/
├── shared/
│   ├── scripts/
│   ├── tools/
│   └── docs/
├── docker-compose.yml (version selector)
└── Makefile (multi-version support)
```

## Version Differences

### TK4- (Current)
- **Hercules Version**: 4.4.1
- **Volumes**: 8 mount points
- **Download Source**: `https://wotho.pebble-beach.ch/tk4-/tk4-_v1.00_current.zip`
- **Features**: Basic MVS 3.8j system

### TK5- (New)
- **Hercules Version**: 4.60 (Hyperion Hercules SDL)
- **Volumes**: 15 DASD volumes (TK5RES, TK5CAT, TK5DLB, TK5001, TK5002, TSO001-003, WORK01-04, INT001, PAGE00, SPOOL0)
- **Download Source**: TBD (from prince-webdesign.nl)
- **Features**: ISPF 2.2, INTERCOMM, LUA370, SLIM, STF, HTTPD 3.3.0, RPF 2.0.0, REVIEW 51.6

## Implementation Phases

### Phase 1: Repository Rename (Week 1)

#### 1.1 GitHub Repository Rename
```bash
# Rename repository using GitHub CLI
gh repo rename tkx-hercules --repo skunklabz/tk4-hercules

# Update local remote
git remote set-url origin https://github.com/skunklabz/tkx-hercules.git
```

#### 1.2 Update Repository Metadata
```bash
# Update description
gh repo edit --description "Multi-version MVS mainframe emulator supporting TK4- and TK5- systems on Hercules"

# Add topics
gh repo edit --add-topic mainframe,mvs,hercules,tk4,tk5,emulation,education,retrocomputing
```

#### 1.3 Create Migration Issues
```bash
gh issue create --title "Update Docker image names" --body "Update all Docker image references from tk4-hercules to tkx-hercules" --label "migration"
gh issue create --title "Update documentation references" --body "Update all documentation to reflect new repository name" --label "migration"
gh issue create --title "Update CI/CD workflows" --body "Update GitHub Actions workflows for new repository name" --label "migration"
```

#### 1.4 Create Announcement Release
```bash
gh release create v1.2.0 \
  --title "Repository Renamed to tkx-hercules" \
  --notes "## Repository Migration

This release renames the repository from tk4-hercules to tkx-hercules to reflect our multi-version support for TK4- and TK5- systems.

### What's Changed
- Repository renamed to tkx-hercules
- Updated repository description and topics
- Maintains backward compatibility with existing TK4- support

### Migration Notes
- GitHub will automatically redirect old URLs
- Docker images will be updated in next release
- Documentation updates in progress

### Next Steps
- Update Docker image names
- Update documentation references
- Update CI/CD workflows" \
  --draft
```

### Phase 2: Infrastructure Setup (Week 2)

#### 2.1 Create Version-Specific Directories
```bash
mkdir -p versions/tk4 versions/tk5 shared/scripts shared/tools
```

#### 2.2 Move Current TK4- Files
```bash
# Move current files to TK4- version directory
mv Dockerfile versions/tk4/
mv docker-compose.yml versions/tk4/
mv mvs.fixed versions/tk4/
```

#### 2.3 Create Version Selector
```bash
# Create main docker-compose.yml that selects version
cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  tkx-hercules:
    extends:
      file: ./versions/${MVS_VERSION:-tk4}/docker-compose.yml
      service: tkx-hercules
EOF
```

#### 2.4 Update Makefile for Multi-Version Support
```bash
# Add version-specific targets to Makefile
cat >> Makefile << 'EOF'

# Multi-version support
build-tk4:
	@echo "Building TK4- version..."
	@MVS_VERSION=tk4 docker-compose build

build-tk5:
	@echo "Building TK5- version..."
	@MVS_VERSION=tk5 docker-compose build

start-tk4:
	@echo "Starting TK4- version..."
	@MVS_VERSION=tk4 docker-compose up -d

start-tk5:
	@echo "Starting TK5- version..."
	@MVS_VERSION=tk5 docker-compose up -d

test-tk4:
	@echo "Testing TK4- version..."
	@MVS_VERSION=tk4 make test

test-tk5:
	@echo "Testing TK5- version..."
	@MVS_VERSION=tk5 make test
EOF
```

### Phase 3: TK5- Implementation (Week 3-4)

#### 3.1 TK5- Download and Installation
Based on the TK5- manual, the installation process requires:

1. **Download complete TK5 system** with Update 4 included
2. **Extract files** to `mvs-tk5` directory  
3. **Set permissions**: `chmod -R +x *` (Linux)
4. **Run cleanup script**: `cleanup.bat` (Windows) or `cleanup` (Linux)
5. **IPL the system**
6. **Run post-installation job**: `devinit 00c update.txt`

**Note**: The TK5- download URL needs to be determined from the prince-webdesign.nl website.

#### 3.2 Create TK5- Dockerfile
```dockerfile
# versions/tk5/Dockerfile
FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tk5-/

# Download TK5- distribution
RUN wget --no-check-certificate -O tk5-update4.zip [TK5_DOWNLOAD_URL] && \
    unzip tk5-update4.zip && \
    rm tk5-update4.zip

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    bash \
    ca-certificates \
    file \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tk5-/

COPY --from=builder /tk5-/ .

# Set up Hercules 4.60 binary
RUN chmod +x hercules/linux/64/bin/hercules

# Create 15 volume mount points for TK5-
RUN mkdir -p tk5res tk5cat tk5dlb tk5001 tk5002 \
    tso001 tso002 tso003 work01 work02 work03 work04 \
    int001 page00 spool0

# Create non-root user
RUN groupadd -g 1000 hercules && \
    useradd -m -s /bin/bash -u 1000 -g hercules hercules && \
    chown -R hercules:hercules .

# Define volume mount points for TK5- (15 volumes)
VOLUME [ "tk5res", "tk5cat", "tk5dlb", "tk5001", "tk5002", 
         "tso001", "tso002", "tso003", "work01", "work02", 
         "work03", "work04", "int001", "page00", "spool0" ]

EXPOSE 3270 8038

CMD ["./mvs"]
```

#### 3.2 Create TK5- Docker Compose
```yaml
# versions/tk5/docker-compose.yml
services:
  tkx-hercules:
    image: tkx-hercules:tk5-latest
    platform: ${PLATFORM:-linux/amd64}
    container_name: tkx-hercules-tk5
    ports:
      - "3270:3270"
      - "8038:8038"
    volumes:
      - tk5-tk5res:/tk5-/tk5res
      - tk5-tk5cat:/tk5-/tk5cat
      - tk5-tk5dlb:/tk5-/tk5dlb
      - tk5-tk5001:/tk5-/tk5001
      - tk5-tk5002:/tk5-/tk5002
      - tk5-tso001:/tk5-/tso001
      - tk5-tso002:/tk5-/tso002
      - tk5-tso003:/tk5-/tso003
      - tk5-work01:/tk5-/work01
      - tk5-work02:/tk5-/work02
      - tk5-work03:/tk5-/work03
      - tk5-work04:/tk5-/work04
      - tk5-int001:/tk5-/int001
      - tk5-page00:/tk5-/page00
      - tk5-spool0:/tk5-/spool0
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '2.0'
        reservations:
          memory: 1G
          cpus: '1.0'
    environment:
      - TZ=UTC
      - HERCULES_VERSION=4.60
      - MVS_VERSION=3.8j-tk5
    labels:
      - "com.skunklabz.description=MVS 3.8j Turnkey 5- System on Hercules Mainframe Emulator"
      - "com.skunklabz.version=1.2.0"
      - "com.skunklabz.mvs-version=tk5"

volumes:
  tk5-tk5res:
    driver: local
  tk5-tk5cat:
    driver: local
  tk5-tk5dlb:
    driver: local
  tk5-tk5001:
    driver: local
  tk5-tk5002:
    driver: local
  tk5-tso001:
    driver: local
  tk5-tso002:
    driver: local
  tk5-tso003:
    driver: local
  tk5-work01:
    driver: local
  tk5-work02:
    driver: local
  tk5-work03:
    driver: local
  tk5-work04:
    driver: local
  tk5-int001:
    driver: local
  tk5-page00:
    driver: local
  tk5-spool0:
    driver: local
```

#### 3.3 Update TK4- Docker Compose
```yaml
# versions/tk4/docker-compose.yml
services:
  tkx-hercules:
    image: tkx-hercules:tk4-latest
    platform: ${PLATFORM:-linux/amd64}
    container_name: tkx-hercules-tk4
    ports:
      - "3270:3270"
      - "8038:8038"
    volumes:
      - tk4-conf:/tk4-/conf
      - tk4-local_conf:/tk4-/local_conf
      - tk4-local_scripts:/tk4-/local_scripts
      - tk4-prt:/tk4-/prt
      - tk4-dasd:/tk4-/dasd
      - tk4-pch:/tk4-/pch
      - tk4-jcl:/tk4-/jcl
      - tk4-log:/tk4-/log
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '2.0'
        reservations:
          memory: 1G
          cpus: '1.0'
    environment:
      - TZ=UTC
      - HERCULES_VERSION=4.4.1
      - MVS_VERSION=3.8j-tk4
    labels:
      - "com.skunklabz.description=MVS 3.8j Turnkey 4- System on Hercules Mainframe Emulator"
      - "com.skunklabz.version=1.2.0"
      - "com.skunklabz.mvs-version=tk4"

volumes:
  tk4-conf:
    driver: local
  tk4-local_conf:
    driver: local
  tk4-local_scripts:
    driver: local
  tk4-prt:
    driver: local
  tk4-dasd:
    driver: local
  tk4-pch:
    driver: local
  tk4-jcl:
    driver: local
  tk4-log:
    driver: local
```

### Phase 4: Documentation Updates (Week 4)

#### 4.1 Update README.md
- Add version selection documentation
- Create comparison table between TK4- and TK5-
- Update quick start guides for both versions
- Add migration guide from TK4- to TK5-

#### 4.2 Create Version-Specific Documentation
- `docs/TK4_GUIDE.md` - TK4- specific features and usage
- `docs/TK5_GUIDE.md` - TK5- specific features and usage
- `docs/VERSION_COMPARISON.md` - Detailed comparison table

#### 4.3 Update Examples
- Create version-specific examples
- Add TK5- specific features (INTERCOMM, LUA370, etc.)
- Update learning materials for new tools

### Phase 5: Testing and Validation (Week 5)

#### 5.1 Create Test Suites
```bash
# scripts/test/test-tk4.sh
#!/bin/bash
MVS_VERSION=tk4 ./scripts/test/test-local.sh

# scripts/test/test-tk5.sh
#!/bin/bash
MVS_VERSION=tk5 ./scripts/test/test-local.sh
```

#### 5.2 Update CI/CD
- Add multi-version testing to GitHub Actions
- Create separate workflows for TK4- and TK5-
- Add version-specific Docker builds

#### 5.3 Validation Checklist
- [ ] TK4- functionality unchanged
- [ ] TK5- system boots successfully
- [ ] All 15 TK5- volumes mount correctly
- [ ] Hercules 4.60 works properly
- [ ] New TK5- features accessible
- [ ] Documentation accurate for both versions

### Phase 6: Release and Communication (Week 6)

#### 6.1 Create Release
```bash
gh release create v1.2.0 \
  --title "Multi-Version Support: TK4- and TK5-" \
  --notes "## Major Release: Multi-Version Support

This release introduces support for both TK4- and TK5- MVS systems.

### New Features
- Support for TK5- system with 15 DASD volumes
- Hercules 4.60 for TK5- (upgraded from 4.4.1)
- New TK5- features: ISPF 2.2, INTERCOMM, LUA370, SLIM, STF
- Version selection via environment variable

### Usage
\`\`\`bash
# Use TK4- (default)
docker-compose up -d

# Use TK5-
MVS_VERSION=tk5 docker-compose up -d
\`\`\`

### Breaking Changes
- Repository renamed to tkx-hercules
- Docker image names updated
- Volume structure differs between versions

### Migration Guide
See docs/MIGRATION_GUIDE.md for detailed migration instructions."
```

#### 6.2 Community Communication
- Update GitHub Discussions
- Announce on relevant forums
- Update external documentation links

## Risk Mitigation

### 1. Backward Compatibility
- Maintain TK4- as default version
- Provide clear migration path
- Keep old image names for transition period

### 2. Testing Strategy
- Comprehensive testing of both versions
- Automated CI/CD for both versions
- Manual testing of key features

### 3. Documentation
- Clear version selection guide
- Feature comparison table
- Migration instructions

## Success Criteria

1. **Repository Successfully Renamed**: `tk4-hercules` → `tkx-hercules`
2. **Both Versions Functional**: TK4- and TK5- systems boot and run
3. **Documentation Complete**: All docs updated for multi-version support
4. **CI/CD Working**: Automated testing for both versions
5. **Community Aware**: Clear communication about changes

## Timeline

- **Week 1**: Repository rename and metadata updates
- **Week 2**: Infrastructure setup and version directories
- **Week 3-4**: TK5- implementation and testing
- **Week 4**: Documentation updates
- **Week 5**: Comprehensive testing and validation
- **Week 6**: Release and community communication

## Rollback Plan

If issues arise during migration:

1. **Immediate**: Revert repository name if critical issues
2. **Short-term**: Maintain old image names alongside new ones
3. **Long-term**: Provide clear migration path with support

## References

- [TK5- Documentation](https://www.prince-webdesign.nl/tk5)
- [Current TK4- Implementation](https://github.com/skunklabz/tk4-hercules)
- [Hercules Emulator](http://www.hercules-390.org/)
- [MVS 3.8j Documentation](https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zmainframe/zmainframe.htm)
- [patrickraths/MVS-TK5](https://github.com/patrickraths/MVS-TK5) - Existing TK5- Docker implementation that influenced our approach 