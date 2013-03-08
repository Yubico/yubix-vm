#!/bin/bash

# Copyright (c) 2013 Yubico AB
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#   * Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#
#   * Redistributions in binary form must reproduce the above
#     copyright notice, this list of conditions and the following
#     disclaimer in the documentation and/or other materials provided
#     with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
