/// obj_skillSelectionMenu Create Event
#region Pause Game
global.isPaused = true;
global.canPause = false;
#endregion

// Track which skill is currently selected (0 = none, 1-3 = skill buttons)
selected_skill = 0;

// Track current column for navigation (only 1 row with 3 columns)
current_col = 0; // 0-2 for the 3 columns
current_location = "grid"; // "grid" or "confirm"

// Track input mode
input_mode = "keyboard"; // "keyboard" or "mouse"

// Error popup display
show_error_popup = false;
error_message = ""; // Dynamic error message text

// Get player to determine which skill tier we're unlocking
var player = instance_find(obj_player, 0);
if (player != noone) {
    skill_tier = floor(player.player_level / 5); // Level 5 = tier 1, Level 10 = tier 2, etc.
} else {
    skill_tier = 1; // Default to tier 1 if player not found
}

show_debug_message("Skill Selection Menu opened for tier " + string(skill_tier));