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
    Database *db = (Database *) calloc(1, sizeof(Database));

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
    
            temp->notifications = (Notification**) realloc(temp->notifications, (temp->nnotifications + 1) * sizeof(Notification*));
            temp->notifications[(temp->nnotifications)++] = db->notifications[i];
        }
    } else {
        printf("Pas des notifications\n");
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
    
            temp->abonnements = (Abonnement**) realloc(temp->abonnements, (temp->nabonnements + 1) * sizeof(Abonnement*));
            temp->abonnements[(temp->nabonnements)++] = db->abonnements[i];
        }
    } else {
        printf("Pas de abonnements\n");
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
    
            temp->reservations = (Reservation**) realloc(temp->reservations, (temp->nreservations + 1) * sizeof(Reservation*));
            temp->reservations[(temp->nreservations)++] = db->reservations[i];
        }
    } else {
        printf("Pas de reservations\n");
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
    
            temp->reviews = (Review**) realloc(temp->reviews, (temp->nreviews + 1) * sizeof(Review*));
            temp->reviews[(temp->nreviews)++] = db->reviews[i];
        }
    } else {
        printf("Pas de reviews\n");
    }

    // loading the penalties
    db->penalites = load_penalite(&(db->npenalites));
    if (db->penalites != NULL)
    {
        for (int i = 0; i < db->npenalites; i++)
        {
            Abonnement *temp = get_abonnement_by_id(db->abonnements, db->nabonnements, db->penalites[i]->id_abonnement);
            if (temp == NULL)
            {
                printf("erreur d'integrite de la cle etrangere, l'ID abonnement dans la penalite n'existe pas dans la table abonnements");
                return NULL;
            }

            temp->penalites = (Penalite**) realloc(temp->penalites, (temp->npenalites + 1) * sizeof(Penalite*));        
            temp->penalites[(temp->npenalites)++] = db->penalites[i];
        }
    } else {
        printf("Pas de penalites\n");
    }

    // loading emprunts
    db->emprunts = load_emprunts(&(db->nemprunts));
    if (db->emprunts != NULL)
    {
        for (int i = 0; i < db->nemprunts; i++)
        {
            Abonnement *temp = get_abonnement_by_id(db->abonnements, db->nabonnements, db->emprunts[i]->id_abonnement);
            if (temp == NULL)
            {
                printf("erreur d'integrite de la cle etrangere, l'ID abonnement dans l'emprunt n'existe pas dans la table abonnements");
                return NULL;
            }

            temp->emprunts = (Emprunt**) realloc(temp->emprunts, (temp->nemprunts + 1) * sizeof(Emprunt*));        
            temp->emprunts[(temp->nemprunts)++] = db->emprunts[i];
        }

    } else {
        printf("Pas de emprunts\n");
    }


    return db;
}