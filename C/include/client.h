#pragma once
#include "abonnement.h"
#include "notification.h"

#ifndef ficher_clients
    #define ficher_clients "data/clients"
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
    Abonnement *abonnements;
    int nabonnements;

    // les notifications
    Notification *notifications;
    int nnotifications;
} Client;

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