#!/bin/bash

## run aspell over all markdown files listed on the command line
## if the argument is a directory aspell all the markdown file in that directory tree

ERR=0
JARGONFILE=./tests/aspell_jargon.txt
PATTERN=$@

if [ -z "$PATTERN" ]; then
    PATTERN=$(find . -path "./src" -prune -o  -name "*.md"  -print)
fi

for arg in $PATTERN
do
    #echo $arg
    CHECKFILES=""

    if [[ -f "${arg}" &&  "${arg}" =~ .md$ ]]; then
        CHECKFILES=${arg}
    fi
    if [[ -d "${arg}" ]]; then
        CHECKFILES=$(find ${arg} -name "*.md")
    fi
    if [ -z "${CHECKFILES}" ]; then
        continue
    fi
    #echo "MATCH!"

    for file in ${CHECKFILES}
    do
        WORDS=$(cat ${file} | aspell -l en_GB.UTF-8 -p ${JARGONFILE} -M list)
        if [ ! -z "${WORDS}" ]; then
            echo "** ${file} **"
            #echo "${WORDS}"
            for W in ${WORDS}; do
                echo -e "\t$W"
            done
            ERR=1
        fi
    done
done
exit $ERR
