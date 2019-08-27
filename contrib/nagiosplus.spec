Summary: Add more packages related to nagioscore rpm
Name: nagiosplus
Version: 0
Release: 0
License: Public
Group: Applications/System
Requires:       nagios
Requires:       httpd
Requires:       php
Requires:       pynag
Requires:       check-mk-livestatus
Requires:       pnp4nagios
Requires:       perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))
%description
Empty PHP RPM
%files
