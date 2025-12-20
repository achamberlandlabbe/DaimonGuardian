/// obj_eidolon Step Event
// Exit if paused
if (global.isPaused) exit;

// Find obj_protect to check shield status
var protect = instance_find(obj_protect, 0);
var player = instance_find(obj_player, 0);

// Determine target based on shield status
if (protect != noone && player != noone) {
    if (protect.is_invulnerable) {
        // Shield is UP - attack player
        current_target = player;
    } else {
        // Shield is DOWN - attack protected one
        current_target = protect;
    }
} else if (player != noone) {
    // Fallback to player if protect doesn't exist
    current_target = player;
} else {
    // No valid target
    current_target = noone;
}

// Move toward target
if (current_target != noone) {
    var dir_to_target = point_direction(x, y, current_target.x, current_target.y);
    
    // Move toward target
    x += lengthdir_x(enemySpeed, dir_to_target);
    y += lengthdir_y(enemySpeed, dir_to_target);
    
    // Face target
    image_angle = dir_to_target;
}

// Update contact damage cooldown
if (contact_damage_cooldown > 0) {
    contact_damage_cooldown--;
}

// Update hit flash
if (hit_flash_timer > 0) {
    hit_flash_timer--;
}

// Check for death
if (enemyHP <= 0) {
    instance_destroy();
}

// Update depth
depth = -y;

// Track position for smoke trail
var dist_moved = point_distance(xprevious, yprevious, x, y);
trail_distance += dist_moved;

if (trail_distance >= trail_spacing) {
    array_insert(trail_positions, 0, {x: x, y: y});
    if (array_length(trail_positions) > trail_length) {
        array_pop(trail_positions);
    }
    trail_distance = 0;
}
