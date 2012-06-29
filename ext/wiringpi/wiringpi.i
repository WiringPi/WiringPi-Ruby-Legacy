%module wiringpi

%apply unsigned char { uint8_t };

extern int  wiringPiSetup     (void) ;
extern void wiringPiGpioMode  (int mode) ;
extern void pullUpDnControl   (int pin, int pud) ;
extern void pinMode           (int pin, int mode) ;
extern void digitalWrite      (int pin, int value) ;
extern void pwmWrite          (int pin, int value) ;
extern int  digitalRead       (int pin) ;
extern void shiftOut          (uint8_t dPin, uint8_t cPin, uint8_t order, uint8_t val);
extern uint8_t shiftIn        (uint8_t dPin, uint8_t cPin, uint8_t order);

extern int   serialOpen      (char *device, int baud) ;
extern void  serialClose     (int fd) ;
extern void  serialPutchar   (int fd, uint8_t c) ;
extern void  serialPuts      (int fd, char *s) ;
extern int   serialDataAvail (int fd) ;
extern int   serialGetchar   (int fd) ;

%{
#include "wiringPi.h";
#include "wiringShift.h";
#include "serial.h";
%}
