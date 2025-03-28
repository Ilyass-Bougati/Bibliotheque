#pragma once
#include "abonnement.h"
#include "notification.h"
#include "reservation.h"
#include "review.h"

#ifndef fichier_clients
    #define fichier_clients "data/clients"
#endif

// la table des clients
typedef struct Client
{
    int id;
    char *nom;
    char *prenom;
    char *CIN;
    char *email;
    char *phone_number;
    char *ville;

    // les abonnements
    Abonnement **abonnements;
    int nabonnements;

    // les notifications
    Notification **notifications;
    int nnotifications;

    // les resevations
    Reservation **reservations;
    int nreservations;

    // les avis
    Review **reviews;
    int nreviews;
} Client;

extern int last_client_id;

/**
 * Cette fonction transformera une chaîne en une structure client
 * @param str la chaîne à convertir
 * @return renvoie NULL si le format n'est pas valide
 */
Client *string_to_client(char *str);

/**
 * Cette fonction transformera une structure client en une chaîne de caractères à écrire dans un fichier
 * @param client la structure client à convertir
 * @return renvoie NULL en cas d'erreur
 */
char *client_to_string(Client *client);

/**
 * Cette fonction charge tous les clients sur le fichier client
 * @param length cette variable contient la taille de la table renvoyée
 */
Client **load_clients(int *length);

/**
 * Cette fonction enregistre tous les clients dans le fichier
 * @param clients Les clients à sauvegarder
 * @param number la taille du tableau clients
 */
void save_clients(Client **clients, int number);

/**
 * Cette fonction trouve un client par son identifiant
 * @param clients le tableau des clients
 * @param len la taille du tableau
 * @param id l'identifiant du client que nous recherchons
 * @return renvoie NULL si aucun client n'a été trouvé
 */
Client *get_client_by_id(Client** clients, int len, int id);