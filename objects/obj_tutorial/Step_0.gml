/// obj_tutorial Step Event
// Advance to next screen or close tutorial
if (input_check_pressed("accept")) {
    current_screen++;
    
    if (current_screen >= total_screens) {
    // Tutorial complete - mark as seen and save
    global.saveData.hasSeenTutorial = true;
    global.doSave = true;
    global.isPaused = false;
    instance_destroy();
	}
}

// Skip tutorial
if (input_check_pressed("pause")) {
    global.saveData.hasSeenTutorial = true;
    global.doSave = true;
    global.isPaused = false;
    instance_destroy();
}