# TKX-Hercules Learning Exercises

Welcome to the TKX-Hercules learning journey! This directory contains individual exercises designed to help you learn mainframe computing step by step.

## 🎯 Learning Path

Each exercise builds upon the previous ones, so we recommend following them in order. However, feel free to jump around if you have specific interests!

## 📚 Exercise Index

### 🚀 Beginner Level (Start Here!)

1. **[Exercise 1: Your First Mainframe Session](01-first-session.md)**
   - Connect and login to MVS 3.8j
   - Explore the TSO menu system
   - Learn basic navigation commands

2. **[Exercise 2: Understanding Mainframe File Systems](02-file-systems.md)**
   - Learn about datasets, libraries, and storage
   - Explore different dataset types (Sequential, PDS, VSAM)
   - Practice browsing and listing datasets

3. **[Exercise 3: Your First JCL Job](03-first-jcl-job.md)**
   - Understand Job Control Language structure
   - Submit and monitor your first batch job
   - Learn about job scheduling

### 💻 Intermediate Level

4. **[Exercise 4: Programming on the Mainframe](04-programming.md)**
   - Explore available compilers (COBOL, FORTRAN, Assembler)
   - Create and compile a simple COBOL program
   - Understand the compilation process

5. **[Exercise 5: File Transfer Adventures](05-file-transfer.md)**
   - Learn IND$FILE protocol
   - Transfer files between mainframe and host
   - Use XMIT for file operations

6. **[Exercise 6: System Administration Basics](06-system-admin.md)**
   - Monitor system status with SDSF
   - Check system resources
   - Understand job classes and priorities

7. **[Exercise 7: Fun with Mainframe Games](07-mainframe-games.md)**
   - Discover classic mainframe games
   - Play Hangman, Tic-tac-toe, and Adventure
   - Create your own simple game

### 🔧 Advanced Level

8. **[Exercise 8: Advanced JCL Techniques](08-advanced-jcl.md)**
   - Conditional execution and job control
   - Data concatenation and symbolic parameters
   - Complex job processing workflows

9. **[Exercise 9: Network and Communication](09-networking.md)**
   - Understand VTAM and mainframe networking
   - Explore terminal types and protocols
   - Learn about network configuration

10. **[Exercise 10: Database and Data Processing](10-database.md)**
    - Work with VSAM datasets
    - Understand IMS hierarchical databases
    - Create data processing jobs

### 🎓 Expert Challenges

11. **[Challenge 1: Multi-Step Job Processing](challenges/01-multi-step-jobs.md)**
    - Create complex job workflows
    - Implement data validation and reporting
    - Master job chaining and dependencies

12. **[Challenge 2: System Programming](challenges/02-system-programming.md)**
    - Learn system programming concepts
    - Understand memory management
    - Explore system internals

13. **[Challenge 3: Performance Tuning](challenges/03-performance-tuning.md)**
    - Optimize JCL jobs for performance
    - Understand resource allocation
    - Monitor and improve system performance

14. **[Challenge 4: Security and RACF](challenges/04-security-racf.md)**
    - Learn about RACF security
    - Practice user and resource management
    - Understand mainframe security concepts

## 🔑 Quick Reference

### Default User Accounts
- `HERC01` / `CUL8TR` - Fully authorized user with full access
- `HERC02` / `CUL8TR` - Fully authorized user (no RAKF access)
- `HERC03` / `PASS4U` - Regular user
- `HERC04` / `PASS4U` - Regular user
- `IBMUSER` / `IBMPASS` - Recovery account (use sparingly)

### Essential Commands
```tso
LISTD    /* List directory contents */
LISTC    /* List catalog entries */
BROWSE   /* Browse a dataset */
HELP     /* Get help on commands */
```

### Connection Instructions
```bash
# Connect to your mainframe
c3270 localhost:3270
```

## 🏆 Certification Path

Complete exercises to earn badges:

- ✅ **Beginner Badge**: Complete Exercises 1-3
- ✅ **Intermediate Badge**: Complete Exercises 4-7
- ✅ **Advanced Badge**: Complete Exercises 8-10
- ✅ **Expert Badge**: Complete all Challenges

## 📚 Additional Resources

- **[Main README](../README.md)** - Project overview and setup instructions
- **[Hercules Documentation](https://hercules-390.github.io/html/hercoper.html)** - Comprehensive Hercules guide
- **[Jay Moseley's Site](https://www.jaymoseley.com/hercules/starthere.htm)** - Excellent tutorials
- **[Mike Slinn's Guide](https://www.mslinn.com/mainframe/2000-hercules.html)** - Historical perspective

## 🤝 Getting Help

- **GitHub Issues**: Report problems or suggest improvements
- **Discussions**: Share your learning experiences
- **Contributions**: Add your own exercises and improvements

---

**Ready to start your mainframe adventure? Begin with [Exercise 1: Your First Mainframe Session](01-first-session.md)! 🚀** 