#!/bin/bash

# Add the Yubico PPA key, since vmbuilder does not automatically do this.
chroot $1 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 32CBA1A9
chroot $1 apt-get update

# Disable SSH Password Authentication.
sed -i 's/^#*PasswordAuthentication .*$/PasswordAuthentication no/g' \
	/etc/ssh/sshd_config
