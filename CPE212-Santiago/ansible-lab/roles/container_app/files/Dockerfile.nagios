FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ARG NAGIOS_VERSION=4.4.14
ARG PLUGINS_VERSION=2.4.8

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       autoconf gcc libc6 make wget unzip apache2 apache2-utils php libapache2-mod-php \
       libgd-dev openssl libssl-dev build-essential libmcrypt-dev bc gawk dc snmp \
       libnet-snmp-perl gettext iputils-ping ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Nagios Core
RUN cd /tmp \
    && wget -q https://github.com/NagiosEnterprises/nagioscore/releases/download/nagios-${NAGIOS_VERSION}/nagios-${NAGIOS_VERSION}.tar.gz \
    && tar xzf nagios-${NAGIOS_VERSION}.tar.gz \
    && cd nagios-${NAGIOS_VERSION} \
    && ./configure --with-httpd-conf=/etc/apache2/sites-enabled \
    && make all \
    && make install-groups-users \
    && usermod -a -G nagios www-data \
    && make install \
    && make install-commandmode \
    && make install-config \
    && make install-webconf \
    && a2enmod rewrite cgi \
    && cd /tmp && rm -rf nagios-${NAGIOS_VERSION}*

# Nagios Plugins
RUN cd /tmp \
    && wget -q https://github.com/nagios-plugins/nagios-plugins/releases/download/release-${PLUGINS_VERSION}/nagios-plugins-${PLUGINS_VERSION}.tar.gz \
    && tar xzf nagios-plugins-${PLUGINS_VERSION}.tar.gz \
    && cd nagios-plugins-${PLUGINS_VERSION} \
    && ./configure \
    && make \
    && make install \
    && cd /tmp && rm -rf nagios-plugins-${PLUGINS_VERSION}*

RUN echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf \
    && a2enconf servername

COPY nagios-entrypoint.sh /usr/local/bin/nagios-entrypoint.sh
RUN chmod +x /usr/local/bin/nagios-entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/usr/local/bin/nagios-entrypoint.sh"]

