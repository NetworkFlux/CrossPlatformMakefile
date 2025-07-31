MAKEFLAGS += --no-print-directory

# Project Name
NAME=cross_compile_makefile

# Project Structure
SRC_DIR=src
INC_DIR=include
OBJ_DIR=obj
BIN_DIR=bin
LIB_DIR=lib

# Platform Specific
ifeq ($(OS),Windows_NT)
	CC=x86_64-w64-mingw32-gcc
	EXT=.exe
	MKDIR_P = if not exist "$(1)" mkdir "$(1)"
	RMDIR_P = if exist "$(1)" rmdir /S /Q "$(1)"
else
	CC=gcc
	EXT=
	MKDIR_P = mkdir -p "$(1)"
	RMDIR_P = rm -rf "$(1)"
endif

# Output Executable
EXEC=$(BIN_DIR)/$(NAME)$(EXT)

# Sources / Objects
SRC=$(wildcard $(SRC_DIR)/*.c)
OBJ=$(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC))

# ========================
# === LIBRARY SUPPORT ====
# ========================

# Include flags for lib/*/include
LIB_INC_DIRS := $(wildcard $(LIB_DIR)/*/include)
CFLAGS += -Wall -Wextra -Werror -I$(INC_DIR) $(foreach dir,$(LIB_INC_DIRS),-I$(dir))

# Library paths for lib/*/lib
LIB_LIB_DIRS := $(wildcard $(LIB_DIR)/*/lib)
LDFLAGS += $(foreach dir,$(LIB_LIB_DIRS),-L$(dir))

# Library files (.a and .dll.a) as -lfoo
LIB_FILES := $(notdir $(basename $(wildcard $(LIB_DIR)/*/lib/lib*.a)))
LDLIBS += $(foreach lib,$(LIB_FILES),-l$(patsubst lib%,%,$(lib)))

# DLLs to copy to bin/
DLL_FILES := $(wildcard $(LIB_DIR)/*/lib/*.dll)

# ============================
# === Build Rules ============
# ============================

all: dir_structure $(EXEC) copy_dlls
	@echo Project built !

dir_structure:
	@echo Creating project structure
	@$(call MKDIR_P,$(OBJ_DIR))
	@$(call MKDIR_P,$(BIN_DIR))

# Linking step
$(EXEC): $(OBJ)
	@echo Linking...
	@$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@ $(LDLIBS)

# Copy all .dlls to bin/
copy_dlls:
	@echo Copying DLLs to $(BIN_DIR)
ifeq ($(OS),Windows_NT)
	@cmd /Q /C "for %%f in ($(subst /,\,$(DLL_FILES))) do (echo Copying %%f && copy /Y %%f $(BIN_DIR))"
else
	@cp $(DLL_FILES) $(BIN_DIR)/
endif

# Compiling source files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@echo Compiling $<
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo Cleaning project
	@$(call RMDIR_P,$(OBJ_DIR))

fclean:
	@echo Fully cleaning project
	@$(call RMDIR_P,$(OBJ_DIR))
	@$(call RMDIR_P,$(BIN_DIR))

re: fclean all

print-dlls:
	@echo DLL_FILES: $(DLL_FILES)

.PHONY: all dir_structure clean fclean re copy_dlls
