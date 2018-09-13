#!/bin/bash
#
# Compare two binary files.
#
# BF 2018
# Version 1.1


duplicates=0
log=dup_list.txt
dupdir=DupDir

echo
echo
echo "This script checks any file in the current directory and it's sub directorys against each other and"
echo "tells wether there are duplicates or not...."
echo

# This is where all duplicates go...

echo Creating directory for duplicates....
mkdir $dupdir

# Remove old 'dup_List' file where all previous attempts are logged..
if [ -f $log ]
then
    rm $log
    echo Old log- files removed...
fi

# Get all files of the current dir and all of it's sub- dirs....
#
# Be carefull! If you use the '*' in find's search pattern, hidden files will
# be checked also. This means, if your dir is under git control, git- file
# structure may be damaged! This is true for all other hidden config- files...

start=`date`
echo "$(find . -name \*.jpg)" > result   # Change search pattern, currently only files with 'jpg' extension are checked!

# Begin checking...
while read a
do
    # Step 1: Get first entry from result list
    # If it is an file entry, begin checking...
    if [ -f "$a" ]
    then
	#echo ---------------------------- Checking: "$a"
	
	# Step 2: Again, get first entry from result list, check if it is a file
	while read i
	do
	    if [ -f "$i" ]
	    then
		
		# Ok, first entry from result list is a file, now check
		# if this file is not the one we want to check against each of the others
	        # (The one we have obtained in step 1).
	       
  		if [ "$a" != "$i" ]
		
		# Check file (Step 1) against each other file in the current dir and
		# all of it's sub dirs.
		then
		    echo Checking "$a" against "$i"
		    result=$(diff "$a" "$i") 
		    if [ "$result" == "" ]
		    then
			echo "$a" = "$i"  >> $log
			printf "Duplicate:\t`date`\tMoving $i to DupDir\n"
			
			# Move duplicate into "quarantaine"
			#
			# This is compulsory!If we leave the file as it is,
			# during the further  it would be compared recursively thus,
			# leading to wrong results........

			mv "$i" ./dupDir
			let "duplicates=duplicates+1"
		    fi
     		fi
	    fi
	done < result
    fi
done < result

if [ $duplicates -gt 0 ]
then
    echo $duplicates duplicates found in $(pwd)
else
    echo No duplicates found
    rmdir $dupdir
fi
printf "START:\t $start\n"
printf "END:\t `date`\n"
