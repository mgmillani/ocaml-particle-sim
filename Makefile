OC = ocamlopt
SRC = src
BIN = bin
OBJ = obj
INCLUDE = include
INC = -I +lablGL -I $(INCLUDE) -I $(OBJ)
LIBS = lablglut.cmxa lablgl.cmxa
OBJECTS = $(OBJ)/Body.cmx $(OBJ)/Massive.cmx $(OBJ)/Particle.cmx $(OBJ)/Physics.cmx $(OBJ)/Loader.cmx $(OBJ)/Quadtree.cmx $(OBJ)/main.cmx
INTERFACES = $(OBJ)/Body.cmi $(OBJ)/Particle.cmi $(OBJ)/Physics.cmi
NAME = particle

# ocamlopt -c physics.mli
# ocamlopt -I +lablGL -c main.ml
# ocamlopt -c physics.ml
# ocamlopt -I +lablGL lablglut.cmxa lablgl.cmxa physics.cmx main.cmx

all: $(OBJ) $(BIN) $(INTERFACES) $(OBJECTS)
	$(OC) $(INC) -o $(BIN)/$(NAME) $(LIBS) $(OBJECTS)

$(OBJ):
	mkdir $(OBJ)
$(BIN):
	mkdir $(BIN)

$(OBJ)/%.cmi:$(INCLUDE)/%.mli
	$(OC) -o $@ -c $<

$(OBJ)/%.cmx:$(SRC)/%.ml
	$(OC) -o $@ -c $(INC) $<

clean:
	rm -f $(OBJ)/*
	rm -f $(BIN)/$(NAME)