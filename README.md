# Description

Shell Scripting Test Driven Development

shtest is a toolbox that supports you to develop shell scripts according to TDD approach.
It was born from need of solve a particular issue (https://github.com/dumblob/mysql2sqlite/issues/8) but looking for a general solution. Other good tools (see links) were discarded when diverging from the desired principles

[Tools for Testing Command Line Interfaces](https://spin.atomicobject.com/2016/01/11/command-line-interface-testing-tools/)

[Bash Automated Testing System](https://github.com/sstephenson/bats)


# Principles

* dumbest (and easiest) KISS solution
* plain string matching
* separate directory "tests"
* fully POSIX-compatible

Of course, shtest was developed using TDD ;-)

Yes, shtest was tested itself!

# Features

shtest can test two main features:

* interactive: means that you can test your shell script outputs that you expect
* executive: means that you can test your shell script executes actions you expect

You are free to test both features using whatever your environment provides to you, for instance, you can use tools like awk, diff, expect, find, grep, sed, another shell script, ...

In order to achieve this features you must allocate your tests suites in tests directory of your current project. In every test suite you must create an file with one or more functions which will be invoke, in turn.

# Getting Started

1. Allocate your tests under *tests* directory.
1. Group them under SuitesTest directories trailing *Tests*.
1. Make a file defining a function begining with *test*, like testIcan...

For example. Let be '*tests\basicTest\testUsage*':

```Shell
function testICanSeeUsage()
{
	# Given
	source src/usage
	expect="shtest -h -D [tests] TestSuite -f test"
	
	# When
	actual=$(usage)
	
	# Then
	assertEquals "${expect}" "${actual}"
}
```

Then just run bin/shtest.sh

Its output will be:

```shell
Success testICanSeeHelp
```

Let see another example, '*tests\basicTest\testHelp*':

```shell
function testICanSeeHelp()
{
	# Given
	source src/shtestHelp
	
	# When
	shtestHelp >actual.out
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

If test will fail, its output will be:

```shell
Failure testICanSeeHelp
```

Please, note that *Success* or *Failure* is followed by function's name under test, extracted from *"${FUNCNAME[1]}"* in assert functions

You will see *Success* and *Failure* colored if it is available into your environment

# Version

Current version is 0.0.3-alpha

I still am working on it... Stay tuned