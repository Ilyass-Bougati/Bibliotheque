#pragma once
#include "livre.h"

#ifndef ficher_exemplaires
    #define ficher_exemplaires "data/exemplaires"
#endif

typedef enum Disponibilite
{
    disponible
} Disponibilite;

typedef struct Exemplaire
{
    int id;
    Disponibilite disponiblite;
    char *localisation;

    // le livre
    int id_livre;
    Livre *livre;
} Exemplaire;


/**
 * Cette fonction transformera une chaîne en une structure exemplaire
 * @param str la chaîne à convertir
 * @return renvoie NULL si le format n'est pas valide
 */
Exemplaire *string_to_exemplaire(char *str);

/**
 * Cette fonction transformera une structure exemplaire en une chaîne de caractères à écrire dans un fichier
 * @param exemplaire la structure exemplaire à convertir
 * @return renvoie NULL en cas d'erreur
 */
char *exemplaire_to_string(Exemplaire *exemplaire);

/**
 * Cette fonction charge tous les exemplaires sur le fichier exemplaire
 * @param length cette variable contient la taille de la table renvoyée
 */
Exemplaire **load_exemplaires(int *length);

/**
 * Cette fonction enregistre tous les exemplaires dans le fichier
 * @param exemplaires Les exemplaires à sauvegarder
 * @param number la taille du tableau exemplaires
 */
void save_exemplaires(Exemplaire **exemplaires, int number);

