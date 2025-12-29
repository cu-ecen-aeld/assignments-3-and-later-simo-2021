CC ?= $(CROSS_COMPILE)gcc
SRCS := writer.c  # Ou tes fichiers sources réels
TARGET := writer  # Nom de l'exécutable

all: $(TARGET)

$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

clean:
	rm -f $(TARGET) *.o

.PHONY: all clean
