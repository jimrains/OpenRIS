import tileif as ti
ti.initPIcom()
data = [1]*512
data[488:496] = [1,0,1,0,1,0,1,0]
data[456:464] = [0,0,0,0,0,0,0,0]
# set configuration of tile 1 to data
ti.setconf(1, data)
