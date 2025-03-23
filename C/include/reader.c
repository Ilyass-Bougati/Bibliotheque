#include "stdio.h"
#include "stdlib.h"

char *saisir_chaine()
{
    char *str = (char *) malloc(sizeof(char));
    int c, i = 0;
    while((c = getchar()) != '\n')
    {
        str[i++] = c;
        str = (char *) realloc(str, (i + 1) * sizeof(char));
    }
    str[i] = '\0';
    return str;
}