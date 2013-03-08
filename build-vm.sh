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
--mem 512 --tmpfs - --hostname yubix --user yubikey --pass yubico \
--copy $DIR/copy --exec $DIR/exec.sh --firstboot $DIR/firstboot.sh \
--dest $DEST --verbose --ppa yubico/stable \
--addpkg unattended-upgrades --addpkg acpid --addpkg yubix \
--addpkg pwgen --addpkg ssh"

vmbuilder $HYPERVISOR $DIST $VMBUILDER_ARGS "$@"

if [ $HYPERVISOR == "vmw6" ]; then
	#Fix path of the virtual hdd.
	sed -i 's,\(ide0:0\.fileName.*"\)[^"]*/\(.*"\),\1\2,g' $DEST/yubix.vmx
fi

echo "Completed successfully, result is in: $DEST"
