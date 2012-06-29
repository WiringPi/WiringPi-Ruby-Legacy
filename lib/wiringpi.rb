require 'wiringpi/wiringpi'

WPI_MODE_PINS = 0
WPI_MODE_GPIO = 1

INPUT		= 0
OUTPUT		= 1
PWM_OUTPUT	= 2

HIGH		= 1
LOW			= 0

PUD_OFF		= 0
PUD_DOWN	= 1
PUD_UP		= 2

class WiringPi

	@@gpioPins = [
		0,1,4,7,8,9,10,11,14,15,17,18,21,22,23,24,25 # seemingly random indeed!
		]

	@@pins = [
		0,1,2,3,4,5,6,7, # basic IO pins
		8,9,			 # i2c with 1k8 pull up resistor
		10,11,12,13,14,	 # SPI pins, can also be used for IO
        15,16,17
		]

	@@mode = WPI_MODE_PINS
	@@init = false

    def self.shiftOut( dataPin, clockPin, latchPin, bits )

        self.wiringPiSetup unless @@init

		self.mode dataPin, OUTPUT
		self.mode clockPin, OUTPUT
		self.mode latchPin, OUTPUT

        Wiringpi.shiftOut( dataPin, clockPin, latchPin, bits, bits.length )

        #self.write( latchPin, LOW )
        #bits.each do |bit|
        #
        #    self.write( clockPin, LOW )
        #    self.write( dataPin, bit )
        #    self.write( clockPin, HIGH )
        #
        #end
        #self.write( latchPin, HIGH )

    end

	def self.readAll

		self.wiringPiSetup unless @@init

		pinValues = Hash.new

		@@pins.each do |pin|
		
			pinValues[pin] = self.read(pin)
		
		end

		pinValues

	end

	def self.wiringPiMode( mode )

		@@mode = mode
		Wiringpi.wiringPiGpioMode( @@mode )

	end

	def self.wiringPiSetup

		begin		
			Wiringpi.wiringPiSetup
		rescue Exception=>e
			raise e
		end

		Wiringpi.wiringPiGpioMode( @@mode )
		@@init = true
	
	end

	def self.read(pin)

		self.wiringPiSetup unless @@init

		raise ArgumentError, "invalid pin, available gpio pins: #{@@pins}" unless ( @@mode = WPI_MODE_PINS and @@pins.include?(pin) ) or ( @@mode = WPI_MODE_GPIO and @@gpioPins.include?(pin) )

		Wiringpi.digitalRead(pin)

	end

	def self.pwmWrite(pin,value)

		self.wiringPiSetup unless @@init

		raise ArgumentError, "invalid pin, available gpio pins: #{@@pins}" unless ( @@mode = WPI_MODE_PINS and @@pins.include?(pin) ) or ( @@mode = WPI_MODE_GPIO and @@gpioPins.include?(pin) )

		Wiringpi.pwmWrite(pin,value)

	end

	def self.write(pin,value)

		self.wiringPiSetup unless @@init
	
		raise ArgumentError, "invalid pin, available gpio pins: #{@@pins}" unless ( @@mode = WPI_MODE_PINS and @@pins.include?(pin) ) or ( @@mode = WPI_MODE_GPIO and @@gpioPins.include?(pin) )
		raise ArgumentError, 'invalid value' unless [0,1].include?(value)

		Wiringpi.digitalWrite(pin,value)

	end

	def self.mode(pin,mode)

		self.wiringPiSetup unless @@init

		raise ArgumentError, "invalid pin, available gpio pins: #{@@pins}" unless ( @@mode = WPI_MODE_PINS and @@pins.include?(pin) ) or ( @@mode = WPI_MODE_GPIO and @@gpioPins.include?(pin) )
		raise ArgumentError, "invalid mode" unless [INPUT,OUTPUT,PWM_OUTPUT].include?(mode)

		Wiringpi.pinMode(pin, mode)

	end

end
