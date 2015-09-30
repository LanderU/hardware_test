#!/bin/bash
clear
echo "Conecte el GPS al conector I2C (4 pins) y el conector serial (6 pines) al UART..."
echo "Conecte el servo-motor al canal1, con el cable amarillo o blanco hacia arriba."
read -p "Pulse intro para continuar... " p
clear
echo "-------------------------"
echo "Detectando sensores I2C"
echo "------------------------"

i2cdetect -y 1 > i2ctest
sleep 2
I2C=`cat i2ctest | grep 1e`
if [ -n "$I2C" ]; then
	echo "I2c EXTERNO OK"
else
	echo "I2C EXTERNO MAL, REVISAR PCA9306-U303"
fi
#-----------------
PCA9685=`cat i2ctest | grep 40`
if [ -n "$PCA9685" ]; then
	echo "PCA9685 DETECTADO"
else
	echo "REVISAR PCA9685-U706, NO DETECTADO"
fi
#-----------------
ADS1115=`cat i2ctest | grep 48`
if [ -n "$ADS1115" ]; then
	echo "ADS1115 DETECTADO"
else
	echo "REVISAR ADS1115-U404, NO DETECTADO"
fi
#----------------
echo "------------------------"
echo "FIN DETECCIÓN DE SENSORES I2C"
echo "------------------------"
echo ""
read -p "Pulsa intro para continuar... " p
clear
echo ""
echo "------------------------"
echo "Comprobando el puerto Serial"
echo "------------------------"


sudo cat /dev/ttyAMA0 > ttyAMA0_output &
sleep 8
killall -9 cat 2> /dev/null
ttySize=`stat -c %s ttyAMA0_output`

if [ $ttySize -eq 0 ]; then
	echo "REVISAR UART"
else
	echo "UART OK"
fi
echo ""
echo "------------------------"
echo "Fin test Serial"
echo "------------------------"
echo ""
read -p "Pulsa intro para continuar..." p
clear
echo "------------------------"
echo "Comprobando sensores SPI"
echo "------------------------"
sudo /home/pi/ROS_HAT/ArduCopter.elf > test_ArduCopter &
sleep 10
MPU9250=`cat test_ArduCopter | grep -a WHOAMI`
MS611=`cat test_ArduCopter | grep -a CRC`
ALLOK=`cat test_ArduCopter | grep -a FLY`
if [ -n "$MPU9250" ]; then
	echo "MPU9250: NO FUNCIONA"
fi

if [ -n "$MS611" ]; then
	echo "MS611: NO FUNCIONA"
fi

if [ -n "$ALLOK" ]; then
	echo "MPU9250 OK"
	echo "MS5611 OK"
fi

sleep 2
sudo killall -9 ArduCopter.elf 2> /dev/null
`sudo rm -rf test_ArduCopter` 
`sudo rm -rf ttyAMA0_output`
`sudo rm -rf i2ctest`
echo "------------------------"
echo "Fin test sensores SPI"
echo "------------------------"
read -p "Pulse intro para continuar..." p
clear
echo "------------------------"
echo "Test salidas PWM"
echo "------------------------"
sudo /home/pi/ROS_HAT/PCA9685_PWM &
sleep 6
`sudo killall -9 PCA9685_PWM 2> /dev/null`
echo ""
echo "SI EL SERVMOTOR HA GIRADO, SALIDAS PWM OK"
echo "SI EL SERVOMOTOR NO HA GIRADO, REVISAR PCA9685 (U706)"
echo ""
sleep 2
echo "------------------------"
echo "FIN test PWM"
echo "------------------------"
read -p "Pulse intro para continuar... " p
clear
echo "------------------------"
echo "FIN DEL TEST, salimos"
echo "------------------------"
sleep 4
exit 0
