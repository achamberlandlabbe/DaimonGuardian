/// obj_sharedSystems Step Event

// Ensure global flag exists for pause key release tracking
if (!variable_global_exists("pause_was_released")) {
    global.pause_was_released = true;
}

// Universal pause system
if (global.canPause) {
    var _doPause = false;
    var _gameHandlesInput = false;
    if (instance_exists(obj_gameManager)) {
        _gameHandlesInput = obj_gameManager.handlesEscapeInput();
    }

    // Only allow pausing if the pause key was released
    if (!_gameHandlesInput && input_check_pressed("pause", 0) && global.pause_was_released) {
        _doPause = true;
        global.pause_was_released = false;
    }

    // Reset pause_was_released when the key is released
    if (!input_check("pause", 0)) {
        global.pause_was_released = true;
    }

    if (_doPause && !instance_exists(obj_options) && !instance_exists(obj_rigBuild)) {
        global.isPaused = true;
        instance_create_depth(0, 0, -10001, obj_options);
    }
}

// Splash screen progression
if (room == RoomStart) {
    splashTimer--;
    if (splashTimer <= 0 || input_check_released("accept", 0)) {
        if (currentSplashScreen < sprite_get_number(spr_logos) - 1) {
            currentSplashScreen++;
            splashTimer = splashTimerLenght;
        } else {
            if (global.HTML)
                room_goto(RoomHTMLclick);
            else
                room_goto(roomTitleScreen);
        }
    }
}

// Title screen menu navigation
if (room == roomTitleScreen) {
    // Determine max option based on whether Continue is available
    var max_option = global.saveData.hasActiveRun ? 3 : 2;

    // New Game confirmation handling
    if (showNewGameConfirmation) {
        // Cursor hover on Yes/No buttons
        var cursor = instance_find(obj_cursor, 0);
        if (cursor != noone) {
            var conf_width = 630;
            var conf_height = 300;
            var conf_x = (room_width / 2) - (conf_width / 2);
            var conf_y = (room_height / 2) - (conf_height / 2);
            var button_width = 100;
            var button_height = 40;
            var button_y = conf_y + conf_height - button_height - 20;
            var no_x = conf_x + conf_width / 2 - button_width - 10;
            var yes_x = conf_x + conf_width / 2 + 10;

            if (point_in_rectangle(cursor.x, cursor.y, no_x, button_y, no_x + button_width, button_y + button_height)) {
                newGameSelection = "no";
            }
            if (point_in_rectangle(cursor.x, cursor.y, yes_x, button_y, yes_x + button_width, button_y + button_height)) {
                newGameSelection = "yes";
            }
        }

        // Navigation
        if (input_check_pressed("left", 0)) newGameSelection = "no";
        if (input_check_pressed("right", 0)) newGameSelection = "yes";

        // Confirm - only accept clicks if cursor is over a button
        if (input_check_pressed("accept", 0)) {
            var cursor = instance_find(obj_cursor, 0);
            var clicked_on_button = false;
            
            if (cursor != noone) {
                var conf_width = 630;
                var conf_height = 300;
                var conf_x = (room_width / 2) - (conf_width / 2);
                var conf_y = (room_height / 2) - (conf_height / 2);
                var button_width = 100;
                var button_height = 40;
                var button_y = conf_y + conf_height - button_height - 20;
                var no_x = conf_x + conf_width / 2 - button_width - 10;
                var yes_x = conf_x + conf_width / 2 + 10;

                // Check if cursor is over either button
                if (point_in_rectangle(cursor.x, cursor.y, no_x, button_y, no_x + button_width, button_y + button_height) ||
                    point_in_rectangle(cursor.x, cursor.y, yes_x, button_y, yes_x + button_width, button_y + button_height)) {
                    clicked_on_button = true;
                }
            } else {
                // No cursor (keyboard input) - always accept
                clicked_on_button = true;
            }
            
            if (clicked_on_button) {
                if (newGameSelection == "yes") {
                    // FULL RESET - same as death

                    // Update best score if current score is higher
                    if (global.player1score > global.saveData.bestScore) {
                        global.saveData.bestScore = global.player1score;
                    }

                    // Reset meta-progression
                    global.player1score = 0;

                    // Reset wave/level
                    global.currentWave = 1;
                    global.currentLevel = 1;

                    // Mark no active run
                    global.saveData.hasActiveRun = false;

                    // Reset tutorial flag and show tutorial
                    global.saveData.hasSeenTutorial = false;
                    global.showTutorial = true;

                    // Trigger save
                    global.doSave = true;

                    // Close confirmation dialog
                    showNewGameConfirmation = false;

                    // Start new game
                    room_goto(global.startingRoom);
                } else {
                    // Selected No - close dialog
                    showNewGameConfirmation = false;
                }
            }
        }

        // Cancel with back button
        if (input_check_pressed("back", 0)) {
            showNewGameConfirmation = false;
        }

        exit; // Don't process other inputs during confirmation
    }

    // Only allow navigation when no submenus are active
    if (!hasSelectedSomething && !instance_exists(obj_options)) {
        // Cursor-based selection
        var cursor = instance_find(obj_cursor, 0);
        if (cursor != noone) {
            // Build menu based on hasActiveRun
            var menu_items = [];
            if (global.saveData.hasActiveRun) {
                menu_items = ["Continue", "New Game", "Options", "Credits"];
            } else {
                menu_items = ["New Game", "Options", "Credits"];
            }

            // Define menu option properties
            var menu_x = room_width * 0.07;
            var menu_top = room_height * 0.40;
            var spacing = room_height * 0.06;

            draw_set_font(Font1);

            // Check each option's bounding box
            for (var i = 0; i < array_length(menu_items); i++) {
                var option_y = menu_top + (i * spacing);
                var option_width = string_width(menu_items[i]);
                var option_height = string_height(menu_items[i]);

                // Check if cursor is inside this option's rectangle
                if (cursor.x >= menu_x && cursor.x <= menu_x + option_width &&
                    cursor.y >= option_y && cursor.y <= option_y + option_height) {
                    selectedOption = i;
                    break;
                }
            }
        }

        // Directional menu navigation
        if (input_check_pressed("up") && selectedOption > 0) {
            selectedOption--;
            playSFX(snd_switch, 1, 1, 1);
        } else if (input_check_pressed("up")) {
            selectedOption = max_option;
            playSFX(snd_switch, 1, 1, 1);
        } else if (input_check_pressed("down") && selectedOption < max_option) {
            selectedOption++;
            playSFX(snd_switch, 1, 1, 1);
        } else if (input_check_pressed("down")) {
            selectedOption = 0;
            playSFX(snd_switch, 1, 1, 1);
        }

        if (input_check_pressed("accept", 0)) {
            playSFX(snd_select, 1, 1, 1);
            hasSelectedSomething = true;
        }
    }

    // Handle menu selection
    if (hasSelectedSomething) {
        hasSelectedSomething = false;

        if (global.saveData.hasActiveRun) {
            // Menu with Continue option
            switch (selectedOption) {
                case 0: // Continue
                    global.doLoad = true;
                    room_goto(global.startingRoom);
                    break;

                case 1: // New Game
                    if (global.saveData.hasActiveRun) {
                        showNewGameConfirmation = true;
                        newGameSelection = "no";
                    }
                    else {
                        global.saveData.hasSeenTutorial = false;
                        global.showTutorial = true;
                        room_goto(global.startingRoom);
                    }
                    break;

                case 2: // Options
                    if (!instance_exists(obj_options))
                        instance_create_depth(0, 0, 0, obj_options);
                    break;

                case 3: // Credits
                    room_goto(roomCredits);
                    break;
            }
        } else {
            // Menu without Continue option
            switch (selectedOption) {
                case 0: // New Game
                    global.saveData.hasSeenTutorial = false;
                    global.showTutorial = true;
                    room_goto(global.startingRoom);
                    break;
                case 1: // Options
                    if (!instance_exists(obj_options))
                        instance_create_depth(0, 0, 0, obj_options);
                    break;
                case 2: // Credits
                    room_goto(roomCredits);
                    break;
            }
        }
    }
}