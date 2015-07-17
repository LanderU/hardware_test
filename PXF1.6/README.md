Collection of device tests for the PXFv1.6
==========================================

- Use them in a Erle-Robotics Debian image.

- BusTest.elf -> SPI bus test for MPU9250 (0x71 SPI addr), LSM9DS(0x49, 0xD4 addrs) and MPU6000 (0x68 addr)
- Baro_MS5611_test.elf -> SPI bus test for MS5611
- bmp085_i2c_test.py -> I2C bmp085 test, intended to use when the bmp085 is connected to the I2C exp. connector
- test_i2c_HIH_6130.py -> I2C HIH_6130,    "      "  "    "    "  HIH_6130 "  "  " " 


-test_pxfv1.6.py : PXFv1.6 test script, checks sensors using 3IMU ArduCopter version.
