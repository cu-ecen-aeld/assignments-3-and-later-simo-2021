#include "systemcalls.h"

#include <stdlib.h>
#include <unistd.h>

#include <sys/wait.h>

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
    int ret = system(cmd);

    if (ret == 0)
        return true;

    perror("failed to run 'system' command");
    return false;
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
    va_list args;
    va_start(args, count);
    char * command[count+1];
    int i;
    for(i=0; i<count; i++)
    {
        command[i] = va_arg(args, char *);
    }
    command[count] = NULL;

/*
 * TODO:
 *   Execute a system command by calling fork, execv(),
 *   and wait instead of system (see LSP page 161).
 *   Use the command[0] as the full path to the command to execute
 *   (first argument to execv), and use the remaining arguments
 *   as second argument to the execv() command.
 *
*/

    int forkRet = fork();
    if (forkRet == -1) {
        perror("fork failed!");
        return false;
    } else if (forkRet == 0) {
        /* we are in the child */
        if (execv(command[0], command) == -1) {
            perror("execv failed in the child");
            exit(-1);
        }
    }

    va_end(args);

    /* we are in the parent */
    int wstatus = 0;
    int waitRet = waitpid(forkRet, &wstatus, 0);
    if (waitRet == -1) {
        perror("failed to wait for child pid");
        return false;
    } else if (waitRet != forkRet) {
        fprintf(stderr, "Expected waitRet to be %d but got %d instead??", forkRet, waitRet);
        return false;
    }

    int childExitStatus = WEXITSTATUS(wstatus);
    fprintf(stdout, "return was %d", childExitStatus);
    return childExitStatus == 0;
}

/**
* @param outputfile - The full path to the file to write with command output.
*   This file will be closed at completion of the function call.
* All other parameters, see do_exec above
*/
bool do_exec_redirect(const char *outputfile, int count, ...)
{
    va_list args;
    va_start(args, count);
    char * command[count+1];
    int i;
    for(i=0; i<count; i++)
    {
        command[i] = va_arg(args, char *);
    }
    command[count] = NULL;

/*
 * TODO:
 *   Execute a system command by calling fork, execv(),
 *   and wait instead of system (see LSP page 161).
 *   Use the command[0] as the full path to the command to execute
 *   (first argument to execv), and use the remaining arguments
 *   as second argument to the execv() command.
 *
*/

    int forkRet = fork();
    if (forkRet == -1) {
        perror("fork failed!");
        return false;
    } else if (forkRet == 0) {
        /* we are in the child */
        freopen(outputfile, "w", stdout);
        if (execv(command[0], command) == -1) {
            perror("execv failed in the child");
            exit(-1);
        }
    }

    va_end(args);

    /* we are in the parent */
    int wstatus = 0;
    int waitRet = waitpid(forkRet, &wstatus, 0);
    if (waitRet == -1) {
        perror("failed to wait for child pid");
        return false;
    } else if (waitRet != forkRet) {
        fprintf(stderr, "Expected waitRet to be %d but got %d instead??", forkRet, waitRet);
        return false;
    }

    int childExitStatus = WEXITSTATUS(wstatus);
    fprintf(stdout, "return was %d", childExitStatus);
    return childExitStatus == 0;
}
