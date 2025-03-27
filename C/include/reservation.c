#include "stdlib.h"
#include "stdio.h"
#include "utils.h"
#include "string.h"
#include "reader.h"
#include "date.h"
#include "reservation.h"


Reservation *string_to_reservation(char *str)
{
    // Splitting the string
    int length;
    char **split_string = split(str, delimiter, &length);

    if (!split_string)
    {
        printf("Erreur d'allocation de mémoire\n");
        return NULL;
    }

    // Vérification du nombre attendu de parties après split
    if (length != 3)
    {
        printf("Erreur de lecture du fichier Reservation\n");
        for (int i = 0; i < length; i++) free(split_string[i]); // Libération des chaînes
        free(split_string);
        return NULL;
    }

    // Allocation de la structure Reservation
    Reservation *reservation = (Reservation *)malloc(sizeof(Reservation));
    if (!reservation)
    {
        printf("Erreur d'allocation de mémoire\n");
        for (int i = 0; i < length; i++) free(split_string[i]); // Libération des chaînes
        free(split_string);
        return NULL;
    }

    // Conversion et affectation des valeurs
    reservation->id = atoi(split_string[0]);
    reservation->id_client = atoi(split_string[1]);
    reservation->date_reservation = string_to_date(split_string[2]);

    // Vérification de l'allocation de Date
    if (!datecmp(reservation->date_reservation , BAD_DATE))
    {
        printf("Erreur de conversion de la date\n");
        free(reservation);
        for (int i = 0; i < length; i++) free(split_string[i]); // Libération des chaînes
        free(split_string);
        return NULL;
    }

    // Libération des chaînes après utilisation
    for (int i = 0; i < length; i++) 
        free(split_string[i]);
    free(split_string);

    return reservation;
}


char *reservation_to_string(Reservation *reservation)
{
    if (!reservation || !datecmp(reservation->date_reservation , BAD_DATE)) return NULL;

    char id[10], id_client[10];
    sprintf(id, "%d", reservation->id);
    sprintf(id_client, "%d", reservation->id_client);

    // Obtenir la représentation de la date
    char *date_str = date_to_string(reservation->date_reservation);
    if (!date_str) return NULL;

    // Calculer la taille nécessaire
    int total_size = strlen(id) + strlen(id_client) + strlen(date_str) + 3 + 1; // 3x '#' + '\0'
    
    // Allouer le buffer
    char *buffer = (char *)calloc(total_size, sizeof(char));
    if (!buffer)
    {
        printf("Erreur d'allocation de mémoire\n");
        free(date_str);
        return NULL;
    }

    // Construire la chaîne avec `strcat()`
    strcpy(buffer, id);
    strcat(buffer, "#");
    strcat(buffer, id_client);
    strcat(buffer, "#");
    strcat(buffer, date_str);

    return buffer;
}


Reservation **load_reservations(int *length)
{
    Reservation **reservations = (Reservation **) malloc(sizeof(Reservation *));
    *length = 0;

    // Lecture du fichier qui contient les réservations
    char *file = read_file("reservations.txt"); 
    if (file == NULL)
    {
        printf("Erreur de lecture du fichier de réservations\n");
        return NULL;
    }

    int len;
    // Séparation du contenu du fichier en lignes
    char **reservation_strings = split(file, '\n', &len);

    for (int i = 0; i < len; i++)
    {
        // Conversion de la ligne en une structure Reservation
        Reservation *reservation = string_to_reservation(reservation_strings[i]);
        if (reservation == NULL)
        {
            printf("Erreur format de fichier pour la réservation à la ligne %d\n", i);
            return NULL;
        }

        reservations[(*length)++] = reservation;

        // Réallocation pour ajouter de nouvelles réservations
        reservations = (Reservation **) realloc(reservations, (*length + 1) * sizeof(Reservation *));
    }

    return reservations;
}
