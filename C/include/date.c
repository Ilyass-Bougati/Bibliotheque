#include "date.h"
#include "utils.h"
#include "string.h"
#include "stdlib.h"
#include "stdio.h"


Date string_to_date(char *str)
{
    int len;
    char **date_strings = split(str, '-', &len);
    if (len != 3)
    {
        printf("%s\n", str);
        printf("Erreur de format de date");
        Date d = {0};
        return d;
    }

    int jours  = atoi(date_strings[0]);
    int mois   = atoi(date_strings[1]);
    int annees = atoi(date_strings[2]);

    // TODO add checks to make sure that the date is correct

    Date d = {
        .jour = jours,
        .mois = mois,
        .annee = annees
    };

    return d;
}


char *date_to_string(Date date)
{
    // this is the buffer used to store the string
    char *buffer = (char *) calloc(11, sizeof(char));
    char jours[3];
    char mois[3];
    char annee[5];
	itoa(date.jour, jours, 10);
	itoa(date.mois, mois, 10);
	itoa(date.annee, annee, 10);
    strcat(buffer, jours);
    strcat(buffer, "-");
    strcat(buffer, mois);
    strcat(buffer, "-");
    strcat(buffer, annee);
    return buffer;
}