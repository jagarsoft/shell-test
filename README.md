# Description

Shell Scripting Test Driven Development

shtest is a toolbox that supports you to develop shell scripts according to TDD approach.
It was born from need of solve a particular issue (https://github.com/dumblob/mysql2sqlite/issues/8) but looking for a general solution. Other good tools (see links) were discarded when diverging from the desired principles

https://spin.atomicobject.com/2016/01/11/command-line-interface-testing-tools/
https://github.com/sstephenson/bats


# Principles

* dumbest (and easiest) KISS solution
* plain string matching
* separate directory "tests"
* fully POSIX-compatible

Of course, shtest was developed using TDD ;-)

Yes, shtest was tested itself!

# Features

shtest can test two main features

* interactive: means that you can test your shell script outputs that you expect
* executive: means that you can test your shell script executes actions you expect

You are free to test both features using whatever your environment provides to you, for instance, you can use tools like awk, sed, grep, find, expect, another shell script, ...

In order to achieve this features you must allocate your tests suites in tests directory of your current project. In every test suite you must create an file with one or more functions which will be invoke, in turn.

# Version

Current version is 0.0.1-alpha

I still am working on it... Stay tuned