<<<<<<< HEAD
#!/bin/sh
# Tester script for assignment 1 and assignment 2
# Author: Arnaud Simo
# 24.11.2025

#set -e
#set -u

##Parameters
filesdir="$1"
searchstr="$2"

## Constants
NUMFILES=10 
NUMLINES=10
 
# Check argument count
if [ $# -lt 2 ]  
then	
	echo "Error::search string and file directory are missing."
	echo "      ./finder.sh  /dir1/subdir1/  stringToSearch"
	exit 1
fi

# Check if directory exists
if [ ! -d "$filesdir" ]; then
	echo "Directory ${filesdir} does not exist"
	exit 1
fi

# Nombre de fichiers: 
NUMFILES=$(find "$filesdir" -type f | wc -l)

# Nombre de lignes contenant le texte
NUMLINES=$(grep -R "$searchstr" "$filesdir" 2>/dev/null | wc -l)

echo "The number of files are ${NUMFILES} and the number of matching lines are ${NUMLINES}"
=======
#!/bin/bash

# Vérifier le nombre d'arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <filesdir> <searchstr>"
    exit 1
fi

filesdir=$1
searchstr=$2
count=0

# Vérifier si le répertoire existe
if [ -d "$filesdir" ]; then
    # Parcourir les fichiers dans le répertoire
    while IFS= read -r -d '' file; do
        # Rechercher la chaîne dans le fichier et compter les lignes où elle apparaît
        while IFS= read -r line; do
            if [[ $line == *"$searchstr"* ]]; then
                ((count++))
            fi
        done < <(grep -H "$searchstr" "$file")
    done < <(find "$filesdir" -type f -print0)
    if [ $count -gt 0 ]; then
        # Ajuster la sortie pour correspondre à la chaîne MATCHSTR dans finder-test.sh
        echo "The number of files are $(find "$filesdir" -type f | wc -l) and the number of matching lines are $count."
    else
        echo "No lines containing '$searchstr' were found in '$filesdir'."
    fi
else
    echo "The directory '$filesdir' does not exist."
fi
>>>>>>> 2f2127cb22f6702a5cf4eebc8fe967c3513c15aa
