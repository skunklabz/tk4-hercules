# Exercise 2: Understanding Mainframe File Systems

**Objective**: Learn about datasets, libraries, and mainframe storage concepts

**Estimated Time**: 20-25 minutes

**Prerequisites**: 
- [Exercise 1: Your First Mainframe Session](01-first-session.md) completed
- Basic familiarity with TSO commands

---

## 🎯 What You'll Learn

- How mainframe file systems differ from modern systems
- Understanding datasets, libraries, and storage concepts
- Working with different dataset types (Sequential, PDS, VSAM)
- Navigating and browsing mainframe data

---

## 📁 Step 1: Understanding Mainframe Storage Concepts

### What is a Dataset?

In mainframe terminology, a **dataset** is what we call a "file" in modern systems. However, mainframe datasets are much more sophisticated:

- **Sequential Datasets**: Like regular files in modern systems
- **Partitioned Datasets (PDS)**: Like directories with multiple files (called "members")
- **VSAM Datasets**: Advanced indexed files with complex access methods

### Dataset Naming Convention

Mainframe datasets use a hierarchical naming system:
```
HIGH-LEVEL-QUALIFIER.SUB-QUALIFIER.MEMBER-NAME
```

Examples:
- `SYS2.JCLLIB` - A partitioned dataset containing JCL jobs
- `HERC01.TEST.COBOL` - A dataset owned by user HERC01
- `SYS1.LINKLIB` - System library containing programs

---

## 🔍 Step 2: Explore the File System

### List Your Current Directory
```tso
LISTD    /* List current directory contents */
```

This shows datasets in your current high-level qualifier (usually your user ID).

### Explore System Datasets
```tso
LISTD 'SYS2.*'    /* List all datasets starting with SYS2 */
```

This shows you system datasets. The `'SYS2.*'` pattern uses wildcards to match multiple datasets.

```tso
LISTD 'SYS1.*'    /* List system datasets */
```

**💡 Tip**: System datasets (SYS1, SYS2) contain the operating system and utilities. User datasets typically start with your user ID.

---

## 📚 Step 3: Understanding Dataset Types

### Sequential Datasets
These are like regular files in modern systems:

```tso
LISTD 'SYS2.JCLLIB'    /* This is a PDS, not sequential */
```

### Partitioned Datasets (PDS)
These are like directories with multiple files (members):

```tso
LISTD 'SYS2.JCLLIB'    /* Shows the PDS itself */
```

To see the members (files) inside a PDS:
```tso
LISTD 'SYS2.JCLLIB'    /* Then look for member names */
```

**🎯 Try This**: Look for the `TESTCOB` member in the JCLLIB dataset.

### VSAM Datasets
Advanced indexed files (we'll explore these in later exercises):

```tso
LISTC ENT('SYS1.VSAM.*')    /* List VSAM datasets */
```

---

## 👀 Step 4: Browse and View Datasets

### Browse a Sequential Dataset
```tso
BROWSE 'SYS2.JCLLIB(TESTCOB)'    /* Browse the TESTCOB member */
```

This opens a file browser. Use these keys to navigate:
- **F8** - Page down
- **F7** - Page up
- **F3** - Exit
- **F1** - Help

### View Dataset Information
```tso
LISTD 'SYS2.JCLLIB'    /* Shows dataset attributes */
```

This shows you information about the dataset:
- **Volume**: Which disk it's stored on
- **Unit**: Device type
- **DSORG**: Dataset organization (PO = Partitioned, PS = Sequential)
- **RECFM**: Record format
- **LRECL**: Logical record length
- **BLKSIZE**: Block size

---

## 🛠️ Step 5: Create Your Own Dataset

### Allocate a New Dataset
```tso
ALLOCATE 'HERC01.TEST.SEQ' NEW SPACE(1,1) TRACKS
```

This creates a new sequential dataset:
- `HERC01.TEST.SEQ` - Dataset name
- `NEW` - Create new dataset
- `SPACE(1,1)` - Allocate 1 primary and 1 secondary track
- `TRACKS` - Space unit

### Allocate a Partitioned Dataset
```tso
ALLOCATE 'HERC01.TEST.PDS' NEW SPACE(1,1) TRACKS DIR(10)
```

The `DIR(10)` parameter creates directory space for 10 members.

---

## 📊 Step 6: Dataset Management Commands

### Copy a Dataset
```tso
COPY 'SYS2.JCLLIB(TESTCOB)' 'HERC01.TEST.COPY'
```

### Rename a Dataset
```tso
RENAME 'HERC01.TEST.SEQ' 'HERC01.TEST.RENAMED'
```

### Delete a Dataset
```tso
DELETE 'HERC01.TEST.RENAMED'
```

**⚠️ Warning**: Be very careful with DELETE commands! There's no "trash can" on mainframes.

---

## 🎯 Learning Checkpoint

### Key Concepts to Understand

1. **Dataset vs File**: Mainframes use "datasets" instead of "files"
2. **PDS vs Directory**: Partitioned datasets are like directories with multiple files
3. **Naming Convention**: Hierarchical naming with dots as separators
4. **Storage Units**: Mainframes use tracks and cylinders instead of bytes

### Reflection Questions

1. How does the mainframe file system differ from Unix/Linux file systems?
2. What advantages might a PDS have over a regular directory structure?
3. Why do you think mainframes use different terminology than modern systems?

### Key Takeaways

- Mainframe storage is designed for reliability and performance
- PDS provides efficient access to multiple related files
- Dataset naming follows strict conventions for organization
- Storage allocation is explicit and controlled

---

## 🔗 Navigation

- **Next**: [Exercise 3: Your First JCL Job](03-first-jcl-job.md)
- **Previous**: [Exercise 1: Your First Mainframe Session](01-first-session.md)
- **Exercises Index**: [README](README.md)

---

## 📚 Additional Resources

- [IBM Dataset Concepts](https://www.ibm.com/docs/en/zos/2.4.0?topic=concepts-dataset) - Official IBM documentation
- [Mainframe Storage Management](https://www.ibm.com/docs/en/zos/2.4.0?topic=storage-management) - Storage concepts
- [VSAM Concepts](https://www.ibm.com/docs/en/zos/2.4.0?topic=concepts-vsam) - Advanced storage concepts

---

## 🏆 Exercise Complete!

Congratulations! You've successfully:
- ✅ Understood mainframe storage concepts
- ✅ Explored different dataset types
- ✅ Learned to browse and view datasets
- ✅ Created and managed your own datasets
- ✅ Understood the differences from modern file systems

You're now ready to learn about Job Control Language (JCL) in the next exercise! 