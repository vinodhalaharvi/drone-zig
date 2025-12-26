.PHONY: all build clean flash monitor help

# Default target
all: build

# Build the firmware
build:
	zig build

# Build with optimizations
release:
	zig build -Doptimize=ReleaseSafe

# Clean build artifacts
clean:
	rm -rf zig-out .zig-cache

# Flash to Pico (Linux path - adjust for your OS)
# Hold BOOTSEL and plug in USB first
PICO_MOUNT ?= /media/$(USER)/RPI-RP2

flash: build
	@if [ -d "$(PICO_MOUNT)" ]; then \
		cp zig-out/firmware/pico-blink.uf2 $(PICO_MOUNT)/ && \
		echo "Flashed successfully!"; \
	else \
		echo "Error: Pico not found at $(PICO_MOUNT)"; \
		echo "Hold BOOTSEL and plug in USB, then retry."; \
		echo "Or set PICO_MOUNT: make flash PICO_MOUNT=/path/to/pico"; \
		exit 1; \
	fi

# macOS flash
flash-mac: build
	cp zig-out/firmware/pico-blink.uf2 /Volumes/RPI-RP2/

# Serial monitor (adjust port as needed)
SERIAL_PORT ?= /dev/ttyACM0
BAUD_RATE ?= 115200

monitor:
	@echo "Connecting to $(SERIAL_PORT) at $(BAUD_RATE) baud..."
	@echo "Press Ctrl+A then Ctrl+X to exit"
	picocom -b $(BAUD_RATE) $(SERIAL_PORT)

# Alternative monitor using screen
monitor-screen:
	screen $(SERIAL_PORT) $(BAUD_RATE)

help:
	@echo "Pico Flight Controller - Build Targets"
	@echo ""
	@echo "  make build     - Build firmware (debug)"
	@echo "  make release   - Build firmware (optimized)"
	@echo "  make clean     - Remove build artifacts"
	@echo "  make flash     - Build and flash to Pico (Linux)"
	@echo "  make flash-mac - Build and flash to Pico (macOS)"
	@echo "  make monitor   - Open serial monitor (picocom)"
	@echo ""
	@echo "Variables:"
	@echo "  PICO_MOUNT  - Path to mounted Pico (default: /media/$$USER/RPI-RP2)"
	@echo "  SERIAL_PORT - Serial port (default: /dev/ttyACM0)"
	@echo "  BAUD_RATE   - Baud rate (default: 115200)"

