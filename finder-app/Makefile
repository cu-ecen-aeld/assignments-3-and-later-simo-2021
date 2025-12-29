# Nouveau Makefile pour le Buildroot
# 29DEC2025 - Arnaud SImo


# Nom de l'exécutable
TARGET = writer

# Sources
SRC = writer.c

# Ne PAS définir CC : Buildroot le fournit
# Ne PAS définir CROSS_COMPILE

# Ajouter nos flags sans écraser ceux de Buildroot
CFLAGS += -Wall -g 

# Règle par défaut
all: $(TARGET)

# Construction du binaire
$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<

# Nettoyage
clean:
	rm -f $(TARGET) *.o

distclean: clean
