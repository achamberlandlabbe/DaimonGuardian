/// obj_gameManager Create Event
persistent = true;

// Game state variables
gameState = "waitingToStart";
levelComplete = false;

// Score tracking
currentLevel = 1;

// Initialize save data structure if needed
if (!variable_global_exists("saveData") || !is_struct(global.saveData)) {
    global.saveData = {};
}
if (!variable_struct_exists(global.saveData, "bestScore")) {
    global.saveData.bestScore = 0;
}

// Framework integration function for pause system
function handlesEscapeInput() {
    return false;
}

// Lighting system
darkness_surface = -1;
darkness_alpha = 0.7;  // How dark the shadows are (0-1)
light_radius = 20;      // Radius of full brightness (smaller = starts fading sooner)
light_falloff = 400;    // Additional radius for gradient (larger = longer fade distance)