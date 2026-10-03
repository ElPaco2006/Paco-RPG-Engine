# STATIC	| SHARED
PACO_ERPG_LIBTYPE		?= STATIC

# RELEASE	| DEBUG
PACO_ERPG_BUILD_MODE 	?= RELEASE

# lib<name>.<ext>
PACO_ERPG_LIB_NAME		?= pacorpgengine

# Where to save output
PACO_ERPG_RELEASE_PATH 	?= bin

# OUT -----------------------------------------------------------------------------------------
LIB_EXT	= .a
ifeq ($(PACO_ERPG_LIBTYPE), SHARED)
	LIB_EXT = .so
endif

TARGET	= $(PACO_ERPG_RELEASE_PATH)/lib$(PACO_ERPG_LIB_NAME)$(LIB_EXT)

# Set up compiler and flags
#----------------------------------------------------------------------------------------------
CC			= gcc
AR			= ar
CFLAGS 		= -std=c23 -Wall -Wextra
ifeq ($(PACO_ERPG_LIBTYPE), SHARED)
	CFLAGS += -fPIC
endif

ifeq ($(PACO_ERPG_BUILD_MODE), DEBUG)
	CFLAGS += -g
endif

CFLAGS += $(CUSTOM_CFLAGS)

INCLUDE_PATHS 	= -I include $(EXTRA_INCLUDE_PATHS)

LDFLAGS_RAYLIB 	= -lraylib -lGL -lm -lpthread -ldl -lrt -lX11
LDFLAGS = $(CUSTOM_LDFLAGS) $(LDFLAGS_RAYLIB)

# Sources and output
#----------------------------------------------------------------------------------------------
SRC_DIR		= src
BUILD_DIR	= build

SOURCES	= $(shell find $(SRC_DIR) -name '*.c')
OBJECTS	= $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SOURCES))

# Dependency generation
CFLAGS 	+= -MMD -MP
DEPS 	:= $(OBJECTS:.o=.d)

# Define processes to execute
#------------------------------------------------------------------------------------------------
.PHONY: all run clean
all: $(TARGET)

$(TARGET): $(OBJECTS)
	@mkdir -p $(PACO_ERPG_RELEASE_PATH)
ifeq ($(PACO_ERPG_LIBTYPE), SHARED)
	$(CC) $(OBJECTS) $(LDFLAGS) -o $(TARGET)
	@echo "---Built dynamic library: $@---"
else
	$(AR) rcs $(TARGET) $(OBJS)
	@echo "---Built static library: $@---"
endif

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $(INCLUDE_PATHS) -c $< -o $@

clean:
	@rm -f $(TARGET) $(OBJECTS) $(DEPS)
	@echo "---Removed all generated files.---"

-include $(DEPS)
