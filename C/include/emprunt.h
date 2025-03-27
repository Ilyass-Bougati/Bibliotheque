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


/**
 * Cette fonction transformera une chaîne en une structure emprunt
 * @param str la chaîne à convertir
 * @return renvoie NULL si le format n'est pas valide
 */
Emprunt *string_to_emprunt(char* str);


/**
 * Cette fonction transformera une structure emprunts en une chaîne de caractères à écrire dans un fichier
 * @param emp la structure emprunts à convertir
 * @return renvoie NULL en cas d'erreur
 */
char *emprunt_to_string(Emprunt *emp);


/**
 * Cette fonction charge tous les emprunts sur le fichier client
 * @param length cette variable contient la taille de la table renvoyée
 */
Emprunt **load_emprunts(int *length);
