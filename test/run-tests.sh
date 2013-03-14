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

if [ "${HOME}" != "/root" ]; then
	echo "Tests must be run as the root user!"
	exit 1
fi

cd "$(dirname "$0")"

echo "================================"
echo "RUNNING YUBI-X TESTS"
echo "`date`"
echo "Thu Mar 14 13:43:36 CET 2013"
echo "================================"

pre=$(find pre.d -mindepth 1 -maxdepth 1 -type f -executable \
	-name '[0-9]*' | sort)
tests=$(find test.d -mindepth 1 -maxdepth 1 -type f -executable \
	-name '[0-9]*' | sort)
post=$(find post.d -mindepth 1 -maxdepth 1 -type f -executable \
	-name '[0-9]*' | sort)

echo "Running pre.d tasks..."
for task in $pre; do
	echo "Running: $task"
	"$task"
done

FAILED=""
for test in $tests; do
	echo "* Running test: $test"
	if "$test"; then
		echo "* Completed successfully!"
	else
		FAILED="true"
		echo "================================"
		echo "FAILURE: $test FAILED!"
		echo "`date`"
		echo "================================"
	fi
done

echo "Done running tests"
echo "Running post.d tasks..."
for task in $post; do
	echo "Running $task"
	"$task"
done

if [ "$FAILED" == "true" ]; then
	echo "================================"
	echo "WARNING: THERE WERE FAILED TESTS"
	echo "`date`"
	echo "================================"
	exit 1
else
	echo "================================"
	echo "ALL TESTS COMPLETED SUCCESSFULLY"
	echo "`date`"
	echo "================================"
fi