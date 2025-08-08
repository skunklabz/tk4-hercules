# TK4-Hercules Learning Guide: Mainframe Computing Adventures

Welcome to the exciting world of mainframe computing! This guide will take you through fun, hands-on exercises to learn about IBM MVS 3.8j and mainframe computing concepts. Whether you're a complete beginner or an experienced programmer, these exercises will help you understand the fascinating world of vintage computing.

## 🎯 Learning Objectives

By completing these exercises, you'll learn:
- Basic mainframe concepts and terminology
- How to navigate the MVS 3.8j operating system
- Job Control Language (JCL) fundamentals
- File transfer between mainframe and host system
- Basic programming on a mainframe
- Understanding of historical computing practices

## 📚 Prerequisites

Before starting these exercises, make sure you have:
1. **TK4-Hercules running**: Follow the main [README.md](README.md) to get your mainframe emulator running
2. **3270 Terminal Emulator**: Install `c3270` or similar 3270 emulator
3. **Patience**: Mainframes are deliberate systems - things take time, and that's part of the learning experience!

## 🔑 Quick Login Reference

**Default User Accounts:**
- `HERC01` / `CUL8TR` - Fully authorized user with full access
- `HERC02` / `CUL8TR` - Fully authorized user (no RAKF access)
- `HERC03` / `PASS4U` - Regular user
- `HERC04` / `PASS4U` - Regular user
- `IBMUSER` / `IBMPASS` - Recovery account (use sparingly)

---

## 🚀 Exercise 1: Your First Mainframe Session

**Objective**: Learn basic navigation and understand the mainframe environment

### Step 1: Connect and Login
```bash
# Connect to your mainframe
c3270 localhost:3270
```

1. Press **Enter** when you see the TSO login screen
2. Enter username: `HERC01`
3. Enter password: `CUL8TR`
4. Press **Enter** twice

### Step 2: Explore the TSO Menu
You should now see the TSO Applications Menu. Try these options:

1. **Option 1** - RFE (Review File Editor) - A text editor
2. **Option 2** - SDSF (System Display and Search Facility) - System monitoring
3. **Option 3** - TSO Commands - Direct command line access

### Step 3: Try Some Basic Commands
From the TSO Applications Menu, select **Option 3** and try these commands:

```tso
LISTC    /* List catalog entries */
LISTD    /* List directory contents */
HELP     /* Get help on commands */
```

**🎯 Learning Checkpoint**: What do you notice about the interface? How does it differ from modern operating systems?

---

## 📁 Exercise 2: Understanding Mainframe File Systems

**Objective**: Learn about datasets, libraries, and mainframe storage concepts

### Step 1: Explore the File System
From TSO, use these commands to explore:

```tso
LISTD    /* List current directory */
LISTD 'SYS2.*'    /* List all datasets starting with SYS2 */
LISTD 'SYS1.*'    /* List system datasets */
```

### Step 2: Understand Dataset Types
Mainframes use different types of datasets:

- **Sequential Datasets**: Like regular files
- **Partitioned Datasets (PDS)**: Like directories with members
- **VSAM Datasets**: Advanced indexed files

Try this command to see a PDS:
```tso
LISTD 'SYS2.JCLLIB'    /* This is a PDS containing JCL jobs */
```

### Step 3: Browse a Dataset
```tso
BROWSE 'SYS2.JCLLIB(TESTCOB)'    /* Browse the TESTCOB member */
```

**🎯 Learning Checkpoint**: How does the mainframe file system differ from Unix/Linux file systems? What advantages might this have?

---

## 🔧 Exercise 3: Your First JCL Job

**Objective**: Learn Job Control Language (JCL) - the scripting language of mainframes

### Step 1: Understand JCL Structure
JCL has three main parts:
- **JOB**: Defines the job and its requirements
- **EXEC**: Defines programs to execute
- **DD**: Defines data definitions (files, devices, etc.)

### Step 2: Submit a Simple Job
From the TSO Applications Menu:

1. Select **Option 1** (RFE)
2. Select **Option 3** (UTILITIES)
3. Select **Option 4** (DSLIST)
4. Type `SYS2.JCLLIB` and press Enter
5. Find `TESTCOB` and type `V` (all the way left), then Enter
6. Type `submit` and press Enter

### Step 3: Monitor Your Job
1. Return to the main menu (F3 six times)
2. Select **Option 2** (SDSF)
3. Select **Option 1** (DA - Display Active)
4. Look for your job in the queue

**🎯 Learning Checkpoint**: What happens when you submit a job? How does this differ from running programs on modern systems?

---

## 💻 Exercise 4: Programming on the Mainframe

**Objective**: Learn about mainframe programming languages and compilers

### Step 1: Explore Available Compilers
```tso
LISTD 'SYS2.PROCLIB'    /* Look for compiler procedures */
```

You should see procedures for:
- COBOL (COBOL compiler)
- FORT (FORTRAN compiler)
- ASM (Assembler)
- PLI (PL/I compiler)

### Step 2: Create a Simple COBOL Program
From RFE, create a new dataset:
```tso
ALLOCATE 'HERC01.TEST.COBOL' NEW SPACE(1,1) TRACKS
```

Then edit it and enter this simple COBOL program:
```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       PROCEDURE DIVISION.
           DISPLAY 'HELLO, MAINFRAME WORLD!'.
           STOP RUN.
```

### Step 3: Compile and Run
Create a JCL job to compile and run your program:
```jcl
//HERC01A JOB (ACCT),'HELLO WORLD',CLASS=A,MSGCLASS=A
//STEP1   EXEC COBOL
//SYSIN   DD DSN=HERC01.TEST.COBOL,DISP=SHR
//SYSLIN  DD DSN=HERC01.TEST.OBJ,DISP=(NEW,PASS)
//STEP2   EXEC PGM=LOADER
//SYSLIN  DD DSN=HERC01.TEST.OBJ,DISP=SHR
//SYSLMOD DD DSN=HERC01.TEST.LOAD,DISP=(NEW,PASS)
//STEP3   EXEC PGM=HERC01.TEST.LOAD
```

**🎯 Learning Checkpoint**: How does the compilation process differ from modern development environments?

---

## 📤 Exercise 5: File Transfer Adventures

**Objective**: Learn to transfer files between the mainframe and your host system

### Step 1: Understanding IND$FILE
IND$FILE is a file transfer protocol for mainframes. Let's set it up:

1. From TSO, enter: `IND$FILE`
2. You should see a menu for file transfer operations

### Step 2: Download a File from Mainframe
1. In IND$FILE, select download option
2. Enter dataset name: `SYS2.JCLLIB(TESTCOB)`
3. Specify local filename on your host system
4. Execute the transfer

### Step 3: Upload a File to Mainframe
1. Create a simple text file on your host system
2. In IND$FILE, select upload option
3. Specify your local file and target dataset
4. Execute the transfer

### Step 4: Using XMIT Files
XMIT is another file transfer method:

```tso
TRANSMIT HERC01 DATASET('SYS2.JCLLIB(TESTCOB)')
```

**🎯 Learning Checkpoint**: Why do mainframes need special file transfer protocols? How does this relate to the different character encoding (EBCDIC vs ASCII)?

---

## 🔍 Exercise 6: System Administration Basics

**Objective**: Learn basic mainframe system administration tasks

### Step 1: Monitor System Status
From SDSF, explore these options:
- **DA** (Display Active) - Shows running jobs
- **I** (Input) - Shows input queue
- **O** (Output) - Shows output queue
- **ST** (Status) - Shows system status

### Step 2: Check System Resources
```tso
D T    /* Display time */
D U    /* Display users */
D ASM  /* Display address spaces */
```

### Step 3: Understand Job Classes
Mainframes use job classes to manage resources:
- **Class A**: High priority, interactive
- **Class B**: Normal batch jobs
- **Class C**: Low priority, background

**🎯 Learning Checkpoint**: How does mainframe job scheduling differ from modern operating systems? What advantages does this provide?

---

## 🎮 Exercise 7: Fun with Mainframe Games

**Objective**: Experience some classic mainframe applications

### Step 1: Find Available Games
```tso
LISTD 'SYS2.GAMES.*'    /* Look for game datasets */
```

### Step 2: Try Classic Games
Many mainframe systems include:
- **HANGMAN**: Word guessing game
- **TICTACTOE**: Tic-tac-toe game
- **ADVENTURE**: Text adventure game

### Step 3: Create Your Own Simple Game
Try creating a simple number guessing game in COBOL or Assembler!

**🎯 Learning Checkpoint**: How do these games demonstrate the capabilities and limitations of mainframe systems?

---

## 🔧 Exercise 8: Advanced JCL Techniques

**Objective**: Master more complex JCL features

### Step 1: Conditional Execution
Learn about JCL condition codes and conditional execution:
```jcl
//STEP1   EXEC PGM=PROGRAM1
//STEP2   EXEC PGM=PROGRAM2,COND=(4,LT,STEP1)
```

### Step 2: Data Concatenation
Learn to concatenate multiple input files:
```jcl
//INPUT   DD DSN=FILE1,DISP=SHR
//        DD DSN=FILE2,DISP=SHR
//        DD DSN=FILE3,DISP=SHR
```

### Step 3: Symbolic Parameters
Use symbolic parameters for flexible JCL:
```jcl
//JOB1    JOB (ACCT),'&PROGNAME',CLASS=&CLASS
//STEP1   EXEC PGM=&PROGNAME
```

**🎯 Learning Checkpoint**: How do these JCL features compare to modern scripting languages? What advantages do they provide?

---

## 🌐 Exercise 9: Network and Communication

**Objective**: Learn about mainframe networking concepts

### Step 1: Understand VTAM
VTAM (Virtual Telecommunications Access Method) handles mainframe networking:
```tso
D NET    /* Display network status */
D VTAM   /* Display VTAM status */
```

### Step 2: Explore Terminal Types
Mainframes support various terminal types:
- **3270**: Standard mainframe terminal
- **5250**: AS/400 terminal
- **VT100**: ASCII terminal

### Step 3: Network Configuration
Learn about mainframe network configuration and how it differs from modern networking.

**🎯 Learning Checkpoint**: How does mainframe networking architecture differ from modern TCP/IP networks?

---

## 📊 Exercise 10: Database and Data Processing

**Objective**: Learn about mainframe data processing capabilities

### Step 1: Explore VSAM
VSAM (Virtual Storage Access Method) is a mainframe database system:
```tso
LISTC ENT('SYS1.VSAM.*')    /* List VSAM datasets */
```

### Step 2: Understand IMS
IMS (Information Management System) is a hierarchical database:
- Learn about IMS databases and transactions
- Understand the difference between hierarchical and relational databases

### Step 3: Data Processing Jobs
Create jobs that demonstrate:
- Sorting large datasets
- Merging multiple files
- Data validation and reporting

**🎯 Learning Checkpoint**: How do mainframe data processing capabilities compare to modern database systems?

---

## 🎓 Advanced Challenges

Ready for more? Try these advanced exercises:

### Challenge 1: Multi-Step Job Processing
Create a complex job that:
1. Reads input data
2. Validates and sorts it
3. Processes it through multiple programs
4. Generates reports
5. Archives the results

### Challenge 2: System Programming
- Learn about system programming concepts
- Understand memory management
- Explore system internals

### Challenge 3: Performance Tuning
- Learn to optimize JCL jobs
- Understand resource allocation
- Monitor and improve performance

### Challenge 4: Security and RACF
- Learn about RACF (Resource Access Control Facility)
- Understand mainframe security concepts
- Practice user and resource management

---

## 📚 Additional Resources

### Documentation References
- [Hercules Documentation](https://hercules-390.github.io/html/hercoper.html) - Comprehensive Hercules operation guide
- [Jay Moseley's Hercules Site](https://www.jaymoseley.com/hercules/starthere.htm) - Excellent tutorials and examples
- [IND$FILE Documentation](https://www.jaymoseley.com/hercules/installMVS/ind$file.htm) - File transfer guide
- [Mainframe Programming Guide](https://monadical.com/posts/how-to-run-programs-on-a-mainframe.html) - Modern perspective on mainframe programming

### Historical Context
- [Mike Slinn's Mainframe Guide](https://www.mslinn.com/mainframe/2000-hercules.html) - Historical perspective and setup guide
- [Timpinkawa's IND$FILE Guide](https://timpinkawa.nfshost.com/hercules/indfile.html) - Detailed file transfer instructions

### YouTube Channels
- **Mosix Channel**: Excellent MVS learning resources
- **Mainframe World**: Modern mainframe concepts
- **Vintage Computing**: Historical computing context

---

## 🏆 Certification Path

Complete these exercises to earn your "Mainframe Explorer" badge:

- ✅ **Beginner**: Complete Exercises 1-3
- ✅ **Intermediate**: Complete Exercises 4-7
- ✅ **Advanced**: Complete Exercises 8-10
- ✅ **Expert**: Complete all Advanced Challenges

## 🤝 Community and Support

- **GitHub Issues**: Report problems or suggest improvements
- **Discussions**: Share your learning experiences
- **Contributions**: Add your own exercises and improvements

---

## 🎉 Congratulations!

You've embarked on an amazing journey through the world of mainframe computing. These systems represent a fascinating chapter in computing history and continue to power critical business applications today.

Remember: Mainframes are about **reliability**, **security**, and **scalability**. The deliberate pace and careful design reflect decades of enterprise computing wisdom.

**Happy mainframe exploring! 🖥️**

---

*This learning guide is based on educational content from various mainframe computing resources and adapted for the TK4-Hercules Docker container. Special thanks to the Hercules community and all the contributors who have made mainframe education accessible to everyone.*