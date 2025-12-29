/// obj_options Cleanup Event
show_debug_message("Options cleanup called");

// Unpause game when options menu closes (only in gameplay rooms)
if (room != roomTitleScreen && room != roomCredits && room != RoomStart) {
    global.isPaused = false;
    global.canPause = true;
}