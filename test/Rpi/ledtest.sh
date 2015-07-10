#! /bin/bash

#Configure LED GPIOs as  outputs
echo 24 > /sys/class/gpio/export
echo 25 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio24/direction
echo out > /sys/class/gpio/gpio25/direction
#Turn on LEDS
echo 0 > /sys/class/gpio/gpio24/value
echo 0 > /sys/class/gpio/gpio25/value
#2s delay
sleep 2
#Turn off LEDS
echo 1 > /sys/class/gpio/gpio24/value
echo 1 > /sys/class/gpio/gpio25/value
