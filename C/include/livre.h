#pragma once

typedef struct Livre
{
    /* data */
} Livre;

// cette variable contient le dernier identifiant livre généré
int last_livre_id = 0;

/**
 * cette fonction transformera une chaîne en une structure livre
 * @param str la chaîne à convertir
 * @return renvoie NULL si le format n'est pas valide
 */
Livre *string_to_livre(char *str);

/**
 * Cette fonction transformera une structure livre en une chaîne de caractères à écrire dans un fichier
 * @param livre la structure livre à convertir
 * @return renvoie NULL en cas d'erreur
 */
char *livre_to_string(Livre livre);