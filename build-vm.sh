#!/bin/bash

set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"

HYPERVISOR="vmw6"
DIST="ubuntu"
DEST="output"

#Allow overriding dest
if [ "x$1" == "x-d" ] || [ "x$1" == "x--dest" ]; then
	shift
	DEST=$1
	shift
fi

VMBUILDER_ARGS="--suite precise --arch i386 --flavour virtual \
--mem 512 --tmpfs - --hostname yubi-x --user yubikey --pass yubico \
--copy $DIR/copy --exec $DIR/exec.sh --firstboot $DIR/firstboot.sh \
--dest $DEST --verbose --ppa yubico/stable \
--addpkg unattended-upgrades --addpkg acpid --addpkg yubi-x \
--addpkg pwgen --addpkg ssh"

vmbuilder $HYPERVISOR $DIST $VMBUILDER_ARGS "$@"

if [ $HYPERVISOR == "vmw6" ]; then
	#Fix path of the virtual hdd.
	sed -i s,$DIR/$DEST/,,g $DEST/yubi-x.vmx
fi

echo "Completed successfully, result is in: $DEST"
