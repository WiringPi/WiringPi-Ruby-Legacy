require 'mkmf'

$srcs = Dir.glob('WiringPi/wiringPi/*.c')
$objs = $srcs.map{ |file| file.sub('.c','.o') }
$srcs << 'wiringpi_wrap.c'
$objs << 'wiringpi_wrap.o'

create_makefile('wiringpi/wiringpi')
    
