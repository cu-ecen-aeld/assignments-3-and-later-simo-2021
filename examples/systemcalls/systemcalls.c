#include "systemcalls.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <stdbool.h>

/**
 * @param cmd the command to execute with system()
 * @return true if the command in @param cmd was executed
 *   successfully using the system() call, false if an error occurred,
 *   either in invocation of the system() call, or if a non-zero return
 *   value was returned by the command issued in @param cmd.
*/
bool do_system(const char *cmd)
{

/*
 * TODO  add your code here
 *  Call the system() function with the command set in the cmd
 *   and return a boolean true if the system() call completed with success
 *   or false() if it returned a failure
*/ 

  printf("                                 \n");
  printf("######## do_system - Start  #######\n");
  printf("Appel de la fonction system: %s \n", cmd);
  int ret;
  ret =  system(cmd);
  if (ret == -1) {
        perror("Erreur lors de l'exécution de la commande");
        return 0;
  }

  printf("Commande exécutée avec succès.\n");
  return 1;
}

/**
* @param count -The numbers of variables passed to the function. The variables are command to execute.
*   followed by arguments to pass to the command
*   Since exec() does not perform path expansion, the command to execute needs
*   to be an absolute path.
* @param ... - A list of 1 or more arguments after the @param count argument.
*   The first is always the full path to the command to execute with execv()
*   The remaining arguments are a list of arguments to pass to the command in execv()
* @return true if the command @param ... with arguments @param arguments were executed successfully
*   using the execv() call, false if an error occurred, either in invocation of the
*   fork, waitpid, or execv() command, or if a non-zero return value was returned
*   by the command issued in @param arguments with the specified arguments.
*/


bool do_exec(int count, ...)
{
	printf("                                 \n");
	printf("######## do_exec - Start  #######\n");
    va_list args;
    va_start(args, count);
    char * command[count+1];
    int i;
    for(i=0; i<count; i++)
    {
		//char *arg = va_arg(args, char *);
        //printf("Argument %d : %s\n", i, arg);
        command[i] = va_arg(args, char *);
    }
    command[count] = NULL;
    // this line is to avoid a compile warning before your implementation is complete
    // and may be removed
    command[count] = command[count];
	va_end(args);
	
/*
 * TODO:
 *   Execute a system command by calling fork, execv(),
 *   and wait instead of system (see LSP page 161).
 *   Use the command[0] as the full path to the command to execute
 *   (first argument to execv), and use the remaining arguments
 *   as second argument to the execv() command.
 *
 * 
*/
	// Création d'un processus enfant avec fork()
    pid_t pid = fork();

    if (pid == -1) {
        // Gestion de l'erreur en cas d'échec de fork()
        perror("Erreur lors de la création du processus enfant");
        return false; //exit(EXIT_FAILURE);
    }

    if (pid == 0) {
        // Processus enfant : exécution de la commande avec execv()
        printf("                                         \n");
        printf("Exécution de la commande : %s\n", command[0]);
        printf("                                         \n");

        // Exécution de la commande en utilisant execv()
        // command[0] contient le chemin complet de la commande
        // argv + 1 est utilisé pour passer le reste des arguments
        execv(command[0], command);

        // Si execv() échoue, afficher un message d'erreur et quitter
        perror("Erreur lors de l'exécution de la commande");
        exit(EXIT_FAILURE);
    } else {
        // Processus parent : attendre la fin du processus enfant
        int status;
              if (waitpid(pid, &status, 0) == -1) {
            perror("Erreur lors de l'attente du processus enfant");
            return false;
        }

        if (WIFEXITED(status)) {
            // La commande s'est terminée normalement
            printf("Commande exécutée avec le code de retour : %d\n", WEXITSTATUS(status));
            return WEXITSTATUS(status) == 0;
        } else {
            // La commande s'est terminée de manière anormale
            printf("La commande ne s'est pas terminée correctement\n");
            return false;
        }
    }
}

/**
* @param outputfile - The full path to the file to write with command output.
*   This file will be closed at completion of the function call.
* All other parameters, see do_exec above
*/
bool do_exec_redirect(const char *outputfile, int count, ...)
{
	printf("                                 \n");
	printf("######## do_exec_redirect - Start  #######\n");
	
    va_list args;
    va_start(args, count);
    char * command[count+1];
    int i;
    for(i=0; i<count; i++)
    {
        command[i] = va_arg(args, char *);
    }
    command[count] = NULL;
    // this line is to avoid a compile warning before your implementation is complete
    // and may be removed
    command[count] = command[count];
    va_end(args);


/*
 * TODO
 *   Call execv, but first using https://stackoverflow.com/a/13784315/1446624 as a 
 *   refernce,
 *   redirect standard out to a file specified by outputfile.
 *   The rest of the behaviour is same as do_exec()
 *
*/
	// Créer un processus enfant
    pid_t pid = fork();
    if (pid == -1) {
        perror("Erreur lors de la création du processus enfant");
        return false;
    }
  
    if (pid == 0) {
        // Ouvrir (ou créer) le fichier de sortie
        int fd = open(outputfile, O_WRONLY | O_CREAT | O_TRUNC, 0644);
        if (fd == -1) {
            perror("Erreur lors de l'ouverture du fichier de sortie");
            exit(EXIT_FAILURE);
        }

        // Rediriger stdout et stderr vers le fichier
        dup2(fd, STDOUT_FILENO);  // Rediriger la sortie standard vers le fichier
        dup2(fd, STDERR_FILENO);  // Rediriger la sortie d'erreur vers le fichier
        close(fd);  // Fermer le descripteur de fichier, car il est maintenant redirigé

        // Exécuter la commande
        execv(command[0], command);

        // Si execv échoue
        perror("Erreur lors de l'exécution de la commande");
        exit(EXIT_FAILURE);
        
    } else { // IF pid >0
        int status;
        waitpid(pid, &status, 0);

        // Vérifier si le processus enfant s'est terminé normalement
        if (WIFEXITED(status)) {
            return WEXITSTATUS(status) == 0;
        } else {
            return false;
        }
    }
}


