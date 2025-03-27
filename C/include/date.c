#include "stdio.h"
#include "stdlib.h"
#include "utils.h"
#include "string.h"
#include "date.h"

Date string_to_date(char *str)
{
    if(str == NULL)
    {
        goto inv_date;
    }

    char **splitted_str = split_2nd(str , "/") ;
    int i , j , m , a ;

    for(i = 0 ; splitted_str[i] != NULL ; i++)
    {
        printf("test %d\n" , i);
        int j;
        for(j = 0 ; splitted_str[i][j] != '\0' ; j++)
        {
            if(splitted_str[i][j] < '0' || splitted_str[i][j] > '9')
            {
                goto inv_date;
            }
        }
    }

    if(i != 3)
    {
        goto inv_date;
    }

    j = atoi(splitted_str[0]);
    m = atoi(splitted_str[1]);
    a = atoi(splitted_str[2]);

    if(j < 1 || m < 1 || a < 1)
    {
        goto inv_date;
    }


    if(m > 12 || m < 1)
    {
        goto inv_date;
    }

    int Mois[13] = {0 , 31 , 28 , 31 , 30 , 31 , 30 , 31 , 31 , 30 , 31 , 30 , 31} ;
    if(a % 100 == 0 || a % 4 == 0)
    {
        Mois[2]++;
    }

    if(j > Mois[m])
    {
        goto inv_date;
    }

    Date date;
    date.jour = j;
    date.mois = m;
    date.annee = a;

    return date;

    inv_date :
        fprintf(stderr , "La date n'est pas valide !");
        exit(1);
}

char *date_to_string(Date date)
{
    char *j = new_itoa(date.jour) , *m = new_itoa(date.mois) , *a = new_itoa(date.annee);
    int l1 = strlen(j) , l2 = strlen(m) , l3 = strlen(a);

    char* out = malloc((l1 + l2 + l3 + 2) * sizeof(char));

    out[0] = '\0';

    strcat(out , j);
    strcat(out , "/");

    strcat(out , m);
    strcat(out , "/");

    strcat(out , a);

    return out;
}