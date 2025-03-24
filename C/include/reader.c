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

char *read_file(char *file_name)
{
    if(check_empty(trim(file_name)))
    {
        fprintf(stderr , "Nom du fichier invalide .\n");
        return NULL;
    }

    FILE* file_pointer = fopen(file_name , "r");
    if(file_pointer == NULL)
    {
        fprintf(stderr , "Fichier introuvable .\n");
        return NULL;
    }

    char c ;
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