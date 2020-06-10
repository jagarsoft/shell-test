#!/bin/bash
# set -x

# TODOs
# -d directory for tests
# -v verbose flag
# -h help/usage flag

# Set ANSI color secuencies from JBlond/bash-colors.md <https://gist.github.com/JBlond/2fea43a3049b38287e5e9cefc87b2124>
failure="\e[41m"
success="\e[42m"
warning="\e[0;30m\e[43m"
reset="\e[0m"

# Options
testsPath=tests
fileTest=

#
# Colored echos functions
#

function echoSuccess() {
	echo -e "$success" "Success" "$reset" "$@"
}

function echoFailure() {
	echo -e "$failure" "Failure" "$reset" "$@"
}

function echoWarning() {
	echo -e "$warning" "Warning" "$reset" "$@"
}

#
# Asserts Functions
#

# Last command exited with zero status
function assertExitSuccessfully() {
	if [[ $? == 0 ]]; then
		echoSuccess "${FUNCNAME[${1:-1}]}"
	else
		echoFailure "${FUNCNAME[${1:-1}]}"
	fi
}

# Last command exited with non-zero status
function assertExitFailurefully() {
	if [[ $? != 0 ]]; then
		echoSuccess "${FUNCNAME[${1:-1}]}"
	else
		echoFailure "${FUNCNAME[${1:-1}]}"
	fi
}

# Strings expected == actual
function assertEquals() {
	if [[ "$1" == "$2" ]]; then
		echoSuccess "${FUNCNAME[${3:-1}]}"
	else
		echoFailure "${FUNCNAME[${3:-1}]}"
		echo "Expected: " "$1"
		echo "Actual:   " "$2"
	fi
}

# File exists and size is not 0
function assertFileNotEmpty() {
	if [[ -f "$1" ]]; then
		echoSuccess "${FUNCNAME[${2:-1}]}"
	else
		echoFailure "${FUNCNAME[${2:-1}]}"
		echo "File not found: " "$1"
	fi
}

# diff expected.out vs actual.out
function assertNoDiff() {
	diff  --strip-trailing-cr "$1" "$2"
	
	assertExitSuccessfully 2
}

function isFunction() {
	declare -Ff "$1" >/dev/null;
}

#
# Global SetUp & TearDown
#

function globalSetUp() {
	echoWarning globalSetUp
}

function globalTearDown() {
	echoWarning globalTearDown
}

#
# Builtin help functions
#

function usage()
{
    echo "shelltest [-h] [-D testsPath] [-f test] [TestSuite]"
}

function usageSummary()
{
	usage
	echo
	echo "-h           This help"
	echo "-D testsPath Directory for your Test Suites"
	echo "-f test      Run this test only"
	echo "TestSuite    Run all test in this Test Suite only"
}

#
# Main
#

while getopts "hD:f:" flag; do
    case "${flag}" in
		h)
			usageSummary
			exit 0
			;;
        D)
            testsPath=${OPTARG}
            ;;
        f)
            fileTest=${OPTARG}
            ;;
        *)
			# usage
			exit 1
            ;;
    esac
done
shift $((OPTIND-1))

if [[ ! -d "$testsPath" ]]; then
	echo "Path not found:" "$testsPath"
	# usage
	exit 1
fi

# https://github.com/koalaman/shellcheck/wiki/SC2144
if [[ -n "${fileTest}" ]]; then
	found=false
	for file in ${testsPath}/*/${fileTest}
	do
	  if [ -f "${file}" ]
	  then
		found=true
		break
	  fi
	done
	if [[ "${found}" = "false" ]]; then
		echo "File not found:" "${fileTest}"
		# usage
		exit 1
	fi
fi

echo "Searching for testSuites in directory: " "${testsPath}"
for d in "${testsPath}"/*; do
	if [[ -d "${d}" ]]; then
		if [[ ! ( "${d}" = *Tests ) ]]; then
			continue
		fi
		echo "Searching for tests in directory: " "${d}"
		for f in "${d}"/*; do
			if [[ -f "${f}" ]]; then
				if [[ -n "$fileTest" && ! ( "${f}" =~ $fileTest ) ]]; then
					continue
				fi
				
				echo "Loading test file:" "${f}"
				source "${f}"
			fi
		done
	fi
done

# 1. Reflexion
# 2. get functions list
# 3. get functions begining with test
testFunctions=$(declare -F | cut -d " " -f 3 | grep -E "^test.*")
# 4. look for setUp & tearDown existence
globalSetUp=$(declare -F | cut -d " " -f 3 | grep -E "^globalSetUp$")
globalTearDown=$(declare -F | cut -d " " -f 3 | grep -E "^globalTearDown$")

# run all them
"${globalSetUp}"
for func in ${testFunctions}; do
	# if [[ -n "$fileTest" &&  "${func}" != "$fileTest" ]]; then
		# continue
	# fi

	if isFunction setUp_"${func}"
	then
		setUp_"${func}"
	fi
	
	${func}
	
	if isFunction tearDown_"${func}"
	then
		tearDown_"${func}"
	fi
done
"${globalTearDown}"

exit 0