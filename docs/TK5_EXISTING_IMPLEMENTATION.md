# Analysis: Existing TK5- Docker Implementation

## Overview

[patrickraths/MVS-TK5](https://github.com/patrickraths/MVS-TK5) provides an existing Docker implementation for TK5- that we can learn from and compare to our planned approach.

## Key Findings

### 1. **Base Image Strategy**
- Uses **SDL-Hercules-390 Version 4.5** as base image
- Removes embedded Hercules from TK5- distribution
- Removes Windows-related startup files
- Removes unattended (daemon) mode support

### 2. **Volume Strategy**
```yaml
volumes:
  - dasd.usr:/opt/tk5/dasd.usr    # User DASD
  - log:/opt/tk5/log              # TK5 Log files
  - tape:/opt/tk5/tape            # Tapes
  - prt:/opt/tk5/prt              # Printer spool files
  - pch:/opt/tk5/pch              # Card Reader
```

**Comparison to Our Approach:**
- **patrickraths**: Uses bind mounts to host directories
- **Our Plan**: Uses Docker named volumes for better portability

### 3. **Configuration Approach**
- Modifies TK5- startup files
- Uses include files for user DASD configuration
- Supports user-defined DASD via docker volume

### 4. **DASD Management**
```bash
# User DASD configuration
/opt/tk5/dasd.usr/usr_dasd.cnf
034a 3350 dasd.usr/usr000.34a
```

**Features:**
- Supports adding custom DASD volumes
- Automatic mounting via VATLST00 configuration
- User catalog creation and import

### 5. **Docker Compose Implementation**
```yaml
services:
  tk5:
    image: praths/mvs-tk5:latest
    container_name: mvs-tk5
    stdin_open: true
    tty: true
    cap_add:
      - SYS_NICE
    ports:
      - 3270:3270
      - 8038:8038
    volumes:
      - dasd.usr:/opt/tk5/dasd.usr
      - log:/opt/tk5/log
      - tape:/opt/tk5/tape
      - prt:/opt/tk5/prt
      - pch:/opt/tk5/pch
```

## Comparison: patrickraths vs Our Planned Approach

### Volume Structure

| Aspect | patrickraths | Our Planned Approach |
|--------|--------------|---------------------|
| **Volume Strategy** | Bind mounts to host | Docker named volumes |
| **TK5- Volumes** | 5 volumes (usr, log, tape, prt, pch) | 15 volumes (all TK5- volumes) |
| **Multi-Version** | TK5- only | TK4- + TK5- support |
| **Portability** | Host-dependent | Container-portable |

### Architecture Differences

#### patrickraths Approach
- **Single version**: TK5- only
- **Simplified volumes**: 5 mount points
- **Host binding**: Direct file system access
- **Custom DASD**: User-defined volumes via configuration

#### Our Planned Approach
- **Multi-version**: TK4- and TK5- support
- **Complete volumes**: All 15 TK5- volumes
- **Docker volumes**: Container-managed storage
- **Version isolation**: Separate volume namespaces

## Lessons Learned

### 1. **Base Image Strategy**
- Using SDL-Hercules as base is a good approach
- Removing embedded Hercules avoids conflicts
- Clean separation of concerns

### 2. **Volume Management**
- Their bind mount approach provides direct host access
- Our named volume approach provides better portability
- Both approaches have merits

### 3. **Configuration Flexibility**
- Include files for user DASD is clever
- VATLST00 integration for automatic mounting
- User catalog support

### 4. **Docker Best Practices**
- Proper capability management (`SYS_NICE`)
- Interactive mode support (`stdin_open`, `tty`)
- Clear volume organization

## Recommendations for Our Implementation

### 1. **Adopt Good Practices**
- Use SDL-Hercules base image approach
- Implement include file strategy for configuration
- Support user DASD addition

### 2. **Enhance Their Approach**
- Add multi-version support (TK4- + TK5-)
- Use Docker named volumes for better portability
- Implement complete 15-volume TK5- support

### 3. **Maintain Compatibility**
- Support their volume mounting patterns
- Provide migration path from their approach
- Document differences clearly

## Implementation Strategy

### Phase 1: Learn from patrickraths
- Study their Dockerfile and configuration
- Understand their volume management approach
- Identify reusable components

### Phase 2: Enhance for Multi-Version
- Extend their approach for TK4- support
- Implement complete TK5- volume structure
- Add version selection mechanism

### Phase 3: Provide Migration Path
- Document differences between approaches
- Provide migration guide for existing users
- Maintain compatibility where possible

## References

- [patrickraths/MVS-TK5](https://github.com/patrickraths/MVS-TK5) - Existing TK5- Docker implementation
- [SDL-Hercules-390](https://github.com/patrickraths/docker-SDL-Hercules-390) - Base image used
- [TK5- Official Documentation](https://www.prince-webdesign.nl/tk5) - Official TK5- information 