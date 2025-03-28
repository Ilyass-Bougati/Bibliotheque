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
void modifie_notification(Database *db, int id, Client *new_notification);

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