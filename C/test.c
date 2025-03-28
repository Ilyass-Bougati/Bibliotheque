#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <ctype.h>
#include "include/utils.h"

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
        if(i == 0)
            splitted_str[j] = malloc(sizeof(char));
        else
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

char* new_strrev(char* str)
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

char* new_itoa(int x)
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

    out = new_strrev(out);

    return out;
}

char **split(char *str, char d, int *length)
{
    *length = 0;
    int j = 0;
    char **table = (char **) malloc(sizeof(char*));
    char *word = (char *) malloc(sizeof(char));
    for (int i = 0; str[i] != '\0'; i++)
    {
        if (str[i] == d)
        {
            // adding the word to the list of words
            word[j] = '\0';
            table[(*length)++] = word;
            table = (char **) realloc(table, (*length + 1) * sizeof(char *));

            // starting the construction of a new word
            word = (char *) malloc(sizeof(char));
            j = 0;

        } else {
            // adding the character to the word buffer
            word[j++] = str[i];
            word = (char *) realloc(word, (j + 1) * sizeof(char));
        }
    }
    // adding the last word to the list of words
    word[j] = '\0';
    table[(*length)++] = word;

    return table;
}

#define BAD_DATE (Date){0 , 0 , 0}

typedef struct {
    int id;
    char *nom_langue;
} Langue;

typedef struct {
    int id;
    char *nom_auteur;
    char *prenom_auteur;
} Auteur;

typedef struct {
    int id;
    char *nom_categorie;
} Categorie;

typedef struct {
    int id;
    char *nom_editeur;
} Editeur;

typedef struct {
    int id;
    char *titre;
    char *isbn;
    
    Langue* langue;
    
    Auteur** auteurs;
    int nombreAuteurs;
    
    Categorie** categories;
    int nombreCategories;
    
    Editeur** editeurs;
    int nombreEditeurs;

} Livre;

typedef struct Date
{
    int jour;
    int mois;
    int annee;
} Date;

typedef struct Reservation
{
    int id;
    int id_client;
    Livre *livre;
    Date date_reservation;
} Reservation;

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
    if(annee_diff = (date1.annee - date2.annee))
    {
        return annee_diff > 0 ? 1 : -1 ;
    }
    else
    {
        if(mois_diff = (date1.mois - date2.mois))
        {
            return mois_diff > 0 ? 1 : -1 ;
        }
        else
        {
            if(jour_diff = (date1.jour - date2.jour))
            {
                return jour_diff > 0 ? 1 : -1 ;
            }
            return 0;
        }
    }
}


char* ftoa(float x)
{
    int integer_part = (int)x;
    x -= integer_part;
    
    while(x - (int)x != 0)
    {
        x *= 10;
    }

    char *int_str   = new_itoa(integer_part),
         *float_str = new_itoa((int)x)      ,
         *out       = malloc((strlen(int_str) + strlen(float_str) + 2)*sizeof(char));
        
    strcat(out , int_str);
    strcat(out , ".");
    strcat(out , float_str);

    return out;
}

int main()
{
	float x = 22.01;
	printf("%s" , ftoa(x));
	return 0;
}