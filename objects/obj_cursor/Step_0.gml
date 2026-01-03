/// obj_cursor Step Event
// Store previous mouse position to detect actual mouse movement
if (!variable_instance_exists(id, "prev_mouse_x")) {
    prev_mouse_x = mouse_x;
    prev_mouse_y = mouse_y;
}

// Determine active gamepad - prioritize slot 0 (console primary controller)
if (active_gamepad == -1 || !gamepad_is_connected(active_gamepad)) {
    // Check slot 0 first (console primary)
    if (gamepad_is_connected(0)) {
        active_gamepad = 0;
    } else {
        // PC fallback: find any connected gamepad
        for (var i = 1; i < 12; i++) {
            if (gamepad_is_connected(i)) {
                active_gamepad = i;
                break;
            }
        }
    }
}

// Get cursor sensitivity modifier (default 0 if not set)
var sensitivity_modifier = 1.0;
if (variable_struct_exists(global.saveData, "cursorSensitivity")) {
    sensitivity_modifier = 1.0 + global.saveData.cursorSensitivity;
}

// Get camera position for view-relative coordinates
var cam = view_camera[0];
var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);

// Check for gamepad input
var gamepad_input = false;
if (active_gamepad != -1 && gamepad_is_connected(active_gamepad)) {
    var axis_h = gamepad_axis_value(active_gamepad, gp_axisrh);
    var axis_v = gamepad_axis_value(active_gamepad, gp_axisrv);
    
    // Deadzone check
    if (abs(axis_h) > 0.2 || abs(axis_v) > 0.2) {
        gamepad_input = true;
        
        // Move cursor with right stick, applying sensitivity modifier
        x += axis_h * CURSOR_SPEED * sensitivity_modifier;
        y += axis_v * CURSOR_SPEED * sensitivity_modifier;
    }
}

// Only update to mouse if mouse actually moved (not if gamepad moved cursor away from mouse)
if (!gamepad_input) {
    if (mouse_x != prev_mouse_x || mouse_y != prev_mouse_y) {
        x = mouse_x;
        y = mouse_y;
    }
}

// Clamp cursor to stay within bounds
// Use room bounds instead of camera view to allow full screen cursor movement
x = clamp(x, 0, room_width - 1);
y = clamp(y, 0, room_height - 1);

// Update previous mouse position for next frame
prev_mouse_x = mouse_x;
prev_mouse_y = mouse_y;