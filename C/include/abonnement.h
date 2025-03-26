#pragma once
#include "client.h"
#include "date.h"

// le type d'un abonnement
enum Type_abonnement {
    etudiant,
    familly
};

// le tableau de l'abonnement
typedef struct Abonnement
{
    int id;
    Type_abonnement type_abonnement;
    Date date_debut;
    bool etat_abonnement;

    // l'utilisateur qui possède l'abonnement
    Client *client;
} Abonnement;
