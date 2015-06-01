require 'mkmf'

$srcs = ["WiringPi/wiringPi/wiringPi.c", "WiringPi/wiringPi/wiringShift.c", "WiringPi/wiringPi/wiringSerial.c"]
$objs = $srcs.map{ |file| file.sub('.c','.o') }

create_makefile('wiringpi/wiringpi')
