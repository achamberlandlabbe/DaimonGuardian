/// obj_story Step Event
// Advance screen
if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
    current_screen++;
    
    if (current_screen >= total_screens) {
        // Story complete - unpause and create tutorial
        global.isPaused = false;
        instance_create_depth(0, 0, -9999, obj_tutorial);
        instance_destroy();
    }
}