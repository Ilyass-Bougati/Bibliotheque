#include "stdio.h"
#include "stdlib.h"
#include "utils.h"

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

char *read_file(char *file_name)
{
    FILE* file_pointer = fopen(file_name , "r");
    if(file_pointer == NULL)
    {
        printf("Error opening the file");
        return NULL;
    }

    int c;
    int i = 0;
    char* file_content = malloc(sizeof(char));

    while((c = fgetc(file_pointer)) != EOF)
    {
        file_content[i++] = c;
        file_content = realloc(file_content , (i+1)*sizeof(char));
    }
    file_content[i] = '\0';

    return file_content;
}