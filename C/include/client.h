#pragma once
#include "abonnement.h"
#include "notification.h"

typedef struct {
    int id;
    char *nom;
    char *prenom;
    char *CIN;
    char *email;
    char *phone_number;
    char *ville;

    // les abonnements
    abonnement *abonnements;
    int nabonnements;

    // les notifications
    notification *notifications;
    int nnotifications;
} client;

