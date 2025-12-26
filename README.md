# Pico Flight Controller - Hello World

Zig-based blink example for Raspberry Pi Pico.

## Prerequisites

1. **Install Zig 0.13.0** (or compatible version)
   ```
   # Check your version
   zig version
   ```

2. **No other dependencies** — microzig is fetched automatically

## Build

```bash
zig build
```

This produces:
- `zig-out/firmware/pico-blink.elf` — for debugging
- `zig-out/firmware/pico-blink.uf2` — for flashing

## Flash to Pico

1. Hold the **BOOTSEL** button on your Pico
2. Plug in USB (while holding button)
3. Release button — Pico mounts as a drive called `RPI-RP2`
4. Copy the `.uf2` file to the drive:
   ```bash
   cp zig-out/firmware/pico-blink.uf2 /media/$USER/RPI-RP2/
   ```
   (On macOS: `/Volumes/RPI-RP2/`)

5. Pico reboots automatically — LED should blink!

## Troubleshooting

**Hash mismatch error:**
The microzig hash in `build.zig.zon` may need updating. Run `zig build` and it will tell you the correct hash if it's wrong.

**Can't find microzig targets:**
Make sure you're using Zig 0.13.x — microzig versions are tied to specific Zig releases.

## Next Steps

Once this works, we'll add:
1. UART serial output (actual "hello world" text)
2. I2C for IMU communication
3. PWM output for ESC control
# drone-zig
