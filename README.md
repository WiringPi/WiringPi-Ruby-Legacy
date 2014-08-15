# WiringPi-Ruby

WiringPi: An implementation of most of the Arduino Wiring
	functions for the Raspberry Pi

WiringPiGem: The WiringPi library wrapped up for Ruby with some OO goodness, sanity checking and other handy additions.

## WiringPi GPIO:

    require 'wiringpi'
    io = WiringPi::GPIO.new
    io.write(pin,value)
    io.read(pin,value)

### Shift out:

    io.write(latch_pin, LOW)
    io.shiftOut(data_pin, clock_pin, LSBFIRST or MSBFIRST, value)
    io.write(latch_pin, HIGH)

    Shift out an array of 1/0s (always uses LSBFIRST):

    io.shiftOutArray(data_pin, clock_pin, latch_pin, [0,1,0,0,1,1,1,0])

## WiringPi GPIO with /sys/class/gpio:

    require 'wiringpi'
    io = WiringPi::GPIO.new(WPI_MODE_SYS)
    # read/write/shift as usual

## WiringPi Serial:

    require 'wiringpi'
    s = WiringPi::Serial.new('/dev/ttyAMA0',9600)
    s.serialPuts('Hello world!')
    s.serialClose

Full details at:
	https://projects.drogon.net/raspberry-pi/wiringpi/

