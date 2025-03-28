#pragma once
#include "date.h"

#ifndef fichier_notifications
    #define fichier_notifications "data/notifications"
#endif

// le type de notification
typedef enum 
{
    alert
} Type_notification;

// le tableau de la notification
typedef struct Notification
{
    int id;
    int id_client;
    Type_notification notification_type;
    char *notification_text;
    Date date_notification;
} Notification;

/**
 * cette fonction transformera une chaîne en une structure client
 * @param str la chaîne à convertir
 * @return renvoie NULL si le format n'est pas valide
 */
Notification *string_to_notification(char *str);

/**
 * Cette fonction transformera une structure client en une chaîne de caractères à écrire dans un fichier
 * @param notification la structure client à convertir
 * @return renvoie NULL en cas d'erreur
 */
char *notification_to_string(Notification *notification);

/**
 * Cette fonction charge tous les notifications sur le fichier notification
 * @param length cette variable contient la taille de la table renvoyée
 */
Notification **load_notifications(int *length);

/**
 * Cette fonction enregistre tous les notifications dans le fichier
 * @param notifications Les notifications à sauvegarder
 * @param number la taille du tableau abonnements
 */
void save_notifications(Notification **notifications, int number);