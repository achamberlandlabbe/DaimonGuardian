/// scr_calculateVehicleStats()
// Call this on obj_player to calculate static vehicle stats
// Acceleration is now calculated dynamically based on current gear (in Step Event)

// CRITICAL SAFETY CHECK
if (!variable_instance_exists(self, "equipped_internal_parts")) {
    show_debug_message("ERROR: Script called on object that doesn't have equipped_internal_parts!");
    show_debug_message("Self: " + string(self));
    return; // Exit early
}

// Motor options reference (matches obj_rigBuild)
// Torque is in lb-ft, horsepower is HP, weight is in lbs
var motor_stats = [
    { horsepower: 50, torque: 60, weight: 175 },     // Small motor (VW flat-4: high-rev, low torque)
    { horsepower: 320, torque: 380, weight: 450 },   // Medium motor (pickup V8: balanced)
    { horsepower: 400, torque: 800, weight: 1400 }   // Large motor (diesel: massive torque!)
];

// Calculate total motor stats from equipped parts
motor_weight = 0;
motor_horsepower = 0;
motor_torque = 0;

for (var i = 0; i < array_length(equipped_internal_parts); i++) {
    var part = equipped_internal_parts[i];
    if (part.type == "motor") {
        var motor = motor_stats[part.motor_index];
        motor_horsepower += motor.horsepower;
        motor_torque += motor.torque;
        motor_weight += motor.weight;
    }
}

// Handle zero motors - vehicle cannot move
if (motor_horsepower <= 0 || motor_torque <= 0) {
    motor_weight = 0;
    motor_horsepower = 0;
    motor_torque = 0;
    total_weight = chassis_weight + parts_weight;
    vehicleMaxSpeed = 0;
    show_debug_message("=== NO MOTORS INSTALLED ===");
    show_debug_message("Vehicle cannot move - no motors equipped!");
    return; // Exit early
}

// Calculate total weight
total_weight = chassis_weight + motor_weight + parts_weight;

// ===== TOP SPEED CALCULATION (STATIC - doesn't change while driving) =====
// At top speed, engine power = drag power
// Drag Force = 0.5 × ρ × Cd × A × v²
// Power = Force × velocity, so: HP × 550 = 0.5 × ρ × Cd × A × v³
// Solving for v: v = ∛(HP × 550 × 2 / (ρ × Cd × A))

var air_density = 0.002377; // slugs/ft³ (sea level, standard conditions)
var hp_to_ft_lbs_per_sec = 550; // Conversion factor

// Calculate max speed in ft/s
var speed_ft_per_sec = power((motor_horsepower * hp_to_ft_lbs_per_sec * 2) / 
                             (air_density * chassis_drag_coefficient * chassis_frontal_area), 1/3);

// Convert ft/s to game units/frame (at 60 fps)
// 1 pixel ≈ 0.0697 feet (from wheelbase scaling)
var ft_to_pixels = 1 / 0.0697;
var speed_pixels_per_frame = speed_ft_per_sec * ft_to_pixels / 60;
vehicleMaxSpeed = max(0.5, speed_pixels_per_frame); // Clamp to reasonable minimum

// DEBUG OUTPUT
show_debug_message("=== VEHICLE STATS CALCULATED ===");
show_debug_message("Motor HP: " + string(motor_horsepower));
show_debug_message("Motor Torque: " + string(motor_torque) + " lb-ft");
show_debug_message("Motor Weight: " + string(motor_weight) + " lbs");
show_debug_message("Total Weight: " + string(total_weight) + " lbs");
show_debug_message("Chassis Drag Coefficient: " + string(chassis_drag_coefficient));
show_debug_message("Chassis Frontal Area: " + string(chassis_frontal_area) + " sq ft");
show_debug_message("Chassis Wheel Radius: " + string(chassis_wheel_radius) + " ft");
show_debug_message("---");
show_debug_message("Top Speed (ft/s): " + string(speed_ft_per_sec));
show_debug_message("Top Speed (game units/frame): " + string(vehicleMaxSpeed));
show_debug_message("Top Speed (mph): " + string(vehicleMaxSpeed * 2.85) + " mph");
show_debug_message("NOTE: Acceleration is calculated dynamically based on current gear");