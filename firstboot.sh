#!/bin/bash

set -e

# Wait for MySQL to start
mysqlWaitFlag=1
while [ "${mysqlWaitFlag}" != "0" ]
do
	echo "Waiting for MySQL to start"
	sleep 5 > /dev/null
	mysqladmin ping -ufakeuser 2> /dev/null
	if [ "${?}" = "0" ]; then
		mysqlWaitFlag=0
	fi
done

# Set random mysql password
ROOT_PASS=$(pwgen -s 16 1)
mysqladmin -u root password $ROOT_PASS
echo "" >> /root/.my.cnf
echo -e "[client]\npassword = $ROOT_PASS" >> /root/.my.cnf

# Randomize passwords for ykval and ykksm
for PACKAGE in yubikey-ksm yubikey-val
do
	PASS=$(pwgen -s 16 1)
	sed -i "s/^dbc_dbpass='.\{1,\}'$/dbc_dbpass='$PASS'/g" \
		/etc/dbconfig-common/$PACKAGE.conf
done

# Create users and tables for ksm and val
echo "yubikey-ksm yubikey-ksm/dbconfig-reinstall boolean true" \
	| debconf-set-selections
echo "yubikey-ksm yubikey-ksm/mysql/admin-pass password $ROOT_PASS" \
	| debconf-set-selections
echo "yubikey-val yubikey-val/dbconfig-reinstall boolean true" \
	| debconf-set-selections
echo "yubikey-val yubikey-val/mysql/admin-pass password $ROOT_PASS" \
	| debconf-set-selections

dpkg-reconfigure yubikey-ksm -f noninteractive
dpkg-reconfigure yubikey-val -f noninteractive
