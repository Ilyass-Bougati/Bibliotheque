#pragma once
#include "livre.h"
#include "date.h"

typedef struct Reservation
{
    int id;
    int id_client;
    Livre *livre;
    Date date_reservation;
} Reservation;
