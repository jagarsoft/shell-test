# Description

Shell Scripting Test Driven Development

*shelltest* is a toolbox that supports you to develop shell scripts according to TDD approach.
It was born from need of solve a particular issue (https://github.com/dumblob/mysql2sqlite/issues/8) but looking for a general solution. Other good tools (see links) were discarded when diverging from the desired principles.

- [Tools for Testing Command Line Interfaces](https://spin.atomicobject.com/2016/01/11/command-line-interface-testing-tools/)
- [Bash Automated Testing System](https://github.com/sstephenson/bats)
- [shUnit2 is a xUnit based unit test framework for Bourne based shell scripts.](https://github.com/kward/shunit2)

*shelltest* is freely inspired by PHPUnit framework

# Principles

* dumbest (and easiest) KISS solution
* plain string matching
* separate directory "tests"
* fully POSIX-compatible

Of course, *shelltest* was developed using TDD ;-)

Yes, *shelltest* was tested itself!

# Features

*shelltest* can test two main features:

* interactive: means that you can test your shell script outputs that you expect
* executive: means that you can test your shell script execute actions you expect

You are free to test both features using whatever your environment provides to you, for instance, you can use tools like awk, diff, expect, find, grep, sed, another shell script, ...

In order to achieve this features you must allocate your tests suites in tests directory of your current project. In every test suite you must create an file with one or more functions which will be invoke, in turn.

# Installation

1. Just clone this repo
1. Change directory to it
1. sudo make install

It will be copied from *src/shelltest.sh* to */usr/local/bin/shelltest*


# Getting Started

1. Allocate your tests under *tests* directory.
1. Group them under SuitesTest directories trailing *Tests*.
1. Make a file defining a function begining with *test*, like testIcan...

For example. Let be '*tests\basicTests\testUsage*':

```Shell
function testICanSeeUsage()
{
	# Given
	source src/usage
	expect="shelltest -h -D [tests] -f test [TestSuite]"
	
	# When
	actual=$(usage)
	
	# Then
	assertEquals "${expect}" "${actual}"
}
```

Then just run *shelltest*

Its output will be:

```shell
Success testICanSeeHelp
```

Let see another example, '*tests\basicTest\testHelp*':

```shell
function testICanSeeHelp()
{
	# Given
	source src/shelltestHelp
	
	# When
	shelltestHelp >actual.out
	( echo
	usage
	echo
	echo "-h         This help"
	echo "-D [tests] Directory for your Test Suites"
	echo "TestSuite  Run all test in this Test Suite only"
	echo "-f test    Run this test only" ) > expected.out

	# Then
	diff --strip-trailing-cr expected.out actual.out
	
	assertExitSuccessfully
}
```

Its output will be:

```shell
Success testICanSeeHelp
```

If test fails, its output will be:

```shell
Failure testICanSeeHelp
```

Please, note that *Success* or *Failure* is followed by function's name under test, extracted from *FUNCNAME* in assert functions

You will see *Success* and *Failure* colored if it is available into your environment

# Assertion functions available

* assertExitSuccessfully
: Last command exited with zero status
* assertExitFailurefully
: Last command exited with non-zero status
* assertEquals
: Strings expected == actual
* assertFileNotEmpty
: File exists and size is not 0
* assertNoDiff
: diff expected.out vs actual.out

# External tools

It is highly recommended that you use [*shellckeck*](https://www.shellcheck.net) in order to keep your scripts cleaned ;-)


# Version

Please see current version file

I still am working on it... Stay tuned