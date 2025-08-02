# TK4- vs TK5- Version Comparison

This document provides a detailed comparison between the TK4- and TK5- MVS systems supported by TKX-Hercules.

## System Architecture

### Volume Structure

| Aspect | TK4- | TK5- |
|--------|------|------|
| **Total Volumes** | 8 | 15 |
| **System Volumes** | 4 | 4 |
| **User Volumes** | 4 | 11 |
| **Volume Types** | Mixed (3350, 3380) | Primarily 3390 |

### TK4- Volume Layout
```
8 volumes:
├── conf/           # Configuration files
├── local_conf/     # Local configuration
├── local_scripts/  # User scripts
├── prt/           # Printer output
├── dasd/          # DASD volumes
├── pch/           # Card punch output
├── jcl/           # Job control files
└── log/           # System logs
```

### TK5- Volume Layout
```
15 volumes:
├── tk5res/        # System residence (3390)
├── tk5cat/        # Master catalog (3390)
├── tk5dlb/        # Distribution libraries (3390)
├── tk5001/        # Package volume 1 (3390)
├── tk5002/        # Package volume 2 (3390)
├── tso001/        # TSO volume 1 (3390)
├── tso002/        # TSO volume 2 (3390)
├── tso003/        # TSO volume 3 (3390)
├── work01/        # Work volume 1 (3390)
├── work02/        # Work volume 2 (3390)
├── work03/        # Work volume 3 (3390)
├── work04/        # Work volume 4 (3390)
├── int001/        # Intercomm volume (3380)
├── page00/        # Page volume (3350)
└── spool0/        # Spool volume (3350)
```

## Technical Specifications

### Hercules Emulator

| Feature | TK4- | TK5- |
|---------|------|------|
| **Version** | 4.4.1 | 4.60 (Hyperion Hercules SDL) |
| **Architecture** | 64-bit Linux/Windows | 64-bit Linux/Windows |
| **Base Image** | Ubuntu 22.04 | Ubuntu 22.04 |
| **Performance** | Standard | Enhanced with SDL |

### System Features

| Feature | TK4- | TK5- |
|---------|------|------|
| **ISPF** | Basic | ISPF 2.2 (Wally Maclaughlin) |
| **HTTP Server** | None | HTTPD 3.3.0 |
| **Scripting** | Basic | LUA370 1.1 |
| **Source Management** | None | SLIM (Source Library Manager) |
| **Network Testing** | None | STF (Skybird Test Facility) |
| **CICS-like App** | None | INTERCOMM |
| **Enhanced Tools** | Basic | PDS 8.6.24.4, REVIEW 51.6, RPF 2.0.0 |

## Software Components

### TK4- Components
- Basic MVS 3.8j system
- Standard Hercules emulation
- Traditional volume structure
- Basic TSO and ISPF

### TK5- Components (Update 4)
- **ISPF 2.2**: Enhanced ISPF with modern features
- **INTERCOMM**: CICS-like application
- **LUA370**: Lua programming language integration
- **SLIM**: Source Library Manager for code management
- **STF**: Skybird Test Facility for network testing
- **HTTPD 3.3.0**: Web server for modern access
- **RPF 2.0.0**: Enhanced RPF with major changes
- **REVIEW 51.6**: Updated review/editor
- **PDS 8.6.24.4**: Enhanced PDS command package
- **MAP3270 3.2.3**: Updated 3270 mapping
- **NJE38 V250**: Network job entry enhancements

## Update Strategy

### TK4- Updates
- **Full system updates**: All volumes replaced
- **Breaking changes**: User data may be lost
- **Manual migration**: Requires user intervention

### TK5- Updates
- **Selective updates**: Only 3 volumes replaced (TK5RES, TK5001, TK5002)
- **User data preserved**: TSOxxx and WORKxx volumes never replaced
- **Minimal disruption**: Updates don't affect user data
- **Volume serial masking**: Uses `******` notation for system residence

## Migration Path

### From TK4- to TK5-
1. **Data export**: Use DSSDUMP to export user data
2. **System switch**: Start TK5- system
3. **Data import**: Use DSSREST to import user data
4. **Catalog updates**: Import user catalogs
5. **Feature testing**: Test new TK5- features

### Benefits of Migration
- **Enhanced tools**: Modern development environment
- **Better performance**: Hercules 4.60 improvements
- **More storage**: 15 volumes vs 8 volumes
- **Future-proof**: Easier updates and maintenance
- **Educational value**: Access to latest mainframe tools

## Educational Value

### TK4- Learning
- **Historical perspective**: Original TK4- system
- **Basic concepts**: Traditional MVS structure
- **Foundation**: Understanding of basic mainframe operations

### TK5- Learning
- **Modern tools**: Contemporary mainframe development
- **Advanced features**: ISPF 2.2, LUA370, SLIM
- **Network concepts**: STF for network testing
- **Web integration**: HTTPD server access

## Use Cases

### When to Use TK4-
- **Historical research**: Studying original TK4- system
- **Basic learning**: Introduction to mainframe concepts
- **Compatibility**: Working with existing TK4- data
- **Simplicity**: Straightforward 8-volume system

### When to Use TK5-
- **Modern development**: Using contemporary mainframe tools
- **Advanced learning**: Exploring enhanced features
- **Network testing**: Using STF for network analysis
- **Web integration**: Accessing system via HTTPD
- **Future preparation**: Learning latest mainframe technologies

## Performance Considerations

### Resource Requirements
- **TK4-**: Lower memory and storage requirements
- **TK5-**: Higher requirements due to enhanced features
- **Both**: Configurable resource limits via Docker

### Storage Efficiency
- **TK4-**: 8 volumes, simpler structure
- **TK5-**: 15 volumes, optimized for modern usage
- **Volume isolation**: Separate namespaces prevent conflicts

## Recommendations

### For New Users
1. **Start with TK4-**: Learn basic concepts
2. **Graduate to TK5-**: Explore advanced features
3. **Compare systems**: Understand evolution of mainframe technology

### For Experienced Users
1. **Use TK5-**: Access to latest tools and features
2. **Maintain TK4-**: For compatibility with existing data
3. **Contribute**: Help improve both systems

### For Educators
1. **TK4- for basics**: Fundamental mainframe concepts
2. **TK5- for advanced**: Modern mainframe development
3. **Comparison exercises**: Show evolution of technology

## References

- [TK5- Technical Specifications](TK5_TECHNICAL_SPECS.md)
- [Migration Plan](TKX_MIGRATION_PLAN.md)
- [TK5- Introduction and User Manual](https://www.prince-webdesign.nl/images/downloads/TK5-Introduction-and-User-Manual.pdf)
- [patrickraths/MVS-TK5](https://github.com/patrickraths/MVS-TK5) 