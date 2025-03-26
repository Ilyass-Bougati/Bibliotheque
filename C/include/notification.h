#pragma once
#include "date.h"

// le type de notification
typedef enum 
{
    alert
} Type_notification;

// le tableau de la notification
typedef struct Notification
{
    int id;
    Type_notification notification_type;
    char *notification_text;
    Date date_notification;
} Notification;
