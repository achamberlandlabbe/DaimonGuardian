/// obj_rigBuild Step Event
// Get cursor for mouse interaction - convert room coords to GUI coords
var cursor = instance_find(obj_cursor, 0);
var cam = view_camera[0];
var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);

// CRITICAL FIX: Use same calculation as Draw GUI Event
if (cursor != noone) {
    cursor_x = cursor.x - cam_x;
    cursor_y = cursor.y - cam_y;
} else {
    // Fallback to mouse GUI position
    cursor_x = device_mouse_x_to_gui(0);
    cursor_y = device_mouse_y_to_gui(0);
}

// Check if cursor is over deploy button (to prevent other interactions)
var cursor_over_deploy = point_in_rectangle(cursor_x, cursor_y, exit_button_x, exit_button_y, 
    exit_button_x + exit_button_width, exit_button_y + exit_button_height);

// Reset hovered tab each frame (will be set if hovering)
hovered_tab_index = -1;

// Tab navigation with keyboard
if (input_check_pressed("left") && selected_tab_index > 0) {
    selected_tab_index--;
    current_tab = tabs[selected_tab_index];
    playSFX(snd_switch, 1, 1, 1);
}
if (input_check_pressed("right") && selected_tab_index < array_length(tabs) - 1) {
    selected_tab_index++;
    current_tab = tabs[selected_tab_index];
    playSFX(snd_switch, 1, 1, 1);
}

// Tab hover with mouse (highlight but don't switch)
for (var i = 0; i < array_length(tabs); i++) {
    var tab_x = menu_x + (i * tab_width);
    var tab_y = menu_y + tab_bar_height - 40;
    
    if (point_in_rectangle(cursor_x, cursor_y, tab_x, tab_y, tab_x + tab_width, tab_y + 40)) {
        hovered_tab_index = i;
        
        // Click to switch tabs
        if (input_check_pressed("accept")) {
            if (selected_tab_index != i) {
                selected_tab_index = i;
                current_tab = tabs[i];
                playSFX(snd_switch, 1, 1, 1);
            }
        }
        break;
    }
}

// === CHASSIS TAB LOGIC ===
if (current_tab == "chassis") {
    // Up/Down navigation with keyboard
    if (input_check_pressed("up") && selected_chassis_index > 0) {
        selected_chassis_index--;
        playSFX(snd_switch, 1, 1, 1);
        
        // Auto-scroll if needed
        if (selected_chassis_index * (chassis_item_height + chassis_item_spacing) < chassis_scroll_offset) {
            chassis_scroll_offset = selected_chassis_index * (chassis_item_height + chassis_item_spacing);
        }
    }
    
    if (input_check_pressed("down") && selected_chassis_index < array_length(chassis_options) - 1) {
        selected_chassis_index++;
        playSFX(snd_switch, 1, 1, 1);
        
        // Auto-scroll if needed
        var item_bottom = (selected_chassis_index + 1) * (chassis_item_height + chassis_item_spacing);
        if (item_bottom > chassis_scroll_offset + chassis_list_height) {
            chassis_scroll_offset = item_bottom - chassis_list_height;
        }
    }
    
    // Accept button confirms selection (makes it bright red) - only if not over deploy button
    if (input_check_pressed("accept") && !cursor_over_deploy) {
        var selected_chassis = chassis_options[selected_chassis_index];
        if (selected_chassis.unlocked) {
            confirmed_chassis_index = selected_chassis_index;
            playSFX(snd_select, 1, 1, 1);
        } else {
            playSFX(snd_switch, 1, 1, 1); // Error sound for locked
        }
    }
    
    // Mouse wheel scrolling
    if (mouse_wheel_up()) {
        chassis_scroll_offset -= chassis_item_height;
        chassis_scroll_offset = max(0, chassis_scroll_offset);
    }
    if (mouse_wheel_down()) {
        chassis_scroll_offset += chassis_item_height;
        chassis_scroll_offset = min(max_chassis_scroll, chassis_scroll_offset);
    }
    
    // Chassis list mouse hover and click - only if not over deploy button
    if (!cursor_over_deploy) {
        for (var i = 0; i < array_length(chassis_options); i++) {
            var item_y = chassis_list_y + (i * (chassis_item_height + chassis_item_spacing)) - chassis_scroll_offset;
            
            // Skip if scrolled out of view
            if (item_y < chassis_list_y || item_y + chassis_item_height > chassis_list_y + chassis_list_height) {
                continue;
            }
            
            if (point_in_rectangle(cursor_x, cursor_y, chassis_list_x + 5, item_y, 
                chassis_list_x + chassis_list_width - 5, item_y + chassis_item_height)) {
                // Hover - change selection
                if (selected_chassis_index != i) {
                    selected_chassis_index = i;
                    playSFX(snd_switch, 1, 1, 1);
                }
                
                // Click - confirm selection
                if (input_check_pressed("accept")) {
                    var chassis = chassis_options[i];
                    if (chassis.unlocked) {
                        confirmed_chassis_index = i;
                        playSFX(snd_select, 1, 1, 1);
                    } else {
                        playSFX(snd_switch, 1, 1, 1); // Error sound
                    }
                }
                break;
            }
        }
    }
}

// === INTERNAL TAB LOGIC (Motor Placement) ===
else if (current_tab == "internal") {
    var confirmed_chassis = chassis_options[confirmed_chassis_index];
    var display_scale = 2.0;
    
    // Calculate grid positioning - MUST MATCH Draw GUI Event exactly
    var chassis_display_x = content_x + content_width / 2;
    var chassis_display_y = content_y + content_height / 2;
    var grid_cols = confirmed_chassis.grid_cols;
    var grid_rows = confirmed_chassis.grid_rows;
    var grid_width = grid_cols * grid_square_size * display_scale;
    var grid_height = grid_rows * grid_square_size * display_scale;
    var grid_start_x = chassis_display_x - (grid_width / 2);
    var grid_start_y = chassis_display_y - (grid_height / 2);
    
    // Motor palette interaction (only if not dragging and not over deploy button)
    if (dragging_motor == noone && !cursor_over_deploy) {
        for (var i = 0; i < array_length(motor_options); i++) {
            var motor = motor_options[i];
            var item_y = motor_palette_y + (i * (motor_palette_item_height + motor_palette_spacing));
            
            // Match the Draw GUI hitbox with padding
            if (point_in_rectangle(cursor_x, cursor_y, motor_palette_x + 5, item_y,
                motor_palette_x + motor_palette_width - 5, item_y + motor_palette_item_height)) {
                
                // Click to start dragging
                if (input_check_pressed("accept") && motor.unlocked) {
                    dragging_motor = i;
                    drag_offset_x = cursor_x - motor_palette_x;
                    drag_offset_y = cursor_y - item_y;
                    playSFX(snd_switch, 1, 1, 1);
                    break;
                }
            }
        }
    }
    
    // Handle dragging motor
    if (dragging_motor != noone) {
        // Click again to place motor
        if (input_check_pressed("accept")) {
            var motor = motor_options[dragging_motor];
            
            // Convert cursor position to grid coordinates
            var grid_cursor_x = cursor_x - grid_start_x;
            var grid_cursor_y = cursor_y - grid_start_y;
            
            // Snap to nearest grid position
            var grid_x = floor(grid_cursor_x / (grid_square_size * display_scale));
            var grid_y = floor(grid_cursor_y / (grid_square_size * display_scale));
            
            // Check if placement is valid (within grid bounds)
            var valid_placement = (grid_x >= 0 && grid_y >= 0 && 
                                   grid_x + motor.width <= grid_cols &&
                                   grid_y + motor.height <= grid_rows);
            
            // Check for collision with existing motors
            if (valid_placement) {
                for (var i = 0; i < array_length(placed_motors); i++) {
                    var placed = placed_motors[i];
                    var placed_motor = motor_options[placed.motor_index];
                    
                    // Check if rectangles overlap
                    if (!(grid_x + motor.width <= placed.grid_x ||
                          grid_x >= placed.grid_x + placed_motor.width ||
                          grid_y + motor.height <= placed.grid_y ||
                          grid_y >= placed.grid_y + placed_motor.height)) {
                        valid_placement = false;
                        break;
                    }
                }
            }
            
            // Place motor if valid
            if (valid_placement) {
                var new_motor = {};
                new_motor.motor_index = dragging_motor;
                new_motor.grid_x = grid_x;
                new_motor.grid_y = grid_y;
                array_push(placed_motors, new_motor);
                playSFX(snd_select, 1, 1, 1);
                
                // Only stop dragging if placement succeeded
                dragging_motor = noone;
            } else {
                playSFX(snd_switch, 1, 1, 1); // Error sound for invalid placement
                // Don't reset dragging_motor - keep dragging so user can try again
            }
        }
        
        // Cancel dragging with back button
        if (input_check_pressed("back")) {
            dragging_motor = noone;
            playSFX(snd_switch, 1, 1, 1);
        }
    }
    
    // Right-click to remove placed motors
    if (input_check_pressed("back") && dragging_motor == noone && !cursor_over_deploy) {
        // Convert cursor to grid coordinates
        var grid_cursor_x = cursor_x - grid_start_x;
        var grid_cursor_y = cursor_y - grid_start_y;
        var grid_x = floor(grid_cursor_x / (grid_square_size * display_scale));
        var grid_y = floor(grid_cursor_y / (grid_square_size * display_scale));
        
        // Check if clicking on a placed motor
        for (var i = array_length(placed_motors) - 1; i >= 0; i--) {
            var placed = placed_motors[i];
            var placed_motor = motor_options[placed.motor_index];
            
            if (grid_x >= placed.grid_x && grid_x < placed.grid_x + placed_motor.width &&
                grid_y >= placed.grid_y && grid_y < placed.grid_y + placed_motor.height) {
                array_delete(placed_motors, i, 1);
                playSFX(snd_switch, 1, 1, 1);
                break;
            }
        }
    }
}

// Deploy button hover and click
if (cursor_over_deploy) {
    if (input_check_pressed("accept")) {
        // Check if at least one motor is equipped
        if (array_length(placed_motors) == 0) {
            playSFX(snd_switch, 1, 1, 1); // Error sound
            show_debug_message("Cannot deploy: No motors installed!");
            // Don't deploy - just make error sound and exit
        } else {
            // Get confirmed chassis
            var confirmed_chassis = chassis_options[confirmed_chassis_index];
            
            // Apply chassis to player
            if (instance_exists(obj_player)) {
                with (obj_player) {
                    // Apply chassis physical properties
                    frame_sprite = confirmed_chassis.sprite;
                    wheel_sprite = confirmed_chassis.wheel_sprite;
                    wheelbase = confirmed_chassis.wheelbase;
                    max_steering_angle = confirmed_chassis.max_steering;
                    
                    // Weight and aerodynamic properties
                    chassis_weight = confirmed_chassis.chassis_weight;
                    chassis_drag_coefficient = confirmed_chassis.drag_coefficient;
                    chassis_frontal_area = confirmed_chassis.frontal_area;
                    chassis_wheel_radius = confirmed_chassis.wheel_radius;
                    parts_weight = 0;  // Reset parts weight
                    
                    // Axle positions for rendering
                    left_wheel_axle_x = confirmed_chassis.left_axle_x;
                    left_wheel_axle_y = confirmed_chassis.left_axle_y;
                    right_wheel_axle_x = confirmed_chassis.right_axle_x;
                    right_wheel_axle_y = confirmed_chassis.right_axle_y;
                    wheel_axle_offset = confirmed_chassis.wheel_offset;
                    
                    // Reset velocity
                    vehicleSpeed = 0;
                    
                    // Save equipped motors to player
                    equipped_internal_parts = [];
                    for (var i = 0; i < array_length(other.placed_motors); i++) {
                        var placed = other.placed_motors[i];
                        var equipped_part = {};
                        equipped_part.type = "motor";
                        equipped_part.motor_index = placed.motor_index;
                        equipped_part.grid_x = placed.grid_x;
                        equipped_part.grid_y = placed.grid_y;
                        array_push(equipped_internal_parts, equipped_part);
                    }
                    
                    // CRITICAL: Recalculate performance with new equipment
                    scr_calculateVehicleStats();
                }
            }
            
            // Close menu
            playSFX(snd_select, 1, 1, 1);
            global.isPaused = false;
            instance_destroy();
        }
    }
}

// Close with back button (only if not dragging)
if (input_check_pressed("back") && dragging_motor == noone && current_tab != "internal") {
    playSFX(snd_select, 1, 1, 1);
    global.isPaused = false;
    instance_destroy();
}

// Calculate max scroll for chassis list
var total_list_height = array_length(chassis_options) * (chassis_item_height + chassis_item_spacing);
max_chassis_scroll = max(0, total_list_height - chassis_list_height);