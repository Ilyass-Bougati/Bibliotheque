#include "client.h"
#include "stdlib.h"
#include "stdio.h"
#include "utils.h"
#include "string.h"
#include "reader.h"


Client *string_to_client(char *str)
{
    // splitting the string
    int length;
    char **split_string = split(str, delimiter, &length);

    // checking if all the fields are present
    if (length != 7)
    {
        return NULL;
    }

    // TODO add checks for email and phone number

    // parsing the string to client
    Client *client       = (Client *) malloc(sizeof(Client));
    client->id           = atoi(split_string[0]);
    client->nom          = split_string[1];
    client->prenom       = split_string[2];
    client->CIN          = split_string[3];
    client->email        = split_string[4];
    client->phone_number = split_string[5];
    client->ville        = split_string[6];

    return client;
}


char *client_to_string(Client *client)
{
    // this is the buffer used to store the string
    char *buffer = (char *) calloc(2048, sizeof(char));
    char id[10];
	my_itoa(client->id, id, 10);
    strcpy(buffer, id);
    strcat(buffer, "#");
    strcat(buffer, client->nom);
    strcat(buffer, "#");
    strcat(buffer, client->prenom);
    strcat(buffer, "#");
    strcat(buffer, client->CIN);
    strcat(buffer, "#");
    strcat(buffer, client->email);
    strcat(buffer, "#");
    strcat(buffer, client->phone_number);
    strcat(buffer, "#");
    strcat(buffer, client->ville);
    return buffer;
}

Client **load_clients(int *length)
{
    // the list of clients
    Client **clients = (Client **) calloc(1, sizeof(Client *));
    *length = 0;

    char *file = read_file(fichier_clients);
    if (file == NULL)
    {
        return NULL;
    }

    int len;
    char **client_strings = split(file, '\n', &len);

    for (int i = 0; i < len; i++)
    {
        Client *client = string_to_client(client_strings[i]);
        if (client == NULL)
        {
            return NULL;
        }

        clients[(*length)++] = client;
        clients = (Client**) realloc(clients, (*length + 1) * sizeof(Client*));
    }

    return clients;
}



void save_clients(Client **clients, int number)
{
    FILE *fptr = fopen(fichier_clients, "w");
    if (fptr == NULL)
    {
        printf("Erreur de lecture du fichier client\n");
        return;
    }

    for (int i = 0; i < number-1; i++)
    {
        fprintf(fptr, "%s\n", client_to_string(clients[i]));
    }
    fprintf(fptr, "%s", client_to_string(clients[number-1]));
    fclose(fptr);
}


Client *get_client_by_id(Client** clients, int len, int id)
{
    for (int i = 0; i < len; i++)
    {
        if (clients[i]->id == id)
        {
            return clients[i];
        }
    }
    return NULL;
}