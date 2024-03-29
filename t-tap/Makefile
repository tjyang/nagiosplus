# Makefile for Nagios tests using libtap


# Source code directories
SRC_COMMON=../common
SRC_INCLUDE=../include
SRC_XDATA=../xdata
SRC_BASE=../base
SRC_CGI=../cgi
SRC_COMMON=../common
SRC_LIB=../lib

CC=gcc
CFLAGS=-g -O2 -DHAVE_CONFIG_H -DNSCORE -I../include -I../tap/src -I..

TESTS = test_logging
TESTS += test_events
TESTS += test_checks
TESTS += test_commands
TESTS += test_downtime
TESTS += test_nagios_config
TESTS += test_timeperiods
TESTS += test_macros

XSD_OBJS = $(SRC_CGI)/statusdata-cgi.o $(SRC_CGI)/xstatusdata-cgi.o
XSD_OBJS += $(SRC_CGI)/objects-cgi.o $(SRC_CGI)/xobjects-cgi.o
XSD_OBJS += $(SRC_CGI)/comments-cgi.o $(SRC_CGI)/downtime-cgi.o
XSD_OBJS += $(SRC_CGI)/cgiutils.o ../common/shared.o

TP_OBJS = $(SRC_BASE)/utils.o $(SRC_BASE)/config.o $(SRC_BASE)/macros-base.o
TP_OBJS += $(SRC_BASE)/objects-base.o $(SRC_BASE)/xobjects-base.o
TP_OBJS += ../common/shared.o

CFG_OBJS = $(TP_OBJS)
CFG_OBJS += $(SRC_BASE)/comments-base.o $(SRC_BASE)/xcomments-base.o
CFG_OBJS += $(SRC_BASE)/downtime-base.o $(SRC_BASE)/xdowntime-base.o
CFG_OBJS += $(SRC_BASE)/retention-base.o $(SRC_BASE)/xretention-base.o


LDFLAGS=
LIBS= ../lib/libnagios.a

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
PERLLIBS=@PERLLIBS@
PERLXSI_O=@PERLXSI_O@
SOCKETLIBS=
BROKERLIBS= -ldl

BROKER_LDFLAGS= -Wl,-export-dynamic 

CP=@CP@

# Extra base code
BASEEXTRALIBS=

TAPOBJ=../tap/src/tap.o $(SNPRINTF_O)

all: $(TESTS)

########## TESTS ##########

test_logging: test_logging.o $(SRC_BASE)/logging.o $(TAPOBJ) $(SRC_COMMON)/shared.o $(SRC_BASE)/objects-base.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LIBS)

test_events: test_events.o $(SRC_BASE)/events.o $(TAPOBJ) $(SRC_BASE)/utils.o $(SRC_COMMON)/shared.o $(SRC_BASE)/objects-base.o $(SRC_BASE)/checks.o $(SRC_LIB)/squeue.o $(SRC_LIB)/nsutils.o $(SRC_LIB)/kvvec.o $(SRC_LIB)/dkhash.o $(SRC_LIB)/pqueue.o $(SRC_BASE)/config.o $(SRC_LIB)/nspath.o $(SRC_BASE)/macros-base.o $(SRC_XDATA)/xodtemplate.o $(SRC_LIB)/bitmap.o $(SRC_LIB)/skiplist.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(MATHLIBS)

test_checks: test_checks.o $(SRC_BASE)/checks.o $(TAPOBJ) $(SRC_BASE)/utils.o $(SRC_COMMON)/shared.o $(SRC_BASE)/objects-base.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(MATHLIBS) $(LIBS)

test_commands: test_commands.o $(SRC_COMMON)/shared.o $(TAPOBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(SRC_BASE)/commands.o $(LIBS)

test_downtime: test_downtime.o $(SRC_BASE)/downtime-base.o $(SRC_BASE)/utils.o $(SRC_COMMON)/shared.o $(SRC_BASE)/checks.o $(SRC_BASE)/config.o $(SRC_BASE)/objects-base.o $(SRC_BASE)/macros-base.o $(SRC_XDATA)/xodtemplate.o $(TAPOBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS) $(MATHLIBS)

test_freshness: test_freshness.o $(SRC_BASE)/freshness.o $(TAPOBJ)
	$(CC) $(CFLAGS) -o $@ $^

test_nagios_config: test_nagios_config.o $(TAPOBJ) $(SRC_BASE)/utils.o $(SRC_BASE)/config.o $(SRC_XDATA)/xrddefault.o $(SRC_BASE)/comments-base.o $(SRC_BASE)/downtime-base.o $(SRC_COMMON)/shared.o $(SRC_BASE)/objects-base.o $(SRC_XDATA)/xcddefault.o $(SRC_XDATA)/xodtemplate.o $(SRC_BASE)/macros-base.o
	$(CC) $(CFLAGS) -o $@ $^ $(BROKER_LDFLAGS) $(LDFLAGS) $(MATHLIBS) $(SOCKETLIBS) $(BROKERLIBS) $(LIBS)

test_timeperiods: test_timeperiods.o $(TP_OBJS) $(TAPOBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(BROKER_LDFLAGS) $(LDFLAGS) $(MATHLIBS) $(SOCKETLIBS) $(BROKERLIBS) $(LIBS)

test_macros: test_macros.o $(TP_OBJS) $(TAPOBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(SRC_BASE)/checks.o $(BROKER_LDFLAGS) $(LDFLAGS) $(MATHLIBS) $(SOCKETLIBS) $(LIBS)

test_xsddefault: test_xsddefault.o $(XSD_OBJS) $(TAPOBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

test: $(TESTS)
	HARNESS_PERL=./test_each.t perl -MTest::Harness -e '$$Test::Harness::switches=""; runtests(map { "./$$_" } @ARGV)' $(TESTS) 2>&1
	if which valgrind >/dev/null 2>&1; then 	\
		valgrind ./test_macros;					\
		valgrind ./test_checks;					\
	fi

each_test: $(TESTS)
	@for t in $(TESTS); do ./$$t 2>&1; done

valgrind_test: $(TESTS)
	@for t in $(TESTS); do valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./$$t; done

clean:
	rm -f core core.* *.o gmon.out $(TESTS)
	rm -f *~ *.*~

distclean: clean
	rm -f perlxsi.c
	rm -f Makefile

devclean: distclean

