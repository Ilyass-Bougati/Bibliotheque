#pragma once
#include "livre.h"
#include "date.h"

#ifndef fichier_reservations
    #define fichier_reservations "data/reservations"
#endif

typedef struct Reservation
{
    int id;
    int id_client;
    Livre *livre;
    Date date_reservation;
} Reservation;


/**
 * Cette fonction transformera une chaîne en une structure reservation
 * @param str la chaîne à convertir
 * @return renvoie NULL si le format n'est pas valide
 */
Reservation *string_to_reservation(char *str);

/**
 * Cette fonction transformera une structure reservation en une chaîne de caractères à écrire dans un fichier
 * @param reservation la structure reservation à convertir
 * @return renvoie NULL en cas d'erreur
 */
char *reservation_to_string(Reservation *reservation);

/**
 * Cette fonction charge tous les reservations sur le fichier reservation
 * @param length cette variable contient la taille de la table renvoyée
 */
Reservation **load_reservations(int *length);

/**
 * Cette fonction enregistre tous les reservations dans le fichier
 * @param reservations Les reservations à sauvegarder
 * @param number la taille du tableau reservations
 */
void save_reservations(Reservation **reservations, int number);