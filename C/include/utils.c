#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include "utils.h"
#include "stdbool.h"

void my_itoa(int origin, char *destination, int size) 
{
    int i;
    // this is unsafe
    char *des = new_itoa(origin);

    for (i = 0; des[i] != '\0'; i++)
    {
        destination[i] = des[i];
    }
    des[i] = '\0';
}


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