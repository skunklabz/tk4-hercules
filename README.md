# Docker tk4-hercules
## The MVS 3.8j Tur(n)key 4- System on the Hercules Mainframe Emulator running inside a Docker container

### Usage
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