#pragma once
#include <stdbool.h>

// c'est le délimiteur qui sépare les champs lors de la conversion de chaînes en structures
#define delimiter      '#'
#define date_delimiter '/'

/**
 * cette fonction coupe une chaîne de caractères à partir d'espaces à gauche et à droite
 * @param str la chaîne de caractères à couper
 */
char *trim(char *str);


/**
 * cette fonction vérifie si une chaîne de caractères est vide ou remplie d'espaces
 * @param str la chaîne de caractères à vérifier
 */
bool check_empty(char *str);

/**
 * cette fonction vérifie si un isbn est valide
 * @param str la chaîne de caractères à vérifier
 */
bool check_isbn(char *str);

/**
 * cette fonction renverse une chaine de caracteres
 * @param str la chaîne de caractères à renverser
 */
char* new_strrev(char* str);

/**
 * cette fonction transforme un reel en une chaine de caracteres
 * @param x le reel a changer
 */
char* ftoa(float x);


/**
 * cette fonction transforme un entier en une chaine de caracteres
 * @param x l'entier a changer
 */
char* new_itoa(int x);

/**
 * Cette fonction divise une chaîne de caractères par un délimiteur
 * @param str la chaîne à diviser
 * @param d Le délimiteur
 * @param length l'adresse où stocker la taille de la table résultante
 */
char **split(char *str, char d, int *length);
