#include <stdio.h>
#include "utils.h"

int main() {
    printf("=== Tests de la fonction trim ===\n");
    
    char str1[] = "  Bonjour  ";
    printf("Original: '%s', ", str1);
    printf("Après trim: '%s'\n", trim(str1));
    
    char str2[] = "Salut";
    printf("Original: '%s', ", str2);
    printf("Après trim: '%s'\n", trim(str2));
    
    char str3[] = "    ";
    printf("Original: '%s', ", str3);
    printf("Après trim: '%s'\n", trim(str3));
    
    char str4[] = "";
    printf("Original: '%s', ", str4);
    printf("Après trim: '%s'\n", trim(str4));
    
    printf("\n=== Tests de la fonction check_isbn ===\n");
    
    char isbn1[] = "0-306-40615-2";
    printf("ISBN '%s' est ", isbn1);
    printf("%s\n", check_isbn(isbn1) ? "valide" : "invalide");
    
    char isbn2[] = "0-306-40615-X";
    printf("ISBN '%s' est ", isbn2);
    printf("%s\n", check_isbn(isbn2) ? "valide" : "invalide");
    
    char isbn3[] = "978-3-16-148410-0";
    printf("ISBN '%s' est ", isbn3);
    printf("%s\n", check_isbn(isbn3) ? "valide" : "invalide");
    
    char isbn4[] = "978-3-16-148410-1";
    printf("ISBN '%s' est ", isbn4);
    printf("%s\n", check_isbn(isbn4) ? "valide" : "invalide");
    
    char isbn5[] = "  978-3-16-148410-0  ";
    printf("ISBN '%s' est ", isbn5);
    printf("%s\n", check_isbn(isbn5) ? "valide" : "invalide");
    
    return 0;
}