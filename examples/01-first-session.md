# Exercise 1: Your First Mainframe Session

**Objective**: Learn basic navigation and understand the mainframe environment

**Estimated Time**: 15-20 minutes

**Prerequisites**: 
- TK4-Hercules running (see [main README](../README.md))
- 3270 terminal emulator installed (`c3270`)

---

## 🎯 What You'll Learn

- How to connect to and login to MVS 3.8j
- Basic navigation through the TSO menu system
- Essential commands for exploring the mainframe
- Understanding the mainframe user interface

---

## 🚀 Step 1: Connect and Login

### Connect to Your Mainframe
```bash
# Connect to your mainframe
c3270 localhost:3270
```

You should see a TSO login screen. If you see the Hercules console instead, wait a few minutes for the system to fully boot.

### Login Process
1. Press **Enter** when you see the TSO login screen
2. Enter username: `HERC01`
3. Enter password: `CUL8TR`
4. Press **Enter** twice

**💡 Tip**: If you get a "Session not available" message, the system might still be booting. Wait a few minutes and try again.

---

## 📋 Step 2: Explore the TSO Menu

After successful login, you should see the **TSO Applications Menu**. This is your gateway to the mainframe world!

### Menu Options Explained

1. **Option 1** - RFE (Review File Editor)
   - A powerful text editor for creating and editing datasets
   - Think of it as the mainframe's version of a modern text editor

2. **Option 2** - SDSF (System Display and Search Facility)
   - System monitoring and job management tool
   - Shows running jobs, system status, and output

3. **Option 3** - TSO Commands
   - Direct command line access to the mainframe
   - Where you'll spend most of your time learning

**🎯 Try This**: Select **Option 3** to access the TSO command line.

---

## 💻 Step 3: Try Some Basic Commands

From the TSO Applications Menu, select **Option 3** and try these commands:

### Essential Commands

```tso
LISTD    /* List directory contents */
```

This shows you what's in your current directory (called a "high-level qualifier" in mainframe terms).

```tso
LISTC    /* List catalog entries */
```

This shows catalog entries - think of it as a file system index.

```tso
HELP     /* Get help on commands */
```

This gives you help information about TSO commands.

### Navigation Commands

```tso
LISTD 'SYS2.*'    /* List all datasets starting with SYS2 */
```

This shows you system datasets. The `'SYS2.*'` is a pattern - the `*` is a wildcard.

```tso
BROWSE 'SYS2.JCLLIB(TESTCOB)'    /* Browse a specific file */
```

This opens a file browser for the TESTCOB job in the JCLLIB library.

---

## 🔍 Step 4: Understanding the Interface

### What You're Seeing

- **Green text on black background**: Classic mainframe terminal colors
- **Function keys**: F1-F12 keys have special meanings
- **PF keys**: Program Function keys (same as F1-F12)
- **Enter key**: Always press Enter to execute commands
- **Clear key**: Usually F12, clears the screen

### Key Differences from Modern Systems

1. **No mouse**: Everything is keyboard-driven
2. **Case insensitive**: Commands work in upper or lower case
3. **Deliberate pace**: Commands take time to process
4. **Batch-oriented**: Designed for processing large amounts of data

---

## 🎯 Learning Checkpoint

**Reflection Questions**:
1. What do you notice about the interface compared to modern operating systems?
2. How does the command structure differ from Unix/Linux commands?
3. What advantages might a keyboard-only interface have for certain tasks?

**Key Takeaways**:
- Mainframes are designed for reliability and batch processing
- The interface is optimized for efficiency, not aesthetics
- Everything is deliberate and structured

---

## 🔗 Navigation

- **Next**: [Exercise 2: Understanding Mainframe File Systems](02-file-systems.md)
- **Previous**: [Exercises Index](README.md)
- **Main Guide**: [Learning Guide](../LEARNING_GUIDE.md)

---

## 📚 Additional Resources

- [Hercules Documentation](https://hercules-390.github.io/html/hercoper.html) - Comprehensive Hercules guide
- [TSO Commands Reference](https://www.ibm.com/docs/en/zos/2.4.0?topic=commands-tso-e) - Official TSO documentation
- [Mainframe Concepts](https://www.ibm.com/docs/en/zos-basic-skills) - IBM's mainframe basics

---

## 🏆 Exercise Complete!

Congratulations! You've successfully:
- ✅ Connected to your mainframe
- ✅ Logged into MVS 3.8j
- ✅ Explored the TSO menu system
- ✅ Used basic navigation commands

You're now ready to dive deeper into mainframe file systems in the next exercise! 