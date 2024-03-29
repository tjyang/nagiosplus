###############################
# Makefile for Nagios
#
###############################


# Source code directories
SRC_BASE=./base
SRC_LIB=./lib
SRC_CGI=./cgi
SRC_HTM=./html
SRC_MODULE=./module
SRC_INCLUDE=./include
SRC_COMMON=./common
SRC_XDATA=./xdata
SRC_CONTRIB=./contrib
SRC_TTAP=./t-tap
SRC_WORKERS=./worker

CC=gcc
CFLAGS=-g -O2 -DHAVE_CONFIG_H
LDFLAGS= 

prefix=/usr/local/nagios
exec_prefix=/usr/local/nagios
LOGDIR=/usr/local/nagios/var
CHECKRESULTDIR=/usr/local/nagios/var/spool/checkresults
CFGDIR=/usr/local/nagios/etc
BINDIR=/usr/local/nagios/bin
CGIDIR=/usr/local/nagios/sbin
LIBEXECDIR=/usr/local/nagios/libexec
LIBDIR=${exec_prefix}/lib
INCLUDEDIR=${prefix}/include/nagios
HTMLDIR=/usr/local/nagios/share
datarootdir=/usr/local/nagios/share
LN_S=ln -s
INSTALL=/usr/bin/install -c
INSTALL_OPTS=-o nagios -g nagios
COMMAND_OPTS=-o nagios -g nagios
HTTPD_CONF=/etc/httpd/conf.d
LN_HTTPD_SITES_ENABLED=0
INIT_DIR=/lib/systemd/system
INIT_OPTS=-o root -g root
CGICFGDIR=$(CGIDIR)
NAGIOS_USER=nagios
NAGIOS_GRP=nagios
DIST=fedora

SRC_INIT=default-service
INIT_FILE=nagios.service
INIT_TYPE=systemd

USE_EVENTBROKER=yes
USE_LIBTAP=no

CGIEXTRAS= statuswrl.cgi statusmap.cgi trends.cgi histogram.cgi

CP=@CP@



none:
		@echo "Please supply a command line argument (i.e. 'make all').  Other targets are:"
		@echo "   nagios cgis contrib modules workers"
		@echo "   test"
		@echo "   install                          install-base"
		@echo "   install-cgis                     install-html"
		@echo "   install-webconf                  install-config"
		@echo "   install-init                     install-daemoninit" 
		@echo "   install-commandmode              install-groups-users"
		@echo "   install-exfoliation              install-classicui"
		@echo "   install-basic                    install-unstripped"
		@echo "   fullinstall"
#		@echo "   uninstall"
		@echo "   clean"

# FreeBSD make does not support -C option, so we'll use the Apache style... (patch by Stanley Hopcroft 12/27/1999)

pretty: indent

indent:
	@sh indent-all.sh

ctags:
	ctags -R --exclude=html/angularjs --exclude=html/d3 --exclude=t-tap

all:
	cd $(SRC_BASE) && $(MAKE)
	cd $(SRC_CGI) && $(MAKE)
	cd $(SRC_HTM) && $(MAKE)
	if [ x$(USE_EVENTBROKER) = xyes ]; then \
		cd $(SRC_MODULE) && $(MAKE); \
	fi
	cd $(SRC_WORKERS) && $(MAKE) $@

	@echo ""
	@echo "*** Compile finished ***"
	@echo ""
	@echo "If the main program and CGIs compiled without any errors, you"
	@echo "can continue with testing or installing Nagios as follows (type"
	@echo "'make' without any arguments for a list of all possible options):"
	@echo ""
	@echo "  make test"
	@echo "     - This runs the test suite"
	@echo ""
	@echo "  make install"
	@echo "     - This installs the main program, CGIs, and HTML files"
	@echo ""
	@echo "  make install-init"
	@echo "     - This installs the init script in $(DESTDIR)$(INIT_DIR)"
	@echo ""
	@echo "  make install-daemoninit"
	@echo "     - This will initialize the init script"
	@echo "       in $(DESTDIR)$(INIT_DIR)"
	@echo ""
	@echo "  make install-groups-users"
	@echo "     - This adds the users and groups if they do not exist"
	@echo ""
	@echo "  make install-commandmode"
	@echo "     - This installs and configures permissions on the"
	@echo "       directory for holding the external command file"
	@echo ""
	@echo "  make install-config"
	@echo "     - This installs *SAMPLE* config files in $(DESTDIR)$(CFGDIR)"
	@echo "       You'll have to modify these sample files before you can"
	@echo "       use Nagios.  Read the HTML documentation for more info"
	@echo "       on doing this.  Pay particular attention to the docs on"
	@echo "       object configuration files, as they determine what/how"
	@echo "       things get monitored!"
	@echo ""
	@echo "  make install-webconf"
	@echo "     - This installs the Apache config file for the Nagios"
	@echo "       web interface"
	@echo ""
	@echo "  make install-exfoliation"
	@echo "     - This installs the Exfoliation theme for the Nagios"
	@echo "       web interface"
	@echo ""
	@echo "  make install-classicui"
	@echo "     - This installs the classic theme for the Nagios"
	@echo "       web interface"
	@echo ""
	@echo ""
	@echo "*** Support Notes *******************************************"
	@echo ""
	@echo "If you have questions about configuring or running Nagios,"
	@echo "please make sure that you:"
	@echo ""
	@echo "     - Look at the sample config files"
	@echo "     - Read the documentation on the Nagios Library at:"
	@echo "           https://library.nagios.com"
	@echo ""
	@echo "before you post a question to one of the mailing lists."
	@echo "Also make sure to include pertinent information that could"
	@echo "help others help you.  This might include:"
	@echo ""
	@echo "     - What version of Nagios you are using"
	@echo "     - What version of the plugins you are using"
	@echo "     - Relevant snippets from your config files"
	@echo "     - Relevant error messages from the Nagios log file"
	@echo ""
	@echo "For more information on obtaining support for Nagios, visit:"
	@echo ""
	@echo "       https://support.nagios.com"
	@echo ""
	@echo "*************************************************************"
	@echo ""
	@echo "Enjoy."
	@echo ""

$(SRC_LIB)/libnagios.a:
	cd $(SRC_LIB) && $(MAKE)

nagios:
	cd $(SRC_BASE) && $(MAKE)

config:
	@echo "Sample config files are automatically generated once you run the"
	@echo "configure script.  You can install the sample config files on your"
	@echo "system by using the 'make install-config' command."

cgis:
	cd $(SRC_CGI) && $(MAKE)

html:
	cd $(SRC_HTM) && $(MAKE)

contrib:
	cd $(SRC_CONTRIB) && $(MAKE)

modules:
	cd $(SRC_MODULE) && $(MAKE)

workers:
	cd $(SRC_WORKERS) && $(MAKE) all

clean:
	cd $(SRC_LIB) && $(MAKE) $@
	cd $(SRC_BASE) && $(MAKE) $@
	cd $(SRC_CGI) && $(MAKE) $@
	cd $(SRC_COMMON) && $(MAKE) $@
	cd $(SRC_XDATA) && $(MAKE) $@
	cd $(SRC_HTM) && $(MAKE) $@
	cd $(SRC_INCLUDE) && $(MAKE) $@
	cd $(SRC_CONTRIB) && $(MAKE) $@
	cd $(SRC_MODULE) && $(MAKE) $@
	cd $(SRC_TTAP) && $(MAKE) $@
	cd $(SRC_WORKERS) && $(MAKE) $@
	rm -f *.cfg core
	rm -f *~ *.*~ */*~ */*.*~ */*/*.*~
	rm -f nagioscore.info-file
	rm -f *.gcno */*.gcno */*/*.gcno
	rm -f *.gcda */*.gcda */*/*.gcda
	rm -f *.gcov */*.gcov */*/*.gcov
	rm -rf coverage-report

distclean: clean
	cd $(SRC_LIB) && $(MAKE) $@
	cd $(SRC_BASE) && $(MAKE) $@
	cd $(SRC_CGI) && $(MAKE) $@
	cd $(SRC_COMMON) && $(MAKE) $@
	cd $(SRC_XDATA) && $(MAKE) $@
	cd $(SRC_HTM) && $(MAKE) $@
	cd $(SRC_INCLUDE) && $(MAKE) $@
	cd $(SRC_CONTRIB) && $(MAKE) $@
	cd $(SRC_MODULE) && $(MAKE) $@
	cd $(SRC_TTAP) && $(MAKE) $@
	cd $(SRC_WORKERS) && $(MAKE) $@
	rm -f sample-config/*.cfg  sample-config/*.conf sample-config/template-object/*.cfg
	rm -f daemon-init daemon-service daemon-openrc pkginfo
	rm -f Makefile subst
	rm -f config.log config.status config.cache
	rm -f tags

devclean: distclean

test: nagios cgis
	cd $(SRC_LIB) && $(MAKE) test
	$(MAKE) test-perl
	$(MAKE) test-tap

test-tap: tap/src/tap.o nagios cgis
	@if [ x$(USE_LIBTAP) = xyes ]; then \
		cd $(SRC_TTAP) && $(MAKE) test; \
	else \
		echo "NOTE: You must run configure with --enable-libtap to run the C tap tests"; \
	fi

tap/src/tap.o:
	cd tap && $(MAKE)

test-perl: cgis
	cd t && $(MAKE) test

coverage: test
	@if ! which lcov >/dev/null 2>&1; then \
		echo "ERROR: You must install lcov and genhtml first"; \
	else \
		lcov -c -d . -o nagioscore.info-file; \
		genhtml nagioscore.info-file -o coverage-report; \
		echo "Your coverage report is in coverage-report/index.html"; \
	fi


install-html:
	cd $(SRC_HTM) && $(MAKE) install
	$(MAKE) install-exfoliation

install-base:
	cd $(SRC_BASE) && $(MAKE) install

install-cgis:
	cd $(SRC_CGI) && $(MAKE) install

install:
	cd $(SRC_BASE) && $(MAKE) $@
	cd $(SRC_CGI) && $(MAKE) $@
	cd $(SRC_HTM) && $(MAKE) $@
	$(MAKE) install-exfoliation
	$(MAKE) install-basic

install-unstripped:
	cd $(SRC_BASE) && $(MAKE) $@
	cd $(SRC_CGI) && $(MAKE) $@
	cd $(SRC_HTM) && $(MAKE) $@
	$(MAKE) install-exfoliation
	$(MAKE) install-basic

install-basic:
	$(INSTALL) -m 775 $(INSTALL_OPTS) -d $(DESTDIR)$(LIBEXECDIR)
	$(INSTALL) -m 775 $(INSTALL_OPTS) -d $(DESTDIR)$(LOGDIR)
	$(INSTALL) -m 775 $(INSTALL_OPTS) -d $(DESTDIR)$(LOGDIR)/archives
	$(INSTALL) -m 775 $(COMMAND_OPTS) -d $(DESTDIR)$(CHECKRESULTDIR)
	chmod g+s $(DESTDIR)$(CHECKRESULTDIR)

	@echo ""
	@echo "*** Main program, CGIs and HTML files installed ***"
	@echo ""
	@echo "You can continue with installing Nagios as follows (type 'make'"
	@echo "without any arguments for a list of all possible options):"
	@echo ""
	@echo "  make install-init"
	@echo "     - This installs the init script in $(DESTDIR)$(INIT_DIR)"
	@echo ""
	@echo "  make install-commandmode"
	@echo "     - This installs and configures permissions on the"
	@echo "       directory for holding the external command file"
	@echo ""
	@echo "  make install-config"
	@echo "     - This installs sample config files in $(DESTDIR)$(CFGDIR)"
	@echo ""

install-config:
	$(INSTALL) -m 775 $(INSTALL_OPTS) -d $(DESTDIR)$(CFGDIR)
	$(INSTALL) -m 775 $(INSTALL_OPTS) -d $(DESTDIR)$(CFGDIR)/objects
	$(INSTALL) -b -m 664 $(INSTALL_OPTS) sample-config/nagios.cfg $(DESTDIR)$(CFGDIR)/nagios.cfg
	$(INSTALL) -b -m 664 $(INSTALL_OPTS) sample-config/cgi.cfg $(DESTDIR)$(CFGDIR)/cgi.cfg
	$(INSTALL) -b -m 660 $(INSTALL_OPTS) sample-config/resource.cfg $(DESTDIR)$(CFGDIR)/resource.cfg
	$(INSTALL) -b -m 664 $(INSTALL_OPTS) sample-config/template-object/templates.cfg $(DESTDIR)$(CFGDIR)/objects/templates.cfg
	$(INSTALL) -b -m 664 $(INSTALL_OPTS) sample-config/template-object/commands.cfg $(DESTDIR)$(CFGDIR)/objects/commands.cfg
	$(INSTALL) -b -m 664 $(INSTALL_OPTS) sample-config/template-object/contacts.cfg $(DESTDIR)$(CFGDIR)/objects/contacts.cfg
	$(INSTALL) -b -m 664 $(INSTALL_OPTS) sample-config/template-object/timeperiods.cfg $(DESTDIR)$(CFGDIR)/objects/timeperiods.cfg
	$(INSTALL) -b -m 664 $(INSTALL_OPTS) sample-config/template-object/localhost.cfg $(DESTDIR)$(CFGDIR)/objects/localhost.cfg
	$(INSTALL) -b -m 664 $(INSTALL_OPTS) sample-config/template-object/windows.cfg $(DESTDIR)$(CFGDIR)/objects/windows.cfg
	$(INSTALL) -b -m 664 $(INSTALL_OPTS) sample-config/template-object/printer.cfg $(DESTDIR)$(CFGDIR)/objects/printer.cfg
	$(INSTALL) -b -m 664 $(INSTALL_OPTS) sample-config/template-object/switch.cfg $(DESTDIR)$(CFGDIR)/objects/switch.cfg

	@echo ""
	@echo "*** Config files installed ***"
	@echo ""
	@echo "Remember, these are *SAMPLE* config files.  You'll need to read"
	@echo "the documentation for more information on how to actually define"
	@echo "services, hosts, etc. to fit your particular needs."
	@echo ""

install-groups-users:
	@autoconf-macros/add_group_user $(DIST) $(NAGIOS_USER) $(NAGIOS_GRP) 1

install-webconf:
	$(INSTALL) -m 644 sample-config/httpd.conf $(DESTDIR)$(HTTPD_CONF)/nagios.conf
	if [ $(LN_HTTPD_SITES_ENABLED) -eq 1 ]; then \
		$(LN_S) $(DESTDIR)$(HTTPD_CONF)/nagios.conf $(DESTDIR)/etc/apache2/sites-enabled/nagios.conf; \
	fi

	@echo ""
	@echo "*** Nagios/Apache conf file installed ***"
	@echo ""

install-exfoliation:
	@cd contrib/exfoliation; \
	$(INSTALL) $(INSTALL_OPTS) -d $(DESTDIR)$(HTMLDIR)/stylesheets; \
	for file in $$(find ./stylesheets/ -type f); do \
		$(INSTALL) -m 644 $(INSTALL_OPTS) $${file} $(DESTDIR)$(HTMLDIR)/$${file}; \
	done; \
	$(INSTALL) $(INSTALL_OPTS) -d $(DESTDIR)$(HTMLDIR)/images; \
	for file in $$(find ./images -type f); do \
		$(INSTALL) -m 644 $(INSTALL_OPTS) $${file} $(DESTDIR)$(HTMLDIR)/$${file}; \
	done; \
	cd ../..

	@echo ""
	@echo "*** Exfoliation theme installed ***"
	@echo "NOTE: Use 'make install-classicui' to revert to classic Nagios theme";
	@echo ""

install-classicui:
	@cd html; \
	$(INSTALL) $(INSTALL_OPTS) -d $(DESTDIR)$(HTMLDIR)/stylesheets; \
	for file in $$(find ./stylesheets/ -type f); do \
		$(INSTALL) -m 644 $(INSTALL_OPTS) $${file} $(DESTDIR)$(HTMLDIR)/$${file}; \
	done; \
	$(INSTALL) $(INSTALL_OPTS) -d $(DESTDIR)$(HTMLDIR)/images; \
	for file in $$(find ./images -type f); do \
		$(INSTALL) -m 644 $(INSTALL_OPTS) $${file} $(DESTDIR)$(HTMLDIR)/$${file}; \
	done; \
	cd ..

	@echo ""
	@echo "*** Classic theme installed ***"
	@echo "NOTE: Use 'make install-exfoliation' to use new Nagios theme";
	@echo ""

install-init:
	$(INSTALL) -m 755 -d $(INIT_OPTS) $(DESTDIR)$(INIT_DIR)
	$(INSTALL) -m 755 $(INIT_OPTS) startup/$(SRC_INIT) $(DESTDIR)$(INIT_DIR)/$(INIT_FILE)

install-daemoninit: install-init
	@if [ x$(INIT_TYPE) = xsysv ]; then \
		if which chkconfig >/dev/null 2>&1; then \
			chkconfig --add nagios; \
		elif which update-rc.d >/dev/null 2>&1; then \
			update-rc.d nagios defaults; \
		fi \
	elif [ x$(INIT_TYPE) = xsystemd ]; then \
		if which systemctl >/dev/null 2>&1; then \
			systemctl daemon-reload; \
			systemctl enable nagios.service; \
		fi; \
		chmod 0644 $(INIT_DIR)/$(INIT_FILE); \
	elif [ x$(INIT_TYPE) = xupstart ]; then \
		if which initctl >/dev/null 2>&1; then \
			initctl reload-configuration; \
		fi \
	elif [ x$(INIT_TYPE) = xopenrc ]; then \
		if which rc-update >/dev/null 2>&1; then \
			rc-update add nagios default; \
		fi \
	fi

	@echo ""
	@echo "*** Init script installed ***"
	@echo ""


install-commandmode:
	$(INSTALL) -m 775 $(COMMAND_OPTS) -d $(DESTDIR)$(LOGDIR)/rw
	chmod g+s $(DESTDIR)$(LOGDIR)/rw

	@echo ""
	@echo "*** External command directory configured ***"
	@echo ""


install-devel: install-headers install-lib

install-headers:
	$(INSTALL) -d -m 755 $(DESTDIR)$(INCLUDEDIR)
	$(INSTALL) -d -m 755 $(DESTDIR)$(INCLUDEDIR)/lib
	$(INSTALL) -m 644 include/*.h $(DESTDIR)$(INCLUDEDIR)
	$(INSTALL) -m 644 lib/*.h $(DESTDIR)$(INCLUDEDIR)/lib
	rm -f $(DESTDIR)$(INCLUDEDIR)/config*.h

install-lib: $(SRC_LIB)/libnagios.a
	$(INSTALL) -d -m 755 $(DESTDIR)$(LIBDIR)
	$(INSTALL) -m 644 $(SRC_LIB)/libnagios.a $(DESTDIR)$(LIBDIR)

dox:
	@rm -rf Documentation
	doxygen doxy.conf


fullinstall: install install-init install-commandmode install-webconf install-devel

# Uninstall is too destructive if base install directory is /usr, etc.
#uninstall:
#	rm -rf $(DESTDIR)$(BINDIR)/nagios $(DESTDIR)$(CGIDIR)/*.cgi $(DESTDIR)$(CFGDIR)/*.cfg $(DESTDIR)$(HTMLDIR)

#
# Targets for creating packages on various architectures
#

# Solaris pkgmk
PACKDIR=/home/tjyang/github/nagioscore/pkg
VERSION=4.4.5

Prototype:
	if [ ! -d $(PACKDIR) ] ; then mkdir $(PACKDIR); fi
	if [ ! -d $(PACKDIR)/etc ] ; then mkdir $(PACKDIR)/etc; fi
	if [ ! -d $(PACKDIR)/etc/init.d ] ; then mkdir $(PACKDIR)/etc/init.d; fi
	if [ ! -d $(PACKDIR)/etc/nagios ] ; then mkdir $(PACKDIR)/etc/nagios; fi
	$(MAKE) all
	$(MAKE) DESTDIR=$(PACKDIR) INIT_OPTS='' INSTALL_OPTS='' COMMAND_OPTS='' nagios_grp='' nagios_usr='' fullinstall
	$(INSTALL) -m 644 sample-config/nagios.cfg $(PACKDIR)$(CFGDIR)/nagios.cfg.$(VERSION)
	$(INSTALL) -m 644 sample-config/cgi.cfg $(PACKDIR)$(CFGDIR)/cgi.cfg.$(VERSION)
	$(INSTALL) -m 640 sample-config/resource.cfg $(PACKDIR)$(CFGDIR)/resource.cfg.$(VERSION)
	$(INSTALL) -m 664 sample-config/template-object/bigger.cfg $(PACKDIR)$(CFGDIR)/bigger.cfg.$(VERSION)
	$(INSTALL) -m 664 sample-config/template-object/minimal.cfg $(PACKDIR)$(CFGDIR)/minimal.cfg.$(VERSION)
	$(INSTALL) -m 664 sample-config/template-object/checkcommands.cfg $(PACKDIR)$(CFGDIR)/checkcommands.cfg.$(VERSION)
	$(INSTALL) -m 664 sample-config/template-object/misccommands.cfg $(PACKDIR)$(CFGDIR)/misccommands.cfg.$(VERSION)
	cd contrib; $(MAKE) all; $(MAKE) DESTDIR=$(PACKDIR) INIT_OPTS='' INSTALL_OPTS='' COMMAND_OPTS='' nagios_grp='' nagios_usr='' install
	echo i pkginfo> Prototype
	if [ -f checkinstall ] ; then echo i checkinstall>> Prototype; fi
	if [ -f preinstall ] ; then echo i preinstall>> Prototype; fi
	if [ -f postinstall ] ; then echo i postinstall>> Prototype; fi
	pkgproto $(PACKDIR)=/ | sed -e "s|$(LOGNAME) $(GROUP)$$|root root|" | egrep -v "(s|d) none (/|/etc|/var|/usr|/usr/local) " >> Prototype

pkg/nagios/pkgmap: Prototype
	mkdir $(PACKDIR)/nagios
	pkgmk -o -r / -f Prototype -d $(PACKDIR) nagios

nagios.SPARC.pkg.tar.gz: pkg/nagios/pkgmap
	cd $(PACKDIR) && tar -cf - nagios | gzip -9 -c > ../nagios.SPARC.pkg.tar.gz

pkgset: nagios.SPARC.pkg.tar.gz

pkgclean:
	rm -rf pkg Prototype nagios.SPARC.pkg.tar.gz

dist: distclean
	rm -f nagios-$(VERSION)
	ln -s . nagios-$(VERSION)
	tar zhcf nagios-$(VERSION).tar.gz --exclude nagios-$(VERSION)/nagios-$(VERSION).tar.gz --exclude nagios-$(VERSION)/nagios-$(VERSION) --exclude RCS --exclude CVS --exclude build-* --exclude *~ --exclude .git* nagios-$(VERSION)/
	rm -f nagios-$(VERSION)

# Targets that always get built
.PHONY:	indent clean clean distclean dox test html
