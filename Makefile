CC := gcc
BIN_NAME := ottw
PKG_CONFIG := pkg-config
PKG_CFLAGS := $(shell $(PKG_CONFIG) --cflags gtk4)
PKG_LDFLAGS := $(shell $(PKG_CONFIG) --libs gtk4)
CFLAGS := -Wall -Wextra -std=c11 $(PKG_CFLAGS)
LDFLAGS := $(PKG_LDFLAGS)

SRC_DIR := src
BUILD_DIR := build

SRC := $(wildcard $(SRC_DIR)/*.c)
OBJ := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SRC))
BIN := $(BUILD_DIR)/$(BIN_NAME)

all: $(BIN)

$(BIN): $(OBJ)
	@mkdir -p $(dir $@)
	$(CC) $(OBJ) -o $@ $(LDFLAGS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean
