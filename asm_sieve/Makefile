CC = gcc
AS = nasm
#DEFINES =
DEBUG = -g3 -O0
ARCH = -m32
PIE = -no-pie -fno-pie
ADEBUG = -g -O0
CFLAGS = $(ARCH) $(PIE) $(DEBUG) -Wall -Werror $(DEFINES)
LDFLAGS = $(ARCH) $(PIE)
ASFLAGS = $(ADEBUG) -f elf32 -F dwarf

PROG = sieve_asm
PROGS = $(PROG)

# there are some special make automatic variables
# $@ is the target filename
# $* is the basname of the target filename
# $^ is the namew sof all the prerequisites
# $< is the name of the first dependency
# $? is the names of all prerequisites that are newer than the target
# there are others, but theasre the the ones we will busing

all: $(PROGS)

$(PROG): $(PROG).o
	$(CC) $(LDFLAGS) -o $@ $^

$(PROG).o: $(PROG).asm
	$(AS) $(ASFLAGS) -l $(PROGS).lst $<

.PHONY: clean cls ci git get tar

# clean up the compiled files and editor chaff
clean cls:
	rm -f $(PROGS) *.s *.o *.lst *~ \#*

# https://wwwl.youtube.com/watch?v=4m48GqaOz90
git lazy:
	if [ ! -d .git ] ; then git init; fi
	git add *.asm ?akefile
	git commit -m "Lazy commit gonna be REAL lazy, feel me?"

TAR_FILE = ${LOGNAME}_$(PROG).tar.gz
tar:
	rm -f $(TAR_FILE)
	tar cvzf $(TAR_FILE) *.asm [Mm]akefile
	
