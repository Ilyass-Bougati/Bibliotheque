#include "review.h"
#include "stdlib.h"
#include "stdio.h"
#include "utils.h"
#include "string.h"
#include "reader.h"

Review *string_to_review(char *str)
{
	
    // splitting the string
    int length;
    char **split_string = split(str, delimiter, &length);

    if (!split_string)
    {
        printf("Erreur d allocation de memoire\n");
        return NULL;
    }
    
	// Vérification du nombre attendu de parties après split
    if (length != 3)
    {
        return NULL;
    }

    // Allocation de la structure Review
    Review *review = (Review *) calloc(1, sizeof(Review));
    if(!review)
    {
    	printf("Erreur d'allocation de mémoire\n");
        free(split_string[0]);
        free(split_string[1]);
        free(split_string);
	}
	// Conversion et affectation des valeurs
    review->id        = atoi(split_string[0]);
    review->id_client = atoi(split_string[1]);
    review->review	  = atoi(split_string[2]);
    // Libération des chaînes après utilisation
    free(split_string[0]);
    free(split_string[1]);
    free(split_string);
    return review;
}
char *review_to_string(Review *review)
{

    char id_client[10], id[10], review_str[10];
    my_itoa(review->id_client, id_client, 10);
    my_itoa(review->id, id, 10);
    my_itoa(review->review, review_str, 10);

    int total_size = strlen(id_client)  + strlen(review_str) + 2; // +1 pour '#' et +1 le '\0'
    char *buffer = (char *)calloc(total_size, sizeof(char));
    if (!buffer)
    {
        printf("Erreur d allocationd de memoire\n");
        return NULL;
    }
    
    // Formater la chaîne de caractères dans le buffer
    strcpy(buffer, id);
    strcat(buffer,"#");
    strcpy(buffer, id_client);
    strcat(buffer,"#");
    strcat(buffer, review_str);
    return buffer;
}

Review **load_reviews(int *length)
{
	Review **Reviews = (Review **)malloc(sizeof(Review));
	*length = 0;
	char *file = read_file(fichier_reviews);
	if (file == NULL)
    {
        return NULL;
    }
	int len;
    char **review_strings = split(file, '\n', &len);
	for (int i = 0; i < len; i++)
    {
        Review *review = string_to_review(review_strings[i]);
        if (review == NULL)
        {
            return NULL;
        }

        Reviews[(*length)++] = review;
        Reviews = (Review**) realloc(Reviews, (*length + 1) * sizeof(Review*));
    }

    return Reviews;
}


void save_reviews(Review **reviews, int number)
{
    FILE *fptr = fopen(fichier_reviews, "w");
    if (fptr == NULL)
    {
        printf("Erreur de lecture du fichier reviews\n");
        return;
    }

    for (int i = 0; i < number - 1; i++)
    {
        fprintf(fptr, "%s\n", review_to_string(reviews[i]));
    }
    fprintf(fptr, "%s", review_to_string(reviews[number - 1]));
    fclose(fptr);
}