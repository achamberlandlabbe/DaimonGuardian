/// obj_rigBuild Draw GUI Event
// Semi-transparent background overlay
draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

// Main menu background
draw_set_color(c_black);
draw_rectangle(menu_x, menu_y, menu_x + menu_width, menu_y + menu_height, false);
draw_set_color(c_white);
draw_rectangle(menu_x, menu_y, menu_x + menu_width, menu_y + menu_height, true);

// Title
draw_set_font(Font1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(menu_x + menu_width/2, menu_y + 15, "RIG BUILD");

// Get cursor for hover detection
var cursor = instance_find(obj_cursor, 0);
var cam = view_camera[0];
var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);
var cursor_x = (cursor != noone) ? (cursor.x - cam_x) : device_mouse_x_to_gui(0);
var cursor_y = (cursor != noone) ? (cursor.y - cam_y) : device_mouse_y_to_gui(0);

// Tab bar
for (var i = 0; i < array_length(tabs); i++) {
    var tab_x = menu_x + (i * tab_width);
    var tab_y = menu_y + tab_bar_height;
    
    // Tab background - three states
    if (i == selected_tab_index) {
        draw_set_color(c_red); // Bright red for selected/active tab
    } else if (i == hovered_tab_index) {
        draw_set_color(#330000); // Dark red for hover
    } else {
        draw_set_color(c_gray);
    }
    draw_rectangle(tab_x, tab_y - 40, tab_x + tab_width, tab_y, false);
    
    // Tab border
    draw_set_color(c_white);
    draw_rectangle(tab_x, tab_y - 40, tab_x + tab_width, tab_y, true);
    
    // Tab text
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var tab_name = string_upper(tabs[i]);
    draw_text(tab_x + tab_width/2, tab_y - 20, tab_name);
}

// Content area border
draw_set_color(c_white);
draw_rectangle(content_x, content_y, content_x + content_width, content_y + content_height, true);

// Draw tab-specific content
if (current_tab == "chassis") {
    // Chassis list background
    draw_set_color(c_dkgray);
    draw_rectangle(chassis_list_x, chassis_list_y, 
        chassis_list_x + chassis_list_width, chassis_list_y + chassis_list_height, false);
    draw_set_color(c_white);
    draw_rectangle(chassis_list_x, chassis_list_y, 
        chassis_list_x + chassis_list_width, chassis_list_y + chassis_list_height, true);
    
    // Draw chassis items
    for (var i = 0; i < array_length(chassis_options); i++) {
        var chassis = chassis_options[i];
        var item_y = chassis_list_y + (i * (chassis_item_height + chassis_item_spacing)) - chassis_scroll_offset;
        
        // Skip if completely out of view
        if (item_y + chassis_item_height < chassis_list_y || item_y > chassis_list_y + chassis_list_height) {
            continue;
        }
        
        // Check if cursor is hovering over this item
        var item_hovered = point_in_rectangle(cursor_x, cursor_y, chassis_list_x + 5, item_y, 
            chassis_list_x + chassis_list_width - 5, item_y + chassis_item_height);
        
        // Item background - three states: confirmed (bright red), hovered (dark red), unselected (gray)
        if (i == confirmed_chassis_index) {
            draw_set_color(c_red); // Bright red for confirmed choice
        } else if (item_hovered || i == selected_chassis_index) {
            draw_set_color(#330000); // Dark red for hover or keyboard selection
        } else {
            draw_set_color(c_gray);
        }
        draw_rectangle(chassis_list_x + 5, item_y, 
            chassis_list_x + chassis_list_width - 5, item_y + chassis_item_height, false);
        
        // Item border
        draw_set_color(c_white);
        draw_rectangle(chassis_list_x + 5, item_y, 
            chassis_list_x + chassis_list_width - 5, item_y + chassis_item_height, true);
        
        // Draw chassis name
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        if (chassis.unlocked) {
            draw_set_color(c_white);
        } else {
            draw_set_color(c_gray);
        }
        draw_text(chassis_list_x + 20, item_y + chassis_item_height / 2, chassis.name);
        
        // "LOCKED" text for locked items
        if (!chassis.unlocked) {
            draw_set_halign(fa_right);
            draw_set_color(c_red);
            draw_text(chassis_list_x + chassis_list_width - 15, item_y + chassis_item_height / 2, "LOCKED");
        }
    }
    
    // Draw scrollbar if needed
    if (max_chassis_scroll > 0) {
        var scrollbar_x = chassis_list_x + chassis_list_width - 15;
        var scrollbar_width = 10;
        var scrollbar_height = chassis_list_height;
        var scrollbar_y = chassis_list_y;
        
        // Scrollbar background
        draw_set_color(c_dkgray);
        draw_rectangle(scrollbar_x, scrollbar_y, scrollbar_x + scrollbar_width, scrollbar_y + scrollbar_height, false);
        
        // Scrollbar thumb
        var thumb_height = (chassis_list_height / (max_chassis_scroll + chassis_list_height)) * scrollbar_height;
        var thumb_y = scrollbar_y + (chassis_scroll_offset / max_chassis_scroll) * (scrollbar_height - thumb_height);
        
        draw_set_color(c_white);
        draw_rectangle(scrollbar_x, thumb_y, scrollbar_x + scrollbar_width, thumb_y + thumb_height, false);
    }
    
    // Preview area (right side) - shows CONFIRMED chassis
    var preview_x = content_x + chassis_list_width + 40;
    var preview_y = content_y + 40;
    var preview_width = content_width - chassis_list_width - 80;
    var preview_height = content_height - 80;
    
    // Preview background
    draw_set_color(c_dkgray);
    draw_rectangle(preview_x, preview_y, preview_x + preview_width, preview_y + preview_height, false);
    draw_set_color(c_white);
    draw_rectangle(preview_x, preview_y, preview_x + preview_width, preview_y + preview_height, true);
    
    // Get confirmed chassis (the one that will be deployed)
    var confirmed_chassis = chassis_options[confirmed_chassis_index];
    
    // Only draw preview if unlocked
    if (confirmed_chassis.unlocked) {
        // Center of preview area
        var preview_center_x = preview_x + preview_width / 2;
        var preview_center_y = preview_y + preview_height / 2;
        
        // Scale for preview (same as internal tab)
        var preview_scale = 2.0;
        
        // Draw frame
        draw_sprite_ext(confirmed_chassis.sprite, 0, preview_center_x, preview_center_y, 
            preview_scale, preview_scale, 0, c_white, 1);
        
        // Get frame dimensions for wheel positioning
        var frame_w = sprite_get_width(confirmed_chassis.sprite);
        var frame_h = sprite_get_height(confirmed_chassis.sprite);
        var frame_center_x = frame_w / 2;
        var frame_center_y = frame_h / 2;
        
        // Calculate wheel positions relative to frame center
        var left_wheel_local_x = (confirmed_chassis.left_axle_x - frame_center_x) * preview_scale;
        var left_wheel_local_y = (confirmed_chassis.left_axle_y - frame_center_y) * preview_scale;
        
        var right_wheel_local_x = (confirmed_chassis.right_axle_x - frame_center_x) * preview_scale;
        var right_wheel_local_y = (confirmed_chassis.right_axle_y - frame_center_y) * preview_scale;
        
        // Wheel offset (scaled)
        var wheel_offset = confirmed_chassis.wheel_offset * preview_scale;
        
        // Draw left wheel (offset to the left)
        var left_wheel_x = preview_center_x + left_wheel_local_x - wheel_offset;
        var left_wheel_y = preview_center_y + left_wheel_local_y;
        draw_sprite_ext(confirmed_chassis.wheel_sprite, 0, left_wheel_x, left_wheel_y, 
            preview_scale, preview_scale, 0, c_white, 1);
        
        // Draw right wheel (offset to the right)
        var right_wheel_x = preview_center_x + right_wheel_local_x + wheel_offset;
        var right_wheel_y = preview_center_y + right_wheel_local_y;
        draw_sprite_ext(confirmed_chassis.wheel_sprite, 0, right_wheel_x, right_wheel_y, 
            preview_scale, preview_scale, 0, c_white, 1);
        
        // Draw chassis name below preview
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
        draw_text(preview_center_x, preview_y + preview_height - 30, confirmed_chassis.name);
    } else {
        // Draw "LOCKED" message
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_red);
        draw_text(preview_x + preview_width / 2, preview_y + preview_height / 2, "LOCKED");
    }
    
} else if (current_tab == "internal") {
    // Internal parts tab - show confirmed chassis with grid overlay and motor placement
    
    // Get confirmed chassis
    var confirmed_chassis = chassis_options[confirmed_chassis_index];
    
    // Display scale
    var display_scale = 2.0;
    
    // Center area for chassis display
    var chassis_display_x = content_x + content_width / 2;
    var chassis_display_y = content_y + content_height / 2;
    
    // Calculate grid dimensions based on chassis
    var grid_cols = confirmed_chassis.grid_cols;
    var grid_rows = confirmed_chassis.grid_rows;
    
    // Calculate grid positioning (centered over frame)
    var grid_width = grid_cols * grid_square_size * display_scale;
    var grid_height = grid_rows * grid_square_size * display_scale;
    var grid_start_x = chassis_display_x - (grid_width / 2);
    var grid_start_y = chassis_display_y - (grid_height / 2);
    
    // Draw chassis frame (semi-transparent for grid visibility)
    draw_sprite_ext(confirmed_chassis.sprite, 0, chassis_display_x, chassis_display_y, 
        display_scale, display_scale, 0, c_white, 0.7);
    
    // Draw grid overlay (yellow)
    draw_set_color(c_yellow);
    draw_set_alpha(0.5);
    
    // Draw vertical lines
    for (var i = 0; i <= grid_cols; i++) {
        var line_x = grid_start_x + (i * grid_square_size * display_scale);
        draw_line_width(line_x, grid_start_y, line_x, grid_start_y + grid_height, 2);
    }
    
    // Draw horizontal lines
    for (var i = 0; i <= grid_rows; i++) {
        var line_y = grid_start_y + (i * grid_square_size * display_scale);
        draw_line_width(grid_start_x, line_y, grid_start_x + grid_width, line_y, 2);
    }
    
    draw_set_alpha(1);
    
    // Draw placed motors
    for (var i = 0; i < array_length(placed_motors); i++) {
        var placed = placed_motors[i];
        var motor = motor_options[placed.motor_index];
        
        // Calculate motor position on grid
        var motor_x = grid_start_x + (placed.grid_x * grid_square_size * display_scale);
        var motor_y = grid_start_y + (placed.grid_y * grid_square_size * display_scale);
        var motor_w = motor.width * grid_square_size * display_scale;
        var motor_h = motor.height * grid_square_size * display_scale;
        
        // Draw motor sprite (centered in its grid space)
        draw_sprite_ext(motor.sprite, 0, motor_x + motor_w/2, motor_y + motor_h/2,
            display_scale, display_scale, 0, c_white, 1);
    }
    
    // Draw dragging preview
    if (dragging_motor != noone) {
        var motor = motor_options[dragging_motor];
        
        // Calculate snapped position
        var grid_cursor_x = cursor_x - grid_start_x;
        var grid_cursor_y = cursor_y - grid_start_y;
        var snap_grid_x = floor(grid_cursor_x / (grid_square_size * display_scale));
        var snap_grid_y = floor(grid_cursor_y / (grid_square_size * display_scale));
        
        // Check if placement would be valid
        var valid_placement = (snap_grid_x >= 0 && snap_grid_y >= 0 && 
                               snap_grid_x + motor.width <= grid_cols &&
                               snap_grid_y + motor.height <= grid_rows);
        
        // Check collision with existing motors
        if (valid_placement) {
            for (var i = 0; i < array_length(placed_motors); i++) {
                var placed = placed_motors[i];
                var placed_motor = motor_options[placed.motor_index];
                
                if (!(snap_grid_x + motor.width <= placed.grid_x ||
                      snap_grid_x >= placed.grid_x + placed_motor.width ||
                      snap_grid_y + motor.height <= placed.grid_y ||
                      snap_grid_y >= placed.grid_y + placed_motor.height)) {
                    valid_placement = false;
                    break;
                }
            }
        }
        
        // Draw preview of motor at snapped position
        var snap_x = grid_start_x + (snap_grid_x * grid_square_size * display_scale);
        var snap_y = grid_start_y + (snap_grid_y * grid_square_size * display_scale);
        var motor_w = motor.width * grid_square_size * display_scale;
        var motor_h = motor.height * grid_square_size * display_scale;
        
        // Draw highlight box (green if valid, red if invalid)
        draw_set_color(valid_placement ? c_green : c_red);
        draw_set_alpha(0.3);
        draw_rectangle(snap_x, snap_y, snap_x + motor_w, snap_y + motor_h, false);
        draw_set_alpha(1);
        draw_rectangle(snap_x, snap_y, snap_x + motor_w, snap_y + motor_h, true);
        
        // Draw motor sprite at snapped position (semi-transparent)
        draw_sprite_ext(motor.sprite, 0, snap_x + motor_w/2, snap_y + motor_h/2,
            display_scale, display_scale, 0, c_white, 0.7);
    }
    
    // Motor palette (left side)
    draw_set_color(c_dkgray);
    var palette_height = array_length(motor_options) * (motor_palette_item_height + motor_palette_spacing) + 40;
    draw_rectangle(motor_palette_x, motor_palette_y - 30, 
        motor_palette_x + motor_palette_width, 
        motor_palette_y - 30 + palette_height, false);
    draw_set_color(c_white);
    draw_rectangle(motor_palette_x, motor_palette_y - 30, 
        motor_palette_x + motor_palette_width, 
        motor_palette_y - 30 + palette_height, true);
    
    // Motor palette title
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text(motor_palette_x + motor_palette_width/2, motor_palette_y - 25, "ENGINES");
    
    // Draw motor options
    for (var i = 0; i < array_length(motor_options); i++) {
        var motor = motor_options[i];
        var item_y = motor_palette_y + (i * (motor_palette_item_height + motor_palette_spacing));
        
        // Check if hovering
        var item_hovered = point_in_rectangle(cursor_x, cursor_y, motor_palette_x, item_y,
            motor_palette_x + motor_palette_width, item_y + motor_palette_item_height);
        
        // Background
        draw_set_color(item_hovered ? #330000 : c_gray);
        draw_rectangle(motor_palette_x + 5, item_y, 
            motor_palette_x + motor_palette_width - 5, item_y + motor_palette_item_height, false);
        draw_set_color(c_white);
        draw_rectangle(motor_palette_x + 5, item_y, 
            motor_palette_x + motor_palette_width - 5, item_y + motor_palette_item_height, true);
        
        // Motor name (centered)
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(motor.unlocked ? c_white : c_gray);
        draw_text(motor_palette_x + motor_palette_width/2, item_y + motor_palette_item_height/2 - 10, motor.name);
        
        // Motor stats (centered, smaller text below name)
        draw_text(motor_palette_x + motor_palette_width/2, item_y + motor_palette_item_height/2 + 10, 
            string(motor.horsepower) + "hp  " + string(motor.weight) + "lbs");
    }
    
    // Draw chassis name at top
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text(chassis_display_x, content_y + 20, confirmed_chassis.name + " - Internal Components");
    
    // Instructions at bottom
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_text(chassis_display_x, content_y + content_height - 10, 
        "Click motor to drag | Click to place | Right-click placed motor to remove");
    
} else {
    // Other tabs - placeholder
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(content_x + content_width/2, content_y + content_height/2, 
        "[ " + string_upper(current_tab) + " TAB CONTENT ]");
}

// Deploy button
var button_hovered = point_in_rectangle(cursor_x, cursor_y, exit_button_x, exit_button_y,
    exit_button_x + exit_button_width, exit_button_y + exit_button_height);

draw_set_color(button_hovered ? #330000 : c_gray); // Dark red on hover
draw_rectangle(exit_button_x, exit_button_y, exit_button_x + exit_button_width, 
    exit_button_y + exit_button_height, false);

draw_set_color(c_white);
draw_rectangle(exit_button_x, exit_button_y, exit_button_x + exit_button_width,
    exit_button_y + exit_button_height, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(exit_button_x + exit_button_width/2, exit_button_y + exit_button_height/2, exit_button_text);

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);