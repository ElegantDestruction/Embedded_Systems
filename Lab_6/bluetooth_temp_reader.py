#!/usr/bin/env python

from bluepy import btle
from time import sleep

sensor = btle.Peripheral('54:6C:0E:80:A2:05')

sensor.writeCharacteristic(0x27, '\x01', withResponse=True) #Temperature
sensor.writeCharacteristic(0x2F, '\x01', withResponse=True) #Humidity
sensor.writeCharacteristic(0x3F, '\x7F\x02', withResponse=True) #Accelerometer
sensor.writeCharacteristic(0x47, '\x01', withResponse=True) #Luxometer

sleep(1) # warm up

conversion_factor = 0.03125

for i in range(30):
    t_data = sensor.readCharacteristic(0x24)
    h_data = sensor.readCharacteristic(0x2C)
    l_data = sensor.readCharacteristic(0x44)
    a_data = sensor.readCharacteristic(0x3C)

    t_msb = ord(t_data[3])
    t_lsb = ord(t_data[2])

    h_msb = ord(h_data[3])
    h_lsb = ord(h_data[2])
    h_msb8 = h_msb << 8
    h_raw_data = h_msb8 + h_lsb
    h_raw_data &= ~0x0003

    l_msb = ord(l_data[1]) << 8
    l_lsb = ord(l_data[0])
    l_raw_data = l_lsb + l_msb
    m = l_raw_data & 0xFFF
    e = (l_raw_data & 0xF000) >> 12
    if (e == 0):
        e = 1
    else:
        e = (2 << (e - 1))

    g_x1 = ord(a_data[0])
    g_x2 = ord(a_data[1])
    g_y1 = ord(a_data[2])
    g_y2 = ord(a_data[3])
    g_z1 = ord(a_data[4])
    g_z2 = ord(a_data[5])
    acc_x1 = ord(a_data[6])
    acc_x2 = ord(a_data[7])
    acc_y1 = ord(a_data[8])
    acc_y2 = ord(a_data[9])
    acc_z1 = ord(a_data[10])
    acc_z2 = ord(a_data[11])
    # add upper and lower half of 16 bits after shifting msb
    acc_x = acc_x1 + (acc_x2 << 8)
    acc_y = acc_y1 + (acc_y2 << 8)
    acc_z = acc_z1 + (acc_z2 << 8)
    gyro_x = g_x1 + (g_x2 << 8)
    gyro_y = g_y1 + (g_y2 << 8)
    gyro_z = g_z1 + (g_z1 << 8)

    c = ((t_msb * 256 + t_lsb)/4)*conversion_factor
    f = c*9/5.0+32
    h = (float(h_raw_data)/65536) * 100
    l = float(m) * (0.01 * float(e))
    

    print '%s degrees fahrenheit' % round(f,2)
    print '%s%% Humidity' % round(h,2)
    print '%s Light Intensity' % round(l,2)
    print '%s Accel X (G)' % round(((float(acc_x) * 1.0) / (32768 / 16)),2)
    print '%s Accel Y (G)' % round(((float(acc_y) * 1.0) / (32768 / 16)),2)
    print '%s Accel Z (G)' % round(((float(acc_z) * 1.0) / (32768 / 16)),2)
    print '\n'
    sleep(2)

sensor.writeCharacteristic(0x27, '\x00', withResponse=True) #Temperature
sensor.writeCharacteristic(0x2F, '\x00', withResponse=True) #Humidity
sensor.writeCharacteristic(0x3F, '\x00', withResponse=True) #Accelerometer
sensor.writeCharacteristic(0x47, '\x00', withResponse=True) #Luxometer
