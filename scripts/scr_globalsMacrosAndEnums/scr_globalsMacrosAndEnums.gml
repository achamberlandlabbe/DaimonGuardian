/// Global Variables Initialization
global.gameTitle = "Daimon Guardian";
global.versionNumber = "v1.0.0";
global.startingRoom = roomLevel1;
global.player1score = 0;
global.debug = false;
global.isPaused = false;
global.canPause = false;
global.demo = false;
global.doRestartLevel = false;
global.levelComplete = false;
global.gameOver = false;
global.currentLevel = 1;
global.currentWave = 1;
global.showTutorial = false;


// Save data structure
global.saveData = {
 	// Meta-progression (kept between runs if extracted successfully, lost on death)
    	currentScore: global.player1score,
  	bestScore: 0,
  	hasActiveRun: false,
	hasSeenTutorial: false,
    
	// Options
	masterVolume: 0.6,
	musicVolume: 0.8,
	soundVolume: 0.6,
	cursorSensitivity : 0,
    
	// PlayStation
	controllerSpeaker: false,
	vibrations: false,
	triggerEffects: false
};

// Save/load triggers
global.doSave = false;
global.doLoad = false;
global.saveSlot = "AUTOSAVE";
global.saveDir = "AUTOSAVE";

#macro UP 90
#macro DOWN 270
#macro LEFT 180
#macro RIGHT 0
#macro MAX_PLAYERS 1
#macro PLAYER_SPEED 1.5
#macro VOLUME_STEP 0.1
#macro CURSOR_SPEED 25

var _spacing = 1;
var _fontString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZàâéèêùç'\"():;/|\\!@#$%?&*—-+=[]<>«»1234567890 ";