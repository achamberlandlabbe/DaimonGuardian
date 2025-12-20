/// obj_anima Create Event
// Anima pickup dropped by enemies

// Lifetime system
lifetime_max = 3600;  // 60 seconds at 60fps
lifetime_current = 0;

// Magnetic pull settings
pickup_radius = 30;  // Distance at which player collects it
magnetic_radius = 100;  // Same as pickup for now (no pre-pull)
magnetic_speed = 5;  // Speed when moving toward player

// Value
anima_value = 1;  // How much anima this pickup gives

// Visual
pulse_timer = 0;
pulse_scale = 1.0;

// Depth
depth = -y;
