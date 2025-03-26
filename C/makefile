CC = gcc
FLAGS = -Wall -Wextra -pedantic

clean:
	rm -f *.exe *.o

biblio.exe: biblio.c
	$(CC) $(FLAGS) -o biblio biblio.c include/*.c

run: biblio.exe
	./biblio.exe

all: clean run