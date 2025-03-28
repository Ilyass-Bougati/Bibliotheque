#include "database.h"
#include "client.h"
#include "notification.h"
#include "abonnement.h"
#include "reservation.h"
#include "livre.h"
#include "review.h"
#include "penalite.h"
#include "emprunt.h"
#include "stdlib.h"
#include "stdio.h"


Database *load_db()
{
    Database *db = (Database *) malloc(sizeof(Database));

    // reading the clients
    db->clients       = load_clients(&(db->nclients));
    // reading notifications
    db->notifications = load_notifications(&(db->nnotifications));
    // checking if notification file is empty
    if (db->notifications != NULL)
    {
        for (int i = 0; i < db->nnotifications; i++)
        {
            Client * temp = get_client_by_id(db->clients, db->nclients, db->notifications[i]->id_client);
            if (temp == NULL)
            {
                printf("erreur d'integrite de la clé etrangere, l'ID client dans la notification n'existe pas dans la table client");
                return NULL;
            }
    
            temp->notifications = (Notification**) realloc(temp->notifications, (temp->nnotifications + 1) * sizeof(Notification));
            temp->notifications[(temp->nnotifications)++] = db->notifications[i];
        }
    }

    // reading the table abonnements
    db->abonnements   = load_abonnements(&(db->nabonnements));
    // checking if the abonnements file is empty
    if (db->abonnements != NULL)
    {
        for (int i = 0; i < db->nnotifications; i++)
        {
            Client * temp = get_client_by_id(db->clients, db->nclients, db->abonnements[i]->id_client);
            if (temp == NULL)
            {
                printf("erreur d'integrite de la cle etrangere, l'ID client dans la abonnements n'existe pas dans la table client");
                return NULL;
            }
    
            temp->abonnements = (Abonnement**) realloc(temp->abonnements, (temp->nabonnements + 1) * sizeof(Abonnement));
            temp->abonnements[(temp->nabonnements)++] = db->abonnements[i];
        }
    }

    // reading the table reservations
    db->reservations   = load_reservations(&(db->nreservations));
    // checking if the reservations file is empty
    if (db->reservations != NULL)
    {
        for (int i = 0; i < db->nreservations; i++)
        {
            Client * temp = get_client_by_id(db->clients, db->nclients, db->reservations[i]->id_client);
            if (temp == NULL)
            {
                printf("erreur d'integrite de la cle etrangere, l'ID client dans la reservations n'existe pas dans la table client");
                return NULL;
            }
    
            temp->reservations = (Reservation**) realloc(temp->reservations, (temp->nreservations + 1) * sizeof(Reservation));
            temp->reservations[(temp->nreservations)++] = db->reservations[i];
        }
    }

    // reading the table reviews
    db->reviews   = load_reviews(&(db->nreviews));
    // checking if the reviews file is empty
    if (db->reviews != NULL)
    {
        for (int i = 0; i < db->nreviews; i++)
        {
            Client * temp = get_client_by_id(db->clients, db->nclients, db->reviews[i]->id_client);
            if (temp == NULL)
            {
                printf("erreur d'integrite de la cle etrangere, l'ID client dans la reviews n'existe pas dans la table client");
                return NULL;
            }
    
            temp->reviews = (Review**) realloc(temp->reviews, (temp->nreviews + 1) * sizeof(Review));
            temp->reviews[(temp->nreviews)++] = db->reviews[i];
        }
    }

    return db;
}