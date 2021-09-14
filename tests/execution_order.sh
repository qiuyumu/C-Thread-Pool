#! /bin/bash

#
# This file has several tests to check for memory leaks.
# valgrind is used so make sure you have it installed
#

. funcs.sh


# ---------------------------- Tests -----------------------------------


function test_pause_resume_est7secs { #threads
	echo "Pause and resume test for 7 secs with $1 threads"
	compile src/pause_resume.c
	realsecs=$(/usr/bin/time -f '%e' ./test "$1" 2>&1 > /dev/null)
	threshold=1.00 # in secs
	
	ret=$(python -c "print(($realsecs-7)<=$threshold)")

	if [ "$ret" == "True" ]; then
		return
	fi
	err "Elapsed $realsecs which is more than than allowed"
	exit 1
}

function execution_order {
    echo "Test the execution order of $1 tasks"
    compile src/priority_work.c
    $(./test $1 > /dev/null)
    src="output.txt"
    dst="expected_output.txt"
    status=$(diff -q "$src" "$dst")
    $(rm -f "$src" "$dst")
    if [ "$status" ];then
        err "Test execution order failed"
        exit 1
    fi
    
}

# Run tests

execution_order 10
execution_order 100
execution_order 200
echo "No execution order errors"
