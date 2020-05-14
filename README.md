# Docker tk4-hercules
## The MVS 3.8j Tur(n)key 4- System on the Hercules Mainframe Emulator running inside a Docker container

## Usage
To run this on your local machine simply run:

`docker run -ti -p 3270:3270 -p8038:8038 skunklabz/tk4-hercules`

After a minute or so you'll get a prompt where you can start learning about MVS 3.8j. 

You will then need a 3270 terminal to connect to your local instance to port 3270, for instance the open source `x3270` terminal. Also, you can use your web browser to connect to the web console page by typing `http://localhost:8038/`

## Persistence
To run with persistence so that you don't lose your data after stopping the docker container please use the following command to start it up.

```
docker run -d \
--mount source=tk4-conf,target=/tk4-/conf \
--mount source=tk4-local_conf,target=/tk4-/local_conf \
--mount source=tk4-local_scripts,target=/tk4-/local_scripts \
--mount source=tk4-prt,target=/tk4-/prt \
--mount source=tk4-dasd,target=/tk4-/dasd \
--mount source=tk4-pch,target=/tk4-/pch \
--mount source=tk4-jcl,target=/tk4-/jcl \
--mount source=tk4-log,target=/tk4-/log \
-p 3270:3270 \
-p 8038:8038 tk4
```

### Description of persisted directories
- /tk4-/conf
  - This is where the master configuration file tk4-.cnf is stored
- /tk4-/local_conf
  - Scripts for initialization and unattended operations
- /tk4-/local_scripts
  - There are 10 files located here that are meant for user applied modifications and are run after Hercules initialization, when operating in manual mode or after MVS 3.8j initialization when operating in unattended mode
- /tk4-/prt
  - Used for simulated line printer devices
- /tk4-/pch
  - Card punch devices output stored here
- /tk4-/dasd
  - This contains all of the simulated CKD DASD volumes. Count key data or CKD is a direct-access storage device (DASD)
- /tk4-/jcl
  - contains the SYSGEN Job Control Files
- /tk4-/log
  - contains log files created during sysgen

## Running on Azure Cloud Container Instances
Check out the skunklabz video on how to run this on Azure Container Instances.
link: https://youtu.be/Y-JDRwk_wFY
