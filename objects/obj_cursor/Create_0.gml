/// obj_cursor Create Event
window_set_cursor(cr_none); // Hide default system cursor

// Initialize position at center of room
x = room_width / 2;
y = room_height / 2;

// Track which gamepad is actively being used
active_gamepad = -1;

// Set depth higher than menus (more negative = drawn on top)
depth = -11000; // Above enchantment menu (-10000) and options menu (-10001)