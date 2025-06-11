#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "database.h"
#include "exemplaire.h"
#include "emprunt.h"
#include "penalite.h"
#include "abonnement.h"
#include "precedures.h"
#include "utils.h"

/**
 * Exemplaires :
 */
int last_exemplaire_id = 0;

 void insere_exemplaire(Database *db, Exemplaire *exemplaire)
 {
     if(db->exemplaires == NULL)
     {
         db->exemplaires = (Exemplaire**)malloc(sizeof(Exemplaire*));
         last_exemplaire_id = 0;
     }
     else if(last_exemplaire_id == -1)
     {
        last_exemplaire_id  = db->exemplaires[db->nexemplaires]->id;
     }
 
     db->exemplaires = (Exemplaire**)realloc(db->exemplaires , (db->nexemplaires++ +1) * sizeof(Exemplaire*));
     
     exemplaire->id = ++last_exemplaire_id;
     db->exemplaires[db->nemprunts - 1] = exemplaire;
 }
 
 void supprime_exemplaire(Database *db, int id)
 {
     if(id <= 0)
     {
         printf("Identifiant invalide !\n");
         return;
     }
     
     bool found = false;
     int i;
     for(i = 0 ; i < db->nexemplaires ; i++)
     {
         if(db->exemplaires[i]->id == id)
         {
             found = true;
             int j ;
             for(j = i ; j < db->nexemplaires - 1 ; j++)
             {
                 db->exemplaires[j] = db->exemplaires[j+1];
             }
             break;
         }
     }
     if(!found)
     {
         printf("Aucun exemplaire a cet identifiant !\n");
         return;
     }
     db->exemplaires = (Exemplaire**)realloc(db->exemplaires , (db->nexemplaires-- -1)*sizeof(Exemplaire*));
 }
 
 void modifie_exemplaire(Database *db, int id, Exemplaire *new_exemplaire)
 {
     if(id <= 0)
     {
         printf("Identifiant invalide !\n");
         return;
     }
     
     int i;
     for(i = 0 ; i < db->nexemplaires ; i++)
     {
         if(db->exemplaires[i]->id == id)
         {
             db->exemplaires[i] = new_exemplaire;
             return;
         }
     }
 
     printf("Aucun exemplaire a cet identifiant !\n");
 }
 

/**
 * Emprunts :
 */

void insere_emprunt(Database *db, Emprunt *emprunt)
{
    if(db->emprunts == NULL)
    {
        db->emprunts = (Emprunt**)malloc(sizeof(Emprunt*));
        last_emprunt_id = 0;
    }
    else if(last_emprunt_id == -1)
    {
        last_emprunt_id  = db->emprunts[db->nemprunts]->id;
    }

    db->emprunts = (Emprunt**)realloc(db->emprunts , (db->nemprunts++ +1) * sizeof(Emprunt*));
    
    emprunt->id = ++last_emprunt_id;
    db->emprunts[db->nemprunts - 1] = emprunt;
}

void supprime_emprunt(Database *db, int id)
{
    if(id <= 0)
    {
        printf("Identifiant invalide !\n");
        return;
    }
    
    bool found = false;
    int i;
    for(i = 0 ; i < db->nemprunts ; i++)
    {
        if(db->emprunts[i]->id == id)
        {
            found = true;
            int j ;
            for(j = i ; j < db->nemprunts - 1 ; j++)
            {
                db->emprunts[j] = db->emprunts[j+1];
            }
            break;
        }
    }
    if(!found)
    {
        printf("Aucun emprunt a cet identifiant !\n");
        return;
    }
    db->emprunts = (Emprunt**)realloc(db->emprunts , (db->nemprunts-- -1)*sizeof(Emprunt*));
}

void modifie_emprunt(Database *db, int id, Emprunt *new_emprunt)
{
    if(id <= 0)
    {
        printf("Identifiant invalide !\n");
        return;
    }
    
    int i;
    for(i = 0 ; i < db->nemprunts ; i++)
    {
        if(db->emprunts[i]->id == id)
        {
            db->emprunts[i] = new_emprunt;
            return;
        }
    }

    printf("Aucun emprunt a cet identifiant !\n");
}

/**
 * Penalites :
 */

void insere_penalite(Database *db, Penalite *penalite)
{
    if(db->penalites == NULL)
    {
        db->penalites = (Penalite**)malloc(sizeof(Penalite*));
        last_penalite_id = 0;
    }
    else if(last_penalite_id == -1)
    {
        last_penalite_id  = db->penalites[db->npenalites]->id;
    }

    db->penalites = (Penalite**)realloc(db->penalites , (db->npenalites++ +1) * sizeof(Penalite*));
    
    penalite->id = ++last_penalite_id;
    db->penalites[db->npenalites - 1] = penalite;
}

void supprime_penalite(Database *db, int id)
{
    if(id <= 0)
    {
        printf("Identifiant invalide !\n");
        return;
    }
    
    bool found = false;
    int i;
    for(i = 0 ; i < db->npenalites ; i++)
    {
        if(db->penalites[i]->id == id)
        {
            found = true;
            int j ;
            for(j = i ; j < db->npenalites - 1 ; j++)
            {
                db->penalites[j] = db->penalites[j+1];
            }
            break;
        }
    }
    if(!found)
    {
        printf("Aucune penalite a cet identifiant !\n");
        return;
    }
    db->penalites = (Penalite**)realloc(db->penalites , (db->npenalites-- -1)*sizeof(Penalite*));
}

void modifie_penalite(Database *db, int id, Penalite *new_penalite)
{
    if(id <= 0)
    {
        printf("Identifiant invalide !\n");
        return;
    }
    
    int i;
    for(i = 0 ; i < db->npenalites ; i++)
    {
        if(db->penalites[i]->id == id)
        {
            db->penalites[i] = new_penalite;
            return;
        }
    }

    printf("Aucune penalite a cet identifiant !\n");
}


/**
 * Abonnements :
 */

 void insere_abonnement(Database *db, Abonnement *abonnement)
 {
     if(db->abonnements == NULL)
     {
         db->abonnements = (Abonnement**)malloc(sizeof(Abonnement*));
         last_abonnement_id = 0;
     }
     else if(last_abonnement_id == -1)
     {
        last_abonnement_id  = db->abonnements[db->nabonnements]->id;
     }
 
     db->abonnements = (Abonnement**)realloc(db->abonnements , (db->nabonnements++ +1) * sizeof(Abonnement*));
     
     abonnement->id = ++last_abonnement_id;
     db->abonnements[db->nabonnements - 1] = abonnement;
 }
 
 void supprime_abonnement(Database *db, int id)
 {
     if(id <= 0)
     {
         printf("Identifiant invalide !\n");
         return;
     }
     
     bool found = false;
     int i;
     for(i = 0 ; i < db->nabonnements ; i++)
     {
         if(db->abonnements[i]->id == id)
         {
             found = true;
             int j ;
             for(j = i ; j < db->nabonnements - 1 ; j++)
             {
                 db->abonnements[j] = db->abonnements[j+1];
             }
             break;
         }
     }
     if(!found)
     {
         printf("Aucun abonnement a cet identifiant !\n");
         return;
     }
     db->abonnements = (Abonnement**)realloc(db->abonnements , (db->nabonnements-- -1)*sizeof(Penalite*));
 }
 
 void modifie_abonnement(Database *db, int id, Abonnement *new_abonnement)
 {
     if(id <= 0)
     {
         printf("Identifiant invalide !\n");
         return;
     }
     
     int i;
     for(i = 0 ; i < db->nabonnements ; i++)
     {
         if(db->abonnements[i]->id == id)
         {
             db->abonnements[i] = new_abonnement;
             return;
         }
     }
 
     printf("Aucun abonnement a cet identifiant !\n");
 }

 void insere_client(Database *db, Client *client)
{
	
	db->clients = (Client **)realloc(db->clients, (db->nclients + 1)*sizeof(Client*));
	db->clients[db->nclients] = client;
	db->nclients ++;
	last_client_id ++;
	
}
void supprime_client(Database *db, int id)
{
	int i, j;
	for(i = 0; i < db->nclients ; i++)
	{
		if(db->clients[i]->id == id)
		{
			
			for(j = i ; j < db->nclients - 1; j++)
			{
				db->clients[j] = db->clients[j+1];
			}
			db->nclients--;
			db->clients = (Client **)realloc(db->clients, (db->nclients)*sizeof(Client*));
			if(db->nclients == 0)
				db->clients = NULL;
			return;	
		}
	}
	printf("\nLe client n existe pas dans la table des clients\n");
}
void modifie_client(Database *db, int id, Client *new_client)
{
	int i;
	for(i = 0; i < db->nclients ; i++)
	{
		if(db->clients[i]->id == id)
		{
			db->clients[i] = new_client;
			return ;
		}
	}
	printf("\nLe client n existe pas dans la table des clients\n");
}


void insere_notification(Database *db, Notification *notification)
{
	
    Client * temp = get_client_by_id(db->clients, db->nclients, notification->id_client);
    if (temp == NULL)
    {
        printf("erreur d'integrite de la clé etrangere, l'ID client dans la notification n'existe pas dans la table client");
        return;
    }
    
    temp->notifications = (Notification**) realloc(temp->notifications, (temp->nnotifications + 1) * sizeof(Notification*));
    for(int i = 0; i < temp->nnotifications ; i++)
    {
    	if(temp->notifications[i]->id == notification->id)
    		temp->notifications[(temp->nnotifications)++] = db->notifications[i];
	}
    
    db->notifications = (Notification **)realloc(db->notifications, (db->nnotifications + 1)*sizeof(Notification*));
	db->notifications[db->nnotifications] = notification;
	db->nnotifications ++;
    
   
}
void supprime_notification(Database *db, int id)
{
	int i;
	for(i = 0; i < db->nnotifications ; i++)
	{
		if(db->notifications[i]->id == id)
		{
			
			Client * temp = get_client_by_id(db->clients, db->nclients, db->notifications[i]->id_client);
			
			for(int k = 0 ; k < temp->nnotifications ; k++)
			{
				if(id == temp->notifications[k]->id )
				{
					
					
					for(int j = k ; j < temp->nnotifications - 1; j++)
					{
						temp->notifications[j] = temp->notifications[j+1];
					}	
					
				}
				
				
			}
			temp->nnotifications--;
			temp->notifications = (Notification **)realloc(temp->notifications, (temp->nnotifications)*sizeof(Notification*));
			
			for(int j = i ; j < db->nnotifications - 1 ; j++)
			{
				db->notifications[j] = db->notifications[j+1];
			}
			db->nnotifications--;
			db->notifications = (Notification **)realloc(db->notifications, (db->nnotifications)*sizeof(Notification*));
			if(db->nnotifications == 0)
				db->notifications = NULL;
			return;	
		}
	}
	
}
void modifie_notification(Database *db, int id, Notification *new_notification)
{
	int i, k;
	for(i = 0; i < db->nnotifications ; i++)
	{
		if(db->notifications[i]->id == id)
		{
			Client * temp = get_client_by_id(db->clients, db->nclients, db->notifications[i]->id_client);
			if (temp == NULL)
            {
                printf("erreur d'integrite de la clé etrangere, l'ID client dans la notification n'existe pas dans la table client");
                return;
            }
			
			for(k = 0 ; k < temp->nnotifications ; k++)
			{
				if(id == temp->notifications[k]->id )
				{
					temp->notifications[k] = new_notification;
				}
			}
			db->notifications[i] = new_notification;
			return ;
		}
	}
	printf("\n la notification n existe pas dans la table des notifications\n");
}

void insere_reservation(Database *db, Reservation *reservation)
{
	
    Client * temp = get_client_by_id(db->clients, db->nclients, reservation->id_client);
    if (temp == NULL)
    {
        printf("erreur d'integrite de la clé etrangere, l'ID client dans la reservation n'existe pas dans la table client");
        return;
    }
    
    temp->reservations = (Reservation**) realloc(temp->reservations, (temp->nreservations + 1) * sizeof(Reservation*));
    for(int i = 0; i < temp->nreservations ; i++)
    {
      if(temp->reservations[i]->id == reservation->id)
        temp->reservations[(temp->nreservations)++] = db->reservations[i];
  }
    
    db->reservations = (Reservation **)realloc(db->reservations, (db->nreservations + 1)*sizeof(Reservation*));
	db->reservations[db->nreservations] = reservation;
	db->nreservations ++;

}

void supprime_reservation(Database *db, int id)
{
	int i;
	for(i = 0; i < db->nreservations ; i++)
	{
		if(db->reservations[i]->id == id)
		{
			
			Client * temp = get_client_by_id(db->clients, db->nclients, db->reservations[i]->id_client);
			
			for(int k = 0 ; k < temp->nreservations ; k++)
			{
				if(id == temp->reservations[k]->id )
				{
					
					
					for(int j = k ; j < temp->nreservations - 1; j++)
					{
						temp->reservations[j] = temp->reservations[j+1];
					}	
					
				}
				
				
			}
			temp->nreservations--;
			temp->reservations = (Reservation **)realloc(temp->reservations, (temp->nreservations)*sizeof(Reservation*));
			
			for(int j = i ; j < db->nreservations - 1 ; j++)
			{
				db->reservations[j] = db->reservations[j+1];
			}
			db->nreservations--;
			db->reservations = (Reservation **)realloc(db->reservations, (db->nreservations)*sizeof(Reservation*));
			if(db->nreservations == 0)
				db->reservations = NULL;
			return;	
		}
	}
	
}

void modifie_reservation(Database *db, int id, Reservation *new_reservation)
{
	int i;
	for(i = 0; i < db->nreservations ; i++)
	{
		if(db->reservations[i]->id == id)
		{
			db->reservations[i] = new_reservation;
			return ;
		}
	}
	printf("\nLe client n existe pas dans la table des clients\n");
}

void insere_review(Database *db, Review *review)
{
	Client * temp = get_client_by_id(db->clients, db->nclients, review->id_client);
    if (temp == NULL)
    {
        printf("erreur d'integrite de la clé etrangere, l'ID client dans la notification n'existe pas dans la table client");
        return;
    }
    
    temp->reviews = (Review**) realloc(temp->reviews, (temp->nreviews + 1) * sizeof(Review*));
    for(int i = 0; i < temp->nreviews ; i++)
    {
    	if(temp->reviews[i]->id == review->id)
    		temp->reviews[(temp->nreviews)++] = db->reviews[i];
	}
    
    temp->reviews = (Review **)realloc(db->reviews, (db->nreviews + 1)*sizeof(Review*));
	db->reviews[db->nreviews] = review;
	db->nreviews ++;
}

void supprime_review(Database *db, int id)
{
	int i;
	for(i = 0; i < db->nreviews ; i++)
	{
		if(db->reviews[i]->id == id)
		{
			
			Client * temp = get_client_by_id(db->clients, db->nclients, db->reviews[i]->id_client);
			
			for(int k = 0 ; k < temp->nreviews ; k++)
			{
				if(id == temp->reviews[k]->id )
				{
					
					
					for(int j = k ; j < temp->nreviews - 1; j++)
					{
						temp->reviews[j] = temp->reviews[j+1];
					}	
					
				}
				
				
			}
			temp->nreviews--;
			temp->reviews = (Review **)realloc(temp->reviews, (temp->nreviews)*sizeof(Review*));
			
			for(int j = i ; j < db->nreviews - 1 ; j++)
			{
				db->reviews[j] = db->reviews[j+1];
			}
			db->nreviews--;
			db->reviews = (Review **)realloc(db->reviews, (db->nreviews)*sizeof(Review*));
			if(db->nreviews == 0)
				db->reviews = NULL;
			return;	
		}
	}
	
}

void modifie_review(Database *db, int id, Review *new_review)
{
	int i, k;
	for(i = 0; i < db->nreviews ; i++)
	{
		if(db->reviews[i]->id == id)
		{
			Client * temp = get_client_by_id(db->clients, db->nclients, db->reviews[i]->id_client);
			if (temp == NULL)
            {
                printf("erreur d'integrite de la clé etrangere, l'ID client dans la notification n'existe pas dans la table client");
                return;
            }
			
			for(k = 0 ; k < temp->nreviews ; k++)
			{
				if(id == temp->reviews[k]->id )
				{
					temp->reviews[k] = new_review;
				}
			}
			db->reviews[i] = new_review;
			return ;
		}
	}
	printf("\n la notification n existe pas dans la table des notifications\n");
}

void select_all(Database *db)
{
    // affcher les clients
    Client **clients = db->clients;

    for(int i = 0 ; i < 20 ; i++)
        printf("-");
    printf("Table des clients :\n");

    for (int i = 0; i < db->nclients; i++) 
    {
        Client *c = clients[i];
        printf(
            "%d, %s, %s, %s, %s, %s\n", 
            c->id, 
            c->email,
            c->CIN,
            c->nom,
            c->prenom,
            c->phone_number
        );
    }

    for(int i = 0 ; i < 20 ; i++)
            printf("-");
        printf("Table des abonnements :\n");

    Abonnement **abonnements = db->abonnements;

    for(int i = 0 ; i < db->nabonnements ; i++)
    {
        Abonnement *a = abonnements[i];
        int size ;
        char** splitted = split(abonnement_to_string(a) , '#' , &size);
        for(int j = 0 ; j < size ; j++)
        {
            printf("%s ", splitted[j]);
        }
        printf("\n");
    }


    for(int i = 0 ; i < 20 ; i++)
        printf("-");
    printf("Table des emprunts :\n");

    Emprunt **emprunts = db->emprunts;

    for(int i = 0 ; i < db->nemprunts ; i++)
    {
        Emprunt *e = emprunts[i];
        int size ;
        char** splitted = split(emprunt_to_string(e) , '#' , &size);
        for(int j = 0 ; j < size ; j++)
        {
            printf("%s ", splitted[j]);
        }
        printf("\n");
    }

    for(int i = 0 ; i < 20 ; i++)
        printf("-");
    printf("Table des exemplaires :\n");

    Exemplaire **exemplaires = db->exemplaires;

    for(int i = 0 ; i < db->nemprunts ; i++)
    {
        Exemplaire *e = exemplaires[i];
        int size ;
        char** splitted = split(exemplaire_to_string(e) , '#' , &size);
        for(int j = 0 ; j < size ; j++)
        {
            printf("%s ", splitted[j]);
        }
        printf("\n");
    }

    for(int i = 0 ; i < 20 ; i++)
        printf("-");
    printf("Table des livres :\n");

    Livre **livres = db->livres;

    for(int i = 0 ; i < db->nlivres ; i++)
    {
        Livre *l = livres[i];
        int size ;
        char** splitted = split(livre_to_string(*l) , '#' , &size);
        for(int j = 0 ; j < size ; j++)
        {
            printf("%s ", splitted[j]);
        }
        printf("\n");
    }

    for(int i = 0 ; i < 20 ; i++)
        printf("-");
    printf("Table des categories :\n");

    Categorie **categories = db->categories;
    
    for(int i = 0 ; i < db->ncategories ; i++)
    {
        Categorie *c = categories[i];
        int size ;
        char** splitted = split(categorie_to_string(c) , '#' , &size);
        for(int j = 0 ; j < size ; j++)
        {
            printf("%s ", splitted[j]);
        }
        printf("\n");
    }

    for(int i = 0 ; i < 20 ; i++)
        printf("-");
    printf("Table des langues :\n");

    Langue **langues = db->langues;

    for(int i = 0 ; i < db->nlangues ; i++)
    {
        Langue *l = langues[i];
        int size ;
        char** splitted = split(langue_to_string(l) , '#' , &size);
        for(int j = 0 ; j < size ; j++)
        {
            printf("%s ", splitted[j]);
        }
        printf("\n");
    }

    for(int i = 0 ; i < 20 ; i++)
        printf("-");
    printf("Table des penalites :\n");

    Penalite **penalite = db->penalites;

    for(int i = 0 ; i < db->npenalites ; i++)
    {
        Penalite *p = penalite[i];
        int size ;
        char** splitted = split(penalite_to_string(p) , '#' , &size);
        for(int j = 0 ; j < size ; j++)
        {
            printf("%s ", splitted[j]);
        }
        printf("\n");
    }

    for(int i = 0 ; i < 20 ; i++)
        printf("-");
    printf("Table des notifications :\n");

    Notification **notifications = db->notifications;

    for(int i = 0 ; i < db->nnotifications ; i++)
    {
        Notification *n = notifications[i];
        int size ;
        char** splitted = split(notification_to_string(n) , '#' , &size);
        for(int j = 0 ; j < size ; j++)
        {
            printf("%s ", splitted[j]);
        }
        printf("\n");
    }

    for(int i = 0 ; i < 20 ; i++)
        printf("-");
    printf("Table des reservations :\n");
    
    Reservation **reservations = db->reservations;

    for(int i = 0 ; i < db->nreservations ; i++)
    {
        Reservation *r = reservations[i];
        int size ;
        char** splitted = split(reservation_to_string(r) , '#' , &size);
        for(int j = 0 ; j < size ; j++)
        {
            printf("%s ", splitted[j]);
        }
        printf("\n");
    }

    for(int i = 0 ; i < 20 ; i++)
        printf("-");
    printf("Table des reviews :\n");

    Review **reviews = db->reviews;

    for(int i = 0 ; i < db->nreviews ; i++)
    {
        Review *r = reviews[i];
        int size ;
        char** splitted = split(review_to_string(r) , '#' , &size);
        for(int j = 0 ; j < size ; j++)
        {
            printf("%s ", splitted[j]);
        }
        printf("\n");
    }
}