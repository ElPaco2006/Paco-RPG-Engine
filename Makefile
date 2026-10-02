
# Build the engine as a library
CC := gcc
SRCDIR := src
BUILDDIR := build
SOURCES := $(shell find $(SRCDIR) -type f -name '*.$(SRCEXT)')
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))
CFLAGS := -O0 -Wall -Wextra -c -fPIC
LFLAGS := -shared
LIB := -lraylib -lGL -lm -lpthread -ldl -lrt -lX11
INC := -I include

OUTDIR ?= bin/shared
TARGET := $(OUTDIR)/pacorpgengine.so

.PHONY: all clean debug

all: $(TARGET)

$(TARGET): $(OBJECTS)
	@echo " Linking..."
	@mkdir -p $(dir $@)
	@echo " $(CC) $^ -o $@ $(LIB)"; $(CC) $(LFLAGS) $^ -o $@ $(LIB)

$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@echo " Building..."
	@mkdir -p $(dir $@)
	@echo " $(CC) $(CFLAGS) $(INC) -c -o $@ $<"; $(CC) $(CFLAGS) $(INC) -MMD -MP -c -o $@ $< -save-temps=obj

debug:
	@$(MAKE) clean
	@$(MAKE) CFLAGS="$(CFLAGS) -g" all

clean:
	@echo " Cleaning..."
	@echo " $(RM) -r $(BUILDDIR) $(TARGET) $(TESTTARGET)"; $(RM) -r $(BUILDDIR) $(TARGET) $(TESTTARGET)
