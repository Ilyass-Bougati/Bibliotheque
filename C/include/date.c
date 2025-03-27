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

    int len ;
    char **splitted_str = split(str , '/' , &len) ;
    int i , j , m , a ;

    for(i = 0 ; i < len ; i++)
    {
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

    Date date = (Date){j , m , a};

    return date;

    inv_date :
        return BAD_DATE;
}


char *date_to_string(Date date)
{
    char *j = new_itoa(date.jour) , *m = new_itoa(date.mois) , *a = new_itoa(date.annee);
    int l1 = strlen(j) , l2 = strlen(m) , l3 = strlen(a);

    char* out = malloc((l1 + l2 + l3 + 3) * sizeof(char));

    out[0] = '\0';

    strcat(out , j);
    strcat(out , "/");

    strcat(out , m);
    strcat(out , "/");

    strcat(out , a);

    return out;
}


int datecmp(Date date1 , Date date2)
{
    int annee_diff , mois_diff , jour_diff;
    if((annee_diff = (date1.annee - date2.annee)))
    {
        return annee_diff > 0 ? 1 : -1 ;
    }
    else
    {
        if((mois_diff = (date1.mois - date2.mois)))
        {
            return mois_diff > 0 ? 1 : -1 ;
        }
        else
        {
            if((jour_diff = (date1.jour - date2.jour)))
            {
                return jour_diff > 0 ? 1 : -1 ;
            }
            return 0;
        }
    }
}