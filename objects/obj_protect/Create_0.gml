/// obj_protect Create Event
// The protected one that the daimon must guard

// Shield system
shield_percent = 100;  // Start at full shield
shield_drain_rate = 0.0556;  // Percent per frame when player is far
shield_charge_rate = 0.5;  // Percent per frame when player is close
shield_recharge_radius = 80;  // How close player must be to recharge

// Protected one is invulnerable while shield > 0
is_invulnerable = true;

// Visual feedback
shield_alpha = 1.0;  // Opacity of shield effect
pulse_timer = 0;  // For pulsing animation when low

// Position (will be set by room or spawner)
depth = -y;
