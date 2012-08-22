require 'mkmf'
create_makefile('wiringpi/wiringpi')

srcs = Dir.glob('WiringPi/wiringPi/*.c')
objs = Dir.glob('WiringPi/wiringPi/*.c').map { |file| file.sub('.c','.o') }

srcs = srcs.join(' ')
objs = objs.join(' ')

makefile = File.open('Makefile', 'r').read

makefile.sub!('SRCS = ','SRCS = ' + srcs + ' ')
makefile.sub!('OBJS = ','OBJS = ' + objs + ' ')

File.open('Makefile','w') {|file| file.write(makefile)}

    
