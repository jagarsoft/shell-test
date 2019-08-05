#!/bin/bash
# set -x

for d in tests/*; do
    if [ -d ${d} ]; then
		echo "Directory " ${d}
        for f in ${d}/*; do
			if [ -f ${f} ]; then
				echo "file " ${f}
				source ${f}
			fi
		done
    fi
done

# declare -F
# declare -f testICanSeeHelp

# testICanSeeUsage
testICanSeeHelp
declare -F
shtestHelp