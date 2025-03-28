#pragma once
#include "date.h"

#ifndef fichier_penalites
    #define fichier_penalites "data/penalites"
#endif

typedef enum 
{
    bad  = 0,
    good = 1,
    none = -1
} Etat_penalite;

typedef struct Penalite
{
    int id;
    int id_abonnement;
    float montant;
    Etat_penalite etat_penalite;
    char *motif;
    Date date_penalite;
} Penalite;

extern int last_penalite_id;

/**
 * Cette fonction transformera une chaîne en une structure penalite
 * @param str la chaîne à convertir
 * @return renvoie NULL si le format n'est pas valide
 */
Penalite *string_to_penalite(char* str);


/**
 * Cette fonction transformera une structure penalite en une chaîne de caractères à écrire dans un fichier
 * @param emp la structure emprunts à convertir
 * @return renvoie NULL en cas d'erreur
 */
char *penalite_to_string(Penalite *emp);


/**
 * Cette fonction charge toutes les penalite sur le fichier penalite
 * @param length cette variable contient la taille de la table renvoyée
 */
Penalite **load_penalite(int *length);

/**
 * Cette fonction recupere une penalite depuis un tableau a partir de son id
 * @param penalite Le tableau des penalite
 * @param len La taille du tableau
 * @param id L'identifiant a rechercher
 */
Penalite *get_penalite_by_id(Penalite** penalites, int len, int id);

/**
 * Cette fonction sauveguarde un tableau de penalites dans le fichier approprie
 * @param penalites Le tableau des penalites
 * @param number la taille du tableau
 */
void save_penalites(Penalite **penalites, int number);

