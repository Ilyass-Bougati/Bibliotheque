#include "abonnement.h"
#include "utils.h"
#include "stdlib.h"
#include "stdio.h"
#include "string.h"

// cette variable contient le dernier identifiant abonnement généré
int last_abonnement_id = 0;


Abonnement *string_to_abonnement(char *str)
{
    // splitting the string
    int length;
    char **split_string = split(str, delimiter, &length);

    // checking if all the fields are present
    if (length != 5)
    {
        printf("Erreur de lecture du fichier abonnement");
        return NULL;
    }

    // parsign the string
    Abonnement *abonnement = (Abonnement *) malloc(sizeof(Abonnement));
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
    itoa(abonnement->id, id, 10);
	itoa(abonnement->id_client, client_id, 10);
	itoa(abonnement->type_abonnement, type, 10);
	itoa(abonnement->etat_abonnement, etat, 10);

    // the buffer
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