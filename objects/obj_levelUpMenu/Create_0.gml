/// obj_levelUpMenu Create Event

#region Pause Game
global.isPaused = true;
global.canPause = false;
#endregion

// Track which upgrade is currently selected (0 = none, 1-3 = upgrade buttons)
selected_upgrade = 0;

// Track which button is currently highlighted for keyboard/gamepad navigation
highlighted_button = 1; // Start with first upgrade button highlighted

// Error popup display
show_error_popup = false;