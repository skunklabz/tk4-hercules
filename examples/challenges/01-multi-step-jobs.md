# Challenge 1: Multi-Step Job Processing

**Objective**: Create complex job workflows with data validation, processing, and reporting

**Estimated Time**: 45-60 minutes

**Prerequisites**: 
- All basic exercises (1-10) completed
- Strong understanding of JCL and mainframe concepts
- Experience with COBOL programming (Exercise 4)

**Difficulty Level**: 🎓 Expert

---

## 🎯 What You'll Learn

- Advanced JCL techniques for complex workflows
- Data validation and error handling
- Job chaining and dependencies
- Report generation and data processing
- Performance optimization techniques

---

## 📋 Challenge Overview

You will create a comprehensive job that:
1. **Reads** input data from multiple sources
2. **Validates** the data for integrity
3. **Processes** the data through multiple programs
4. **Generates** reports and summaries
5. **Archives** the results
6. **Handles** errors gracefully

---

## 🚀 Step 1: Design Your Data Flow

### Data Flow Architecture

```
Input Files → Validation → Processing → Reporting → Archiving
     ↓           ↓           ↓           ↓           ↓
  Raw Data   Clean Data   Processed   Reports    Archive
```

### Required Components

1. **Input Datasets**: Multiple source files
2. **Validation Program**: Data integrity checks
3. **Processing Programs**: Business logic
4. **Report Generator**: Summary and detail reports
5. **Archive Process**: Long-term storage
6. **Error Handling**: Graceful failure management

---

## 🔧 Step 2: Create Your Input Data

### Create Sample Input Files

```tso
ALLOCATE 'HERC01.CHALLENGE.INPUT1' NEW SPACE(1,1) TRACKS
ALLOCATE 'HERC01.CHALLENGE.INPUT2' NEW SPACE(1,1) TRACKS
ALLOCATE 'HERC01.CHALLENGE.INPUT3' NEW SPACE(1,1) TRACKS
```

### Populate with Sample Data

Create realistic test data in each file. For example:

**INPUT1** (Customer Data):
```
CUST001,John Doe,123 Main St,New York,NY,10001
CUST002,Jane Smith,456 Oak Ave,Los Angeles,CA,90210
CUST003,Bob Johnson,789 Pine Rd,Chicago,IL,60601
```

**INPUT2** (Order Data):
```
ORD001,CUST001,2024-01-15,150.00
ORD002,CUST002,2024-01-16,275.50
ORD003,CUST001,2024-01-17,89.99
```

**INPUT3** (Product Data):
```
PROD001,Laptop,999.99,50
PROD002,Mouse,25.00,200
PROD003,Keyboard,75.00,100
```

---

## 📊 Step 3: Create the Validation Program

### COBOL Validation Program

Create a COBOL program that validates your input data:

```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. VALIDATE.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO INPUT1.
           SELECT VALID-FILE ASSIGN TO VALID1.
           SELECT ERROR-FILE ASSIGN TO ERROR1.
       DATA DIVISION.
       FILE SECTION.
       FD  INPUT-FILE.
       01  INPUT-RECORD.
           05  CUST-ID      PIC X(6).
           05  CUST-NAME    PIC X(30).
           05  CUST-ADDR    PIC X(50).
       FD  VALID-FILE.
       01  VALID-RECORD     PIC X(86).
       FD  ERROR-FILE.
       01  ERROR-RECORD     PIC X(86).
       WORKING-STORAGE SECTION.
       01  EOF-FLAG         PIC X VALUE 'N'.
       01  VALID-COUNT      PIC 9(6) VALUE 0.
       01  ERROR-COUNT      PIC 9(6) VALUE 0.
       PROCEDURE DIVISION.
       MAIN-LOGIC.
           OPEN INPUT INPUT-FILE
                OUTPUT VALID-FILE ERROR-FILE.
           PERFORM UNTIL EOF-FLAG = 'Y'
               READ INPUT-FILE
                   AT END MOVE 'Y' TO EOF-FLAG
                   NOT AT END PERFORM VALIDATE-RECORD
               END-READ
           END-PERFORM.
           CLOSE INPUT-FILE VALID-FILE ERROR-FILE.
           DISPLAY 'VALIDATION COMPLETE'.
           DISPLAY 'VALID RECORDS: ' VALID-COUNT.
           DISPLAY 'ERROR RECORDS: ' ERROR-COUNT.
           STOP RUN.
       VALIDATE-RECORD.
           IF CUST-ID IS NUMERIC AND CUST-NAME NOT = SPACES
               WRITE VALID-RECORD FROM INPUT-RECORD
               ADD 1 TO VALID-COUNT
           ELSE
               WRITE ERROR-RECORD FROM INPUT-RECORD
               ADD 1 TO ERROR-COUNT
           END-IF.
```

---

## 🔄 Step 4: Create the Multi-Step JCL Job

### Complex JCL with Error Handling

```jcl
//MULTIJOB JOB (ACCT),'MULTI-STEP PROCESSING',CLASS=A,MSGCLASS=A,
//         NOTIFY=HERC01
//*
//* STEP 1: VALIDATE INPUT DATA
//*
//VALIDATE EXEC PGM=VALIDATE
//INPUT1   DD DSN=HERC01.CHALLENGE.INPUT1,DISP=SHR
//VALID1   DD DSN=HERC01.CHALLENGE.VALID1,DISP=(NEW,CATLG),
//            SPACE=(TRK,1),UNIT=SYSDA
//ERROR1   DD DSN=HERC01.CHALLENGE.ERROR1,DISP=(NEW,CATLG),
//            SPACE=(TRK,1),UNIT=SYSDA
//*
//* STEP 2: PROCESS VALIDATED DATA (ONLY IF VALIDATION SUCCEEDS)
//*
//PROCESS  EXEC PGM=PROCESS,COND=(0,LT,VALIDATE)
//INPUT    DD DSN=HERC01.CHALLENGE.VALID1,DISP=SHR
//OUTPUT   DD DSN=HERC01.CHALLENGE.PROCESSED,DISP=(NEW,CATLG),
//            SPACE=(TRK,1),UNIT=SYSDA
//*
//* STEP 3: GENERATE REPORTS (ONLY IF PROCESSING SUCCEEDS)
//*
//REPORT   EXEC PGM=REPORT,COND=(0,LT,PROCESS)
//INPUT    DD DSN=HERC01.CHALLENGE.PROCESSED,DISP=SHR
//SUMMARY  DD DSN=HERC01.CHALLENGE.SUMMARY,DISP=(NEW,CATLG),
//            SPACE=(TRK,1),UNIT=SYSDA
//DETAIL   DD DSN=HERC01.CHALLENGE.DETAIL,DISP=(NEW,CATLG),
//            SPACE=(TRK,1),UNIT=SYSDA
//*
//* STEP 4: ARCHIVE RESULTS (ONLY IF ALL PREVIOUS STEPS SUCCEED)
//*
//ARCHIVE  EXEC PGM=IEFBR14,COND=(0,LT,REPORT)
//ARCHIVE  DD DSN=HERC01.CHALLENGE.ARCHIVE(+1),DISP=(NEW,CATLG),
//            SPACE=(TRK,5),UNIT=SYSDA
//*
//* STEP 5: CLEANUP (ALWAYS RUN)
//*
//CLEANUP  EXEC PGM=IEFBR14
//CLEAN    DD DSN=HERC01.CHALLENGE.TEMP,DISP=OLD
```

### Understanding the JCL

- **COND=(0,LT,STEPNAME)**: Only execute if previous step completed successfully
- **DISP=(NEW,CATLG)**: Create new dataset and catalog it
- **DISP=OLD**: Use existing dataset
- **SPACE=(TRK,1)**: Allocate 1 track of space

---

## 📈 Step 5: Add Performance Optimization

### Optimize Your Job

```jcl
//OPTIMIZE JOB (ACCT),'OPTIMIZED PROCESSING',CLASS=A,MSGCLASS=A,
//         PRTY=8,REGION=2M
//*
//* STEP 1: PARALLEL VALIDATION
//*
//VALID1   EXEC PGM=VALIDATE,REGION=1M
//INPUT1   DD DSN=HERC01.CHALLENGE.INPUT1,DISP=SHR
//VALID1   DD DSN=HERC01.CHALLENGE.VALID1,DISP=(NEW,CATLG),
//            SPACE=(TRK,1),UNIT=SYSDA
//ERROR1   DD DSN=HERC01.CHALLENGE.ERROR1,DISP=(NEW,CATLG),
//            SPACE=(TRK,1),UNIT=SYSDA
//*
//VALID2   EXEC PGM=VALIDATE,REGION=1M
//INPUT1   DD DSN=HERC01.CHALLENGE.INPUT2,DISP=SHR
//VALID1   DD DSN=HERC01.CHALLENGE.VALID2,DISP=(NEW,CATLG),
//            SPACE=(TRK,1),UNIT=SYSDA
//ERROR1   DD DSN=HERC01.CHALLENGE.ERROR2,DISP=(NEW,CATLG),
//            SPACE=(TRK,1),UNIT=SYSDA
//*
//* STEP 2: MERGE VALIDATED DATA
//*
//MERGE    EXEC PGM=SORT,COND=(0,LT,VALID1,VALID2)
//SORTIN   DD DSN=HERC01.CHALLENGE.VALID1,DISP=SHR
//         DD DSN=HERC01.CHALLENGE.VALID2,DISP=SHR
//SORTOUT  DD DSN=HERC01.CHALLENGE.MERGED,DISP=(NEW,CATLG),
//            SPACE=(TRK,2),UNIT=SYSDA
//SYSIN    DD *
  SORT FIELDS=(1,6,CH,A)
  SUM FIELDS=NONE
/*
```

---

## 🎯 Step 6: Implement Error Handling

### Error Recovery JCL

```jcl
//ERRORJOB JOB (ACCT),'ERROR RECOVERY',CLASS=A,MSGCLASS=A
//*
//* CHECK FOR ERRORS AND TAKE CORRECTIVE ACTION
//*
//CHECK    EXEC PGM=CHECKERR
//ERRORS   DD DSN=HERC01.CHALLENGE.ERROR1,DISP=SHR
//         DD DSN=HERC01.CHALLENGE.ERROR2,DISP=SHR
//REPORT   DD SYSOUT=A
//*
//* IF ERRORS FOUND, SEND NOTIFICATION
//*
//NOTIFY   EXEC PGM=NOTIFY,COND=(4,GT,CHECK)
//MESSAGE  DD *
  ERRORS DETECTED IN DATA PROCESSING
  PLEASE CHECK ERROR LOGS
/*
//*
//* CONTINUE WITH CLEAN DATA
//*
//CONTINUE EXEC PGM=PROCESS,COND=(0,LT,CHECK)
//INPUT    DD DSN=HERC01.CHALLENGE.VALID1,DISP=SHR
//OUTPUT   DD DSN=HERC01.CHALLENGE.PROCESSED,DISP=(NEW,CATLG)
```

---

## 📊 Step 7: Monitor and Analyze Results

### Check Job Results

```tso
/* Check job output */
SDSF O

/* Browse summary report */
BROWSE 'HERC01.CHALLENGE.SUMMARY'

/* Check error logs */
BROWSE 'HERC01.CHALLENGE.ERROR1'
```

### Performance Analysis

```tso
/* Check job execution time */
SDSF ST

/* Analyze resource usage */
D ASM
```

---

## 🎯 Learning Checkpoint

### Advanced Concepts Demonstrated

1. **Conditional Execution**: Using COND parameters for job flow control
2. **Parallel Processing**: Running multiple steps simultaneously
3. **Error Handling**: Graceful failure management
4. **Resource Optimization**: Memory and storage management
5. **Data Flow Management**: Complex data processing pipelines

### Reflection Questions

1. How does this multi-step approach compare to modern workflow engines?
2. What advantages does JCL provide for complex data processing?
3. How would you handle real-time processing requirements?

### Key Takeaways

- Complex workflows require careful planning and error handling
- JCL provides powerful tools for job orchestration
- Performance optimization is crucial for large-scale processing
- Monitoring and logging are essential for production systems

---

## 🔗 Navigation

- **Next**: [Challenge 2: System Programming](02-system-programming.md)
- **Previous**: [Exercise 10: Database and Data Processing](../10-database.md)
- **Exercises Index**: [README](../README.md)

---

## 📚 Additional Resources

- [IBM JCL Advanced Topics](https://www.ibm.com/docs/en/zos/2.4.0?topic=reference-jcl) - Advanced JCL techniques
- [Mainframe Performance Tuning](https://www.ibm.com/docs/en/zos/2.4.0?topic=tuning-performance) - Performance optimization
- [Job Scheduling Best Practices](https://www.ibm.com/docs/en/zos/2.4.0?topic=scheduling-job) - Job scheduling guidelines

---

## 🏆 Challenge Complete!

Congratulations! You've successfully:
- ✅ Designed and implemented a complex multi-step job workflow
- ✅ Created data validation and error handling mechanisms
- ✅ Optimized job performance with parallel processing
- ✅ Implemented comprehensive monitoring and reporting
- ✅ Demonstrated advanced JCL techniques

You're now ready for the next challenge: System Programming! 