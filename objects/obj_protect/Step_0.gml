/// obj_protect Step Event
// Exit if paused
if (global.isPaused) exit;

// Find the player
var player = instance_find(obj_player, 0);
if (player == noone) {
    show_debug_message("obj_protect: No player found!");
    exit;
}

// Calculate distance to player
var dist_to_player = point_distance(x, y, player.x, player.y);

// Debug output every 60 frames
if (!variable_instance_exists(id, "debug_timer")) {
    debug_timer = 0;
}
debug_timer++;
if (debug_timer >= 60) {
    show_debug_message("obj_protect: shield=" + string(shield_percent) + "%, distance=" + string(dist_to_player) + ", invuln=" + string(is_invulnerable));
    debug_timer = 0;
}

// Shield mechanics
if (dist_to_player <= shield_recharge_radius) {
    // Player is close - recharge shield
    shield_percent += shield_charge_rate;
    shield_percent = min(shield_percent, 100);
} else {
    // Player is far - shield drains
    shield_percent -= shield_drain_rate;
    shield_percent = max(shield_percent, 0);
}

// Update invulnerability based on shield
is_invulnerable = (shield_percent > 0);

// If shield breaks and protected one is hit, game over
if (!is_invulnerable) {
    // Check for enemy collision
    var enemy = instance_place(x, y, obj_parentEnemies);
    if (enemy != noone) {
        global.gameOver = true;
        global.isPaused = true;
    }
}

// Visual feedback - pulse when shield is low
pulse_timer++;
if (shield_percent < 25) {
    // Fast pulse when critical
    shield_alpha = 0.5 + 0.5 * sin(pulse_timer * 0.2);
} else if (shield_percent < 50) {
    // Moderate pulse when low
    shield_alpha = 0.7 + 0.3 * sin(pulse_timer * 0.1);
} else {
    // Stable when healthy
    shield_alpha = 1.0;
}

// Update depth
depth = -y;
