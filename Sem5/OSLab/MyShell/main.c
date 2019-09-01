#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

#define EXIT_FAILURE 1
#define EXIT_SUCCESS 0

char *readLine()
{
    fflush(stdout);
    char *str = NULL;
    size_t bytes;
    getline(&str, &bytes, stdin);
    // printf("Entered: %s\n", str);
    // printf("Bytes read: %d\n", bytes);
    return str;
}

char **parseLine(char *str, int *n_token)
{
    *n_token = 0;
    int n = strlen(str);
    char **tokens = malloc(sizeof(char *));
    tokens[0] = NULL;

    int i = 0;
    while (i < n)
    {
        int start = i;
        for (; i < n; ++i)
        {
            if (str[i] == ' ' || str[i] == '\n' || str[i] == '\0')
            {
                break;
            }
        }
        int end = i;
        if (end - start > 0)
        {
            ++(*n_token);
            tokens = realloc(tokens, (*n_token + 1) * sizeof(char *));
            tokens[*n_token] = NULL;
            char *token = NULL;
            token = malloc(sizeof(char) * (end - start + 1));
            int k;
            int len = end - start;
            for (k = 0; k < len; ++k)
            {
                token[k] = str[start];
                ++start;
            }
            token[k] = '\0';
            tokens[*n_token - 1] = token;
        }
        ++i;
    }
    return tokens;
}

int newProcess(char **tokens)
{
    pid_t pid, wpid;
    int status;
    pid = fork();
    if (pid == 0)
    {
        if (execvp(tokens[0], tokens) == -1)
        {
            perror("MyShell");
        }
        exit(EXIT_FAILURE);
    }
    else if (pid < 0)
    {
        perror("MyShell");
    }
    else
    {
        do
        {
            wpid = waitpid(pid, &status, WUNTRACED);
        } while (!WIFEXITED(status) && !WIFSIGNALED(status));
    }
    return 1;
}

void printAbout()
{
    printf("\033[22;31m ============ MyShell =============\n");
    printf("\033[22;31m || BCSE III Project             ||\n");
    printf("\033[22;31m || Author: Prasenjit Kumar Shaw ||\n");
    printf("\033[22;31m ==================================\n");
    printf("\n");
}

void builtInExit(int status)
{
    exit(status);
}

int builtInChdir(char *path)
{
    if (chdir((path == NULL) ? "~" : path) != 0)
    {
        perror("MyShell");
    }
    return 1;
}

int builtInMkdir(char **tokens)
{
    char *temp = tokens[0];
    tokens[0] = malloc(sizeof(char) * 6);
    tokens[0][0] = 'm';
    tokens[0][1] = 'k';
    tokens[0][2] = 'd';
    tokens[0][3] = 'i';
    tokens[0][4] = 'r';
    tokens[0][5] = '\0';
    free(temp);
    return newProcess(tokens);
}

int builtInEditFile(char **tokens)
{
    char *temp = tokens[0];
    tokens[0] = malloc(sizeof(char) * 3);
    tokens[0][0] = 'v';
    tokens[0][1] = 'i';
    tokens[0][2] = '\0';
    free(temp);
    return newProcess(tokens);
}

int builtInInfo(char **tokens)
{
    char *temp = tokens[0];
    tokens[0] = malloc(sizeof(char) * 5);
    tokens[0][0] = 'f';
    tokens[0][1] = 'i';
    tokens[0][2] = 'l';
    tokens[0][3] = 'e';
    tokens[0][4] = '\0';
    free(temp);
    return newProcess(tokens);
}

int executeCommand(char **tokens, int n_token)
{
    if (strcmp(tokens[0], "exit") == 0 || strcmp(tokens[0], "exitnewshell") == 0)
    {
        builtInExit(0);
    }
    else if (strcmp(tokens[0], "cd") == 0)
    {
        return builtInChdir(tokens[1]);
    }
    else if (strcmp(tokens[0], "dirnew") == 0)
    {
        return builtInMkdir(tokens);
    }
    else if (strcmp(tokens[0], "editfile") == 0)
    {
        return builtInEditFile(tokens);
    }
    else if (strcmp(tokens[0], "info") == 0)
    {
        return builtInInfo(tokens);
    }
    else if (strcmp(tokens[0], "help") == 0)
    {
        printAbout();
    }
    else
    {
        return newProcess(tokens);
    }
    return 1;
}

int main(void)
{
    printAbout();
    int status;
    char *str;
    char **tokens;
    do
    {
        printf("> ");
        str = readLine();
        int n_token;
        tokens = parseLine(str, &n_token);
        status = executeCommand(tokens, n_token);
        free(str);
        free(tokens);
    } while (status);
    return EXIT_SUCCESS;
}
