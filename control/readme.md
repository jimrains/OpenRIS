# Control

This directory contains all the information necessary to set up and interface with the RIS prototype. 

RIS configurations are sent over a WiFi link hosted on the Raspberry Pi 3B. A socket is established with MATLAB acting as the client, connecting to a server running on the Raspberry Pi. The server-side software is currently written in Python. Configurations sent via MATLAB are transformed into the correct format by the Python program on the Pi side. The Pi then sets the digital states of the GPIO pins to program the shift registers on the respective RIS tiles. 

<img src="images/control_diagram.png" width="500" />

## Ethernet Connection

It is possible to connect to the Raspberry Pi via an ethernet cable through a secure shell through the command:

**ssh pi@raspberrypi.local**

with the default password.

## WiFi Access Point

By default, the access point on the USC prototype is set up on boot, with an access point name **PiRS**. The password is the default and won't be posted here for obvious reasons (just ask James or others in the project). 

To set up an access point on the Raspberry Pi 3B from a fresh install, see the guide posted [here](https://learn.sparkfun.com/tutorials/setting-up-a-raspberry-pi-3-as-an-access-point/all). Note the static IP address you use in the __interfaces__ file.

As an alternative, you may set up a mobile hotspot on a PC and get the Pi to connect to you. To keep things simple, you may connect a monitor/keyboard/mouse to the Pi the first time you do this. 

## Socket Setup

The current procedure for setting up a socket for RIS control involves:

- Connect to the **PiRS** WiFi access point from the user machine
- Establish control of the Pi via SSH (i.e., via the command __ssh pi@192.168.4.1__). Use the default username and password.
- Run the program **python ~/control/socket-server-tiles.py**
- Note the port number **port_number** (this can be found in the **PORT** variable in the program)
- In MATLAB on the user machine, run the command **sock = tcpclient("192.168.4.1", port_number)** where **port_number** is an integer of the port number displayed when running the server

## MATLAB Interfacing

Configurations are sent over the socket in the form of a string of bits. Additionally, a tile number is sent so that the Pi knows which set of GPIO pins it should send the control signals over. 

## Pinouts

### Tile pinout

Each RIS tile requires 6 digital inputs alongside a DC voltage and a ground connection. The DC voltage should be the same level as the logic high. For the Raspberry Pi 3B, this will be 3.3 V. 

<img src="images/pinout_tile.png" width="500" />

| Pin # | ID   | Function                                           | T1->Raspberry Pi | T2->Raspberry Pi |
|-------|------|----------------------------------------------------|------------------|------------------|
| 1     | NC   | Not connected                                      | -                | -                |
| 2     | NC   | Not connected                                      | -                | -                |
| 3     | D4   | Data line 4                                        | 3->12            | 3->19            |
| 4     | D3   | Data line 3                                        | 4->10            | 4->18            |
| 5     | L    | Latch (shifts out data to shift register outputs)  | 5->5             | 5->13            |
| 6     | D2   | Data line 2                                        | 6->8             | 6->16            |
| 7     | C    | Clock (timing signal)                              | 7->3             | 7->11            |
| 8     | D1   | Data line 1                                        | 8->7             | 8->15            |
| 9     | GND  | DC ground                                          | 9->6             | 9->14            |
| 10    | GND  | DC ground                                          | -                | -                |
| 11    | Vcc  | DC voltage (3.3 V for Pi 3B)                       | 11->1            | 11->17           |
| 12    | Vcc  | DC voltage (3.3 V for Pi 3B)                       | -                | -                |

### Pi pinout

<img src="images/GPIO-Pinout-Diagram-2.png" width="700" />

The pinout of the Raspberry Pi 3 will depend on the number of tiles that are utilised for a particular arrangement. This is governed by the **tile.h** file in this directory. The pin mapping for two tiles is shown in the two right-hand columns in the table above. The Pi GPIO pin numbers refer to the __board__ numbering scheme (i.e., the physical pin number). For more information on the Raspberry Pi GPIO interface, see [here](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#gpio-and-the-40-pin-header). 



## Pi Graphical User Interface

If for whatever reason you need to access the graphical user interface (GUI) of the Raspberry Pi, you can use a VNC viewer. One such program is RealVNC which can be found [here](https://www.realvnc.com/en/connect/download/vnc/). Follow the first two instructions in the **Socket Setup** section above, then:

- In the secure shell, run the command **vncserver**. Note down the IP address and the number following the colon.
- Open VNC Viewer or an equivalent program. Use the VNC server address **192.168.4.1:#** where **#** is the number obtained in the previous step (typically defaults to 1 if no other session is open).
- Enter the username and password of the Pi. This is set to default.

