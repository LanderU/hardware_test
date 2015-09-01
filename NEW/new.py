#!/usr/bin/python
# -*- coding: utf-8 -*- 
import os
import time
import sys

#------- I2Ctest --------#
print(' ')
print ('Conecte el GPS al conector I2C (4 pins) y el conector serial (6 pines) al UART...')
print ('Conecte el servo-motor al canal1, con el cable amarillo o blanco hacia arriba')
print(' y pulsa INTRO ...')
print (' ')

key=sys.stdin.read(1)
print('Detectando sensores I2C...')

f=os.popen('i2cdetect -y 1 > i2ctest.txt')
time.sleep(2)

b = '1e'
file=open('i2ctest.txt','r')
line=file.readline()
while line!="":
        if b in line:
                validate=0
                break
        else:
		validate=1
             	line=file.readline()

if validate==0:
        print '+ I2C EXTERNO OK'
	print (' ')
else:
        print '+ REVISAR PCA9306-U303'
	print (' ')
b = '40'
file=open('i2ctest.txt','r')
line=file.readline()
while line!="":
        if b in line:
                validate=0
                break
        else:
                validate=1
                line=file.readline()

if validate==0:
        print '+ PCA9685 detectado'
	print (' ')
else:
        print '+ REVISAR PCA9685-U706, no detectado!'
	print (' ')
b = '48'
file=open('i2ctest.txt','r')
line=file.readline()
while line!="":
        if b in line:
                validate=0
                break
        else:
                validate=1
                line=file.readline()

if validate==0:
        print '+ ADS1115 detectado'
	print (' ')
else:
        print '+ REVISAR ADS1115-U404, no detectado'
	print (' ')
print('Fin detección de sensores I2C')
print (' ')

#---------- UART ---------#
#print ('Conecta el cable de 6 pines al conector UART, y pulsa INTRO...')

#key=sys.stdin.read(1)
print (' Test de conector Serial...')
print (' ')

f=os.popen('sudo cat /dev/ttyAMA0 > ttyAMA0.txt')
time.sleep(8)
f=os.popen('sudo killall -9 cat 2> /dev/null')
if os.stat("ttyAMA0.txt").st_size==0:
        print "+ Revisar UART"
else:
        print "+ UART OK"
print (' ')
print ('Fin test Serial... ')
print ( ' ' )

#---- SENSOR TEST USING ARDUCOPTER ----#
print('Comprobando sensores SPI...')
print (' ')
#f=os.popen('sudo ./ArduCopter.elf > test_out.txt')
f=os.popen('sudo ../ROS_HAT/ArduCopter.elf > test_out.txt')
#Wait Arducopter to fill the txt
#print "Time"
time.sleep(8)

#Check for errors

if 'MPU9250: unexpected WHOAMI' in open('test_out.txt').read():
        print "+MPU9250: No Funciona"

if 'Bad CRC on MS5611' in open('test_out.txt').read():
	print "+MS5611: No Funciona"

if 'Ready to FLY' in open('test_out.txt').read():
	print "+MPU02950 OK, MS5611 OK"
print (' ')

#Kill ArduCOpter, after txt
f=os.popen('sudo killall -9 ArduCopter.elf')
print('------------------------')
print('Fin test sensores SPI...')
print('------------------------')
print ('')
f=os.popen('rm test_out.txt')
f=os.popen('rm i2ctest.txt')
f=os.popen('rm ttyAMA0.txt')

#------ TEST PCA9685 ----#
print ('Test salidas PWM...')
print ('-------------------')
print ('')
time.sleep(5)
#key2=sys.stdin.read(1)
#f=os.popen('sudo ./PCA9685_PWM')
f=os.popen('sudo ../ROS_HAT/PCA9685_PWM')
time.sleep(10)
f=os.popen('sudo killall -9 PCA9685_PWM')
print('Si el servomotor ha girado, salidas PWM OK')
print ('Si no, revisar PCA9685 (U706)')
print('')
time.sleep(2)
print ('------------')
print ('|FIN test PWM| ')
print ('-------------')
print ('')
time.sleep(1)
print 'FIN TEST'
time.sleep(3)
