// obj_practiceMenu Step Event - INPUT HANDLING AND LESSON SELECTION (Preserve Selection, 20 Steps, No Introduction, Beginner Songs 2–5 Skip Popup)

if (!hasSelectedSomething) {
// Navigation UP
var should_move_up = false;
if (input_check_pressed("up")) {
	should_move_up = true;
	up_key_held = true;
	up_hold_timer = 0;
	up_continuous_timer = 0;
} else if (input_check("up") && up_key_held) {
	up_hold_timer++;
	if (up_hold_timer >= hold_delay) {
	up_continuous_timer++;
	if (up_continuous_timer >= continuous_scroll_interval) {
		should_move_up = true;
		up_continuous_timer = 0;
	}
	}
} else if (!input_check("up")) {
	up_key_held = false;
	up_hold_timer = 0;
	up_continuous_timer = 0;
}

if (should_move_up) {
	var foundSelectable = false;
	var originalSelection = selectedLesson;
	var searchAttempts = 0;
	while (searchAttempts < totalItems && !foundSelectable) {
	selectedLesson--;
	if (selectedLesson < 0) selectedLesson = totalItems - 1;
	if (availableLessons[selectedLesson].selectable) {
		foundSelectable = true;
		playSFX(snd_switch, 1, 1, 1);
		if (selectedLesson < scrollOffset) {
		scrollOffset = selectedLesson;
		} else if (selectedLesson >= scrollOffset + maxVisibleItems) {
		scrollOffset = selectedLesson - maxVisibleItems + 1;
		} else if (selectedLesson >= totalItems - maxVisibleItems && scrollOffset < selectedLesson - maxVisibleItems + 1) {
		scrollOffset = max(0, totalItems - maxVisibleItems);
		}
		break;
	}
	searchAttempts++;
	if (selectedLesson == originalSelection) break;
	}
}

// Navigation DOWN
var should_move_down = false;
if (input_check_pressed("down")) {
	should_move_down = true;
	down_key_held = true;
	down_hold_timer = 0;
	down_continuous_timer = 0;
} else if (input_check("down") && down_key_held) {
	down_hold_timer++;
	if (down_hold_timer >= hold_delay) {
	down_continuous_timer++;
	if (down_continuous_timer >= continuous_scroll_interval) {
		should_move_down = true;
		down_continuous_timer = 0;
	}
	}
} else if (!input_check("down")) {
	down_key_held = false;
	down_hold_timer = 0;
	down_continuous_timer = 0;
}

if (should_move_down) {
	var foundSelectable = false;
	var originalSelection = selectedLesson;
	var searchAttempts = 0;
	while (searchAttempts < totalItems && !foundSelectable) {
	selectedLesson++;
	if (selectedLesson >= totalItems) selectedLesson = 0;
	if (availableLessons[selectedLesson].selectable) {
		foundSelectable = true;
		playSFX(snd_switch, 1, 1, 1);
		if (selectedLesson >= scrollOffset + maxVisibleItems) {
		scrollOffset = selectedLesson - maxVisibleItems + 1;
		} else if (selectedLesson < scrollOffset) {
		scrollOffset = selectedLesson;
		} else if (selectedLesson < maxVisibleItems && scrollOffset > 0) {
		scrollOffset = 0;
		}
		break;
	}
	searchAttempts++;
	if (selectedLesson == originalSelection) break;
	}
}

// Selection
if (input_check_pressed("accept", 0)) {
	if (selectedLesson < totalItems && availableLessons[selectedLesson].selectable) {
	playSFX(snd_select, 1, 1, 1);
	hasSelectedSomething = true;
	}
}

// Back to main menu
if (input_check_pressed("pause", 0) || input_check_pressed("back", 0)) {
	playSFX(snd_switch, 1, 1, 1);
	global.lastPracticeMenuSelection = selectedLesson;
	instance_destroy();
}
}

if (hasSelectedSomething) {
hasSelectedSomething = false;
if (selectedLesson < totalItems) {
	var selectedLessonData = availableLessons[selectedLesson];

	// Set practice mode flags
	global.practiceMode = true;
	global.selectedPracticeLevel = selectedLessonData.level;

	// Set obj_gameManager to the correct lesson and activate tutorial system
	obj_gameManager.currentLevel = selectedLessonData.level;

	// --- Core Lessons ---
	if (selectedLessonData.level >= 1 && selectedLessonData.level <= 5) {
	obj_gameManager.tutorialActive = true;
	obj_gameManager.gameState = "tutorial";
	obj_gameManager.tutorialPaused = true;
	switch(selectedLessonData.level) {
		case 1: obj_gameManager.tutorialStep = 14; break;
		case 2: obj_gameManager.tutorialStep = 25; break;
		case 3: obj_gameManager.tutorialStep = 27; break;
		case 4: obj_gameManager.tutorialStep = 29; break;
		case 5: obj_gameManager.tutorialStep = 31; break;
		default: obj_gameManager.tutorialStep = 14; break;
	}
	obj_gameManager.initializeLevelParameters();
	global.lastPracticeMenuSelection = selectedLesson;
	show_debug_message("Practice lesson " + string(selectedLessonData.level) + " selected - tutorial step " + string(obj_gameManager.tutorialStep));
	roomTransition(RoomPlay);
	instance_destroy();
	return;
	}

	// --- Beginner Song 1 (number 6): show intro message ---
	if (selectedLessonData.level == 6) {
	obj_gameManager.tutorialActive = true;
	obj_gameManager.gameState = "tutorial";
	obj_gameManager.tutorialPaused = true;
	obj_gameManager.tutorialStep = 33;
	obj_gameManager.initializeLevelParameters();
	global.lastPracticeMenuSelection = selectedLesson;
	show_debug_message("Beginner Song 1 selected - tutorial step 33");
	roomTransition(RoomPlay);
	instance_destroy();
	return;
	}

	// --- Beginner Songs 2–5 (numbers 7–10): skip educational popup, go straight to countdown ---
	if (selectedLessonData.level >= 7 && selectedLessonData.level <= 10) {
	obj_gameManager.tutorialActive = false;
	obj_gameManager.tutorialPaused = false;
	obj_gameManager.gameState = "countdown";
	obj_gameManager.initializeLevelParameters();
	obj_gameManager.startCountdown();
	global.lastPracticeMenuSelection = selectedLesson;
	show_debug_message("Beginner Song " + string(selectedLessonData.level - 5) + " selected - skipping popup, starting countdown");
	roomTransition(RoomPlay);
	instance_destroy();
	return;
	}

	// --- Bridging Lessons (11–15): placeholder, treat as core lessons for now ---
	if (selectedLessonData.level >= 11 && selectedLessonData.level <= 15) {
	obj_gameManager.tutorialActive = true;
	obj_gameManager.gameState = "tutorial";
	obj_gameManager.tutorialPaused = true;
	obj_gameManager.tutorialStep = 34 + (selectedLessonData.level - 10); // Steps 35–39
	obj_gameManager.initializeLevelParameters();
	global.lastPracticeMenuSelection = selectedLesson;
	show_debug_message("Bridging Lesson " + string(selectedLessonData.level - 10) + " selected - tutorial step " + string(obj_gameManager.tutorialStep));
	roomTransition(RoomPlay);
	instance_destroy();
	return;
	}

	// --- Easy Songs (16–20): skip educational popup, go straight to countdown ---
	if (selectedLessonData.level >= 16 && selectedLessonData.level <= 20) {
	obj_gameManager.tutorialActive = false;
	obj_gameManager.tutorialPaused = false;
	obj_gameManager.gameState = "countdown";
	obj_gameManager.initializeLevelParameters();
	obj_gameManager.startCountdown();
	global.lastPracticeMenuSelection = selectedLesson;
	show_debug_message("Easy Song " + string(selectedLessonData.level - 15) + " selected - skipping popup, starting countdown");
	roomTransition(RoomPlay);
	instance_destroy();
	return;
	}

	// --- Fallback: treat as lesson 1 ---
	obj_gameManager.tutorialActive = true;
	obj_gameManager.gameState = "tutorial";
	obj_gameManager.tutorialPaused = true;
	obj_gameManager.tutorialStep = 14;
	obj_gameManager.initializeLevelParameters();
	global.lastPracticeMenuSelection = selectedLesson;
	show_debug_message("Fallback: Defaulting to lesson 1 explanation");
	roomTransition(RoomPlay);
	instance_destroy();
}
}
