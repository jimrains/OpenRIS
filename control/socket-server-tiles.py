# load additional Python module
import socket
import csv
#import event_pb2
import tileif as tif


PORT = 13591

# Initialise GPIO pins of raspberry pi
tif.initPIcom()

# create TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# retrieve local hostname
local_hostname = socket.gethostname()

# get fully qualified hostname
local_fqdn = socket.getfqdn()

# get the according IP address
ip_address = socket.gethostbyname(local_hostname)

ip_address = "192.168.4.1"

# output hostname, domain name and IP address
print ("working on %s (%s) with %s" % (local_hostname, local_fqdn, ip_address))

# bind the socket to the port 23456
server_address = (ip_address, PORT)
print('starting up on %s port %s' % server_address)
sock.bind(server_address)


# listen for incoming connections (server mode) with one connection at a time
sock.listen(1)

while True:
    # wait for a connection
    print('waiting for a connection')
    connection, client_address = sock.accept()
    #sock.send('a'.encode())
    try:
        # show who connected to us
        print('connection from', client_address)
        # receive the data in small chunks and print it
        while True:
            sockdata = connection.recv(1025)
            if sockdata:
#                print(len(sockdata))
                if len(sockdata) == 1025:
                # output received data
#                    print("Data: %s" % sockdata)
                    stream = str(sockdata)
                    bitstring = stream[4:-1]
#                    print(bitstring)
                    tilestring = stream[2:4]
                    tile_num = int(tilestring)
                # remove MATLAB matrix formatting
                    data = bitstring.replace(';',' ')
#                    print(data)
                    u = data.split()
                    g = [int(x) for x in u]
                    if len(g) < 512:
                        connection.sendall('b'.encode('utf-8'))
                        break
                #    print(len(g))
#                    print('Received %d bits for tile %d' % (len(g), tile_num))
                #print(g)
                    tif.setconf(tile_num, g)
                #ok = 'a';
                    connection.sendall('a'.encode('utf-8'))
                #print(len(g))
            else:
                # no more data -- quit the loop
                print("no more data.")
                break
    finally:
        # Clean up the connection
        connection.close()
