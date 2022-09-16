### Test RIS configuration setting code


## Send 32 bits of data and clock in


## go for 101010101... on the hardware itself

import RPi.GPIO as GPIO
import time
import tilemapping

SCLK =  [3,11,21]
LATCH = [5,13,23]
DATA1 = [7,15,22]
DATA2 = [8,16,24]
DATA3 = [10,18,26]
DATA4 = [12,19,29]

map = [16,14,15,13,8,7,6,5,4,3,12,11,2,1,9,10,17, \
	18,25,26,19,20,27,28,29,30,32,31,22,24,23,21]
map.reverse()

colmap = map + [x + 32 for x in map] + [x + 64 for x in map] + [x + 96 for x in map]
colmap = [x - 1 for x in colmap]


def initPIcom():
	GPIO.setmode(GPIO.BOARD)
	GPIO.setwarnings(False)
	for k in range(0,3):
		GPIO.setup(DATA1[k], GPIO.OUT)
		GPIO.setup(DATA2[k], GPIO.OUT)
		GPIO.setup(DATA3[k], GPIO.OUT)
		GPIO.setup(DATA4[k], GPIO.OUT)
		GPIO.setup(SCLK[k], GPIO.OUT)
		GPIO.setup(LATCH[k], GPIO.OUT)

def mapbits(bits):
	D1,D2,D3,D4 = [],[],[],[]

	for k in range(0,16):
		D1 = D1 + bits[(24 + k*32):(24 + k*32 + 8)]
		D2 = D2 + bits[(16 + k*32):(16 + k*32 + 8)]
		D3 = D3 + bits[( 8 + k*32):( 8 + k*32 + 8)]
		D4 = D4 + bits[(k*32):(k*32 + 8)]
	D1_mapped = [D1[i] for i in colmap]
	D2_mapped = [D2[i] for i in colmap]
	D3_mapped = [D3[i] for i in colmap]
	D4_mapped = [D4[i] for i in colmap]
	return D1_mapped, D2_mapped, D3_mapped, D4_mapped


# Input: tile number (1-3) and configuration (512 bits) for given tile
def setconf(tile_num, config):

	# Data for 4 columns of shift registers (128 bits per)
	D1,D2,D3,D4 = mapbits(config)

	# Tile number index (0-2)
	t = tile_num - 1

	# Set latch low
	GPIO.output(LATCH[t], GPIO.LOW)
	GPIO.output(LATCH[t], GPIO.LOW)

	# Cycle over 4 parallel data streams
	for k in range(0,128):
		GPIO.output(SCLK[t], GPIO.LOW)
		GPIO.output(SCLK[t], GPIO.LOW)

		## Send out data on 4 lines
		if D1[k] > 0:
			GPIO.output(DATA1[t], GPIO.HIGH)
		else:
			GPIO.output(DATA1[t], GPIO.LOW)
		if D2[k] > 0:
			GPIO.output(DATA2[t], GPIO.HIGH)
		else:
			GPIO.output(DATA2[t], GPIO.LOW)

		if D3[k] > 0:
			GPIO.output(DATA3[t], GPIO.HIGH)
		else:
			GPIO.output(DATA3[t], GPIO.LOW)

		if D4[k] > 0:
			GPIO.output(DATA4[t], GPIO.HIGH)
		else:
			GPIO.output(DATA4[t], GPIO.LOW)

		# Clock in the data lines
		GPIO.output(SCLK[t], GPIO.HIGH)

	# Latch in data
	GPIO.output(LATCH[t], GPIO.HIGH)

#initPIcom()

#while 1:
#	data = [0]*512
#	data[488:496] = [1,1,1,1,0,0,1,1]
#	data[456:464] = [1,1,1,1,1,1,1,1]
#	setconf(1, data)
