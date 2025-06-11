#include "abonnement.h"
#include "utils.h"
#include "stdlib.h"
#include "stdio.h"
#include "string.h"
#include "reader.h"
#include "database.h"


Abonnement *string_to_abonnement(char *str)
{
    // splitting the string
    int length;
    char **split_string = split(str, delimiter, &length);

    // checking if all the fields are present
    if (length != 5)
    {
        printf("Erreur de format d'abonnement");
        return NULL;
    }

    // parsign the string
    Abonnement *abonnement = (Abonnement *) calloc(1, sizeof(Abonnement));
    abonnement->id = atoi(split_string[0]);
    abonnement->id_client = atoi(split_string[1]);
    abonnement->type_abonnement = atoi(split_string[2]);
    abonnement->etat_abonnement = atoi(split_string[3]);
    abonnement->date_debut = string_to_date(split_string[4]);

    return abonnement;
}


char *abonnement_to_string(Abonnement *abonnement)
{
    char id[10];
    char client_id[10];
    char type[10];
    char etat[10];
    my_itoa(abonnement->id, id, 10);
	my_itoa(abonnement->id_client, client_id, 10);
	my_itoa(abonnement->type_abonnement, type, 10);
	my_itoa(abonnement->etat_abonnement, etat, 10);

    // the buffer
    // TODO : add type and etat
    char *buffer = (char *) calloc(2048, sizeof(char));
    strcat(buffer, id);
    strcat(buffer, "#");
    strcat(buffer, client_id);
    strcat(buffer, "#");
    strcat(buffer, type);
    strcat(buffer, "#");
    strcat(buffer, etat);
    strcat(buffer, "#");
    strcat(buffer, date_to_string(abonnement->date_debut));
    return buffer;
}



Abonnement **load_abonnements(int *length)
{
    // the list of clients
    Abonnement **abonnements = (Abonnement **) malloc(sizeof(Abonnement *));
    *length = 0;

    char *file = read_file(fichier_abonnements);
    if (file == NULL)
    {
        return NULL;
    }

    int len;
    char **abonnements_strings = split(file, '\n', &len);

    for (int i = 0; i < len; i++)
    {
        Abonnement *abonnement = string_to_abonnement(abonnements_strings[i]);
        if (abonnement == NULL)
        {
            return NULL;
        }

        abonnements[(*length)++] = abonnement;
        abonnements = (Abonnement**) realloc(abonnements, (*length + 1) * sizeof(Abonnement*));
    }

    return abonnements;
}

void save_abonnements(Abonnement **abonnements, int number)
{
    FILE *fptr = fopen(fichier_abonnements, "w");
    if (fptr == NULL)
    {
        return;
    }

    for (int i = 0; i < number - 1; i++)
    {
        fprintf(fptr, "%s\n", abonnement_to_string(abonnements[i]));
    }
    fprintf(fptr, "%s", abonnement_to_string(abonnements[number -1]));
    fclose(fptr);
}

Abonnement *get_abonnement_by_id(Abonnement** abonnements, int len, int id)
{
    for (int i = 0; i < len; i++)
    {
        if (abonnements[i]->id == id)
        {
            return abonnements[i];
        }
    }
    return NULL;
}

void add_abonnement(Database* db ,int id_client ,Type_abonnement* type ,Date date ,int* len)
{
    db->abonnements = (Abonnement**)realloc(db->abonnements , (++*len)*sizeof(Abonnement*));
    Abonnement* new = (Abonnement*)malloc(sizeof(Abonnement));
    *new = (Abonnement){.id= ++last_abonnement_id,
                        .id_client = id_client ,
                        .date_debut = date ,
                        .type_abonnement = type ,
                        .etat_abonnement = get_BA_by_id(db->EAs , db->nEa , 1) ,
                        .emprunts = (Emprunt**)malloc(sizeof(Emprunt*)),
                        .nemprunts = 0,
                        .penalites = (Penalite**)malloc(sizeof(Penalite*)),
                        .npenalites = 0
                        };
    db->abonnements[*len - 1] = new;
}