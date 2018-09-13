#!/bin/bash
#
# This resets the test environment in the current dir 
# after 'compare.sh' was run.
#

if [ -f dup_list.txt ]
then
    echo Removing old log file....
    rm dup_list.txt
fi

if [ -f result ]
then
    echo Removing result- list.....
    rm result
fi

if [ -d DupDir ]
then
    echo Moving all files from 'dupDir' to $(pwd)
    mv DupDir/*.* SampleDir/
    echo Removing dir 'DupDir'
    rmdir DupDir
fi

if [ -f found.txt ]
then
    echo Removing result list....
    rm found.txt
fi

echo Removing backup files....
rm *.*~
