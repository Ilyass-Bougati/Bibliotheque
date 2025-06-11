#pragma once
#include "date.h"
#include "stdbool.h"
#include "penalite.h"
#include "emprunt.h"

#ifndef fichier_abonnements
    #define fichier_abonnements "data/abonnements"
#endif

// le type et l'etat d'un abonnement
typedef struct 
{
    char* intitule ;
    int id ;
} Type_abonnement , Etat_abonnement , Booleenne_abonnement;

// le tableau de l'abonnement
typedef struct Abonnement
{
    int id;
    int id_client;
    Type_abonnement *type_abonnement;
    Etat_abonnement *etat_abonnement;
    Date date_debut;

    // les emprunts
    Emprunt **emprunts;
    int nemprunts;

    // les penalites
    Penalite **penalites;
    int npenalites;
} Abonnement;

extern int last_abonnement_id;

/**
 * cette fonction transformera une chaîne en une structure Booleenne_abonnement
 * @param str la chaîne à convertir
 * @return renvoie NULL si le format n'est pas valide
 */
Booleenne_abonnement *string_to_BA(char *str); 

/**
 * Cette fonction transformera une structure en une chaîne de caractères à écrire dans un fichier
 * @param Booleenne_abonnement la structure à convertir
 * @return renvoie NULL en cas d'erreur
 */
char *BA_to_string(Booleenne_abonnement *abonnement);

/**
 * Cette fonction charge tous les types d'abonnements sur le fichier abonnement
 * @param length cette variable contient la taille de la table renvoyée
 */
Type_abonnement **load_type_abonnement(int *length);

/**
 * Cette fonction charge tous les etats d'abonnements sur le fichier abonnement
 * @param length cette variable contient la taille de la table renvoyée
 */
Etat_abonnement **load_etat_abonnement(int *length);

/**
 * cette fonction recherche une booleenne abonnement en utilisant son identifiant
 * @param BAs le tableau des booleennes abonnements
 * @param len la taille du tableau
 * @param id L'identifiant de l'abonnement que nous recherchons
 */
Booleenne_abonnement *get_BA_by_id(Booleenne_abonnement** BAs, int len, int id);

/**
 * Cette fonction enregistre tous les types d'abonnements sur le fichier abonnement
 * @param length cette variable contient la taille de la table renvoyée
 */
void save_type_abonnement(Type_abonnement** typesAbonnement , int *length);

/**
 * Cette fonction enregistre tous les etats d'abonnements sur le fichier abonnement
 * @param length cette variable contient la taille de la table renvoyée
 */
void save_etat_abonnement(Etat_abonnement** etatsAbonnement , int *length);



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

/**
 * Cette fonction enregistre tous les abonnements dans le fichier
 * @param abonnements Les abonnements à sauvegarder
 * @param number la taille du tableau abonnements
 */
void save_abonnements(Abonnement **abonnements, int number);

/**
 * cette fonction recherche un abonnement en utilisant son identifiant
 * @param abonnements le tableau des abonnements
 * @param len la taille du tableau
 * @param id L'identifiant de l'abonnement que nous recherchons
 */
Abonnement *get_abonnement_by_id(Abonnement** abonnements, int len, int id);

/**
 * cette fonction cree un abonnement et l'ajoute a la table
 * @param abonnements le tableau des abonnements
 * @param id_client l'id du client
 * @param type le type de l'abonnement
 * @param etat l'etat de l'abonnement
 * @param date la date de debut de l'abonnement
 * @param len la taille du tableau
 */
void add_abonnement(Abonnement** abonnements ,int id_client ,Type_abonnement type ,Date date ,int* len);