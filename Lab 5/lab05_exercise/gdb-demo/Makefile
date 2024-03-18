CC=gcc
TARGETS=demo

all: $(TARGETS)

ex: ex.c
	$(CC) -o $@ -fno-stack-protector -g -O0 $<

.PHONY: clean


clean:
	rm -f $(TARGETS) *.o
