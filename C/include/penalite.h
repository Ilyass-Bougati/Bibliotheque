#pragma once
#include "date.h"


typedef enum 
{
    good
} Etat_penalite;

typedef struct Penalite
{
    int id;
    float montant;
    Etat_penalite etat_penalite;
    char *motif;
    Date date_penalite;
} Penalite;
