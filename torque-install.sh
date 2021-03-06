#!/bin/bash
#
# This script is for RHEL distribution
#
# Adaptive computing installation guide:
# http://goo.gl/qkW7aQ

curl -o torque-4.2.7.tar.gz -L http://www.adaptivecomputing.com/index.php?wpfb_dl=2420
tar xf torque-4.2.7.tar.gz
cd torque-4.2.7
./configure
make

# Run as root
sudo su
make install
cp contrib/init.d/trqauthd /etc/init.d/trqauthd
chkconfig --add trqauthd
cp contrib/init.d/pbs_mom /etc/init.d/pbs_mom
chkconfig --add pbs_mom
cp contrib/init.d/pbs_server /etc/init.d/pbs_server
chkconfig --add pbs_server
cp contrib/init.d/pbs_sched /etc/init.d/pbs_sched
chkconfig --add pbs_sched

echo /usr/local/lib >/etc/ld.so.conf.d/torque.conf
ldconfig
service trqauthd start
echo $(hostname) >/var/spool/torque/server_name

./torque.setup root

/usr/local/bin/qmgr -c "create node $(hostname) np=$(nproc)"
/usr/local/bin/qmgr -c 'unset queue batch resources_default.walltime'
/usr/local/bin/qterm
service pbs_server start
service pbs_mom start
service pbs_sched start
