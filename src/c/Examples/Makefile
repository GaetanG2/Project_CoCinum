
MEM_SIZE = 65536

C_DEPS = \
	../LibC/string.c \
	../InterruptController/InterruptController.c \
	../UART/UART-buffered.c \
	../Timer/Timer.c \
	../SegmentDisplay/SegmentDisplay.c \
	../UserIO/UserIO.c \
	../SPI/SPI.c \
	../SPI/Joystick.c \
	../SPI/Accelerometer.c \
	Platform.c

C_FLAGS_USER = -Os

all: Hello.hex Echo.hex Tick.hex SegmentDisplay.hex UserIO.hex

include ../../../scripts/Virgule.make
