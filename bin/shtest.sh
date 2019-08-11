#!/bin/bash
#set -x


# 
function echoSuccess() {
	echo -e "\e[42m" "Success" "\e[0m"  "$1"
}

function echoFailure() {
	echo -e "\e[41m" "Failure" "\e[0m" "$1"
}

#
# Asserts Functions
#

function assertExitSuccessfully() {
	if [ $? == 0 ]; then
		echoSuccess "${FUNCNAME[1]}"
	else
		echoFailure "${FUNCNAME[1]}"
	fi
}

function assertEquals() {
	if [ "$1" == "$2" ]; then
		echoSuccess "${FUNCNAME[1]}"
	else
		echoFailure "${FUNCNAME[1]}"
		echo "Expected: " $1
		echo "Actual:   " $2
	fi
}

tests=tests

for d in ${tests}/*; do
    if [ -d ${d} ]; then
		echo "Searching for tests Directory: " ${d}
        for f in ${d}/*; do
			if [ -f ${f} ]; then
				echo "Loading test file: " ${f}
				source ${f}
			fi
		done
    fi
done

# declare -F
# declare -f testICanSeeHelp

testICanSeeUsage
testICanSeeHelp
