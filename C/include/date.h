#pragma once

// cette date va servir de flag a retourner en cas de mauvaise entree de date
#define BAD_DATE (Date){0 , 0 , 0}

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


/**
 * cette fonction compare deux date
 * @param date1 la premiere date
 * @param date2 la deuxieme date
 * @return 1 si la premiere date est superieure
 * @return 0 si les dates sont egales
 * @return -1 si la deuxieme date est superieure
 */
int datecmp(Date date1 , Date date2);