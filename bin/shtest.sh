#!/bin/bash
#set -x


# echo Message
function echoSuccess() {
	echo -e "\e[42m" "Success" "\e[0m"  "$1"
}

# echo Message
function echoFailure() {
	echo -e "\e[41m" "Failure" "\e[0m" "$1"
}

#
# Asserts Functions
#

# last command exited with zero status
function assertExitSuccessfully() {
	if [ $? == 0 ]; then
		echoSuccess "${FUNCNAME[${1:-1}]}"
	else
		echoFailure "${FUNCNAME[${1:-1}]}"
	fi
}

# last command exited with non-zero status
function assertExitFailurefully() {
	if [ $? != 0 ]; then
		echoSuccess "${FUNCNAME[${1:-1}]}"
	else
		echoFailure "${FUNCNAME[${1:-1}]}"
	fi
}

# expected == actual
function assertEquals() {
	if [ "$1" == "$2" ]; then
		echoSuccess "${FUNCNAME[${3:-1}]}"
	else
		echoFailure "${FUNCNAME[${3:-1}]}"
		echo "Expected: " "$1"
		echo "Actual:   " "$2"
	fi
}

# file exists and size is not 0
function assertFileNotEmpty() {
	if [ -f "$1" ]; then
		echoSuccess "${FUNCNAME[${2:-1}]}"
	else
		echoFailure "${FUNCNAME[${2:-1}]}"
		echo "Not found: " "$1"
	fi
}

# diff expected.out vs actual.out
function assertNoDiff() {
	diff  --strip-trailing-cr "$1" "$2"
	
	assertExitSuccessfully 2
}

tests=tests

for d in "${tests}"/*; do
    if [ -d "${d}" ]; then
		echo "Searching for tests Directory: " "${d}"
        for f in "${d}"/*; do
			if [ -f "${f}" ]; then
				echo "Loading test file: " "${f}"
				source "${f}"
			fi
		done
    fi
done

# 1. Reflexion
# 2. get functions list
# 3. get functions begining with test
testFunctions=$(declare -F | cut -d " " -f 3 | egrep "^test.*")
# 4. look setUp & tearDown existence
setUp=$(declare -F | cut -d " " -f 3 | egrep "^setUp$")
tearDown=$(declare -F | cut -d " " -f 3 | egrep "^tearDown$")

# run all them
for func in ${testFunctions}; do
	${setUp}
	${func}
	${tearDown}
done
