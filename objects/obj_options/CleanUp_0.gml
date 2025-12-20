/// obj_options Cleanup Event
show_debug_message("Options cleanup called");

// Conditionally unpause game - only unpause if:
// 1. No other menus exist
// 2. We're in a room that supports pausing
if (!instance_exists(obj_upgradeMenu) && 
    !instance_exists(obj_enchantmentMenu) && 
    !instance_exists(obj_rigBuild)) {
    
    // Only unpause in gameplay rooms
    if (room != roomTitleScreen && room != roomCredits && room != RoomStart) {
        global.isPaused = false;
        global.canPause = true;
    }
}