#!/usr/bin/python
import os
import sys
import datetime
import commands
import math
import time
from string import split
from smbus import SMBus
from time import sleep

#set devide ID
deviceID = 1

#initilise the humidity & temperature sensor (HIH-6130) - uncomment appropriate line depending on Pi version used
#if using version 2 Pi (512 M) then use i2c bus is #1
#HIH6130 = SMBus(0)  # 0 indicates /dev/i2c-0
HIH6130 = SMBus(1)  # 1 indicates /dev/i2c-1

def readHIH6130():
  #temporary storage array for HIH6130 data
  var = [0, 0, 0, 0]

  #fetch temp and humidity data from HIH-6130
  humidityOffSet = 6.5
  #HIH6130.write_quick(0x27)
  sleep(0.050)
  var = HIH6130.read_i2c_block_data(0x27, 0)
  humidity = ((((var[0] & 0x3f) << 8) + var[1]) * 100.0 / 16383.0) + humidityOffSet

  return {'humidity':humidity}

def main():

  try:
    while(True):
      print  readHIH6130().get('humidity')
  #Ctrl C user interrupt
  except KeyboardInterrupt:
    print 'User cancelled...'
if __name__ == '__main__':
  main()
  print 'Alex'
