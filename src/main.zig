const std = @import("std");
const microzig = @import("microzig");

const rp2xxx = microzig.hal;
const time = rp2xxx.time;
const adc = rp2xxx.adc;

const pin_config = rp2xxx.pins.GlobalConfiguration{
    // Status LED
    .GPIO15 = .{
        .name = "led",
        .direction = .out,
    },
};

const pins = pin_config.pins();

pub fn main() !void {
    pin_config.apply();

    // Configure GP26 for ADC use
    adc.Input.ain0.configure_gpio_pin();

    // Enable ADC
    adc.apply(.{});

    var last_value: u12 = 0;

    while (true) {
        // Read ADC (blocking)
        const ecg_value = adc.convert_one_shot_blocking(.ain0) catch 0;

        // Blink LED when heartbeat detected (signal rises sharply)
        if (ecg_value > last_value +| 200) {
            pins.led.put(1);
        } else {
            pins.led.put(0);
        }

        last_value = ecg_value;
        time.sleep_ms(2); // ~500Hz sampling
    }
}