# TK5- Technical Specifications

## Overview

TK5- is a significant evolution of the MVS Turnkey series, featuring a streamlined architecture with 15 DASD volumes (reduced from 28 in TK4+) and enhanced functionality.

## Volume Structure

### Core System Volumes (4 volumes required for IPL)

| Volume | Device Type | Unit Addr | Description |
|--------|-------------|-----------|-------------|
| TK5RES | 3390 | 390 | MVS system residence volume (IPL volume) |
| TK5CAT | 3390 | 391 | MVS Master Catalog volume |
| SPOOL0 | 3350 | 249 | SPOOL volume for JES2 |
| PAGE00 | 3350 | 248 | Page volume |

### Distribution and Package Volumes

| Volume | Device Type | Unit Addr | Description |
|--------|-------------|-----------|-------------|
| TK5DLB | 3390 | 392 | MVS system distribution libraries |
| TK5001 | 3390 | 298 | Package volume 1 |
| TK5002 | 3390 | 299 | Package volume 2 |

### User Data Volumes

| Volume | Device Type | Unit Addr | Description |
|--------|-------------|-----------|-------------|
| TSO001 | 3390 | 190 | TSO volume 1 for user data sets |
| TSO002 | 3390 | 191 | TSO volume 2 for user data sets |
| TSO003 | 3390 | 192 | TSO volume 3 for user data sets |
| WORK01 | 3390 | 290 | Work volume 1 for temporary data sets |
| WORK02 | 3390 | 291 | Work volume 2 for temporary data sets |
| WORK03 | 3390 | 292 | Work volume 3 for temporary data sets |
| WORK04 | 3390 | 293 | Work volume 4 for temporary data sets |

### Application Volumes

| Volume | Device Type | Unit Addr | Description |
|--------|-------------|-----------|-------------|
| INT001 | 3380 | 380 | Intercomm volume (CICS-like application) |

## Catalog Structure

### Master Catalog
- **SYS1.MCAT.TK5** (TK5CAT volume)
  - Contains all system data sets
  - ALIAS entries and their associated User Catalogs
  - **Never replaced** by TK5 updates

### User Catalogs
- **SYS1.UCAT.TSO** (TSO001 volume)
  - Catalog for all user datasets on TSOxxx volumes
  - **Never replaced** by TK5 updates
- **SYS1.UCAT.TK5** (TK5001 volume)
  - Contains contribution, usermod and install datasets
  - **Will be replaced** in future TK5 Update releases
- **SYS1.UCAT.ICOM** (INT001 volume)
  - Contains the Intercomm libraries and datasets
  - **Never replaced** by TK5 updates

## Key Features

### New Components in Update 4
- **STF (Skybird Test Facility)** - VTAM application for SNA network monitoring
- **SLIM (Source Library Manager)** - Integrates with Archiver for source code management
- **LUA370** - Lua programming language integration with HTTPD server
- **VSI (VSAM data set Information)** - Accessible via ISPF VTOC dialog

### Updated Components
- **RPF** - Updated to Version 2.0.0 (major changes)
- **REVIEW/RFE** - Updated to version 51.6
- **PDS command package** - Updated to 8.6.24.4
- **HTTPD server** - Updated to version 3.3.0
- **MAP3270** - Updated to 3.2.3

### Hercules Version
- **Hyperion Hercules SDL 4.60** (64-bit Windows and Linux)
- Other operating systems stay on Hyperion Hercules SDL 4.3.99999

## Installation Process

### Complete System Installation
1. Download complete TK5 system with Update 4 included
2. Extract files to `mvs-tk5` directory
3. For Linux users: `chmod -R +x *`
4. Run cleanup script (`cleanup.bat` for Windows, `cleanup` for Linux)
5. IPL the system
6. Run post-installation job: `devinit 00c update.txt`

### Update Installation
1. Download Update-4 in the `mvs-tk5` directory
2. Unzip `mvstk5-update4.zip` in place
3. For Linux users: `chmod -R +x *`
4. Run cleanup script
5. After IPL, run the job `update.txt`

## Migration from Previous Systems

### Migration Strategy
TK5 uses **DSSDUMP** and **DSSREST** utilities for data migration:

1. **Inventory current system** - List Master Catalog and User Catalogs
2. **Export VSAM datasets** (if any) to sequential datasets
3. **Dump SYS1.UADS** for TSO UserIDs
4. **Dump RAKF profiles** (if RAKF installed)
5. **Run DSSDUMP** to create tape dump
6. **Start TK5** system
7. **Define ALIAS entries** for custom UserIDs/HLQs
8. **Run DSSREST** to generate restoration JCL
9. **Edit and submit restoration JCL**
10. **Update TK5 SYS1.UADS**
11. **Import User Catalogs** (if any)
12. **Import VSAM datasets** (if any)

### Pre-installed ALIAS Entries
TK5 comes with pre-installed ALIAS entries for popular software:
- ALGOL, BREXX, CUTIL00, DVTOC, EREP, FSE, HTTPD, ISPF, LUA370
- MAP3270, NJE38, PDS, RPF, SORT, STF, TK5, USERMOD
- TSO UserIDs: HERC01, HERC02, HERC03, HERC04

## System Architecture Benefits

### Update Strategy
- Only **3 volumes** replaced in updates: TK5RES, TK5001, TK5002
- User data on TSOxxx and WORKxx volumes **never replaced**
- Master Catalog and User Catalogs **preserved** across updates

### Volume Serial Masking
- System residence volume uses `******` notation
- Usermods dynamically replace `******` with actual volume serial
- Enables system residence volume cloning without catalog impact

### 3390 DASD Support
- System residence volume on 3390 DASD
- Most volumes are 3390 type for better performance
- Support for 3375, 3380, and 3390 DASD devices

## Docker Implementation Requirements

### Volume Mount Points
Need to support 15 volume mount points:
```bash
# Core system volumes
/tk5-/tk5res    # TK5RES - System residence
/tk5-/tk5cat    # TK5CAT - Master catalog
/tk5-/spool0    # SPOOL0 - JES2 spool
/tk5-/page00    # PAGE00 - Paging

# Distribution volumes
/tk5-/tk5dlb    # TK5DLB - Distribution libraries
/tk5-/tk5001    # TK5001 - Package volume 1
/tk5-/tk5002    # TK5002 - Package volume 2

# User data volumes
/tk5-/tso001    # TSO001 - TSO volume 1
/tk5-/tso002    # TSO002 - TSO volume 2
/tk5-/tso003    # TSO003 - TSO volume 3
/tk5-/work01    # WORK01 - Work volume 1
/tk5-/work02    # WORK02 - Work volume 2
/tk5-/work03    # WORK03 - Work volume 3
/tk5-/work04    # WORK04 - Work volume 4

# Application volumes
/tk5-/int001    # INT001 - Intercomm volume
```

### Hercules Configuration
- Hercules 4.60 binary required
- Device configuration for 15 DASD volumes
- Unit address mapping as specified above

### Download Requirements
- TK5- distribution download URL (TBD)
- Update 4 included in complete system
- Different file structure than TK4-

## References

- [TK5- Introduction and User Manual](https://www.prince-webdesign.nl/images/downloads/TK5-Introduction-and-User-Manual.pdf)
- [TK5- Website](https://www.prince-webdesign.nl/tk5)
- [DSSDUMP/DSSREST Guide](https://www.prince-webdesign.nl/tk5) (referenced in manual)
- [patrickraths/MVS-TK5](https://github.com/patrickraths/MVS-TK5) - Existing TK5- Docker implementation 