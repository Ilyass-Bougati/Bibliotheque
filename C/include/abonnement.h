#pragma once
#include "client.h"
#include "date.h"

// le type d'un abonnement
enum type_abonnement {
    etudiant,
    familly
};

// le tableau de l'abonnement
typedef struct
{
    int id;
    type_abonnement type_abonnement;
    date date_debut;
    bool etat_abonnement;

    // l'utilisateur qui possède l'abonnement
    client *client;
} abonnement;
