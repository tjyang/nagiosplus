############################
# Makefile for Nagios
#
############################


# Source code directories
SRC_COMMON=../common
SRC_INCLUDE=../include
SRC_XDATA=../xdata
SRC_LIB=../lib

CC=gcc
CFLAGS=-Wall -I.. -g -O2 -DHAVE_CONFIG_H -DNSCORE

# Compiler flags for use with gprof
#CFLAGS=-pg -I.. -DHAVE_CONFIG_H -DNSCORE

# Compiler flags for use with Valgrind
#CFLAGS=-O0 -I.. -g -DHAVE_CONFIG_H -DNSCORE

# Compiler flags for optimization (overrides default)
#CFLAGS=-O3 -Wall -I.. -fno-strict-aliasing -Wshadow -Wpointer-arith -Wcast-qual -Wcast-align -Wstrict-prototypes -Wmissing-prototypes -Wnested-externs -DHAVE_CONFIG_H -DNSCORE

# Compiler flags for optimization (complements default)
#CFLAGS_WARN=-Wall -Wshadow -Wpointer-arith -Wcast-qual -Wcast-align -Wstrict-prototypes -Wmissing-prototypes -Wnested-externs
#CFLAGS_DEBUG=-ggdb3 -g3
#CFLAGS_GPROF=-pg
#CFLAGS+=$(CFLAGS_WARN) $(CFLAGS_DEBUG) $(CFLAGS_GPROF)

LDFLAGS=
LIBS=

prefix=/usr/local/nagios
exec_prefix=/usr/local/nagios
LOGDIR=/usr/local/nagios/var
CFGDIR=/usr/local/nagios/etc
BINDIR=/usr/local/nagios/bin
CGIDIR=/usr/local/nagios/sbin
HTMLDIR=/usr/local/nagios/share
INSTALL=/usr/bin/install -c
INSTALL_OPTS=-o nagios -g nagios
COMMAND_OPTS=-o nagios -g nagios
STRIP=/usr/bin/strip

CGIURL=/nagios/cgi-bin
HTMURL=/nagios

MATHLIBS=-lm
SOCKETLIBS=
BROKERLIBS= -ldl

BROKER_LDFLAGS= -Wl,-export-dynamic 

CP=@CP@

# Extra base code
BASEEXTRALIBS=

# Generated automatically from configure script
BROKER_O=broker.o nebmods.o
BROKER_H=../include/broker.h ../include/nebmods.h ../include/nebmodules.h ../include/nebcallbacks.h ../include/neberrors.h

# Object data
ODATALIBS=objects-base.o xobjects-base.o
ODATAHDRS=
ODATADEPS=$(ODATALIBS)

# Retention data
RDATALIBS=retention-base.o xretention-base.o
RDATAHDRS=
RDATADEPS=$(RDATALIBS)

# Comment data
CDATALIBS=comments-base.o xcomments-base.o
CDATAHDRS=
CDATADEPS=$(CDATALIBS)

# Status data
SDATALIBS=statusdata-base.o xstatusdata-base.o
SDATAHDRS=
SDATADEPS=$(SDATALIBS)

# Performance data
PDATALIBS=perfdata-base.o xperfdata-base.o
PDATAHDRS=
PDATADEPS=$(PDATALIBS)

# Downtime data
DDATALIBS=downtime-base.o
DDATAHDRS=
DDATADEPS=$(DDATALIBS)


OBJS=$(BROKER_O) $(SRC_COMMON)/shared.o  query-handler.o workers.o checks.o config.o commands.o events.o flapping.o logging.o macros-base.o netutils.o notifications.o sehandlers.o utils.o $(RDATALIBS) $(CDATALIBS) $(ODATALIBS) $(SDATALIBS) $(PDATALIBS) $(DDATALIBS) $(BASEEXTRALIBS)
OBJDEPS=$(ODATADEPS) $(ODATADEPS) $(RDATADEPS) $(CDATADEPS) $(SDATADEPS) $(PDATADEPS) $(DDATADEPS) $(BROKER_H)

all: nagios nagiostats


######## REQUIRED FILES ##########

macros-base.o: $(SRC_COMMON)/macros.c $(SRC_INCLUDE)/macros.h
	$(CC) $(CFLAGS) -c -o $@ $(SRC_COMMON)/macros.c

objects-base.o: $(SRC_COMMON)/objects.c $(SRC_INCLUDE)/objects.h
	$(CC) $(CFLAGS) -c -o $@ $(SRC_COMMON)/objects.c

xobjects-base.o: $(SRC_XDATA)/xodtemplate.c $(SRC_XDATA)/xodtemplate.h
	$(CC) $(CFLAGS) -c -o $@ $(SRC_XDATA)/xodtemplate.c

statusdata-base.o: $(SRC_COMMON)/statusdata.c $(SRC_INCLUDE)/statusdata.h
	$(CC) $(CFLAGS) -c -o $@ $(SRC_COMMON)/statusdata.c

xstatusdata-base.o: $(SRC_XDATA)/xsddefault.c $(SRC_XDATA)/xsddefault.h
	$(CC) $(CFLAGS) -c -o $@ $(SRC_XDATA)/xsddefault.c

comments-base.o: $(SRC_COMMON)/comments.c $(SRC_INCLUDE)/comments.h
	$(CC) $(CFLAGS) -c -o $@ $(SRC_COMMON)/comments.c

xcomments-base.o: $(SRC_XDATA)/xcddefault.c $(SRC_XDATA)/xcddefault.h
	$(CC) $(CFLAGS) -c -o $@ $(SRC_XDATA)/xcddefault.c

downtime-base.o: $(SRC_COMMON)/downtime.c $(SRC_INCLUDE)/downtime.h
	$(CC) $(CFLAGS) -c -o $@ $(SRC_COMMON)/downtime.c

perfdata-base.o: perfdata.c $(SRC_INCLUDE)/perfdata.h
	$(CC) $(CFLAGS) -c -o $@ perfdata.c

xperfdata-base.o: $(SRC_XDATA)/xpddefault.c $(SRC_XDATA)/xpddefault.h
	$(CC) $(CFLAGS) -c -o $@ $(SRC_XDATA)/xpddefault.c

retention-base.o: sretention.c $(SRC_INCLUDE)/sretention.h
	$(CC) $(CFLAGS) -c -o $@ sretention.c

xretention-base.o: $(SRC_XDATA)/xrddefault.c $(SRC_XDATA)/xrddefault.h
	$(CC) $(CFLAGS) -c -o $@ $(SRC_XDATA)/xrddefault.c

$(SRC_COMMON)/shared.o: $(SRC_COMMON)/shared.c
	$(CC) $(CFLAGS) -c -o $@ $<

workers.o: workers.c wpres-phash.h
	$(CC) $(CFLAGS) -c -o $@ $<

wpres-phash.h: wpres.gperf
	gperf -S 1 -t -H wpres_key_phash -N wpres_get_key $< > $@

########## NAGIOS ##########

libnagios:
	$(MAKE) -C $(SRC_LIB)

nagios.o: nagios.c $(SRC_INCLUDE)/nagios.h $(SRC_INCLUDE)/locations.h
	$(CC) $(CFLAGS) -c -o $@ nagios.c

nagios: nagios.o $(OBJS) $(OBJDEPS) libnagios
	$(CC) $(CFLAGS) -o $@ $< $(OBJS) $(BROKER_LDFLAGS) $(LDFLAGS) $(MATHLIBS) $(SOCKETLIBS) $(BROKERLIBS) $(LIBS) $(SRC_LIB)/libnagios.a

nagiostats: nagiostats.c $(SRC_INCLUDE)/locations.h libnagios
	$(CC) $(CFLAGS) -o $@ nagiostats.c $(LDFLAGS) $(MATHLIBS) $(LIBS) $(SRC_LIB)/libnagios.a

$(OBJS): $(SRC_INCLUDE)/locations.h

clean:
	rm -f nagios nagiostats core *.o gmon.out
	rm -f *~ *.*~

distclean: clean
	rm -f perlxsi.c
	rm -f Makefile

devclean: distclean
	rm -f wpres-phash.h

install:
	$(INSTALL) -m 775 $(INSTALL_OPTS) -d $(DESTDIR)$(BINDIR)
	$(INSTALL) -s -m 774 $(INSTALL_OPTS) nagios $(DESTDIR)$(BINDIR)
	$(INSTALL) -s -m 774 $(INSTALL_OPTS) nagiostats $(DESTDIR)$(BINDIR)

install-unstripped:
	$(INSTALL) -m 775 $(INSTALL_OPTS) -d $(DESTDIR)$(BINDIR)
	$(INSTALL) -m 774 $(INSTALL_OPTS) nagios $(DESTDIR)$(BINDIR)
	$(INSTALL) -m 774 $(INSTALL_OPTS) nagiostats $(DESTDIR)$(BINDIR)

.PHONY: libnagios
