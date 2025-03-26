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

// le tableau de l'abonnement
typedef struct Abonnement
{
    int id;
    Type_abonnement type_abonnement;
    Date date_debut;
    bool etat_abonnement;

    // les emprunts
    Emprunt *emprunts;
    int nemprunts;
} Abonnement;

// cette variable contient le dernier identifiant abonnement généré
int last_abonnement_id = 0;

/**
 * cette fonction transformera une chaîne en une structure client
 * @param str la chaîne à convertir
 * @return renvoie NULL si le format n'est pas valide
 */
Client *string_to_abonnement(char *str);

/**
 * Cette fonction transformera une structure client en une chaîne de caractères à écrire dans un fichier
 * @param abonnement la structure client à convertir
 * @return renvoie NULL en cas d'erreur
 */
char *abonnement_to_string(Abonnement abonnement);
