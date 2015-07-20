#!/usr/bin/python

import os
import time
import sys

#---- SENSOR TEST USING ARDUCOPTER ----#

#OK, creates file with output of ArduCopter
#print "Open"
f=os.popen('./ArduCopter_3IMU.elf > test_out.txt')

#TEST cases
#f=os.popen('./ArduCopter_3IMU_MPU6000primero.elf > test_out.txt')
#f=os.popen('./ArduCopter_3IMU_LSMprimero.elf > test_out.txt')


#Wait Arducopter to fill the txt
print "Time"
time.sleep(15)

#Check for errors
if 'Failed to boot MPU6000' in open('test_out.txt').read():
        print "MPU6000: No Funciona"

if 'LSM9DS0: unexpected gyro WHOAMI' in open('test_out.txt').read():
	print "LSM9D: No Funciona"

if 'LSM9DS0: unexpected acc/mag  WHOAMI' in open('test_out.txt').read(): 
        print "LSM9D: No Funciona"

if 'MPU9250: unexpected WHOAMI' in open('test_out.txt').read():
        print "MPU9250: No Funciona"

if 'Bad CRC on MS5611' in open('test_out.txt').read():
	print "MS5611: No Funciona"

if 'Ready to FLY' in open('test_out.txt').read():
	print "MPU6000 ok, MPU02950 OK, LSM9D OK, MS5611 OK"

print "End if"
#Kill ArduCOpter, after txt
f=os.popen('killall -9 ./ArduCopter_3IMU.elf')
print "ArduCopter killed"

f=os.popen('rm test_out.txt')

print "End sensor tests"


#----- I2C test ----#
print "Test I2C"
f=os.popen('i2cdetect -r -y 1 > i2ctest.txt')
# NOT working
if ' 1e ' in open('i2ctest.txt').read():
        print "I2C Funciona OK"
else: print "I2C NO funciona" 


#print "Conecta el cable de 6 pinea al TTYO5 y pulse INTRO..."

#How to get input from user?? Facing errrors...
#text = sys.stdin.read() 
#print text
#print (raw_input('Conecta el cable de 6 pines al conector ttyO5, pulsa INTRO...'))
#entrada = raw_input()
#print entrada
#---------------------#

f=os.popen('cat /dev/ttyO5 > ttyO5.txt')
time.sleep(15)
f=os.popen('killall -9 cat')
if os.stat("ttyO5.txt").st_size==0:
	print "Revisar ttyO5"

f=os.popen('rm ttyO5.txt')

f=os.popen('cat /dev/ttyO4 > ttyO4.txt')
time.sleep(15)
f=os.popen('killall -9 cat')
if os.stat("ttyO4.txt").st_size==0:
        print "Revisar ttyO4"

f=os.popen('rm ttyO4.txt')
