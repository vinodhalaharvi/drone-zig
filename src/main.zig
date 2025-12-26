const std = @import("std");
const microzig = @import("microzig");

const rp2xxx = microzig.hal;
const time = rp2xxx.time;

const pin_config = rp2xxx.pins.GlobalConfiguration{
    // Status LED
    .GPIO15 = .{
        .name = "led",
        .direction = .out,
    },
    // Photo interrupter input
    .GPIO16 = .{
        .name = "photo_sensor",
        .direction = .in,
    },
};

const pins = pin_config.pins();

pub fn main() !void {
    pin_config.apply();

    // LED mirrors the sensor state
    // Blocked = LED on, Clear = LED off (or vice versa depending on module)
    while (true) {
        const blocked = pins.photo_sensor.read();

        if (blocked == 0) {
            pins.led.put(1);  // Beam blocked - LED on
        } else {
            pins.led.put(0);  // Beam clear - LED off
        }

        time.sleep_ms(10);
    }
}