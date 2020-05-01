# Docker tk4-hercules
## The MVS 3.8j Tur(n)key 4- System on the Hercules Mainframe Emulator running inside a Docker container

### Usage
To run this on your local machine simply run:

`docker run -ti -p 3270:3270 -p8038:8038 skunklabz/tk4-hercules`

After a minute or so you'll get a prompt where you can start learning about MVS 3.8j. 

You will then need a 3270 terminal to connect to your local instance to port 3270, for instance the open source `x3270` terminal. Also, you can use your web browser to connect to the web console page by typing `http://localhost:8038/`
