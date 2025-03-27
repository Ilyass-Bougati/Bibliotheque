#include <string.h>
#include <stdio.h>
#include <stdbool.h>
#include "stdlib.h"
#include <ctype.h>

typedef struct Date
{
    int jour;
    int mois;
    int annee;
} Date;

#define delimiter '#'


/**
 * cette fonction coupe une chaîne de caractères à partir d'espaces à gauche et à droite
 * @param str la chaîne de caractères à couper
 */
char *trim(char *str);

/**
 * cette fonction coupe une chaîne de caractères selon un delimiteur predefini
 * @param str la chaîne de caractères à couper
 * @param del le delimiteur
 */
char **split_2nd(char *str , char *del);

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

bool check_empty(char *str)
{
    str = trim(str);
    if (str == NULL)
    {
        return false;
    } 
    else 
    {
        return str[0] == '\0';
    }
}


char *trim(char *str)
{
    if (str == NULL)
    {
        return NULL;
    }

    if (str[0] == '\0')
    {
        return str;
    }

    char *start = str;
    while (*start != '\0' && isspace(*start))
    {
        start++;
    }

    if (*start == '\0')
    {
        *str = '\0';
        return str;
    }

    char *end = start + strlen(start) - 1;
    while (end > start && isspace(*end))
    {
        end--;
    }

    end[1] = '\0';

    if (start == str)
    {
        return str;
    }

    memmove(str, start, (end - start + 2) * sizeof(char));

    return str;
}


char **split_2nd(char *str , char *del)
{
    char** splitted_str = malloc(sizeof(char*));
    int i , j = 0 , k = 0, l = strlen(str) , m;
    /**
     * i : index for str
     * j : 1st index for splitted_str
     * k : 2nd index for splitted_str
     * m : index for del
     */
    for(i = 0 ; i < l ; i++)
    {
        splitted_str[j] = realloc(splitted_str[j] , (k+1) * sizeof(char));
        if(str[i] == del[0])
        {
            m = 0 ;
            while(str[i+m] == del[m])
            {
                m++;
            }
            if(del[m] == '\0')
            {
                splitted_str[j++][k] = '\0';
                splitted_str = realloc(splitted_str , (j+1) * sizeof(char*));
                i += m-1 ;
                k = 0;
            }
            else{
                splitted_str[j][k++] = str[i];
            }
        }
        else{
            splitted_str[j][k++] = str[i];
        }
    }
    splitted_str[j] = realloc(splitted_str[j] , (k+1) * sizeof(char));
    splitted_str[j++][k] = '\0';

    splitted_str = realloc(splitted_str , (j+1) * sizeof(char*));
    splitted_str[j] = NULL;

    return splitted_str ;
}

void removeChar(char *str, char ch)
{
    int i, j = 0;
    for (i = 0; str[i] != '\0'; i++) 
    {
        if (str[i] != ch) 
        {
            str[j++] = str[i];
        }
    }
    str[j] = '\0';
}


bool check_isbn(char *str)
{

    if (check_empty(str))
    {
        return false;
    }

    char *isbn_copy = malloc(strlen(str) + 1);
    if (isbn_copy == NULL)
    {
        printf("allocation failed !!");
        return false;
    }
    strcpy(isbn_copy, str);

    char *trimmed_isbn = trim(isbn_copy);

    if (check_empty(trimmed_isbn)) {
        free(isbn_copy);
        return false;
    }

    removeChar(trimmed_isbn, '-');

    if (strlen(trimmed_isbn) == 10)
    {
        int sum = 0;
        for (int i = 0; i < 10; i++)
        {
            if (trimmed_isbn[i] == 'X' && i == 9)
            {
                sum += 10 * (10 - i);
            }
            else if (isdigit(trimmed_isbn[i]))
            {
                sum += (trimmed_isbn[i] - '0') * (10 - i);
            }
            else
            {   
                free(isbn_copy);
                return false;
            }
        }
        free(isbn_copy);
        return (sum % 11 == 0);
    }
    else if (strlen(trimmed_isbn) == 13)
    {
        int sum = 0;
        for (int i = 0; i < 13; i++)
        {
            if (!isdigit(trimmed_isbn[i]))
            {
                free(isbn_copy);
                return false;
            }

            int digit = trimmed_isbn[i] - '0';
            sum += (i % 2 == 0) ? digit : digit * 3;
        }
        free(isbn_copy);
        return (sum % 10 == 0);
    }
    else
    {
        free(isbn_copy);
        return false;
    } 
}


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

char* strrev(char* str)
{
    int l = strlen(str);
    char* strreved = malloc((l+1) * sizeof(char));
    int i ;
    for(i = 0 ; i < l ; i++)
    {
        strreved[l-1-i] = str[i];
    }

    strreved[l] = '\0';
    return strreved;
}

char* itoa(int x)
{
    bool isNegative = x < 0 ? true : false ;
    int i = 0 ;
    char* out = malloc(sizeof(char));

    while(x != 0)
    {
        out[i++] = x%10 + '0';
        out = realloc(out , (i+1) * sizeof(char));
        x /= 10;
    }
    if(isNegative)
    {
        out[i++] = '-';
        out = realloc(out , (i+1)*sizeof(char));
    }

    out[i] = '\0';

    out = strrev(out);

    return out;

}

char *date_to_string(Date date)
{
    char *j = itoa(date.jour) , *m = itoa(date.mois) , *a = itoa(date.annee);
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


int main()
{
    Date d ;
    d.jour = 24 ;
    d.mois = 2 ;
    d.annee = 2005 ;

    char* date = date_to_string(d);

    printf("%s\n%s/%s/%s" ,date,itoa(d.jour),itoa(d.mois),itoa(d.annee));
}