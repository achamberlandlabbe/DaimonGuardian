/// obj_tutorial Step Event

// Check for input to advance screens
if (input_check_pressed("accept")) {
    current_screen++;
    
    if (current_screen >= total_screens) {
        // Tutorial complete, destroy and unpause
        global.isPaused = false;
        instance_destroy();
    }
}