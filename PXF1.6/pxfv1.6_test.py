import os
import time

#OK, creates file with output of ArduCopter
print "Open"
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


#destroy txt
#os.popen('rm test_out.txt')
os.popen('killall -9 ./ArduCopter_3IMU.elf')
