/// obj_child Create Event
// The cursed child that the daimon must protect

// Shield system
shield_percent = 100;  // Start at full shield
shield_drain_rate = 0.2;  // Percent per frame when player is far
shield_charge_rate = 0.5;  // Percent per frame when player is close
shield_recharge_radius = 80;  // How close player must be to recharge

// Child is invulnerable while shield > 0
is_invulnerable = true;

// Visual feedback
shield_alpha = 1.0;  // Opacity of shield effect
pulse_timer = 0;  // For pulsing animation when low

// Position (will be set by room or spawner)
depth = -y;
