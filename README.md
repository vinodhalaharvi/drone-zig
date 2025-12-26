# Pico Flight Controller

A quadcopter flight controller written from scratch in Zig, targeting the Raspberry Pi Pico 2 W.

## Status

🚧 **Work in Progress** — Currently in Phase 1 (Foundation)

See [ROADMAP.md](ROADMAP.md) for detailed project plan.

## Why?

- Learn embedded systems programming
- Understand flight controller internals
- Explore Zig for bare-metal development
- Build something that actually flies

## Hardware

- **MCU:** Raspberry Pi Pico 2 W (RP2350)
- **IMU:** MPU6050 (planned)
- **Frame:** 450mm quadcopter (planned)

## Quick Start

### Prerequisites

- [Zig 0.15.x](https://ziglang.org/download/)

### Build

```bash
# First time setup (fetches MicroZig)
make setup

# Build firmware
make build
```

### Flash

1. Hold **BOOTSEL** button on Pico
2. Plug in USB cable
3. Release button (Pico mounts as drive)
4. Run:

```bash
make flash-mac   # macOS
make flash       # Linux
```

## Project Structure

```
pico-flight-controller/
├── src/
│   └── main.zig        # Main firmware code
├── build.zig           # Build configuration
├── build.zig.zon       # Dependencies
├── Makefile            # Build shortcuts
├── README.md           # This file
└── ROADMAP.md          # Project roadmap
```

## Current Progress

- [x] Toolchain setup (Zig + MicroZig)
- [x] GPIO output (LED blink)
- [ ] UART serial debug
- [ ] I2C + IMU
- [ ] PWM motor output
- [ ] Sensor fusion
- [ ] PID control
- [ ] Flight testing

## License

MIT


## India link for product
https://robocraze.com/products/f450-quadcopter-frame-kit-with-a2212-kv1000-brushless-motor-and-4-30a-esc-and-2-pair-1045-propeller

