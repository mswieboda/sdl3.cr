CRYSTAL_COMPILER := crystal
SOURCE_DIR := src
BUILD_DIR := bin
LIB_DIR := lib
SDL3_IMAGE_LIB_PATH := /opt/homebrew/Cellar/sdl3_image/3.4.0/lib
SDL3_TTF_LIB_PATH := /opt/homebrew/Cellar/sdl3_ttf/3.2.2/lib
LIB_NAME := libsdl3.a
RM_CMD := rm -rf
MKDIR_CMD := mkdir -p

# Phony targets don't represent files
.PHONY: all build build-debug clean examples spec run

# The default target, executed when you just run `make`
all: build

build:
	@echo "Building release library..."
	$(MKDIR_CMD) $(LIB_DIR)
	$(CRYSTAL_COMPILER) build $(SOURCE_DIR)/sdl3.cr -o $(LIB_DIR)/$(LIB_NAME) --release --no-debug

build-debug:
	@echo "Building debug library..."
	$(MKDIR_CMD) $(LIB_DIR)
	$(CRYSTAL_COMPILER) build $(SOURCE_DIR)/sdl3.cr -o $(LIB_DIR)/$(LIB_NAME) --no-debug --error-trace

clean:
	@echo "Executing clean..."
	$(RM_CMD) $(BUILD_DIR)
	$(RM_CMD) $(LIB_DIR)

examples:
	@echo "Building and running all examples..."
	@$(MAKE) run EXAMPLE=hello
	@$(MAKE) run EXAMPLE=keyboard
	@$(MAKE) run EXAMPLE=geometry
	@$(MAKE) run EXAMPLE=texture
	@$(MAKE) run EXAMPLE=text
	@$(MAKE) run EXAMPLE=image
	@$(MAKE) run EXAMPLE=mouse
	@$(MAKE) run EXAMPLE=audio
	@$(MAKE) run EXAMPLE=game_pad
	@$(MAKE) run EXAMPLE=platform
	@$(MAKE) run EXAMPLE=pixels

spec:
	@echo "Running specs..."
	$(CRYSTAL_COMPILER) spec --no-color -I .

run:
	@echo "Building and running example: $(EXAMPLE)"
	$(MKDIR_CMD) $(BUILD_DIR)
	$(CRYSTAL_COMPILER) build examples/$(EXAMPLE).cr -o $(BUILD_DIR)/$(EXAMPLE)
	./$(BUILD_DIR)/$(EXAMPLE)

debug:
	@echo "Building and running example in debug mode: $(EXAMPLE)"
	$(MKDIR_CMD) $(BUILD_DIR)
	$(CRYSTAL_COMPILER) build examples/$(EXAMPLE).cr -o $(BUILD_DIR)/$(EXAMPLE)_debug --no-debug --error-trace
	./$(BUILD_DIR)/$(EXAMPLE)_debug