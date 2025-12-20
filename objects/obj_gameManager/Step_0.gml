/// obj_gameManager Step Event

#region Rig Build Menu
// Rig Build menu toggle - available in any gameplay room
if ((room != roomTitleScreen && room != roomCredits && room != RoomStart) && input_check_pressed("rigBuild") && !instance_exists(obj_options)) {
    if (instance_exists(obj_rigBuild)) {
        // Menu is open, close it
        with (obj_rigBuild) {
            instance_destroy();
        }
    } else {
        // Menu is closed, open it
        instance_create_depth(0, 0, -10002, obj_rigBuild);
    }
}
#endregion

#region Pause Exit Check
if (global.isPaused) {
    exit;
}
#endregion

// Your new vehicle combat game logic will go here