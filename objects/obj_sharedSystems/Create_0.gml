/// obj_sharedSystems Create Event – Nyaa Smack
randomize();
config();
global.buffer = room_height * 0.05;

// Splash screen timing
splashTimerLenght = 60;
splashTimer = splashTimerLenght;
currentSplashScreen = 0;

draw_set_font(Font1);

// Main menu options
selectedOption = 0;
hasSelectedSomething = false;
playString = "Play";
optionsString = "Options";
creditsString = "Credits";

// Create framework managers
var _inst = noone;
instance_create_depth(0, 0, depth, obj_sound);
instance_create_depth(0, 0, depth, obj_gameManager);
instance_create_depth(0, 0, depth, obj_gamepadManager);
if (!instance_exists(oSaveManager)) {
    _inst = instance_create_depth(0, 0, depth, oSaveManager);
    _inst.persistent = true;
}
instance_create_depth(0, 0, depth, obj_spawner);

// Application surface scaling for different display resolutions
if (display_get_height() <= 480)
    surface_resize(application_surface, 720, 480);
else if (display_get_height() <= 720)
    surface_resize(application_surface, 1280, 720);
else if (display_get_height() <= 1080)
    surface_resize(application_surface, 1920, 1080);
else if (display_get_height() <= 1440)
    surface_resize(application_surface, 2560, 1440);
else if (display_get_height() <= 2160)
    surface_resize(application_surface, 3840, 2160);
else
    surface_resize(application_surface, 7680, 4320);

display_set_gui_size(1920, 1080);

// New Game confirmation system
showNewGameConfirmation = false;
newGameSelection = "no"; // "yes" or "no" (defaults to "no")