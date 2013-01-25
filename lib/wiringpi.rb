require 'wiringpi/wiringpi'

WPI_MODE_PINS = 0 # Use sane pin numbering
WPI_MODE_GPIO = 1 # Use Broadcom barmy GPIO pin numbering
WPI_MODE_SYS  = 2 # Use /sys/class/gpio method

# Constants for mode()
INPUT = 0
OUTPUT = 1
PWM_OUTPUT = 2

# Constants for digitalWrite()
HIGH = 1
LOW = 0

PUD_OFF = 0
PUD_DOWN = 1
PUD_UP = 2

# Bit-order for shiftOut and shiftIn
LSBFIRST = 0 # Least Significant Bit First
MSBFIRST = 1 # Most Significant Bit First

module WiringPi

  class Serial

    @id = 0
    @device = '/dev/ttyAMA0'
    @baud = 9600

    def initialize(device='/dev/ttyAMA0',baud=9600)

      @device = device
      @baud = baud

      @id = Wiringpi.serialOpen( @device,@baud )

    end

    def serialClose

      Wiringpi.serialClose( @id )
      @id = 0

    end

    def serialPutchar( char )

      Wiringpi.serialPutchar( @id, char )

    end

    def serialPuts( string )

      Wiringpi.serialPuts( @id, string )

    end

    def serialDataAvail
    
      Wiringpi.serialDataAvail( @id )

    end

    def serialGetchar

      Wiringpi.serialGetchar( @id )

    end

  end

  class GPIO

    GPIO_PINS_REV_1 = [
      0,1,4,7,8,9,10,11,14,15,17,18,21,22,23,24,25 # seemingly random indeed!
      ]

    GPIO_PINS_REV_2 = [
      2,3,4,7,8,9,10,11,14,15,17,18,22,23,24,25,27 # replace 3 pins for Rev. 2 Pi's
      ]

    PINS = [
      0,1,2,3,4,5,6,7, # basic IO pins
      8,9,             # i2c with 1k8 pull up resistor
      10,11,12,13,14,     # SPI pins, can also be used for IO
      15,16,17
      ]

    @mode = WPI_MODE_PINS

    @gpio_pins = GPIO_PINS_REV_2

    @@init = false  # once wiringPiSetup has been called, we don't have to do it again

    def initialize( mode=WPI_MODE_PINS )

	    @mode = mode
      self.wiringPiSetup unless @@init

    end

    def wiringPiMode( mode )

      @mode = mode
      Wiringpi.wiringPiGpioMode( @mode )

    end

    def piBoardRev
      Wiringpi.piBoardRev
    end

    def wiringPiSetup

      begin
        if @mode == WPI_MODE_PINS
            Wiringpi.wiringPiSetup
        elsif @mode == WPI_MODE_GPIO
            Wiringpi.wiringPiSetupGpio
        elsif @mode == WPI_MODE_SYS
            Wiringpi.wiringPiSetupSys
        end

        if self.piBoardRev == 1   # What PINs should we use for this board
          @gpio_pins = GPIO_PINS_REV_1
        else
          @gpio_pins = GPIO_PINS_REV_2
        end
      rescue Exception=>e
        raise e
      end

      #Wiringpi.wiringPiGpioMode( @mode )
      @@init = true
    
    end

    def checkPin(pin)

      ( @mode = WPI_MODE_PINS and PINS.include?(pin) ) or ( @mode = WPI_MODE_GPIO and @gpio_pins.include?(pin) )

    end

    def pinError(pin)
      "invalid #{pin}, available gpio pins: #{PINS}" if @mode == WPI_MODE_PINS
      "invalid #{pin}, available gpio pins: #{@gpio_pins}" if @mode == WPI_MODE_GPIO
    end

    def read(pin)

      raise ArgumentError, pinError(pin) unless checkPin(pin)

      Wiringpi.digitalRead(pin)

    end

    def pwmWrite(pin,value)

      raise ArgumentError, pinError(pin) unless checkPin(pin)

      Wiringpi.pwmWrite(pin,value)

    end

    def write(pin,value)
    
      raise ArgumentError, pinError(pin) unless checkPin(pin)
      raise ArgumentError, 'invalid value' unless [0,1].include?(value)

      Wiringpi.digitalWrite(pin,value)

    end

    def mode(pin,mode)

      raise ArgumentError, pinError(pin) unless checkPin(pin)
      raise ArgumentError, "invalid mode" unless [INPUT,OUTPUT,PWM_OUTPUT].include?(mode)

      Wiringpi.pinMode(pin, mode)

    end

=begin
shiftOutArray int dataPin, int clockPin, int latchPin, int[] bits
Shifts out an array of ints by converting them into bytes
and handing to Wiringpi.shiftOut, must contain only 1s or 0s
=end
    def shiftOutArray(dataPin, clockPin, latchPin, bits)

      raise ArgumentError, "invalid data pin, available gpio pins: #{PINS}" unless checkPin(dataPin)
      raise ArgumentError, "invalid clock pin, available gpio pins: #{PINS}" unless checkPin(clockPin)
      raise ArgumentError, "invalid latch pin, available gpio pins: #{PINS}" unless checkPin(latchPin)

      Wiringpi.digitalWrite( latchPin, LOW )

      bits.each_slice(8) do |slice|
        Wiringpi.shiftOut(dataPin, clockPin, LSBFIRST, slice.reverse.join.to_i(2)) 
      end

      Wiringpi.digitalWrite( latchPin, HIGH )

    end

=begin
shiftOut int dataPin, int clockPin, int latchPin, char
Shift out a single 8-bit integer 0-255
=end
    def shiftOut(dataPin, clockPin, byteOrder, char)

      #raise ArgumentError, "invalid data pin, available gpio pins: #{PINS}" unless checkPin(dataPin)
      #raise ArgumentError, "invalid clock pin, available gpio pins: #{PINS}" unless checkPin(clockPin)
      #raise ArgumentError, "invalid latch pin, available gpio pins: #{PINS}" unless checkPin(latchPin)
        
      #Wiringpi.digitalWrite( latchPin, LOW )

      Wiringpi.shiftOut(dataPin, clockPin, byteOrder, char)

      #Wiringpi.digitalWrite( latchPin, HIGH )

    end

=begin
readAll
Reads values of all pins and returns them as a hash
=end
    def readAll

      pinValues = Hash.new

      if @mode == WPI_MODE_GPIO

        @gpio_pins.each do |pin|
        
          pinValues[pin] = self.read(pin)
        
        end

      else
      
        PINS.each do |pin|
        
          pinValues[pin] = self.read(pin)
        
        end

      end

      pinValues

    end

  end

end
