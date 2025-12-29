# Nouveau Makefile pour le Buildroot
# 29DEC2025 - Arnaud SImo


# Utiliser le compilateur cross fourni par Buildroot
CC ?= $(CROSS_COMPILE)gcc

# Fichiers sources (ex: writer.c) et nom de l'exécutable final
SRCS := writer.c  # Remplace par tes fichiers .c réels
TARGET := writer  # Nom de l'exécutable généré

# Cible par défaut (OBLIGATOIRE pour Buildroot)
all: $(TARGET)

# Règle pour compiler l'exécutable
$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

# Règle pour nettoyer les fichiers générés
clean:
	rm -f $(TARGET) *.o

# Déclarer les cibles comme "phony" (pas de fichier correspondant)
.PHONY: all clean
