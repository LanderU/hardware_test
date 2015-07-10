#! /bin/bash

#Configure LED GPIOs as  outputs
echo 12 > /sys/class/gpio/export
echo 13 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio12/direction
echo out > /sys/class/gpio/gpio13/direction
#Turn on GPIOs
echo 1 > /sys/class/gpio/gpio12/value
echo 1 > /sys/class/gpio/gpio13/value
#2s delay
sleep 2
#Turn off GPIOs
echo 0 > /sys/class/gpio/gpio12/value
echo 0 > /sys/class/gpio/gpio13/value
