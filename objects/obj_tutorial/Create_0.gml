/// obj_tutorial Create Event

// Destroy any interfering UI objects
// (We'll identify which ones are causing issues)

// depth = -99999;
tutorial_text = [
    "Fly around using WASD/left joystick, and aim the Daimon's\n targetable attacks using the right joystick/mouse",
    "Collect anima droped by enemies to increase your strenght\n and stand within the barrier to recharge it",
    "Survive the night, while never allowing the barrier to fail.",
    "Press " + get_button_name("accept") + " to start"
];
current_screen = 0;
total_screens = array_length(tutorial_text);
global.isPaused = true;

show_debug_message("obj_tutorial created! depth=" + string(depth) + ", visible=" + string(visible));