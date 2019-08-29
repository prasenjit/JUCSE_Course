#include <stdio.h>

int main(void) {
    char *str = NULL;
    size_t bytes;
    getline(&str, &bytes, stdin);
    printf("str:%s\nbytes:%ld\n", str, bytes);
    return 0;
}