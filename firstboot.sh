#!/bin/bash

set -e

# Set random mysql password
ROOT_PASS=$(pwgen -s 16 1)
mysqladmin -u root password $ROOT_PASS

# Randomize passwords for ykval and ykksm
for PACKAGE in yubikey-ksm yubikey-val
do
	PASS=$(pwgen -s 16 1)
	sed -i "s/^dbc_dbpass='.\{1,\}'$/dbc_dbpass='$PASS'/g" \
		/etc/dbconfig-common/$PACKAGE.conf
done

# Create users and tables for ksm and val
for LINE in \
	yubikey-ksm yubikey-ksm/dbconfig-reinstall boolean true \
	yubikey-ksm yubikey-ksm/mysql/admin-pass password $ROOT_PASS \
	yubikey-val yubikey-val/dbconfig-reinstall boolean true \
	yubikey-val yubikey-val/mysql/admin-pass password $ROOT_PASS
do
	echo $LINE | debconf-set-selections
done

dpkg-reconfigure yubikey-ksm -f noninteractive
dpkg-reconfigure yubikey-val -f noninteractive
