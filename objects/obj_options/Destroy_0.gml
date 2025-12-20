/// obj_options Destroy Event

show_debug_message("obj_options DESTROYED: " + string(id));

// Reactivate deactivated objects in gameplay rooms
if (room != roomTitleScreen && room != roomCredits && room != RoomStart) {
    for (var i = 0; i < array_length(arrayOfObjToDeactivate); i++) {
        instance_activate_object(arrayOfObjToDeactivate[i]);
    }
    global.canPause = true;
}