#!/bin/sh
# Tester script for assignment 1 and assignment 2
# Author: Siddhant Jajoo
<<<<<<< HEAD
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
=======
# Modified by: Arnaud Simo
# Date: February 2nd, 2025
# modified 24th 2025


>>>>>>> 2f2127cb22f6702a5cf4eebc8fe967c3513c15aa

set -e
set -u

#Arguments par defaut
NUMFILES=10
WRITESTR=AELD_IS_FUN
WRITEDIR=/tmp/aeld-data  #/home/tchuinkou/_old 
username=$(cat /etc/finder-app/conf/username.txt)
#username=$(cat conf/username.txt)

cd `dirname $0`

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

#rm -rf "${WRITEDIR}"

# create $WRITEDIR if not assignment1
assignment=`cat /etc/finder-app/conf/assignment.txt`
#assignment=`cat conf/assignment.txt`

#echo "Debug:: avant if"

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
<<<<<<< HEAD
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

=======
fi 

#echo "Debug:: apres if"
#echo "Removing the old writer utility and compiling as a native application"
#make clean
#make

for i in $( seq 1 $NUMFILES)
do	
	/etc/finder-app/writer "$WRITEDIR/${username}$i.txt" "$WRITESTR"
done

#read -p "hint enter to continue..."
#La sortie de finder.sh sera capturée dans la variable OUTPUTSTRING
OUTPUTSTRING=$(/etc/finder-app/finder.sh "$WRITEDIR" "$WRITESTR")
##write output of the finder command to /tmp/assignment4-result.txt
echo ${OUTPUTSTRING} > /tmp/assignment4-result.txt

# remove temporary directories
#rm -rf /tmp/aeld-data

>>>>>>> 2f2127cb22f6702a5cf4eebc8fe967c3513c15aa
set +e
echo ${OUTPUTSTRING} | grep "${MATCHSTR}"
if [ $? -eq 0 ]; then
#La commande tee permet d'écrire la sortie à la fois sur la sortie standard 
#et dans un fichier, et l'option -a permet d'ajouter le texte à la fin du fichier.
	echo "success" | tee -a /tmp/assignment4-result.txt
	exit 0
else
	echo "failed: expected  ${MATCHSTR} in ${OUTPUTSTRING} but instead found" | tee -a /tmp/assignment4-result.txt
	exit 1
fi

# Redirige à la fois stdout et stderr vers le fichier /tmp/assignment4 - result.txt
exec &> /tmp/assignment4-result.txt
