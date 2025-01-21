#!/bin/sh
# Tester script for assignment 1 and assignment 2
# Author: Siddhant Jajoo

#set -e
set -u

NUMFILES=10
WRITESTR=AELD_IS_FUN
WRITEDIR=/tmp/aeld-data  #/home/tchuinkou/linux_sys/finder-app
username=$(cat conf/username.txt)


#compile writer.c
#gcc -Wall writer.c -o writer

#chmod +x writer

#rm -rf "${WRITEDIR}"

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


