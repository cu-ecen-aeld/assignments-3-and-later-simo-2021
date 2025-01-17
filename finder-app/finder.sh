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
