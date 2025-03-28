#pragma once
#include "client.h"
#include "notification.h"
#include "abonnement.h"
#include "reservation.h"
#include "livre.h"
#include "review.h"
#include "penalite.h"
#include "emprunt.h"

typedef struct Database
{
    Client       **clients;
    Notification **notifications;
    Abonnement   **abonnements;
    Reservation  **reservations;
    Penalite     **penalites;
    Review       **reviews;
    Livre        **livres;
    Categorie    **categories;
    Langue       **langues;
    Auteur       **auteurs;
    Editeur      **editeurs;
    Emprunt      **emprunts;
    Exemplaire   **exemplaires;

    // Ces variables contiennent la taille de chaque table
    int nclients;
    int nnotifications;
    int nabonnements;
    int nreservations;
    int npenalites;
    int nreviews;
    int nlivres;
    int ncategories;
    int nlangues;
    int nauteurs;
    int nediteurs;
    int nemprunts;
    int nexemplaires;
} Database;


/**
 * Cette fonction charge la base de données entière
 */
Database *load_db();