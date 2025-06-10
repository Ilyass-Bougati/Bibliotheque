CC = gcc
FLAGS = -Wall -Wextra -pedantic

clean:
	rm -f biblio *.o

biblio: biblio.c
	$(CC) -o biblio biblio.c include/*.c

run: biblio
	./biblio

all: clean run
