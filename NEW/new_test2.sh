#!/bin/bash
: '
	Maintener Lander Usategui e-mail: lander@erlerobotics.com
		  Iñigo Muguruza e-mail:  inigo@erlerobotics.com
'
###########################
##########FUNCTIONS########
###########################
redColor(){
	tput setaf 1
} # End red color

greenColor(){
	tput setaf 2
} # End green color

resetColor(){
	tput sgr 0
} # End Reset color
###########################
##########################

### Check for the version of Raspberry Pi ##

cpu=`cat /proc/cpuinfo | grep Hardware`

if [ cpu="*BCM2709" ]; then
        #echo "Rpi V2"
        GPS_PATH="/dev/ttyAMA0"

elif  [cpu="*BCM2835"];then
        #echo "Rpi V3"
        GPS_PATH="/dev/ttyS0"
fi


#TEST_PATH="/home/erle/hardware_test/NEW"
TEST_PATH=`pwd`
echo $pwd
sleep 5
PATH2="/home/pi/Desktop"
clear
echo "Conecte el GPS al conector I2C (4 pins) y el conector serial (6 pines) al UART..."
echo "Conecte el servo-motor al canal1, con el cable amarillo o blanco hacia arriba."
read -p "Pulse intro para continuar... " p
clear
clear
echo "-------------------------"
echo "TEST DE LEDS"
echo "------------------------"
echo -e "Prueba de LED, el orden de los LEDs es el siguiente:\n1-Amarrillo\n2-Ámbar\n3-Azul"
sudo -s <<EOF
echo "25" > /sys/class/gpio/export 2>/dev/null
echo "out" > /sys/class/gpio/gpio25/direction 2>/dev/null
echo "24" > /sys/class/gpio/export 2>/dev/null
echo "out" > /sys/class/gpio/gpio24/direction 2>/dev/null
echo "1" > /sys/class/gpio/gpio24/value 2>/dev/null
echo "1" > /sys/class/gpio/gpio25/value 2>/dev/null
EOF
read -p "Pulse intro para encender el LED azul... " p
echo "Luz azul (LED número 3) encendida"
sudo -s <<EOF
echo "1" > /sys/class/gpio/gpio25/value 2>/dev/null
echo "0" > /sys/class/gpio/gpio25/value 2>/dev/null
EOF
read -p "Pulsa intro para apagar el LED azul..." p
echo "Luz azul (LED número 3) apagada"
sudo -s <<EOF
echo "1" > /sys/class/gpio/gpio25/value 2>/dev/null
EOF
read -p "Pulse intro para encender el ambar... " p
echo "Luz ámbar (LED número 2) encendida"
sudo -s <<EOF
echo "0" > /sys/class/gpio/gpio24/value 2>/dev/null
EOF
read -p "Pulse intro para atenuar el LED... " p
echo "Luz ámbar (LED número 2) atenuada"
sudo -s <<EOF
echo "1" > /sys/class/gpio/gpio24/value 2>/dev/null
EOF
echo "------------------------"
echo "FIN TEST DE LEDS"
echo "------------------------"
echo ""
read -p "Pulse intro para continuar... " p

clear
echo "-------------------------"
echo "Detectando sensores I2C"
echo "------------------------"

`sudo i2cdetect -y 1 > /home/pi/Desktop/i2ctest`
sleep 2
I2C=`cat $PATH2/i2ctest | grep 1e`
if [ -n "$I2C" ]; then
#	tput setaf 2
	greenColor
	echo "I2c EXTERNO OK"
#	tput sgr0
	resetColor
else
#	tput setaf 1
	redColor
	echo "I2C EXTERNO MAL, REVISAR PCA9306-U303"
#	tput sgr0
	resetColor
fi
#-----------------
PCA9685=`cat $PATH2/i2ctest | grep 40`
if [ -n "$PCA9685" ]; then
#	tput setaf 2
	greenColor
	echo "PCA9685 DETECTADO"
	resetColor
#	tput sgr0
else
#	tput setaf 1
	redColor
	echo "REVISAR PCA9685-U706, NO DETECTADO"
#	tput sgr0
	resetColor
fi
#-----------------
ADS1115=`cat $PATH2/i2ctest | grep 48`
if [ -n "$ADS1115" ]; then
#	tput setaf 2
	greenColor
	echo "ADS1115 DETECTADO"
#	tput sgr0
	resetColor
else
#	tput setaf 1
	redColor
	echo "REVISAR ADS1115-U404, NO DETECTADO"
#	tput sgr0
	resetColor
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


sudo cat $GPS_PATH > $PATH2/ttyAMA0_output &
sleep 8
`sudo killall -9 cat 2> /dev/null`
ttySize=`stat -c %s $PATH2/ttyAMA0_output`

if [ $ttySize -eq 0 ]; then
#	tput setaf 1
	redColor
	echo "REVISAR UART"
#	tput sgr0
	resetColor
else
#	tput setaf 2
	greenColor
	echo "UART OK"
#	tput sgr0
	resetColor
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
sudo $TEST_PATH/ArduCopter.elf > $PATH2/test_ArduCopter &
sleep 10
MPU9250=`cat $PATH2/test_ArduCopter | grep -a WHOAMI`
MS611=`cat $PATH2/test_ArduCopter | grep -a CRC`
ALLOK=`cat $PATH2/test_ArduCopter | grep -a FLY`
if [ -n "$ALLOK" ]; then
	greenColor
	echo "MPU9250 OK"
	echo "MS5611 OK"
	resetColor
elif [ -n "$MPU9250" ]; then
	redColor
	echo "MPU9250: NO FUNCIONA"
	resetColor
elif [ -n "$MS611" ]; then
	redColor
	echo "MS611: NO FUNCIONA"
	resetColor
else
	redColor
	echo "MS5611 o MPU9250 no funcionan"
	resetColor
fi

sleep 2
while :; do

	if [ "`ps -e | grep ArduCopter.elf 2>/dev/null`" ]; then
#		echo "Matando procesos"
		`sudo killall -9 ArduCopter.elf 2> /dev/null`
	else
		break
	fi
done

while :; do

	if [ "`ls $PATH2/test_ArduCopter 2>/dev/null`" ]; then
#		echo "Borrando archivos temporales"
		`sudo rm -rf $PATH2/test_ArduCopter`

	else
		break
	fi
done
while :; do

	if [ "`ls $PATH2/ttyAMA0_output 2>/dev/null`" ]; then
#		echo "Borrando archivos temporales"
		`sudo rm -rf $PATH2/ttyAMA0_output`
	else
		break
	fi
done
while :; do
	if [ "`ls $PATH2/i2ctest 2>/dev/null`" ]; then
#		echo "Borrando archivos temporales"
		`sudo rm -rf $PATH2/i2ctest`
	else
		break
	fi
done
echo "------------------------"
echo "Fin test sensores SPI"
echo "------------------------"
read -p "Pulse intro para continuar..." p
clear
echo "------------------------"
echo "Test salidas PWM"
echo "------------------------"
sleep 6
sudo $TEST_PATH/PCA9685_PWM &
while :; do
	if [ "`ps -e | grep PCA9685_PWM 2>/dev/null`" ]; then
#		echo "Matando los procesos"
		`sudo killall -9 PCA9685_PWM 2> /dev/null`
	else
		break
	fi
done
echo ""
greenColor
echo "SI EL SERVMOTOR HA GIRADO, SALIDAS PWM OK"
resetColor
echo ""
redColor
echo "SI EL SERVOMOTOR NO HA GIRADO, REVISAR PCA9685 (U706)"
resetColor
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
