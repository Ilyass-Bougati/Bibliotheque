#include <stdio.h>
#include "include/database.h"
#include "stdlib.h"
#include "include/precedures.h"

int main()
{
    Database *db = load_db();
    //commit(db);
    select_all(db);
}