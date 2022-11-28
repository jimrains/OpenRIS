# Control

This directory contains all the information necessary to set up and interface with the RIS prototype. 

RIS configurations are sent over a WiFi link hosted on the Raspberry Pi. A socket is established with MATLAB acting as the client, connecting to a server running on the Raspberry Pi. The server-side software is currently written in Python. 

<img src="images/control_diagram.png" width="500" />

## Socket Setup

The current procedure for setting up a socket for RIS control involves:

- Connect to the WiFi **PiRS** access point from the user machine
- Establish control of the Pi via SSH (i.e., via the command __ssh pi@192.168.4.1__)
- Run the program **python ~/control/socket-server-tiles.py**
- Note the port number **port_number** (this can be found in the **PORT** variable in the program)
- In MATLAB on the user machine, run the command **sock = tcpclient("192.168.4.1", port_number)** where **port_number** is an integer of the port number displayed when running the server

## Pi Graphical User Interface

If for whatever reason you need to access the graphical user interface (GUI) of the Raspberry Pi, you can use a VNC viewer. One such program you is RealVNC which can be found [here](https://www.realvnc.com/en/connect/download/vnc/). Follow the first two instructions in the **Socket Setup** section above, then:

- In the secure shell, run the command **vncserver**. Note down the IP address and the number following the colon.
- Open VNC Viewer or an equivalent program. Use the VNC server address **192.168.4.1:#** where **#** is the number obtained in the previous step (typically defaults to 1 if no other session is open).
