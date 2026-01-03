/// obj_tutorial Create Event
// Destroy any interfering UI objects
// (We'll identify which ones are causing issues)
// depth = -99999;

// Determine movement and aiming text based on input method
var movement_text = "";
var aiming_text = "";

// Check if gamepad is connected
if (gamepad_is_connected(0)) {
    movement_text = "left stick";
    aiming_text = "right stick";
} else {
    // Concatenate movement keys without spaces or slashes
    var up_key = get_button_name("up");
    var left_key = get_button_name("left");
    var down_key = get_button_name("down");
    var right_key = get_button_name("right");
    
    // Remove any slashes or extra characters, keep only the letter
    up_key = string_replace_all(up_key, "/", "");
    left_key = string_replace_all(left_key, "/", "");
    down_key = string_replace_all(down_key, "/", "");
    right_key = string_replace_all(right_key, "/", "");
    
    movement_text = up_key + left_key + down_key + right_key;
    aiming_text = "mouse";
}

tutorial_text = [
    "Fly around using " + movement_text + ", and aim the Daimon's\n targetable attacks using the " + aiming_text,
    "Collect anima dropped by enemies to increase your strength\n and stand within the barrier to recharge it",
    "Survive the night, while never allowing the barrier to fail.",
    "Press " + get_button_name("accept") + " to start"
];
current_screen = 0;
total_screens = array_length(tutorial_text);
global.isPaused = true;
show_debug_message("obj_tutorial created! depth=" + string(depth) + ", visible=" + string(visible));