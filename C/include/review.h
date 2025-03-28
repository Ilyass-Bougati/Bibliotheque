#pragma once
#include "livre.h"

#ifndef fichier_reviews
    #define fichier_reviews "data/reviews"
#endif

typedef struct Review
{
    int id_client;
    Livre *livre;
    int review;
} Review;


/**
 * Cette fonction transformera une chaîne en une structure review
 * @param str la chaîne à convertir
 * @return renvoie NULL si le format n'est pas valide
 */
Review *string_to_review(char *str);

/**
 * Cette fonction transformera une structure review en une chaîne de caractères à écrire dans un fichier
 * @param review la structure review à convertir
 * @return renvoie NULL en cas d'erreur
 */
char *review_to_string(Review *review);

/**
 * Cette fonction charge tous les reviews sur le fichier review
 * @param length cette variable contient la taille de la table renvoyée
 */
Review **load_reviews(int *length);

/**
 * Cette fonction enregistre tous les reviews dans le fichier
 * @param reviews Les reviews à sauvegarder
 * @param number la taille du tableau reviews
 */
void save_reviews(Review **reviews, int number);