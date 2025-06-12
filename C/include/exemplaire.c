#include "exemplaire.h"
#include "utils.h"
#include "stdlib.h"
#include "stdio.h"
#include "reader.h"
#include "string.h"


Exemplaire *string_to_exemplaire(char *str)
{
    int length;
    char **split_string = split(str, delimiter, &length);

    // checking if all the fields are present
    if (length != 4)
    {
        return NULL;
    }

    // Creating the exemplaire
    Exemplaire *exemplaire   = (Exemplaire*) malloc(sizeof(Exemplaire));
    exemplaire->id           = atoi(split_string[0]);
    exemplaire->id_livre     = atoi(split_string[1]);
    exemplaire->disponiblite = atoi(split_string[2]);
    exemplaire->localisation = split_string[3];

    return exemplaire;
}

char *exemplaire_to_string(Exemplaire *exemplaire)
{
    char id[10] = {0}, id_livre[10] = {0}, disponible[10] = {0};
    my_itoa(exemplaire->id, id, 10);
    my_itoa(exemplaire->disponiblite, disponible, 10);
    my_itoa(exemplaire->id_livre, id_livre, 10);
    char *buffer = (char *) calloc(2048,  sizeof(char));
    strcat(buffer, id);
    strcat(buffer, "#");
    strcat(buffer, id_livre);
    strcat(buffer, "#");
    strcat(buffer, disponible);
    strcat(buffer, "#");
    strcat(buffer, exemplaire->localisation);

    return buffer;
}

Exemplaire **load_exemplaires(int *length)
{
    // the list of Exemplaires
    Exemplaire **exemplaires = (Exemplaire**) calloc(1, sizeof(Exemplaire *));
    *length = 0;

    char *file = read_file(fichier_exemplaires);
    if (file == NULL)
    {
        return NULL;
    }

    int len;
    char **exemplaire_strings = split(file, '\n', &len);

    for (int i = 0; i < len; i++)
    {
        Exemplaire *exemplaire = string_to_exemplaire(exemplaire_strings[i]);
        if (exemplaire == NULL)
        {
            return NULL;
        }

        exemplaires[(*length)++] = exemplaire;
        exemplaires = (Exemplaire**) realloc(exemplaires, (*length + 1) * sizeof(Exemplaire*));
    }

    return exemplaires;
}

void save_exemplaires(Exemplaire **exemplaires, int number)
{
    FILE *fptr = fopen(fichier_exemplaires, "w");
    if (fptr == NULL)
    {
        printf("Erreur de lecture du fichier exemplaire\n");
        return;
    }

    for (int i = 0; i < number - 1; i++)
    {
        fprintf(fptr, "%s\n", exemplaire_to_string(exemplaires[i]));
    }
    fprintf(fptr, "%s", exemplaire_to_string(exemplaires[number - 1]));
    fclose(fptr);
}


Exemplaire *get_exemplaire_by_id(Exemplaire** exemplaires, int len, int id)
{
    for (int i = 0; i < len; i++)
    {
        if (exemplaires[i]->id == id)
        {
            return exemplaires[i];
        }
    }
    return NULL;
}