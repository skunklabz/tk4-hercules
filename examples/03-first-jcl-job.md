# Exercise 3: Your First JCL Job

**Objective**: Learn Job Control Language (JCL) - the scripting language of mainframes

**Estimated Time**: 25-30 minutes

**Prerequisites**: 
- [Exercise 2: Understanding Mainframe File Systems](02-file-systems.md) completed
- Basic understanding of datasets and TSO commands

---

## 🎯 What You'll Learn

- Understanding JCL structure and components
- How to submit and monitor batch jobs
- Job scheduling and execution concepts
- Basic JCL syntax and parameters

---

## 📋 Step 1: Understanding JCL Structure

### What is JCL?

**Job Control Language (JCL)** is the scripting language used to tell the mainframe what programs to run, what data to use, and how to handle the results. Think of it as the mainframe's equivalent of a shell script or batch file.

### JCL Components

JCL has three main statement types:

1. **JOB Statement**: Defines the job and its requirements
2. **EXEC Statement**: Defines programs to execute
3. **DD Statement**: Defines data definitions (files, devices, etc.)

### Basic JCL Syntax

```jcl
//JOBNAME  JOB (ACCOUNT),'JOB DESCRIPTION',CLASS=A,MSGCLASS=A
//STEP1    EXEC PGM=PROGRAM-NAME
//INPUT    DD DSN=DATASET-NAME,DISP=SHR
//OUTPUT   DD DSN=OUTPUT-DATASET,DISP=(NEW,CATLG)
```

---

## 🔍 Step 2: Examine an Existing JCL Job

### Browse the TESTCOB Job

```tso
BROWSE 'SYS2.JCLLIB(TESTCOB)'
```

This will show you a sample COBOL job. Let's analyze its structure:

```jcl
//TESTCOB  JOB (ACCT),'COBOL TEST',CLASS=A,MSGCLASS=A
//STEP1    EXEC COBOL
//SYSIN    DD DSN=SYS2.COBOL(TEST),DISP=SHR
//SYSLIN   DD DSN=&&TEMP,DISP=(NEW,PASS)
//STEP2    EXEC PGM=LOADER
//SYSLIN   DD DSN=&&TEMP,DISP=SHR
//SYSLMOD  DD DSN=SYS2.LOAD(TEST),DISP=SHR
//STEP3    EXEC PGM=SYS2.LOAD(TEST)
```

### Understanding Each Line

- `//TESTCOB JOB` - Job statement defining the job
- `//STEP1 EXEC COBOL` - Execute the COBOL compiler
- `//SYSIN DD` - Input source code
- `//SYSLIN DD` - Output object code
- `//STEP2 EXEC PGM=LOADER` - Execute the loader
- `//STEP3 EXEC PGM=SYS2.LOAD(TEST)` - Run the compiled program

---

## 🚀 Step 3: Submit Your First Job

### Using RFE to Submit a Job

1. From the TSO Applications Menu, select **Option 1** (RFE)
2. Select **Option 3** (UTILITIES)
3. Select **Option 4** (DSLIST)
4. Type `SYS2.JCLLIB` and press Enter
5. Find `TESTCOB` and type `V` (all the way left), then Enter
6. Type `submit` and press Enter

### What Happens When You Submit

When you submit a job:
1. The job enters the **input queue**
2. The **Job Entry Subsystem (JES)** processes it
3. The job moves to the **execution queue**
4. Programs execute in sequence
5. Output goes to the **output queue**

---

## 📊 Step 4: Monitor Your Job

### Using SDSF to Monitor Jobs

1. Return to the main menu (F3 six times)
2. Select **Option 2** (SDSF)
3. Select **Option 1** (DA - Display Active)

You should see your job in the active jobs list. Look for:
- **Job Name**: TESTCOB
- **Status**: Running, Complete, or Error
- **Step**: Which step is currently executing

### SDSF Options

- **DA** (Display Active) - Shows running jobs
- **I** (Input) - Shows jobs waiting to run
- **O** (Output) - Shows completed jobs
- **ST** (Status) - Shows system status

---

## 🔧 Step 5: Create Your Own Simple JCL Job

### Create a Dataset for Your JCL

```tso
ALLOCATE 'HERC01.TEST.JCL' NEW SPACE(1,1) TRACKS
```

### Edit Your JCL Job

From RFE, edit your new dataset and enter this simple job:

```jcl
//HERC01A JOB (ACCT),'HELLO WORLD',CLASS=A,MSGCLASS=A
//STEP1   EXEC PGM=IEFBR14
//DD1     DD DSN=HERC01.TEST.OUTPUT,DISP=(NEW,CATLG),
//            SPACE=(TRK,1),UNIT=SYSDA
//STEP2   EXEC PGM=IEFBR14
//DD1     DD DSN=HERC01.TEST.OUTPUT,DISP=OLD
```

### Understanding This Job

- `IEFBR14` is a dummy program that does nothing (like `/bin/true` in Unix)
- `STEP1` creates a new dataset
- `STEP2` deletes the dataset
- This demonstrates basic JCL syntax

### Submit Your Job

1. In RFE, type `submit` and press Enter
2. Monitor it in SDSF
3. Check the output queue for results

---

## 📈 Step 6: Understanding Job Classes and Priorities

### Job Classes

Mainframes use job classes to manage resources:

- **Class A**: High priority, interactive jobs
- **Class B**: Normal batch jobs
- **Class C**: Low priority, background jobs

### Job Parameters

```jcl
//MYJOB JOB (ACCT),'DESCRIPTION',CLASS=A,MSGCLASS=A,PRTY=8
```

- `CLASS=A` - Job class for scheduling
- `MSGCLASS=A` - Output message class
- `PRTY=8` - Priority (1-15, higher is more important)

---

## 🎯 Learning Checkpoint

### Key Concepts to Understand

1. **Batch Processing**: Jobs run in the background, not interactively
2. **Job Scheduling**: JES manages job execution order
3. **Step-by-Step Execution**: Jobs can have multiple steps
4. **Resource Management**: Jobs specify their resource requirements

### Reflection Questions

1. How does JCL job submission differ from running programs on modern systems?
2. What advantages does batch processing provide for large-scale operations?
3. Why do you think mainframes separate job submission from execution?

### Key Takeaways

- JCL is the mainframe's job control language
- Jobs are submitted to queues and executed by the system
- Batch processing allows efficient resource utilization
- Job monitoring is essential for understanding execution status

---

## 🔗 Navigation

- **Next**: [Exercise 4: Programming on the Mainframe](04-programming.md)
- **Previous**: [Exercise 2: Understanding Mainframe File Systems](02-file-systems.md)
- **Exercises Index**: [README](README.md)

---

## 📚 Additional Resources

- [IBM JCL Reference](https://www.ibm.com/docs/en/zos/2.4.0?topic=reference-jcl) - Official JCL documentation
- [JCL Tutorial](https://www.tutorialspoint.com/jcl/index.htm) - JCL basics
- [Mainframe Job Processing](https://www.ibm.com/docs/en/zos/2.4.0?topic=processing-job) - Job processing concepts

---

## 🏆 Exercise Complete!

Congratulations! You've successfully:
- ✅ Understood JCL structure and components
- ✅ Submitted and monitored your first batch job
- ✅ Created your own JCL job
- ✅ Learned about job scheduling and classes
- ✅ Understood batch processing concepts

You're now ready to learn about programming on the mainframe in the next exercise! 