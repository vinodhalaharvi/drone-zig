const std = @import("std");
const microzig = @import("microzig");

const rp2040 = microzig.hal;
const gpio = rp2040.gpio;
const time = rp2040.time;

// Built-in LED is on GPIO 25
const LED_PIN = gpio.num(25);

pub fn main() !void {
    // Configure LED pin as output
    LED_PIN.set_function(.sio);
    LED_PIN.set_direction(.out);

    // Blink forever
    while (true) {
        LED_PIN.toggle();
        time.sleep_ms(500);
    }
}
