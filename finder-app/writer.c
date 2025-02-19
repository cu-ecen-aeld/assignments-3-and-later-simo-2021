#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>

//$ tail  -n 19 /var/log/syslog
/* write.c est similaire a writer.sh
# Ce fichier prends en entrée 2 parametres:
# 1er param: un chemin vers un fichier: exemple: \home\tchuinkou\linux_sys\finder-app\text.txt
# 2e  param: une chaine de caractère qui sera ecrit dans le fichier: text.txt
# et ecrit le contenu de la chaine dans le fichier texte.
# exemple d'appel: tchuinkou@PC$: ./writer  /home/tchuinkou/linux_sys/finder-app/test.txt   ios */
// Author: Arnaud Simo
// rewrite the 18th Feb to fit the requirements of Assignment4Part2INstructions

int main(int argc, char *argv[]) {
    // Vérifier le nombre d'arguments
    if (argc!= 3) {
        fprintf(stderr, "Usage: %s <file> <string>\n", argv[0]);
        return EXIT_FAILURE;;
    }

    // Ouvrir la connexion avec le démon syslog
    openlog("List of logs:", LOG_CONS | LOG_PID | LOG_NDELAY, LOG_USER);

    // Nom du fichier et chaîne de caractères à écrire
    const char *file_path = argv[1];
    const char *text = argv[2];

    // Ouvrir le fichier en mode écriture
    printf("Chemin du fichier: %s\n", file_path);
    FILE *file = fopen(file_path, "w");
    if (file == NULL) {
        syslog(LOG_ERR, "Erreur lors de l'ouverture du fichier %s: %m", file_path);
        return EXIT_FAILURE;;
    }

    // Écrire la chaîne de caractères dans le fichier
    size_t len = fprintf(file, "%s", text);
    if (len < 0) {
        syslog(LOG_ERR, "Erreur lors de l'écriture dans le fichier %s: %m", file_path);
        fclose(file);
        return EXIT_FAILURE;;
    }

    // Fermer le fichier
    if (fclose(file)!= 0) {
        syslog(LOG_ERR, "Erreur lors de la fermeture du fichier %s: %m", file_path);
        return EXIT_FAILURE;;
    }

    // Enregistrer un message de débogage dans syslog
    syslog(LOG_DEBUG, "Writing %s to %s", text, file_path);

    // Fermer la connexion avec le démon syslog
    closelog();

    return 1;
}
