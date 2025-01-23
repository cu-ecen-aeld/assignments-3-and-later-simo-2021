#!/bin/sh
# Tester script for assignment 1 and assignment 2
# and assignement 3-part 2
# Author: Siddhant Jajoo
# Modified by Arnaud Simo

#set -e
set -u

NUMFILES=10
WRITESTR=AELD_IS_FUN
WRITEDIR=/tmp/aeld-data  #/home/tchuinkou/linux_sys/finder-app
username=$(cat conf/username.txt)

#echo "NUMFILES value is $NUMFILES"

## test si le nombre de parametre < 3
if [ $# -lt 3 ]
then
	echo "Using default value ${WRITESTR} for string to write"
	if [ $# -lt 1 ]
	then
		echo "Using default value ${NUMFILES} for number of files to write"
	else
		NUMFILES=$1
	fi	
else
	NUMFILES=$1
	WRITESTR=$2
	WRITEDIR=/tmp/aeld-data/$3
fi

MATCHSTR="The number of files are ${NUMFILES} and the number of matching lines are ${NUMFILES}"

echo "Writing ${NUMFILES} files containing string ${WRITESTR} to ${WRITEDIR}"

rm -rf "${WRITEDIR}"

# create $WRITEDIR if not assignment1
assignment=`cat ../conf/assignment.txt`

if [ $assignment != 'assignment1' ]
then
	mkdir -p "$WRITEDIR"

	#The WRITEDIR is in quotes because if the directory path consists of spaces, then variable substitution will consider it as multiple argument.
	#The quotes signify that the entire string in WRITEDIR is a single string.
	#This issue can also be resolved by using double square brackets i.e [[ ]] instead of using quotes.
	if [ -d "$WRITEDIR" ]
	then
		echo "$WRITEDIR created"
		ls "$WRITEDIR"
	else
		exit 1
	fi
fi

#echo "Removing the old writer utility and compiling as a native application"
#make clean
#make -f Makefile

#compile writer.c
#gcc -Wall writer.c -o writer

for i in $(seq 1 "$NUMFILES"); do
    echo "counter"
    echo "Iteration $i of $NUMFILES"
    echo "debug: $WRITEDIR/${username}_$i.txt"
    
    file_to_write="$WRITEDIR/${username}$i.txt"
    echo "Chemin du fichier à écrire : $file_to_write" # Correction de l'encodage des accents

    if [ -e "$file_to_write" ]; then
        echo "File $file_to_write already exists, skipping write operation."
    else
        echo "Writing to $file_to_write"
        ./writer "$file_to_write" "$WRITESTR"
        echo "Après l'appel à writer"

        if [ $? -ne 0 ]; then
            echo "Error writing to $file_to_write"
            exit 1
        fi    
    fi
done

OUTPUTSTRING=$(./finder.sh "$WRITEDIR" "$WRITESTR")

echo "Debug:: ("$WRITESTR")"
echo "${MATCHSTR}"

# remove temporary directories
#rm -rf /tmp/aeld-data

set +e
echo ${OUTPUTSTRING} | grep "${MATCHSTR}"
if [ $? -eq 0 ]; then
	echo "success"
	exit 0
else
	echo "failed: expected  ${MATCHSTR} in ${OUTPUTSTRING} but instead found"
	exit 1
fi
