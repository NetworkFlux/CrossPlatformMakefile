# x86_64-w64-mingw32-gcc -Wall -Wextra -Werror -Iinclude src/main.c -o compile_test.exe

NAME=compile_test

INC_DIR=include
SRC_DIR=src
OBJ_DIR=obj
BIN_DIR=bin

SRC=$(wildcard $(SRC_DIR)/*.c)
OBJ=$(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC))

EXEC=$(BIN_DIR)/$(NAME)$(EXT)
CC=x86_64-w64-mingw32-gcc
CFLAGS=-Wall -Wextra -Werror

# Platform Specific

# Executable Name
ifeq ($(OS),Windows_NT)
	EXT=.exe
else
	EXT=
endif

# Create Directory
ifeq ($(OS),Windows_NT)
	MKDIR_P = if not exist "$(1)" mkdir "$(1)"
else
	MKDIR_P = mkdir -p "$(1)"
endif

# Remove Directories
ifeq ($(OS),Windows_NT)
	RMDIR_P = if exist "$(1)" rmdir /S /Q "$(1)"
else
	RMDIR_P = rm -rf "$(1)"
endif

all: dir_structure $(EXEC)
	@echo Project built !

dir_structure:
	@echo Creating project structure
	@echo 	Creating $(OBJ_DIR) directory
	@$(call MKDIR_P,$(OBJ_DIR))
	@echo 	Creating $(BIN_DIR) directory
	@$(call MKDIR_P,$(BIN_DIR))

# Link the executable
$(EXEC): $(OBJ)
	@echo Linking .o files
	@echo 	linking $^ ...
	@$(CC) $(CFLAGS) $^ -o $@

# Compile each .c to .o in obj/
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@echo Compiling .c files
	@echo 	compiling $^ ...
	@$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

clean:
	@echo Cleaning project
	@echo 	Removing $(OBJ_DIR) directory
	@$(call RMDIR_P,$(OBJ_DIR))

fclean:
	@echo Fully cleaning project
	@echo 	Removing $(OBJ_DIR) directory
	@$(call RMDIR_P,$(OBJ_DIR))
	@echo 	Removing $(BIN_DIR) directory
	@$(call RMDIR_P,$(BIN_DIR))

re: fclean all

.PHONY: all dir_structure clean fclean re