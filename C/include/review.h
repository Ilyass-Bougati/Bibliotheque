#pragma once
#include "livre.h"

typedef struct Review
{
    int id_client;
    Livre *livre;
    int review;
} Review;