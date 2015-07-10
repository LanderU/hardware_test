Collection of device tests for Rpi
=====================================


- BusTest.elf -> SPI bus test for MPU9250 (0x71 SPI addr)
- MS5611_SPI_test.elf -> SPI bus test for MS5611
- ADS1115_test -> ADS1115 test I2C.
- MPU9250_test.py -> reads accel/gyro values (SPI)
- PCA9685_PWM -> generates PWM out in ch1 
- PPM_decoder -> Decodes PPm Input and displays values
- bmp180 -> reads bmp180 temp/pressure values through I2C.
- gpiotest.sh -> Turns on/off 2xGPIOs of the connector
- ledtest.sh -> Turns on/off 2x LEDs
- pca9685 -> generates PWM outs using PCA9685

