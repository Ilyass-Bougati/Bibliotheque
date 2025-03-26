#pragma once
#include "abonnement.h"
#include "notification.h"

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

// cette variable contient le dernier identifiant client généré
int last_client_id = 0;

/**
 * cette fonction transformera une chaîne en une structure client
 * @param str la chaîne à convertir
 * @return renvoie NULL si le format n'est pas valide
 */
Client *string_to_client(char *str);

/**
 * Cette fonction transformera une structure client en une chaîne de caractères à écrire dans un fichier
 * @param client la structure client à convertir
 * @return renvoie NULL en cas d'erreur
 */
char *client_to_string(Client client);