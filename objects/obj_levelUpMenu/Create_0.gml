/// obj_levelUpMenu Create Event

#region Pause Game
global.isPaused = true;
global.canPause = false;
#endregion

// Track which upgrade is currently selected (0 = none, 1-36 = upgrade buttons)
selected_upgrade = 0;

// Track current row and column for grid navigation
current_row = 0; // 0-11 for the 12 rows
current_col = 0; // 0-2 for the 3 columns
current_location = "grid"; // "grid" or "confirm"

// Track input mode
input_mode = "keyboard"; // "keyboard" or "mouse"

// Error popup display
show_error_popup = false;
error_message = ""; // Dynamic error message text

// Scrolling variables
scroll_offset = 0; // Current scroll position
scroll_max = 0; // Maximum scroll (calculated based on content)
scroll_speed = 130; // Row height (120) + spacing (10) = 130px per row