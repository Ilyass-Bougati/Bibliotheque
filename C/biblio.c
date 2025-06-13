#include <stdio.h>
#include "include/database.h"
#include "stdlib.h"
#include "include/precedures.h"
#include "include/interface.h"


int main()
{
    Database *db = load_db();
    interface(db);
}