#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

#define EXIT_FAILURE 1
#define EXIT_SUCCESS 0

char *readLine()
{
    fflush(stdin);
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
    while (i < n) {
        int start = i;
        for (; i < n; ++i) {
            if (str[i] == ' ' || str[i] == '\n' || str[i] == '\0') {
                break;
            }
        }
        int end = i;
        if (end - start > 0) {
            ++(*n_token);
            tokens = realloc(tokens, (*n_token + 1) * sizeof(char *));
            tokens[*n_token] = NULL;
            char *token = NULL;
            token = malloc(sizeof(char) * (end - start + 1));
            int k;
            int len = end - start;
            for (k = 0; k < len; ++k) {
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

int executeCommand(char **tokens, int n_token)
{
    pid_t pid, wpid;
    int status;
    pid = fork();
    if (pid == 0) {
        if (execvp(tokens[0], tokens) == -1) {
            perror("MyShell");
        }
        exit(EXIT_FAILURE);
    } else if (pid < 0) {
        perror("MyShell");
    } else {
        do {
            wpid = waitpid(pid, &status, WUNTRACED);
        } while (!WIFEXITED(status) && !WIFSIGNALED(status));
    }
    return 1;
}

int main(void)
{
    int status;
    // printf("\033[22;31m ============ MyShell =============\n");
    // printf("\033[22;31m || BCSE III Project             ||\n");
    // printf("\033[22;31m || Author: Prasenjit Kumar Shaw ||\n");
    // printf("\033[22;31m ==================================\n");
    // printf("\n");
    char *str;// = NULL;
    char **tokens;// = NULL;
    do
    {
        // printf("\033[22;32m> ");
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
