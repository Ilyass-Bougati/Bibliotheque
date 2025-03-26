#pragma once
#include "livre.h"
#include "date.h"

typedef struct Reservation
{
    Livre *livre;
    Date date_reservation;
} Reservation;
