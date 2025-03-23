#include <string.h>
#include <ctype.h>
#include "utils.h"
#include "stdbool.h"

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


void removeChar(char *str, char ch) // i need this function in the check_isbn function to clean the isbn for hyphens
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
    char *isbn = trim(str);

    if (check_empty(isbn) || isbn == NULL)
    {
        return false;
    }

    removeChar(isbn, '-');

    if (strlen(isbn) == 10)
    {
        int sum = 0;
        for (int i = 0; i < 10; i++)
        {
            if (isbn[i] == 'X' && i == 9)
            {
                sum += 10 * (i + 1);
            }
            else if (isdigit(isbn[i]))
            {
                sum += (isbn[i] - '0') * (i + 1);
            }
            else
            {
                return false;
            }
        }
        return (sum % 11 == 0);
    }
    else if (strlen(isbn) == 13)
    {
        int sum = 0;
        for (int i = 0; i < 13; i++)
        {
            if (!isdigit(isbn[i]))
            {
                return false;
            }

            int digit = isbn[i] - '0';
            sum += (i % 2 == 0) ? digit : digit * 3;
        }
        return (sum % 10 == 0);
    }
    else return false;
}