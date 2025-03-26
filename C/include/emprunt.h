#pragma once
#include "exemplaire.h"
#include "date.h"

typedef struct Emprunt
{
    int id;
    int id_abonnement;
    Date date_emprunt;
    Date date_retour;
    Exemplaire *exemplaire;
} Emprunt;
