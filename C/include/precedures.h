#pragma once
#include "database.h"


/**
 * Cette fonction insère un client dans la base de données
 * @param db la base de données
 * @param client le client à insérer
 */
void insere_client(Database *db, Client *client);

/**
 * Cette fonction supprime un client de la base de données
 * @param db la base de données
 * @param id l'identifiant du client
 */
void supprime_client(Database *db, int id);

/**
 * Cette fonction modifie un client
 * @param db la base de données
 * @param id l'identifiant du client
 * @param new_client le nouveau client
 */
void modifie_client(Database *db, int id, Client *new_client);

/**
 * Cette fonction insère un notification dans la base de données
 * @param db la base de données
 * @param notification le notification à insérer
 */
void insere_notification(Database *db, Notification *notification);

/**
 * Cette fonction supprime un notification de la base de données
 * @param db la base de données
 * @param id l'identifiant du notification
 */
void supprime_notification(Database *db, int id);

/**
 * Cette fonction modifie un notification
 * @param db la base de données
 * @param id l'identifiant du notification
 * @param new_notification le nouveau notification
 */
void modifie_notification(Database *db, int id, Notification *new_notification);

/**
 * Cette fonction insère un abonnement dans la base de données
 * @param db la base de données
 * @param abonnement le abonnement à insérer
 */
void insere_abonnement(Database *db, Abonnement *abonnement);

/**
 * Cette fonction supprime un abonnement de la base de données
 * @param db la base de données
 * @param id l'identifiant du abonnement
 */
void supprime_abonnement(Database *db, int id);

/**
 * Cette fonction modifie un abonnement
 * @param db la base de données
 * @param id l'identifiant du abonnement
 * @param new_abonnement le nouveau abonnement
 */
void modifie_abonnement(Database *db, int id, Abonnement *new_abonnement);

/**
 * Cette fonction insère un penalite dans la base de données
 * @param db la base de données
 * @param penalite le penalite à insérer
 */
void insere_penalite(Database *db, Penalite *penalite);

/**
 * Cette fonction supprime un penalite de la base de données
 * @param db la base de données
 * @param id l'identifiant du penalite
 */
void supprime_penalite(Database *db, int id);

/**
 * Cette fonction modifie un penalite
 * @param db la base de données
 * @param id l'identifiant du penalite
 * @param new_penalite le nouveau penalite
 */
void modifie_penalite(Database *db, int id, Penalite *new_penalite);

/**
 * Cette fonction insère un emprunt dans la base de données
 * @param db la base de données
 * @param emprunt le emprunt à insérer
 */
void insere_emprunt(Database *db, Emprunt *emprunt);

/**
 * Cette fonction supprime un emprunt de la base de données
 * @param db la base de données
 * @param id l'identifiant du emprunt
 */
void supprime_emprunt(Database *db, int id);

/**
 * Cette fonction modifie un emprunt
 * @param db la base de données
 * @param id l'identifiant du emprunt
 * @param new_emprunt le nouveau emprunt
 */
void modifie_emprunt(Database *db, int id, Emprunt *new_emprunt);

/**
 * Cette fonction insère un reservation dans la base de données
 * @param db la base de données
 * @param reservation le reservation à insérer
 */
void insere_reservation(Database *db, Reservation *reservation);

/**
 * Cette fonction supprime un reservation de la base de données
 * @param db la base de données
 * @param id l'identifiant du reservation
 */
void supprime_reservation(Database *db, int id);

/**
 * Cette fonction modifie un reservation
 * @param db la base de données
 * @param id l'identifiant du reservation
 * @param new_reservation le nouveau reservation
 */
void modifie_reservation(Database *db, int id, Reservation *new_reservation);

/**
 * Cette fonction insère un review dans la base de données
 * @param db la base de données
 * @param review le review à insérer
 */
void insere_review(Database *db, Review *review);

/**
 * Cette fonction supprime un review de la base de données
 * @param db la base de données
 * @param id l'identifiant du review
 */
void supprime_review(Database *db, int id);

/**
 * Cette fonction modifie un review
 * @param db la base de données
 * @param id l'identifiant du review
 * @param new_review le nouveau review
 */
void modifie_review(Database *db, int id, Review *new_review);

/**
 * Cette fonction insère un exemplaire dans la base de données
 * @param db la base de données
 * @param exemplaire le exemplaire à insérer
 */
void insere_exemplaire(Database *db, Exemplaire *exemplaire);

/**
 * Cette fonction supprime un exemplaire de la base de données
 * @param db la base de données
 * @param id l'identifiant du exemplaire
 */
void supprime_exemplaire(Database *db, int id);

/**
 * Cette fonction modifie un exemplaire
 * @param db la base de données
 * @param id l'identifiant du exemplaire
 * @param new_exemplaire le nouveau exemplaire
 */
void modifie_exemplaire(Database *db, int id, Exemplaire *new_exemplaire);

/**
 * Cette fonction insère un categorie dans la base de données
 * @param db la base de données
 * @param categorie le categorie à insérer
 */
void insere_categorie(Database *db, Categorie *categorie);

/**
 * Cette fonction supprime un categorie de la base de données
 * @param db la base de données
 * @param id l'identifiant du categorie
 */
void supprime_categorie(Database *db, int id);

/**
 * Cette fonction modifie un categorie
 * @param db la base de données
 * @param id l'identifiant du categorie
 * @param new_categorie le nouveau categorie
 */
void modifie_categorie(Database *db, int id, Categorie *new_categorie);


/**
 * Cette fonction insère un langue dans la base de données
 * @param db la base de données
 * @param langue le langue à insérer
 */
void insere_langue(Database *db, Langue *langue);

/**
 * Cette fonction supprime un langue de la base de données
 * @param db la base de données
 * @param id l'identifiant du langue
 */
void supprime_langue(Database *db, int id);

/**
 * Cette fonction modifie un langue
 * @param db la base de données
 * @param id l'identifiant du langue
 * @param new_langue le nouveau langue
 */
void modifie_langue(Database *db, int id, Langue *new_langue);


/**
 * Cette fonction insère un editeur dans la base de données
 * @param db la base de données
 * @param editeur le editeur à insérer
 */
void insere_editeur(Database *db, Editeur *editeur);

/**
 * Cette fonction supprime un editeur de la base de données
 * @param db la base de données
 * @param id l'identifiant du editeur
 */
void supprime_editeur(Database *db, int id);

/**
 * Cette fonction modifie un editeur
 * @param db la base de données
 * @param id l'identifiant du editeur
 * @param new_editeur le nouveau editeur
 */
void modifie_editeur(Database *db, int id, Editeur *new_editeur);


/**
 * Cette fonction insère un auteur dans la base de données
 * @param db la base de données
 * @param auteur le auteur à insérer
 */
void insere_auteur(Database *db, Auteur *auteur);

/**
 * Cette fonction supprime un auteur de la base de données
 * @param db la base de données
 * @param id l'identifiant du auteur
 */
void supprime_auteur(Database *db, int id);

/**
 * Cette fonction modifie un auteur
 * @param db la base de données
 * @param id l'identifiant du auteur
 * @param new_auteur le nouveau auteur
 */
void modifie_auteur(Database *db, int id, Auteur *new_auteur);


/**
 * Cette fonction insère un livre dans la base de données
 * @param db la base de données
 * @param livre le livre à insérer
 */
void insere_livre(Database *db, Livre *livre);

/**
 * Cette fonction supprime un livre de la base de données
 * @param db la base de données
 * @param id l'identifiant du livre
 */
void supprime_livre(Database *db, int id);

/**
 * Cette fonction modifie un livre
 * @param db la base de données
 * @param id l'identifiant du livre
 * @param new_livre le nouveau livre
 */
void modifie_livre(Database *db, int id, Livre *new_livre);