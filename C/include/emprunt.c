#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "reader.h"
#include "date.h"
#include "utils.h"
#include "emprunt.h"

Emprunt *string_to_emprunt(char* str)
{
    if(str == NULL)
    {
        goto inv_emprunt;
    }
    int i;
    char** splitted_str = split(str , '#', &i);
    
    if(i != 5)
    {
        goto inv_emprunt;
    }

    Emprunt* emprunt = (Emprunt*) calloc(1, sizeof(Emprunt));

    emprunt->id             = atoi(splitted_str[0]);
    emprunt->id_abonnement  = atoi(splitted_str[1]);
    emprunt->id_exemplaire  = atoi(splitted_str[2]);
    emprunt->date_emprunt   = string_to_date(splitted_str[3]);
    emprunt->date_retour    = string_to_date(splitted_str[4]);
    
    char isValid = (emprunt->id > 0)
                    &&(emprunt->id_abonnement > 0)
                    &&(datecmp(emprunt->date_emprunt , BAD_DATE))
                    &&(datecmp(emprunt->date_retour , BAD_DATE))
                    &&(datecmp(emprunt->date_retour , emprunt->date_emprunt) > 0);

    if(!isValid)
    {
        goto inv_emprunt;
    }

    return emprunt;

    inv_emprunt :
        return NULL;
    
}

char *emprunt_to_string(Emprunt *emp)
{
    char 
        *str_id = new_itoa(emp->id),
        *str_id_exemplaire = new_itoa(emp->id_exemplaire),
        *str_id_abonnement = new_itoa(emp->id_abonnement),
        *str_date_emprunt = date_to_string(emp->date_emprunt) ,
        *str_date_retour = date_to_string(emp->date_retour);

    char* buffer = malloc(strlen(str_id)
                        + strlen(str_id_exemplaire)
                        + strlen(str_id_abonnement)
                        + strlen(str_date_emprunt)
                        + strlen(str_date_retour) + 4);

    buffer[0] = '\0';
    strcat(buffer , str_id);
    strcat(buffer , "#");

    strcat(buffer , str_id_exemplaire);
    strcat(buffer , "#");

    strcat(buffer , str_id_abonnement);
    strcat(buffer , "#");
    
    strcat(buffer , str_date_emprunt);
    strcat(buffer , "#");

    strcat(buffer , str_date_retour);

    return buffer;

}

Emprunt **load_emprunts(int *length)
{
    // the list of clients
    Emprunt **emprunts = (Emprunt **) calloc(1, sizeof(Emprunt *));
    *length = 0;

    char *file = read_file(fichier_emprunts);
    if (file == NULL)
    {
        return NULL;
    }

    int len;
    char **emprunt_strings = split(file, '\n', &len);
    for (int i = 0; i < len; i++)
    {
        Emprunt *emprunt = string_to_emprunt(emprunt_strings[i]);
        if (emprunt == NULL)
        {
            return NULL;
        }

        emprunts[(*length)++] = emprunt;
        emprunts = (Emprunt**) realloc(emprunts, (*length + 1) * sizeof(Emprunt*));
    }

    return emprunts;
}

Emprunt *get_emprunt_by_id(Emprunt** emprunts, int len, int id)
{
    for (int i = 0; i < len; i++)
    {
        if (emprunts[i]->id == id)
        {
            return emprunts[i];
        }
    }
    return NULL;
}

void save_emprunts(Emprunt **emprunts, int number)
{
    FILE *fptr = fopen(fichier_emprunts, "w");
    if (fptr == NULL)
    {
        printf("Erreur de lecture du fichier emprunts\n");
        return;
    }

    for (int i = 0; i < number - 1; i++)
    {
        fprintf(fptr, "%s\n", emprunt_to_string(emprunts[i]));
    }
    fprintf(fptr, "%s", emprunt_to_string(emprunts[number - 1]));
    fclose(fptr);
}