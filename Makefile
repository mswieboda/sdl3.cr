CRYSTAL_COMPILER := crystal
SOURCE_DIR := src
BUILD_DIR := build
LIB_DIR := lib
EXT_LIB_DIR := /usr/local/lib
LINKFLAGS := -L$(EXT_LIB_DIR) -Wl,-rpath,$(EXT_LIB_DIR)
LIB_NAME := libsdl3.a
RM_CMD := rm -rf
MKDIR_CMD := mkdir -p

# Phony targets don't represent files
.PHONY: all build build-debug clean examples spec run run-release init-wasm build-wasm-docker build-example-wasm build-example-wasm-docker test-wasm-docker

# The default target, executed when you just run `make`
all: build

build:
	@echo "Building release library..."
	$(MKDIR_CMD) $(LIB_DIR)
	$(CRYSTAL_COMPILER) build $(SOURCE_DIR)/sdl3.cr -o $(LIB_DIR)/$(LIB_NAME) --release --no-debug -p

build-debug:
	@echo "Building debug library..."
	$(MKDIR_CMD) $(LIB_DIR)
	$(CRYSTAL_COMPILER) build $(SOURCE_DIR)/sdl3.cr -o $(LIB_DIR)/$(LIB_NAME) --no-debug --error-trace -p

build-wasm:
	@echo "Building Wasm library..."
	$(MKDIR_CMD) $(LIB_DIR)
	$(CRYSTAL_COMPILER) build $(SOURCE_DIR)/sdl3.cr -o $(LIB_DIR)/$(LIB_NAME) --cross-compile --target wasm32-wasi --link-flags="-s USE_SDL=3 -s ASYNCIFY"

init-wasm:
	@echo "Setting up Wasm build environment (Docker)..."
	docker build -t sdl3-wasm -f Dockerfile.wasm .

build-wasm-docker:
	@echo "Compiling Wasm library inside Docker..."
	docker run --rm -v $(CURDIR):/src sdl3-wasm make build-wasm

build-example-wasm:
	@echo "Compiling example $(EXAMPLE) to Wasm object file..."
	$(MKDIR_CMD) $(BUILD_DIR)
	$(CRYSTAL_COMPILER) build examples/$(EXAMPLE).cr --target wasm32-wasi --cross-compile -o $(BUILD_DIR)/$(EXAMPLE).o --link-flags="-r"
	@echo "Bridging WASI to Emscripten..."
	emcc src/sdl3/wasi_bridge.c -c -o $(BUILD_DIR)/wasi_bridge.o
	@echo "Linking final HTML bundle..."
	emcc $(BUILD_DIR)/$(EXAMPLE).o $(BUILD_DIR)/wasi_bridge.o -o $(BUILD_DIR)/$(EXAMPLE).html \
		-s USE_SDL=3 -s USE_SDL_MIXER=3 -s USE_SDL_TTF=3 -s USE_SDL_IMAGE=3 \
		-s ASYNCIFY -s ALLOW_MEMORY_GROWTH=1 -s ERROR_ON_UNDEFINED_SYMBOLS=0

build-example-wasm-docker:
	@echo "Building example $(EXAMPLE) inside Docker..."
	docker run --rm -v $(CURDIR):/src sdl3-wasm make build-example-wasm EXAMPLE=$(EXAMPLE)

test-wasm-docker:
	@echo "Automated Test: Building $(EXAMPLE)..."
	$(MAKE) build-example-wasm-docker EXAMPLE=$(EXAMPLE)
	@echo "Automated Test: Starting local server..."
	# Start server in background
	python3 -m http.server 8000 & PID=$$!; \
	echo "Automated Test: Server started with PID $$PID. Running Puppeteer..."; \
	node scripts/wasm_runner.js http://localhost:8000/build/$(EXAMPLE).html; \
	echo "Automated Test: Cleaning up server..."; \
	kill $$PID

serve-wasm:
	@echo "Serving Wasm at http://localhost:8000/build/$(EXAMPLE).html"
	python3 -m http.server 8000

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
	@$(MAKE) run EXAMPLE=misc
	@$(MAKE) run EXAMPLE=blendmode
	@$(MAKE) run EXAMPLE=logical_presentation
	@$(MAKE) run EXAMPLE=mixer

spec:
	@echo "Running specs..."
	$(CRYSTAL_COMPILER) spec

run:
	@echo "Building and running example: $(EXAMPLE)"
	$(MKDIR_CMD) $(BUILD_DIR)
	$(CRYSTAL_COMPILER) build examples/$(EXAMPLE).cr -o $(BUILD_DIR)/$(EXAMPLE) --link-flags "$(LINKFLAGS)" --no-debug -p
	./$(BUILD_DIR)/$(EXAMPLE)

run-release:
	@echo "Building and running example: $(EXAMPLE)"
	$(MKDIR_CMD) $(BUILD_DIR)
	$(CRYSTAL_COMPILER) build examples/$(EXAMPLE).cr -o $(BUILD_DIR)/$(EXAMPLE) --link-flags "$(LINKFLAGS)" --release --no-debug -p
	./$(BUILD_DIR)/$(EXAMPLE)

debug:
	@echo "Building and running example in debug mode: $(EXAMPLE)"
	$(MKDIR_CMD) $(BUILD_DIR)
	$(CRYSTAL_COMPILER) build examples/$(EXAMPLE).cr -o $(BUILD_DIR)/$(EXAMPLE)_debug --link-flags "$(LINKFLAGS)" --error-trace -p
	./$(BUILD_DIR)/$(EXAMPLE)_debug
