#pragma once
#include "client.h"
#include "date.h"

// le type de notification
enum Type_notification {
    alert
};

// le tableau de la notification
typedef struct Notification
{
    int id;
    Type_notification notification_type;
    char *notification_text;
    Date notification_type;

    // le client auquel la notification est envoyée
    Client *client;
} Notification;
