#!/bin/bash

if [[ ! -d proftpd-1.3.4d.tar.gz ]]; then
  wget ftp://ftp.proftpd.org/distrib/source/proftpd-1.3.4d.tar.gz
  tar xf proftpd-1.3.4d.tar.gz
fi

cd proftpd-1.3.4d/
./configure --disable-auth-file --disable-ncurses --disable-ident \
  --disable-shadow --enable-openssl --with-modules=mod_sql:mod_sql_postgres:mod_sql_passwd:mod_sftp
make

# Run as root
unalias cp
sudo su
make install
curl https://raw.github.com/jlhg/galaxy-preinstall/master/proftpd-init -o /etc/init.d/proftpd
chmod 555 /etc/init.d/proftpd
chkconfig --add proftpd
