#pragma once
#include "date.h"
#include "stdbool.h"

// le type d'un abonnement
typedef enum 
{
    etudiant,
    familly
} Type_abonnement;

// le tableau de l'abonnement
typedef struct Abonnement
{
    int id;
    Type_abonnement type_abonnement;
    Date date_debut;
    bool etat_abonnement;
} Abonnement;
