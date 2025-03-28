#pragma once
#include "exemplaire.h"
#include "date.h"

#ifndef fichier_emprunts
    #define fichier_emprunts "data/emprunts"
#endif

typedef struct Emprunt
{
    int id;
    int id_abonnement;
    Date date_emprunt;
    Date date_retour;
    int id_exemplaire;
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

/**
 * Cette fonction recupere un emprunt depuis un tableau a partir de son id
 * @param emprunts Le tableau des emprunts
 * @param len La taille du tableau
 * @param id L'identifiant a rechercher
 */
Emprunt *get_emprunt_by_id(Emprunt** emprunts, int len, int id);

/**
 * Cette fonction sauveguarde un tableau d'emprunts dans le fichier approprie
 * @param emprunts Le tableau des emprunts
 * @param number la taille du tableau
 */
void save_emprunts(Emprunt **emprunts, int number);
