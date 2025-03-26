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

