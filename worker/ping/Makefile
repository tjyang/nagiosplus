###################################
# Makefile for NEB examples
#
###################################


# Source code directories
SRC_LIB=./lib
SRC_INCLUDE=./include

CC=gcc
WORKER_CFLAGS=-I ../../include -I ../..
CFLAGS=-g -O2 -DHAVE_CONFIG_H
WORKER_LDFLAGS=-L ../../lib -l nagios
LDFLAGS=
LIBS=

prefix=/usr/local/nagios
exec_prefix=/usr/local/nagios
BINDIR=/usr/local/nagios/bin
INSTALL=/usr/bin/install -c
INSTALL_OPTS=-o nagios -g nagios
COMMAND_OPTS=-o nagios -g nagios
STRIP=/usr/bin/strip

CP=@CP@

all:	worker-ping

worker-ping: worker-ping.c
	$(CC) -I.. $(WORKER_CFLAGS) $(CFLAGS) -o worker-ping worker-ping.c $(WORKER_LDFLAGS) $(LDFLAGS) $(LIBS)

clean:
	rm -f worker-ping worker-ping.o
	rm -f core *.o
	rm -f *~ *.*~

distclean: clean
	rm -f Makefile

devclean: distclean

install:
	$(INSTALL) -m 775 $(INSTALL_OPTS) -d $(DESTDIR)$(BINDIR)
	$(INSTALL) -m 774 $(INSTALL_OPTS) worker-ping $(DESTDIR)$(BINDIR)

install-unstripped:
	$(INSTALL) -s -m 775 $(INSTALL_OPTS) -d $(DESTDIR)$(BINDIR)
	$(INSTALL) -s -m 774 $(INSTALL_OPTS) worker-ping $(DESTDIR)$(BINDIR)
