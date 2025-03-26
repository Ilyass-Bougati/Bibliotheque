#pragma once
#include "exemplaire.h"
#include "date.h"

typedef struct Emprunt
{
    int id;
    Date date_emprunt;
    Date date_retour;
    Exemplaire *exemplaire;
} Emprunt;
