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

int last_client_id = 0;
int last_notification_id = 0;
int last_abonnement_id = 0;
int last_penalite_id = 0;
int last_emprunt_id = 0;
int last_reservation_id = 0;


Database *load_db()
{
    Database *db = (Database *) calloc(1, sizeof(Database));

    // reading the clients
    db->clients       = load_clients(&(db->nclients));
    if (db->clients == NULL)
    {
        printf("Pas des clients\n");
    }
    // reading notifications
    db->notifications = load_notifications(&(db->nnotifications));
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
        for (int i = 0; i < db->nabonnements; i++)
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

    // loading les exemplaires
    db->exemplaires = load_exemplaires(&(db->nexemplaires));

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

            // linking with exemplaires
            Exemplaire *exmp = get_exemplaire_by_id(db->exemplaires, db->nexemplaires, db->emprunts[i]->id_exemplaire);
            if (temp == NULL)
            {
                printf("erreur d'integrite de la cle etrangere, l'ID exemplaire dans l'emprunt n'existe pas dans la table exemplaires");
                return NULL;
            }
            db->emprunts[i]->exemplaire = exmp;
        }

    } else {
        printf("Pas de emprunts\n");
    }

    // loading les langues, categories, editeurs and auteurs
    db->langues    = load_langues(fichier_langues, &(db->nlangues));
    if (db->langues == NULL)
    {
        printf("Pas des langues\n");
    }

    db->editeurs   = load_editeurs(fichier_editeurs, &(db->nediteurs));
    if (db->editeurs == NULL)
    {
        printf("Pas des editeurs\n");
    }

    db->categories = load_categories(fichier_categories, &(db->ncategories));
    if (db->categories == NULL)
    {
        printf("Pas des categories\n");
    }

    db->auteurs    = load_auteurs(fichier_auteurs, &(db->nauteurs));
    if (db->auteurs == NULL)
    {
        printf("Pas des auteurs\n");
    }

    // loading livres
    db->livres = load_livres(
        fichier_livres,
        db->langues,
        db->auteurs,
        db->categories,
        db->editeurs,
        &(db->nlivres)
    );
    if (db->livres == NULL)
    {
        printf("Pas des livres\n");
    }

    // setting the last ids
    // this shouldn't be here, but it's too late to change each function on its own
    last_client_id = db->clients[db->nclients - 1]->id;
    last_notification_id = db->notifications[db->nnotifications - 1]->id;
    last_abonnement_id = db->abonnements[db->nabonnements - 1]->id;
    last_penalite_id = db->penalites[db->npenalites - 1]->id;
    last_emprunt_id = db->emprunts[db->nemprunts - 1]->id;
    last_reservation_id = db->reservations[db->nreservations - 1]->id;

    return db;
}


void commit(Database *db)
{
    save_clients(db->clients, db->nclients);
    save_abonnements(db->abonnements, db->nabonnements);
    save_notifications(db->notifications, db->nnotifications);
    save_emprunts(db->emprunts, db->nemprunts);
    save_penalites(db->penalites, db->npenalites);
    save_exemplaires(db->exemplaires, db->nexemplaires);
    save_reservations(db->reservations, db->nreservations);
    save_reviews(db->reviews, db->nreviews);
    save_livres(fichier_livres, db->livres, db->nlivres);
    save_categories(fichier_categories, db->categories, db->ncategories);
    save_langues(fichier_langues, db->langues, db->nlangues);
    save_editeurs(fichier_editeurs, db->editeurs, db->nediteurs);
    save_auteurs(fichier_auteurs, db->auteurs, db->nauteurs);
}