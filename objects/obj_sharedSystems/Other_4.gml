/// obj_sharedSystems Room Start Event
show_debug_message("=== ROOM START === Room: " + room_get_name(room));
if room == roomTitleScreen{
    global.canPause = false;
    global.loadingGame = false;
    hasSelectedSomething = false;
    
    // Always start at option 0 (top of menu)
    selectedOption = 0;
        
    // Create title screen background BEHIND menu text
    if (!instance_exists(obj_titleScreen)) {
        var titleScreen = instance_create_depth(0, 0, -1000, obj_titleScreen);
        show_debug_message("obj_titleScreen created: " + string(instance_exists(titleScreen)));
    } else {
        show_debug_message("obj_titleScreen already exists");
    }
    depth = -2000;
}

// Any gameplay room (not title/credits/start)
if (room != roomTitleScreen && room != roomCredits && room != RoomStart) {
    global.canPause = true;
    
    // Mark that player has an active run
    global.saveData.hasActiveRun = true;
    global.doSave = true; // Save immediately so if they close the game, they can continue
}