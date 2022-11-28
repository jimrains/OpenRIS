# Control

This directory contains all the information necessary to set up and interface with the RIS prototype. 

RIS configurations are sent over a WiFi link hosted on the Raspberry Pi. A socket is established with MATLAB acting as the client, connecting to a server running on the Raspberry Pi. The server-side software is currently written in Python. 

<img src="images/control_diagram.png" width="500" />

The current procedure for setting up a socket for RIS control involves:

- Connecting to the WiFi access point from the user machine
- Connect to the Pi via SSH (i.e., via the command __ssh pi@192.168.4.1__)
- Run the program **~/control/socket-server-tiles.py**
- Note the port number **port_number** (this can be found in the **PORT** variable in the program)
- In MATLAB on the user machine, run the command **sock = tcpclient("192.168.4.1", port_number)** where **port_number** is an integer of the port number displayed when running the server

