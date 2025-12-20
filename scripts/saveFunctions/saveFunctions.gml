///saveFunctions
global.defaultInternalDirName = "AUTOSAVE";//NE PAS CONFONDRE AVEC LE DOSSIER DANS PS SYS pour anciens projets, c'est slot title
global.saveDir = global.defaultInternalDirName;
global.defaultSlotName = "AUTOSAVE";//What actually displays on savedata management on PS
global.saveSlot = global.defaultSlotName;
global.doSave = false;//boolean to trigger autosave
global.doLoad = false;//boolean to trigger loading

/// @desc Loads accordingly
function loader() {
    show_debug_message("loader() called: Restoring settings from global.saveData");
    
    // Apply loaded data to game variables
    global.player1score = global.saveData.currentScore;
    
    show_debug_message("Loaded - Score: " + string(global.player1score) + ", Best: " + string(global.saveData.bestScore));
}

/// @desc Put global.doSave to True
function autoSave(_slot = global.defaultSlotName, _dir = global.defaultInternalDirName) {
    show_debug_message("autoSave() called from room: " + room_get_name(room) + " | slot=" + string(_slot) + ", dir=" + string(_dir) + " | hasActiveRun: " + string(global.saveData.hasActiveRun));
    global.saveSlot = _slot;
    global.saveDir = _dir;
    global.doSave = true;
    show_debug_message("autoSave() set global.doSave = true");
}

/// @desc Put global.doLoad to True
function autoLoad(_slot = global.defaultSlotName, _dir = global.defaultInternalDirName) {
    show_debug_message("autoLoad() called: slot=" + string(_slot) + ", dir=" + string(_dir));
    global.saveSlot = _slot;
    global.saveDir = _dir;
    global.doLoad = true;
    show_debug_message("autoLoad() set global.doLoad = true");
}