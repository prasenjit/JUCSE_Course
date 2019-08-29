#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

#define EXIT_FAILURE 1
#define EXIT_SUCCESS 0

char *readLine()
{
    char *str;
    size_t bytes;
    getline(&str, &bytes, stdin);
    //printf("Entered: %s\n", str);
    return str;
}

char **parseLine(char *str, int *n_token)
{
    *n_token = 0;
    char **result = malloc(((*n_token) + 1) * sizeof(char *));
    size_t n = strlen(str);
    int i, j;
    int start, end;
    start = 0;
    for (i = 0, j = 0; i < n && j < n; ++i)
    {
        start = i;
        for (j = i; j < n; ++j)
        {
            // printf("%c", str[j]);
            if (str[j] == ' ' || str[j] == '\n' || str[j] == '\0')
            {
                end = j;
                break;
            }
        }
        // printf("start: %d  end: %d\n", start, end);
        char *token = malloc(sizeof(char) * (end - start + 1));
        int k = 0;
        for (; start < end && str[start] != '\n'; ++k, ++start)
        {
            token[k] = str[start];
            // printf("  k=%d  start=%d  %c\n", k, start, str[start]);
        }
        token[k] = '\0';
        // printf("Token: %s\n", token);
        start = end;
        i = end;
        ++(*n_token);
        result[(*n_token) - 1] = token;
        result = realloc(result, ((*n_token) + 1) * sizeof(char *));
        result[(*n_token)] = NULL;
    }
    //result[(*n_token) - 1] = NULL;
    return result;
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
    printf("\033[22;31m ============ MyShell =============\n");
    printf("\033[22;31m || BCSE III Project             ||\n");
    printf("\033[22;31m || Author: Prasenjit Kumar Shaw ||\n");
    printf("\033[22;31m ==================================\n");
    do
    {
        printf("\033[22;32m> ");
        char *str = readLine();
        int n_token;
        char **tokens = parseLine(str, &n_token);
        int i;
        printf("\033[22;36mTokens:\n");
        for (i = 0; i < n_token; ++i)
        {
            printf("\033[22;35m%d: %s\n", i + 1, tokens[i]);
        }
        status = executeCommand(tokens, n_token);
        free(str);
        for (i = 0; i < n_token; ++i)
        {
            free(tokens[i]);
        }
        free(tokens);
    } while (status);

    return EXIT_SUCCESS;
}
