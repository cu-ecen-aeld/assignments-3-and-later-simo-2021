#!/bin/sh
# Tester script for assignment 1 and assignment 2
# Author: Siddhant Jajoo
# Modified by Arnaud, on the 27.11.2025
#
# Ce script valide le bon fonctionnement de 2 prog: 
# writer: ecrit une chaine de charactere dans un fichier
#	&
# finder.sh 
#	cherche une chaine de charactere dans un fichier et y compte le nombre de fichier.
#   exemple: ./finder-test.sh 1 test_string / 
#   
# Updates
# replace writer.sh by writer.c
# New modification: 11.12.2025
# remove make step and replace with cross-compiler

set -e
set -u

#Arguments par defaut
NUMFILES=10
WRITESTR=AELD_IS_FUN
WRITEDIR=/tmp/aeld-data
username=$(cat conf/username.txt)

if [ $# -lt 3 ]
then
	echo "No parameters                        "
	echo "Using default value: ${WRITESTR} for string to write"
	if [ $# -lt 1 ]
	then
		echo "                                                             "
		echo "Using default value: ${NUMFILES} for number of files to write"
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
		echo "Folder '$WRITEDIR' has been created"
	else
		exit 1
	fi
fi

make clean

# Add make cross compiler
make CC=aarch64-linux-gnu-gcc
 

for i in $( seq 1 $NUMFILES)
do
	./writer "$WRITEDIR/${username}$i.txt" "$WRITESTR"
done

# Lance finder.sh pour chercher WRITESTR dans WRITEDIR → récupère le résultat dans OUTPUTSTRING
OUTPUTSTRING=$(./finder.sh "$WRITEDIR" "$WRITESTR")

set +e
echo ${OUTPUTSTRING} | grep "${MATCHSTR}"
if [ $? -eq 0 ]; then
	echo "success"
	exit 0
else
	echo "failed: expected  ${MATCHSTR} in ${OUTPUTSTRING} but instead found"
	exit 1
fi
