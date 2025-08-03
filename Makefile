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

OBJ_EXT=o

# Windows Compiler - gcc, cl ? (don't change if not using Windows)
WIN_CC=
WIN_LIB_NAME=User32

# 📦 Libraries to link (names only, no prefix or extension)
LIB_NAME = staticlib dynamiclib

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
	ifeq ($(WIN_CC),cl)
		OBJ_EXT=obj
		CFLAGS=/W4 /WX
	endif
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
OBJ = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.$(OBJ_EXT),$(SRC))


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

LIB_LIB_FILES := $(LIB_DIR)/*.lib \
	$(wildcard $(LIB_DIR)/*/lib/*.lib) \
	$(wildcard $(LIB_DIR)/*/*/lib/*.lib) \
	$(wildcard $(LIB_DIR)/*/*.lib) \
	$(wildcard $(LIB_DIR)/*/*/*.lib)

ifeq ($(WIN_CC),cl)
	LIBS=$(LIB_LIB_FILES)
	LIBS+=$(foreach lib,$(WIN_LIB_NAME),$(lib).lib)
else
	LIBS=$(foreach lib,$(LIB_NAME),-l$(lib))
endif

# 🔗 Add lib dirs to LDFLAGS
ifeq ($(WIN_CC),cl)
	LDFLAGS += $(foreach dir,$(dir $(LIB_LIB_FILES)),/LIBPATH:$(dir))
else
	LDFLAGS += $(foreach dir,$(LIB_LIB_DIRS),-L$(dir))
endif

# 📥 DLL files to copy
DLL_FILES := $(wildcard $(LIB_DIR)/*.dll) \
	$(wildcard $(LIB_DIR)/*/*.dll) \
	$(wildcard $(LIB_DIR)/*/*/*.dll)


# =====================
# == 🔨 BUILD RULES ==
# =====================

# 🧱 Build everything
all: project_structure $(EXEC) copy_dlls
	@echo ✅ Project built!

# 📁 Create needed folders
project_structure:
	@echo 📂 Creating folders
	@$(call MKDIR_P,$(OBJ_DIR))
	@$(call MKDIR_P,$(BIN_DIR))
	@$(call MKDIR_P,$(DOC_DIR))

# 🔗 Link object files into executable
$(EXEC): $(OBJ)
	@echo 🔗 Linking...
ifeq ($(WIN_CC),cl)
	@$(WIN_CC) $(CFLAGS) $^ /link $(LDFLAGS) /OUT:$@ $(LIBS)
else
	@$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@ $(LIBS)
endif

# 📤 Copy DLLs to bin/ (Windows only)
copy_dlls:
	@echo 📥 Copying DLLs to $(BIN_DIR)
ifeq ($(OS),Windows_NT)
	@cmd /Q /C "for %%f in ($(subst /,\,$(DLL_FILES))) do (echo Copying %%f && copy /Y %%f $(BIN_DIR))"
else
	@cp $(DLL_FILES) $(BIN_DIR)/
endif

# 🧱 Compile .c to .o
$(OBJ_DIR)/%.$(OBJ_EXT): $(SRC_DIR)/%.c
	@echo 🧪 Compiling $<
ifeq ($(WIN_CC),cl)
	@$(WIN_CC) $(CFLAGS) /c $< /Fo:$@
else
	@$(CC) $(CFLAGS) $(LDFLAGS) -c $< -o $@
endif

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
