#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "date.h"
#include "utils.h"
#include "penalite.h"
#include "reader.h"

Penalite *string_to_penalite(char* str)
{
    if(str == NULL)
    {
        return NULL;
    }

    int len ;
    char** splitted_str = split(str , '#' , &len);
    
    if(len != 6)
    {
        return NULL;
    }

    Penalite *penalite = (Penalite*) calloc(1, sizeof(Penalite));

    penalite->id            = atoi(splitted_str[0]);
    penalite->id_abonnement = atoi(splitted_str[1]);
    penalite->montant       = atof(splitted_str[2]);
    penalite->etat_penalite = atoi(splitted_str[3]) <= good && atoi(splitted_str[3]) >= bad ? atoi(splitted_str[3]) : none;
    penalite->motif         = splitted_str[4];
    penalite->date_penalite = string_to_date(splitted_str[5]);

    
    char isValid =    (penalite->id > 0)
                    &&(penalite->id_abonnement > 0)
                    &&(penalite->montant > 0)
                    &&(penalite->etat_penalite != none)
                    &&(penalite->motif != NULL)
                    &&(datecmp(penalite->date_penalite,BAD_DATE));

    if(!isValid)
    {
        return NULL;
    }

    return penalite;
}


char *penalite_to_string(Penalite *pen)
{
    char 
    *str_id = new_itoa(pen->id),
    *str_id_abonnement = new_itoa(pen->id_abonnement),
    *str_date_penalite = date_to_string(pen->date_penalite),
    *str_montant       = ftoa(pen->montant),
    *str_motif         = malloc((2048 + 1)*sizeof(char)),
    *str_etat          = new_itoa(pen->etat_penalite);

    strncpy(str_motif , pen->motif , 2048);

    char* buffer = malloc(strlen(str_id)
                        + strlen(str_id_abonnement)
                        + strlen(str_date_penalite)
                        + strlen(str_montant) 
                        + 2048
                        + strlen(str_etat) + 6);

    strcat(buffer , str_id);
    strcat(buffer , "#");

    strcat(buffer , str_id_abonnement);
    strcat(buffer , "#");
    
    strcat(buffer , str_date_penalite);
    strcat(buffer , "#");

    strcat(buffer , str_montant);
    strcat(buffer , "#");

    strcat(buffer , str_motif);
    strcat(buffer , "#");

    strcat(buffer , str_etat);

    return buffer;
}


Penalite **load_penalite(int *length)
{
    int size , i ;
    char *file = read_file(fichier_penalites) , **splitted_file = split(file , '\n', &size);

    *length = size;
    
    Penalite** penalites = malloc(size * sizeof(Penalite*));

    for(i = 0 ; i < size ; i++)
    {
        penalites[i] = string_to_penalite(splitted_file[i]);
    }

    return penalites;
}


Penalite *get_penalite_by_id(Penalite** penalites, int len, int id)
{
    for (int i = 0; i < len; i++)
    {
        if (penalites[i]->id == id)
        {
            return penalites[i];
        }
    }
    return NULL;
}

void save_penalites(Penalite **penalites, int number)
{
    FILE *fptr = fopen(fichier_penalites, "w");
    if (fptr == NULL)
    {
        printf("Erreur de lecture du fichier penalites\n");
        return;
    }

    for (int i = 0; i < number; i++)
    {
        fprintf(fptr, "%s\n", penalite_to_string(penalites[i]));
    }
    fclose(fptr);
}

