#pragma once

typedef enum Disponibilite
{
    disponible
} Disponibilite;

typedef struct Exemplaire
{
    int id;
    Disponibilite disponiblite;
    char *localisation;
    // add link to livre
} Exemplaire;
