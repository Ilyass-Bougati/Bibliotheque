#pragma once
#include "client.h"
#include "date.h"

// le type de notification
enum notification_type {
    alert
};

// le tableau de la notification
typedef struct
{
    int id;
    notification_type notification_type;
    char *notification_text;
    date notification_type;

    // le client auquel la notification est envoyée
    client *client;
} notification;
