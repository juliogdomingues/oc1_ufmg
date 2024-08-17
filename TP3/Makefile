CC = g++
LIBS = -lm
SRC = src
OBJ = obj
INC = include
BIN = bin
OBJS = $(OBJ)/simulador.o
# HDRS = $(INC)/heap.hpp
CFLAGS = -g -pg -Wall -std=c++17 -c -I$(INC)
EXE = $(BIN)/simulador

all: use $(EXE)

tests: use $(EXE)
	$(EXE) 4096 1024 4 ./tests/exemplo_1.txt
	# $(EXE) 4096 1024 4 ./tests/exemplo_2.txt
	# $(EXE) 4096 1024 4 ./tests/exemplo_3.txt
	# $(EXE) 4096 1024 4 ./tests/exemplo_4.txt
	# $(EXE) 4096 1024 2 ./tests/exemplo_5.txt

use:
	mkdir -p bin/
	mkdir -p obj/
	
$(BIN)/simulador: $(OBJS)
	$(CC) -g -o $(BIN)/simulador $(OBJS) $(LIBS)

$(OBJ)/simulador.o: $(HDRS) $(SRC)/simulador.cpp
	$(CC) $(CFLAGS) -o $(OBJ)/simulador.o $(SRC)/simulador.cpp

clean:
	rm -f $(EXE) $(OBJS) bin/* output.txt gmon.out
