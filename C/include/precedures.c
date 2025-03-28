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

/**
 * Exemplaires :
 */

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
     db->emprunts[db->nemprunts - 1] = exemplaire;
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
     for(i = 0 ; i < db->exemplaires ; i++)
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