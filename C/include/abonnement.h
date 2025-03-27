#pragma once
#include "date.h"
#include "stdbool.h"
#include "penalite.h"
#include "emprunt.h"

// le type d'un abonnement
typedef enum 
{
    etudiant,
    familly
} Type_abonnement;

// le type d'un abonnement
typedef enum 
{
    suspendue,
    actif
} Etat_abonnement;

// le tableau de l'abonnement
typedef struct Abonnement
{
    int id;
    int id_client;
    Type_abonnement type_abonnement;
    Etat_abonnement etat_abonnement;
    Date date_debut;

    // les emprunts
    Emprunt *emprunts;
    int nemprunts;
} Abonnement;

/**
 * cette fonction transformera une chaîne en une structure client
 * @param str la chaîne à convertir
 * @return renvoie NULL si le format n'est pas valide
 */
Abonnement *string_to_abonnement(char *str);

/**
 * Cette fonction transformera une structure client en une chaîne de caractères à écrire dans un fichier
 * @param abonnement la structure client à convertir
 * @return renvoie NULL en cas d'erreur
 */
char *abonnement_to_string(Abonnement *abonnement);

/**
 * Cette fonction charge tous les abonnements sur le fichier abonnement
 * @param length cette variable contient la taille de la table renvoyée
 */
Abonnement **load_abonnements(int *length);