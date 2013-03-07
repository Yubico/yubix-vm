#!/bin/bash

set -e

echo "===================="
echo "RUNNING YUBI-X TESTS"
echo "===================="

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
#for test in `ls tests|grep -e "^[0-9]\{3\}-"`;do
for test in $tests; do
	echo "* Running test: $test"
	if "$test"; then
		echo "* Completed successfully!"
	else
		FAILED="true"
		echo "================================"
		echo "FAILURE: $test FAILED!"
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
	echo "================================"
	exit 1
else
	echo "================================"
	echo "ALL TESTS COMPLETED SUCCESSFULLY"
	echo "================================"
fi
