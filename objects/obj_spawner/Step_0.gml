/// obj_spawner Step Event

// Debug: Show current room
show_debug_message("Spawner Step: room=" + room_get_name(room) + ", roomLevel1=" + room_get_name(roomLevel1));

// Only spawn in gameplay rooms
if (room != roomLevel1) {
    show_debug_message("Spawner: Not in roomLevel1, exiting");
    exit;
}

// Exit if paused
if (global.isPaused) {
    show_debug_message("Spawner: Game is paused, not spawning");
    exit;
}

show_debug_message("Spawner: Active! spawn_timer=" + string(spawn_timer) + ", spawn_rate_current=" + string(spawn_rate_current));

// Increment spawn timer
spawn_timer++;

// Ramp up spawn rate over time (decrease delay between spawns)
if (spawn_rate_current > spawn_rate_target) {
    spawn_rate_current -= spawn_rate_ramp_speed;
    spawn_rate_current = max(spawn_rate_current, spawn_rate_target);
}

// Spawn enemy when timer reaches current spawn rate
if (spawn_timer >= spawn_rate_current) {
    spawn_timer = 0;
    
    show_debug_message("Spawner: Attempting to spawn enemy...");
    
    // Get camera bounds
    var cam = view_camera[0];
    var cam_x = camera_get_view_x(cam);
    var cam_y = camera_get_view_y(cam);
    var cam_w = camera_get_view_width(cam);
    var cam_h = camera_get_view_height(cam);
    
    show_debug_message("Camera: x=" + string(cam_x) + " y=" + string(cam_y) + " w=" + string(cam_w) + " h=" + string(cam_h));
    
    // Pick random edge to spawn from (0=top, 1=right, 2=bottom, 3=left)
    var edge = irandom(3);
    var spawn_x, spawn_y;
    
    switch(edge) {
        case 0: // Top (100px above camera view)
            spawn_x = cam_x + irandom_range(0, cam_w);
            spawn_y = cam_y - 100;
            break;
        case 1: // Right (100px right of camera view)
            spawn_x = cam_x + cam_w + 100;
            spawn_y = cam_y + irandom_range(0, cam_h);
            break;
        case 2: // Bottom (100px below camera view)
            spawn_x = cam_x + irandom_range(0, cam_w);
            spawn_y = cam_y + cam_h + 100;
            break;
        case 3: // Left (100px left of camera view)
            spawn_x = cam_x - 100;
            spawn_y = cam_y + irandom_range(0, cam_h);
            break;
    }
    
    show_debug_message("Spawning enemy at: x=" + string(spawn_x) + " y=" + string(spawn_y) + " (edge " + string(edge) + ")");
    
    // Create enemy
    var new_enemy = instance_create_depth(spawn_x, spawn_y, -spawn_y, obj_eidolon);
    show_debug_message("Enemy created: " + object_get_name(new_enemy.object_index));
}
