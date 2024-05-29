CC = gcc
DEFINES =
DEBUG = -g3 -O0
WERROR = -Werror
CFLAGS = -Wall -Wshadow -Wunreachable-code -Wredundant-decls -Wmissing-declarations \
	 -Wold-style-definition -Wmissing-prototypes -Wdeclaration-after-statement \
	 -Wextra -Werror -Wpedantic $(WERROR) $(DEBUG) $(DEFINES)

SIEVE = sieve
VL = view_long
PROGS = $(SIEVE) $(VL)
TAR_FILE = ${LOGNAME}_Lab02.tar.gz

all: $(PROGS) 

$(SIEVE): $(SIEVE).o
	$(CC) -o $(SIEVE) $(SIEVE).o

$(SIEVE).o: $(SIEVE).c
	$(CC) $(CFLAGS) -c $(SIEVE).c

$(VL): $(VL).o
	$(CC) -o $(VL) $(VL).o

$(VL).o: $(VL).c
	$(CC) $(CFLAGS) -c $(VL).c

clean cls:
	rm -f $(PROGS) *.o *~ \

tar: clean
	rm -f $(TAR_FILE)
	tar cvfa $(TAR_FILE) *.[ch] [Mm]akefile

