#!/bin/bash
# Creates the web login at start-up (password comes from the NAGIOS_PASS env var,
# so it is NOT baked into the image), then starts Nagios + Apache.
set -e

htpasswd -b -c /usr/local/nagios/etc/htpasswd.users \
  "${NAGIOS_USER:-nagiosadmin}" "${NAGIOS_PASS:?NAGIOS_PASS is not set}"

/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg   # validate config
/usr/local/nagios/bin/nagios -d /usr/local/nagios/etc/nagios.cfg   # run daemon

exec apache2ctl -D FOREGROUND        # keeps the container alive (PID 1)