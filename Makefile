########################################
#                                      #
#      🧱 Cross-Platform Makefile      #
#                                      #
########################################

# ========================================
# == ⚠️ USER SETTINGS – MODIFY HERE ⚠️ ==
# ========================================

# 🏷️ Name of your final executable (without extension)
NAME = cpm

# 📁 Project folder structure
SRC_DIR = src
INC_DIR = include
OBJ_DIR = obj
BIN_DIR = bin
LIB_DIR = lib
DOC_DIR = docs

# 📦 Libraries to link (names only, no prefix or extension)
LIBS = -lstaticlib -ldynamiclib

# ⚙️ Additional compiler flags
CFLAGS = -Wall -Wextra -Werror


# ============================================================================
# == ⚙️ INTERNAL SETTINGS – DO NOT TOUCH UNLESS YOU KNOW WHAT YOU'RE DOING ==
# ============================================================================

# 🔇 Suppress make output to reduce noise
MAKEFLAGS += --no-print-directory

# 🌍 Platform detection
ifeq ($(OS),Windows_NT)
	CC = x86_64-w64-mingw32-gcc
	EXT = .exe
	MKDIR_P = if not exist "$(1)" mkdir "$(1)"
	RMDIR_P = if exist "$(1)" rmdir /S /Q "$(1)"
else
	CC = gcc
	EXT =
	MKDIR_P = mkdir -p "$(1)"
	RMDIR_P = rm -rf "$(1)"
endif

# 📎 Final binary output
EXEC = $(BIN_DIR)/$(NAME)$(EXT)

# 📄 Collect all .c files in src/
SRC = $(wildcard $(SRC_DIR)/*.c)

# 🧱 Generate corresponding .o file names
OBJ = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC))


# =======================================================
# == 📚 LIBRARY INCLUDE AND LINK PATHS (auto-detected) ==
# =======================================================

# ➕ Include directories
LIB_INC_DIRS := $(LIB_DIR)/include \
	$(wildcard $(LIB_DIR)/*/include) \
	$(wildcard $(LIB_DIR)/*/*/include) \
	$(wildcard $(LIB_DIR)/*) \
	$(wildcard $(LIB_DIR)/*/*)

# ➕ Add include dirs to CFLAGS
CFLAGS += -I$(INC_DIR) $(foreach dir,$(LIB_INC_DIRS),-I$(dir))

# 🔗 Library directories
LIB_LIB_DIRS := $(LIB_DIR) \
	$(wildcard $(LIB_DIR)/*/lib) \
	$(wildcard $(LIB_DIR)/*/*/lib) \
	$(wildcard $(LIB_DIR)/*) \
	$(wildcard $(LIB_DIR)/*/*)

# 🔗 Add lib dirs to LDFLAGS
LDFLAGS += $(foreach dir,$(LIB_LIB_DIRS),-L$(dir))

# 📥 DLL files to copy
DLL_FILES := $(wildcard $(LIB_DIR)/*.dll) \
	$(wildcard $(LIB_DIR)/*/*.dll) \
	$(wildcard $(LIB_DIR)/*/*/*.dll)


# =====================
# == 🔨 BUILD RULES ==
# =====================

# 🧱 Build everything
all: dir_structure $(EXEC) copy_dlls
	@echo ✅ Project built!

# 📁 Create needed folders
dir_structure:
	@echo 📂 Creating folders
	@$(call MKDIR_P,$(OBJ_DIR))
	@$(call MKDIR_P,$(BIN_DIR))
	@$(call MKDIR_P,$(DOC_DIR))

# 🔗 Link object files into executable
$(EXEC): $(OBJ)
	@echo 🔗 Linking...
	@$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@ $(LIBS)

# 📤 Copy DLLs to bin/ (Windows only)
copy_dlls:
	@echo 📥 Copying DLLs to $(BIN_DIR)
ifeq ($(OS),Windows_NT)
	@cmd /Q /C "for %%f in ($(subst /,\,$(DLL_FILES))) do (echo Copying %%f && copy /Y %%f $(BIN_DIR))"
else
	@cp $(DLL_FILES) $(BIN_DIR)/
endif

# 🧱 Compile .c to .o
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@echo 🧪 Compiling $<
	@$(CC) $(CFLAGS) $(LDFLAGS) -c $< -o $@

# 🧹 Clean object files
clean:
	@echo 🧹 Cleaning object files
	@$(call RMDIR_P,$(OBJ_DIR))

# 🧼 Full clean: obj + bin
fclean:
	@echo 🧼 Full clean
	@$(call RMDIR_P,$(OBJ_DIR))
	@$(call RMDIR_P,$(BIN_DIR))

# 🔁 Clean and rebuild
re: fclean all

# 🧾 Print DLLs to be copied
print-dlls:
	@echo 📜 DLL_FILES: $(DLL_FILES)

# 📛 Mark these as phony
.PHONY: all dir_structure clean fclean re copy_dlls print-dlls
