
# Build the engine as a library
# TODO: Add more doc regarding options (copy from raylib)
PACO_ERPG_LIBTYPE		?= SHARED
PACO_ERPG_BUILD_MODE 	?= RELEASE
PACO_ERPG_LIB_NAME		?= libpacorpgengine
PACO_ERPG_RELEASE_PATH 	?= bin


CC			= gcc
SRC_DIR		= src
BUILD_DIR	= build
BIN_DIR		= bin

TARGET	= $(BIN_DIR)/$(PACO_ERPG_LIB_NAME)

CFLAGS = -Wall -Wextra
ifeq ($(PACO_ERPG_LIBTYPE), SHARED)
	CFLAGS += -fPIC
endif
CFLAGS += $(CUSTOM_CFLAGS)

INCLUDE_PATHS = -I. include $(EXTRA_INCLUDE_PATHS)
LDFLAGS = $(CUSTOM_LDFLAGS) -L. -L$(PACO_ERPG_RELEASE_PATH) -lraylib -lGL -lm -lpthread -ldl -lrt -lX11
ifeq ($(PACO_ERPG_LIBTYPE), SHARED)
	LDFLAGS += -shared
endif

SOURCES	= $(shell find $(SRC_DIR) -name '*.c')
OBJECTS	= $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SOURCES))

CFLAGS 	+= -MMD -MP
DEPS 	:= $(OBJECTS:.o=.d)

.PHONY: all run clean debug

all: $(TARGET)

$(TARGET): $(OBJECTS)
	@mkdir -p $(BIN_DIR)
	$(CC) $(OBJECTS) $(LDFLAGS) -o $(TARGET)
	@echo "Built target: $@"

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $(INCLUDE_PATHS) -c $< -o $@

debug:
	@$(MAKE) clean
	CFLAGS += -g
	@$(MAKE) all

clean:
	@echo " Cleaning..."
	@rm -rf $(BUILD_DIR) $(BIN_DIR)

-include $(DEPS)
