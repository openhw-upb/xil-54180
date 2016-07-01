CC = g++
CFLAGS = -Wall
OBJ = client.o
TARGET = client

%.o: %.c $(DEPS)
	$(CC) $(CFLAGS) -c -o $@ $<

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^
	
clean:
	$(RM) $(OBJ)
