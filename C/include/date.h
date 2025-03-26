#pragma once

// cette structure détient la date
typedef struct Date
{
    int jour;
    int mois;
    int annee;
} Date;


/**
 * Cette fonction convertit une chaîne de caractères en date. La chaîne doit respecter le format 'jj/mm/aaaa'.
 * @param str la chaîne à convertir
 */
Date string_to_date(char *str);

/**
 * cette fonction transforme une structure de date en une chaîne suivant le format 'jj/mm/aaaa'
 * @param date la date à convertir
 */
char *date_to_string(Date date);