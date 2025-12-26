# Pico Flight Controller - Project Roadmap

A from-scratch quadcopter flight controller written in Zig, targeting the Raspberry Pi Pico 2 W (RP2350).

## Project Goals

- Write flight controller firmware from scratch (no existing FC firmware)
- Learn embedded systems, control theory, and sensor fusion
- Use Zig with MicroZig for bare-metal development
- Document everything for others to learn from

## Hardware

| Component | Model | Purpose |
|-----------|-------|---------|
| MCU | Raspberry Pi Pico 2 W (RP2350) | Main processor |
| IMU | MPU6050 or ICM-20689 | Accelerometer + Gyroscope |
| ESCs | 4x 30A (PWM input) | Motor control |
| Motors | 4x Brushless (e.g., 2212 920KV) | Propulsion |
| Frame | 450mm quadcopter | Mechanical structure |
| Radio RX | Any PWM/SBUS receiver | Pilot input |
| Battery | 3S/4S LiPo | Power |

## Milestones

### Phase 1: Foundation ✅
- [x] Set up Zig + MicroZig toolchain
- [x] Blink LED (GPIO output)
- [ ] UART serial output (debug logging)
- [ ] Millisecond timing utilities

### Phase 2: Sensors
- [ ] I2C driver
- [ ] MPU6050 initialization and raw data reading
- [ ] Accelerometer calibration
- [ ] Gyroscope calibration
- [ ] Temperature reading (for drift compensation)

### Phase 3: Sensor Fusion
- [ ] Complementary filter (roll/pitch estimation)
- [ ] Gyro integration for yaw
- [ ] Optional: Kalman filter implementation
- [ ] Attitude visualization (send to PC)

### Phase 4: Motor Control
- [ ] PWM output (1000-2000μs pulses)
- [ ] ESC calibration routine
- [ ] Motor test mode (controlled spin-up)
- [ ] Motor mixing (attitude → individual motor speeds)

### Phase 5: RC Input
- [ ] PWM input capture (basic receivers)
- [ ] Optional: SBUS parsing (inverted UART)
- [ ] Channel mapping (throttle, roll, pitch, yaw)
- [ ] Failsafe detection

### Phase 6: Control System
- [ ] PID controller implementation
- [ ] Rate mode (gyro-based)
- [ ] Angle mode (accelerometer-assisted)
- [ ] PID tuning interface (via serial)

### Phase 7: Flight Ready
- [ ] Arming/disarming logic
- [ ] Pre-flight checks
- [ ] Main control loop (1kHz target)
- [ ] Emergency stop

### Phase 8: Advanced (Future)
- [ ] GPS integration
- [ ] Altitude hold (barometer)
- [ ] Position hold
- [ ] Return to home
- [ ] MAVLink telemetry
- [ ] Configuration EEPROM/flash storage

## Technical Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Main Loop (1kHz)                     │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────┐    ┌──────────────┐    ┌──────────────┐   │
│  │  IMU    │───▶│ Sensor Fusion │───▶│ PID Control  │   │
│  │ (I2C)   │    │ (Attitude)    │    │ (Rate/Angle) │   │
│  └─────────┘    └──────────────┘    └──────┬───────┘   │
│                                            │           │
│  ┌─────────┐                               ▼           │
│  │  RC RX  │───────────────────────▶┌──────────────┐   │
│  │ (PWM)   │   Setpoints            │ Motor Mixer  │   │
│  └─────────┘                        └──────┬───────┘   │
│                                            │           │
│                                            ▼           │
│                                     ┌──────────────┐   │
│                                     │  PWM Output  │   │
│                                     │  (4x ESCs)   │   │
│                                     └──────────────┘   │
│                                                         │
├─────────────────────────────────────────────────────────┤
│                   UART Debug Output                      │
└─────────────────────────────────────────────────────────┘
```

## Pin Mapping (Planned)

| GPIO | Function | Notes |
|------|----------|-------|
| GP0  | UART TX  | Debug output |
| GP1  | UART RX  | Debug input |
| GP4  | I2C SDA  | IMU data |
| GP5  | I2C SCL  | IMU clock |
| GP10 | PWM (Motor 1) | Front-Left |
| GP11 | PWM (Motor 2) | Front-Right |
| GP12 | PWM (Motor 3) | Back-Right |
| GP13 | PWM (Motor 4) | Back-Left |
| GP15 | LED | Status indicator |
| GP16-19 | RC Input | 4 channels (PWM) |

## Control Theory Overview

### PID Controller
```
Output = Kp * error + Ki * ∫error + Kd * d(error)/dt
```

Each axis (roll, pitch, yaw) has its own PID controller.

### Sensor Fusion (Complementary Filter)
```
angle = α * (angle + gyro * dt) + (1 - α) * accel_angle
```
Where α ≈ 0.98 (trust gyro short-term, accelerometer long-term)

### Motor Mixing (Quad X configuration)
```
Motor1 (FL) = throttle + pitch + roll - yaw
Motor2 (FR) = throttle + pitch - roll + yaw
Motor3 (BR) = throttle - pitch - roll - yaw
Motor4 (BL) = throttle - pitch + roll + yaw
```

## Development Setup

### Requirements
- Zig 0.15.x
- Raspberry Pi Pico 2 W
- USB cable

### Build & Flash
```bash
# First time setup
make setup

# Build
make build

# Flash (hold BOOTSEL, plug in USB, then run)
make flash-mac   # macOS
make flash       # Linux
```

## Resources

### Documentation
- [RP2350 Datasheet](https://datasheets.raspberrypi.com/rp2350/rp2350-datasheet.pdf)
- [MicroZig](https://microzig.tech/)
- [Zig Language Reference](https://ziglang.org/documentation/master/)

### Reference Implementations
- [Betaflight](https://github.com/betaflight/betaflight) - Popular FC firmware (C)
- [ArduPilot](https://github.com/ArduPilot/ardupilot) - Autonomous vehicle platform (C++)
- [dRehmFlight](https://github.com/nickrehm/dRehmFlight) - Simple Arduino FC (good for learning)

### Learning
- [MPU6050 Datasheet](https://invensense.tdk.com/wp-content/uploads/2015/02/MPU-6000-Datasheet1.pdf)
- [PID Control Theory](https://en.wikipedia.org/wiki/PID_controller)
- [Complementary Filter Explanation](http://www.pieter-jan.com/node/11)

## Contributing

This is a learning project. Contributions, suggestions, and questions are welcome!

## License

MIT
