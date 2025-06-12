#include <stdio.h>
#include "include/database.h"
#include "stdlib.h"
#include "include/precedures.h"
#include "include/interface.h"

int main()
{
    Database *db = load_db();
    // add_abonnement(db->abonnements , 1 , etudiant , string_to_date("24/02/2005") ,&(db->nabonnements));
    // commit(db);
    select_all(db);
    // printf("%d\n", db->abonnements[0]->etat_abonnement);
}