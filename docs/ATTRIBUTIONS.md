# Attributions and Acknowledgments

This project builds upon the work of many contributors in the mainframe emulation and MVS community. We gratefully acknowledge their contributions.

## Primary Influences

### TK4- System
- **Volker Bandke** - Original creator of MVS Turnkey 3 (TK3)
- **Jürgen Winkelmann** - Creator of MVS Turnkey 4- (TK4-)
- **TK4- Community** - Contributors who enhanced TK4- with various usermods and improvements

### TK5- System
- **Rob Prins** - Creator of MVS Turnkey 5 (TK5-)
- **Thomas Armstrong** - Co-author of TK5- Introduction and User Manual
- **TK5- Community** - Contributors who developed usermods and enhancements

### Docker Implementation
- **[patrickraths/MVS-TK5](https://github.com/patrickraths/MVS-TK5)** - Existing TK5- Docker implementation that influenced our approach
  - **Patrick Raths** - Creator of the Docker implementation for TK5- and SDL-Hercules-390 base image
  - **SDL-Hercules-390** - Base image approach and configuration strategies

## Technical Components

### Hercules Emulator
- **Jay Maynard** - Original Hercules creator
- **SDL-Hercules Team** - Modern Hercules implementation
- **Hyperion Hercules** - SDL 4.60 version used in TK5-

### MVS 3.8j System
- **IBM** - Original MVS 3.8j operating system
- **MVS Community** - Preservation and documentation efforts

### Software Packages in TK5-
- **Wally Maclaughlin** - ISPF 2.2
- **Rob Kemme** - Skybird Test Facility (STF)
- **Ed Liss** - Source Library Manager (SLIM), Archiver Extensions
- **Mike Rayborn** - LUA370, HTTPD server
- **Larry Belmontes** - VSI (VSAM data set Information)
- **Greg Price** - REVIEW/RFE updates
- **Bob Polmanter** - NJE38 updates
- **Jim Morrison** - 3375/3380/3390 DASD support usermods

## Migration and Utilities

### DSSDUMP/DSSREST
- **Gerhard Postpischil** - DSSDUMP utility for data migration
- **Charlie Brint** - DSSREST utility for data restoration

### RAKF Security
- **RAKF Community** - Security enhancements and updates

## Documentation and Resources

### Official Documentation
- **[TK5- Introduction and User Manual](https://www.prince-webdesign.nl/images/downloads/TK5-Introduction-and-User-Manual.pdf)** - Comprehensive TK5- documentation
- **[TK5- Website](https://www.prince-webdesign.nl/tk5)** - Official TK5- information and downloads

### Community Resources
- **MVS 3.8j Documentation** - IBM knowledge base
- **Hercules Documentation** - Emulator guides and references

## Our Contributions

While we build upon the work of others, our project adds:

1. **Multi-Version Support** - Simultaneous TK4- and TK5- support
2. **Docker Volume Strategy** - Complete volume isolation between versions
3. **Educational Focus** - Comparison and learning materials
4. **Migration Path** - Tools and documentation for version transitions
5. **Future-Proofing** - Architecture for additional MVS versions

## License Compliance

This project respects the licenses of all incorporated works:

- **TK4- and TK5-** - Educational use and preservation
- **Hercules** - Open source emulator
- **patrickraths/MVS-TK5** - MIT License (as indicated in their repository)
- **IBM MVS 3.8j** - Historical preservation and educational use

## How to Attribute

When referencing our work, please include:

```markdown
This project builds upon:
- TK4- by Jürgen Winkelmann
- TK5- by Rob Prins  
- Docker implementation by Patrick Raths (https://github.com/patrickraths/MVS-TK5)
- Hercules emulator by Jay Maynard and SDL team
```

## Contact and Collaboration

We welcome collaboration and contributions while respecting the work of the original creators. For questions about attribution or collaboration, please open an issue in our repository.

---

*This document will be updated as we incorporate additional resources and influences.* 