#pragma once

/**
 * Cette fonction lit un fichier et renvoie son contenu sous forme de chaîne de caractères
 * @param file_name c'est le chemin vers le fichier
 * @return en cas d'erreur, cette fonction renvoie NULL
 */
char *read_file(char *file_name);

/**
 * cette fonction saisir une chaîne de caractères de l'utilisateur
 */
char *saisir_chaine();