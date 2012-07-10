Gem::Specification.new do |s|
  s.name	= 'wiringpi'
  s.version	= '1.1.0'
  s.license = 'GNU General Public License'
  s.date	= '2012-06-22'
  s.platform= Gem::Platform::RUBY
  s.summary	= "Arduino wiring-like library for Raspberry Pi GPIO. Will only work on a Pi. Alpha version."
  s.authors	= ["Gordon","Phil"]
  s.email	= 'phil@gadgetoid.com'
  s.files	= Dir.glob('lib/*.rb') + Dir.glob('ext/**/**/*.{c,h}') + Dir.glob('ext/**/*.{c,h,rb}')
  s.homepage	= 'http://rubygems.org/gems/wiringpi'
  s.extensions	= ['ext/wiringpi/extconf.rb']
  s.description = 'WiringPi library wrapper for the Raspberry Pi only. Wraps up the Arduino wiring-like WiringPi library into a convinient Ruby gem. Currently includes GPIO functionality, serial and shiftOut/shiftIn support. Credit to Gordon for the WiringPi library, which can be found here: http://projects.drogon.net/raspberry-pi/wiringpi/'
end
