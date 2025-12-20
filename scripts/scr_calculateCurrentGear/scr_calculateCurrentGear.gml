/// scr_calculateCurrentGear()
// Determines which gear the automatic transmission is in based on current speed
// Returns the combined gear ratio (transmission gear × final drive) for acceleration calculation

// Safety check - if vehicleSpeed doesn't exist yet, return 1st gear ratio
if (!variable_instance_exists(self, "vehicleSpeed")) {
    return 3.5 * 3.5; // 1st gear (3.5) × final drive (3.5) = 12.25
}

// Real automatic transmission gear ratios (typical 6-speed auto)
var transmission_gears = [
    3.5,   // 1st gear
    2.5,   // 2nd gear
    1.7,   // 3rd gear
    1.0,   // 4th gear
    0.8,   // 5th gear
    0.65   // 6th gear
];

var final_drive_ratio = 3.5; // Differential/final drive

// Calculate current speed in mph for gear selection
var current_speed_mph = abs(vehicleSpeed) * 2.85;

// Determine shift points based on speed
// Automatic transmissions shift at specific speeds based on throttle and load
// These are approximate shift points for a typical truck under full throttle
var shift_speeds = [
    15,   // Shift to 2nd at 15 mph
    30,   // Shift to 3rd at 30 mph
    45,   // Shift to 4th at 45 mph
    60,   // Shift to 5th at 60 mph
    75    // Shift to 6th at 75 mph
];

// Determine current gear based on speed
var current_gear = 0; // Start in 1st gear (index 0)

for (var i = 0; i < array_length(shift_speeds); i++) {
    if (current_speed_mph >= shift_speeds[i]) {
        current_gear = i + 1; // Shift up one gear
    } else {
        break; // Stop checking once we're below a shift point
    }
}

// Clamp to available gears
current_gear = clamp(current_gear, 0, array_length(transmission_gears) - 1);

// Calculate combined ratio (transmission × final drive)
var transmission_ratio = transmission_gears[current_gear];
var combined_ratio = transmission_ratio * final_drive_ratio;

return combined_ratio;