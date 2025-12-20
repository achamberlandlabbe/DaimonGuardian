/// obj_anima Step Event
// Exit if paused
if (global.isPaused) exit;

// Increment lifetime
lifetime_current++;

// Despawn after lifetime expires
if (lifetime_current >= lifetime_max) {
    instance_destroy();
    exit;
}

// Find player
var player = instance_find(obj_player, 0);
if (player == noone) exit;

// Calculate distance to player
var dist_to_player = point_distance(x, y, player.x, player.y);

// Magnetic pull toward player when in range
if (dist_to_player <= magnetic_radius) {
    // Move toward player
    var dir_to_player = point_direction(x, y, player.x, player.y);
    x += lengthdir_x(magnetic_speed, dir_to_player);
    y += lengthdir_y(magnetic_speed, dir_to_player);
}

// Pickup when close enough
if (dist_to_player <= pickup_radius) {
    // Add anima to player
    player.player_anima += anima_value;
    
    // Destroy pickup
    instance_destroy();
    exit;
}

// Visual pulse
pulse_timer += 0.1;
pulse_scale = 1.0 + 0.2 * sin(pulse_timer);

// Update depth
depth = -y;
