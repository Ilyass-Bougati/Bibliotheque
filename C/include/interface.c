#include "interface.h"
#include "reader.h"

void afficher_les_noms_des_tables()
{
    printf("1 )- Clients \n");
    printf("2 )- Notifications \n");
    printf("3 )- Abonnements \n");
    printf("4 )- Reservations \n");
    printf("5 )- Penalites \n");
    printf("6 )- Reviews \n");
    printf("7 )- Livres \n");
    printf("8 )- Categories \n");
    printf("9 )- Langues \n");
    printf("10)- Auteurs \n");
    printf("11)- Editeurs \n");
    printf("12)- Emprunts \n");
    printf("13)- Exemplaires \n");
}

void afficher_clients(Database *db)
{
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
}

void afficher_client_par_id(Database *db , int id)
{
    Client **clients = db->clients;

    for (int i = 0; i < db->nclients; i++) 
    {
        Client *c = clients[i];
        if(c->id == id)
        {
            printf(
                "%d, %s, %s, %s, %s, %s\n", 
                c->id, 
                c->email,
                c->CIN,
                c->nom,
                c->prenom,
                c->phone_number
            );
            break;
        }
    }
}

void afficher_abonnements(Database *db)
{
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
}

void afficher_abonnements_par_id(Database *db , int id)
{
    Abonnement **abonnements = db->abonnements;

    for(int i = 0 ; i < db->nabonnements ; i++)
    {
        Abonnement *a = abonnements[i];
        if(a->id == id)
        {
            int size ;
            char** splitted = split(abonnement_to_string(a) , '#' , &size);
            for(int j = 0 ; j < size ; j++)
            {
                printf("%s ", splitted[j]);
            }
            printf("\n");
            break;
        }
    }
}

void afficher_emprunts(Database *db)
{
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
}

void afficher_emprunts_par_id(Database *db , int id)
{
    Emprunt **emprunts = db->emprunts;

    for(int i = 0 ; i < db->nemprunts ; i++)
    {
        Emprunt *e = emprunts[i];
        if(e->id == id)
        {
            int size ;
            char** splitted = split(emprunt_to_string(e) , '#' , &size);
            for(int j = 0 ; j < size ; j++)
            {
                printf("%s ", splitted[j]);
            }
            printf("\n");
            break;
        }
    }
}

void afficher_exemplaires(Database *db)
{
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
}

void afficher_exemplaires_par_id(Database *db , int id)
{
    Exemplaire **exemplaires = db->exemplaires;

    for(int i = 0 ; i < db->nemprunts ; i++)
    {
        Exemplaire *e = exemplaires[i];
        if(e->id == id)
        {   
            int size ;
            char** splitted = split(exemplaire_to_string(e) , '#' , &size);
            for(int j = 0 ; j < size ; j++)
            {
                printf("%s ", splitted[j]);
            }
            printf("\n");
            break;
        }
    }
}

void afficher_livres(Database *db)
{
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
}

void afficher_livres_par_id(Database *db , int id)
{
    Livre **livres = db->livres;

    for(int i = 0 ; i < db->nlivres ; i++)
    {
        Livre *l = livres[i];
        if(l->id == id)
        {
            int size ;
            char** splitted = split(livre_to_string(*l) , '#' , &size);
            for(int j = 0 ; j < size ; j++)
            {
                printf("%s ", splitted[j]);
            }
            printf("\n");
            break;
        }
    }
}

void afficher_categories(Database *db)
{
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
}

void afficher_categories_par_id(Database *db , int id)
{
    Categorie **categories = db->categories;
    
    for(int i = 0 ; i < db->ncategories ; i++)
    {
        Categorie *c = categories[i];
        if(c->id == id)
        {
            int size ;
            char** splitted = split(categorie_to_string(c) , '#' , &size);
            for(int j = 0 ; j < size ; j++)
            {
                printf("%s ", splitted[j]);
            }
            printf("\n");
            break;
        }
    }
}

void afficher_langues(Database *db)
{
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
}

void afficher_langues_par_id(Database *db , int id)
{
    Langue **langues = db->langues;

    for(int i = 0 ; i < db->nlangues ; i++)
    {
        Langue *l = langues[i];
        if(l->id == id)
        {
            int size ;
            char** splitted = split(langue_to_string(l) , '#' , &size);
            for(int j = 0 ; j < size ; j++)
            {
                printf("%s ", splitted[j]);
            }
            printf("\n");
            break;
        }
    }
}

void afficher_penalites(Database *db)
{
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
}

void afficher_penalites_par_id(Database *db , int id)
{
    Penalite **penalite = db->penalites;

    for(int i = 0 ; i < db->npenalites ; i++)
    {
        Penalite *p = penalite[i];
        if(p->id == id)
        {
            int size ;
            char** splitted = split(penalite_to_string(p) , '#' , &size);
            for(int j = 0 ; j < size ; j++)
            {
                printf("%s ", splitted[j]);
            }
            printf("\n");
            break;
        }
    }
}

void afficher_notifications(Database *db)
{
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
}

void afficher_notifications_par_id(Database *db , int id)
{
    Notification **notifications = db->notifications;

    for(int i = 0 ; i < db->nnotifications ; i++)
    {
         Notification *n = notifications[i];
        if(n->id == id)
        {  
            int size ;
            char** splitted = split(notification_to_string(n) , '#' , &size);
            for(int j = 0 ; j < size ; j++)
            {
                printf("%s ", splitted[j]);
            }
            printf("\n");
        }
    }
}

void afficher_reservations(Database *db)
{
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
}

void afficher_reservations_par_id(Database *db , int id)
{
    Reservation **reservations = db->reservations;

    for(int i = 0 ; i < db->nreservations ; i++)
    {
        Reservation *r = reservations[i];
        if(r->id == id)
        {
            int size ;
            char** splitted = split(reservation_to_string(r) , '#' , &size);
            for(int j = 0 ; j < size ; j++)
            {
                printf("%s ", splitted[j]);
            }
            printf("\n");
        }
    }
}

void afficher_auteurs(Database *db)
{
    for(int i = 0 ; i < 20 ; i++)
        printf("-");
    printf("Table des auteurs :\n");
    
    Auteur **auteurs = db->auteurs;

    for(int i = 0 ; i < db->nauteurs ; i++)
    {
        Auteur *a = auteurs[i];
        int size ;
        char** splitted = split(auteur_to_string(a) , '#' , &size);
        for(int j = 0 ; j < size ; j++)
        {
            printf("%s ", splitted[j]);
        }
        printf("\n");
    }
}

void afficher_auteurs_par_id(Database *db , int id)
{
    for(int i = 0 ; i < 20 ; i++)
        printf("-");
    printf("Table des auteurs :\n");
    
    Auteur **auteurs = db->auteurs;

    for(int i = 0 ; i < db->nauteurs ; i++)
    {
        Auteur *a = auteurs[i];
        if(a->id == id)
        {
            int size ;
            char** splitted = split(auteur_to_string(a) , '#' , &size);
            for(int j = 0 ; j < size ; j++)
            {
                printf("%s ", splitted[j]);
            }
            printf("\n");
            break;
        }
    }
}

void afficher_reviews(Database *db)
{
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

void afficher_reviews_par_id(Database *db , int id)
{
    for(int i = 0 ; i < 20 ; i++)
        printf("-");
    printf("Table des reviews :\n");

    Review **reviews = db->reviews;

    for(int i = 0 ; i < db->nreviews ; i++)
    {
        Review *r = reviews[i];
        if(r->id == id)
        {
            int size ;
            char** splitted = split(review_to_string(r) , '#' , &size);
            for(int j = 0 ; j < size ; j++)
            {
                printf("%s ", splitted[j]);
            }
            printf("\n");
        }
    }
}

void afficher_editeurs(Database *db)
{
    for(int i = 0 ; i < 20 ; i++)
        printf("-");
    printf("Table des editeurs :\n");

    Editeur **editeurs = db->editeurs;

    for(int i = 0 ; i < db->nediteurs ; i++)
    {
        Editeur *e = editeurs[i];
        int size ;
        char** splitted = split(editeur_to_string(e) , '#' , &size);
        for(int j = 0 ; j < size ; j++)
        {
            printf("%s ", splitted[j]);
        }
        printf("\n");
    }
}

void afficher_editeurs_par_id(Database *db , int id)
{
    Editeur **editeurs = db->editeurs;

    for(int i = 0 ; i < db->nediteurs ; i++)
    {
        Editeur *e = editeurs[i];
        if(e->id == id)
        {
            int size ;
            char** splitted = split(editeur_to_string(e) , '#' , &size);
            for(int j = 0 ; j < size ; j++)
            {
                printf("%s ", splitted[j]);
            }
            printf("\n");
            break;
        }
    }
}

void interface(Database *db)
{
    do{
        system("clear");
        for(int i = 0 ; i < 20 ; i++)
            printf("-");
        printf("\nPROGRAMME DE GESTION DE LA BIBLIOTHEQUE\n");
        for(int i = 0 ; i < 20 ; i++)
            printf("-");

        printf(" Choisissez une option : \n");
        printf("1)- Afficher le contenu d'une table \n");
        printf("2)- Modifier le contenu d'une table \n");
        printf("3)- Quitter le programme \n");

        char* input = read_file(stdin);
        int choix = atoi(input);
        switch(choix)
        {
            case 1:
                system("clear");
                printf(" 1 )- Afficher par ID\n");
                printf(" 2 )- Afficher la table en entier\n");

                input = read_file(stdin);
                choix = atoi(input);

                switch(choix)
                {
                    case 1:
                        system("clear");
                        printf(" Choisissez la table a afficher :\n");
                        afficher_les_noms_des_tables();

                        input = read_file(stdin);
                        choix = atoi(input);

                        system("clear");

                        switch(choix)
                        {
                            case 1:
                                printf("Entrez l'id \n");
                                int id = atoi(read_file(stdin));

                                afficher_client_par_id(db , id);
                            break;

                            case 2:
                                printf("Entrez l'id \n");
                                int id = atoi(read_file(stdin));

                                afficher_notifications_par_id(db , id);
                            break;

                            case 3:
                                printf("Entrez l'id \n");
                                int id = atoi(read_file(stdin));

                                afficher_abonnements_par_id(db , id);
                            break;

                            case 4:
                                printf("Entrez l'id \n");
                                int id = atoi(read_file(stdin));

                                afficher_reservations_par_id(db , id);
                            break;

                            case 5:
                                printf("Entrez l'id \n");
                                int id = atoi(read_file(stdin));

                                afficher_penalites_par_id(db , id);
                            break;

                            case 6:
                                printf("Entrez l'id \n");
                                int id = atoi(read_file(stdin));

                                afficher_reviews_par_id(db , id);
                            break;

                            case 7:
                                printf("Entrez l'id \n");
                                int id = atoi(read_file(stdin));

                                afficher_livres_par_id(db , id);
                            break;

                            case 8:
                                printf("Entrez l'id \n");
                                int id = atoi(read_file(stdin));

                                afficher_categories_par_id(db , id);
                            break;

                            case 9:
                                printf("Entrez l'id \n");
                                int id = atoi(read_file(stdin));

                                afficher_langues_par_id(db , id);
                            break;

                            case 10:
                                printf("Entrez l'id \n");
                                int id = atoi(read_file(stdin));

                                afficher_auteurs_par_id(db , id);
                            break;

                            case 11:
                                printf("Entrez l'id \n");
                                int id = atoi(read_file(stdin));

                                afficher_editeurs_par_id(db , id);
                            break;

                            case 12:
                                printf("Entrez l'id \n");
                                int id = atoi(read_file(stdin));

                                afficher_emprunts_par_id(db , id);
                            break;

                            case 13:
                                printf("Entrez l'id \n");
                                int id = atoi(read_file(stdin));

                                afficher_exemplaires_par_id(db , id);
                            break;

                            default : printf(" Choix invalide .");
                            exit(1);
                        }
                    break;

                    case 2:
                        system("clear");
                        printf(" Choisissez la table a afficher :\n");
                        afficher_les_noms_des_tables();

                        input = read_file(stdin);
                        choix = atoi(input);

                        switch(choix)
                        {
                            case 1:
                                afficher_clients(db);
                            break;

                            case 2:
                                afficher_notifications(db);
                            break;

                            case 3:
                                afficher_abonnements(db);
                            break;

                            case 4:
                                afficher_reservations(db);
                            break;

                            case 5:
                                afficher_penalites(db);
                            break;

                            case 6:
                                afficher_reviews(db);
                            break;

                            case 7:
                                afficher_livres(db);
                            break;

                            case 8:
                                afficher_categories(db);
                            break;

                            case 9:
                                afficher_langues(db);
                            break;

                            case 10:
                                afficher_auteurs(db);
                            break;

                            case 11:
                                afficher_editeurs(db);
                            break;

                            case 12:
                                afficher_emprunts(db);
                            break;

                            case 13:
                                afficher_exemplaires(db);
                            break;

                            default : printf(" Choix invalide .");
                            exit(1);
                        }
                    break;
                }
            break;

            case 2:
                system("clear");
                printf(" Choisissez la table a modifier :\n");
                afficher_les_noms_des_tables();
            break;

            case 3:
                printf(" PROGRAMME EN COURS DE FERMETURE ..");
                exit(0);
            break;

            default: 
            printf("Choix invalide .");
            exit(1);
        }
    }while(1);
}