/// obj_upgradeMenu Step Event
// Check for cursor
var cursor = instance_find(obj_cursor, 0);
var cursor_x = (cursor != noone) ? cursor.x : mouse_x;
var cursor_y = (cursor != noone) ? cursor.y : mouse_y;

// Exit confirmation handling
if (show_exit_confirmation) {
    // Cursor hover on Yes/No buttons
    var conf_width = 400;
    var conf_height = 150;
    var conf_x = (menu_width / 2) - (conf_width / 2);
    var conf_y = (menu_height / 2) - (conf_height / 2);
    var button_width = 100;
    var button_height = 40;
    var button_y = conf_y + conf_height - button_height - 20;
    var no_x = conf_x + conf_width / 2 - button_width - 10;
    var yes_x = conf_x + conf_width / 2 + 10;
    
    if (point_in_rectangle(cursor_x, cursor_y, no_x, button_y, no_x + button_width, button_y + button_height)) {
        exit_selection = "no";
    }
    if (point_in_rectangle(cursor_x, cursor_y, yes_x, button_y, yes_x + button_width, button_y + button_height)) {
        exit_selection = "yes";
    }
    
    // Navigation
    if (input_check_pressed("left")) {
        exit_selection = "no";
        playSFX(snd_switch, 1, 1, 1);
    }
    if (input_check_pressed("right")) {
        exit_selection = "yes";
        playSFX(snd_switch, 1, 1, 1);
    }
    
    // Confirm
    if (input_check_pressed("accept")) {
        playSFX(snd_select, 1, 1, 1);
        if (exit_selection == "yes") {
            if (exit_action == "new_run") {
                // Reset to Wave 1
                global.currentWave = 1;
                global.currentLevel = 1;
                
                // Reset game manager tracking
                if (instance_exists(obj_gameManager)) {
                    obj_gameManager.goldThisRun = 0;
                    obj_gameManager.xpThisRun = 0;
                    obj_gameManager.enemiesSpawnedThisWave = 0;
                    obj_gameManager.enemiesKilledThisWave = 0;
                    obj_gameManager.mainEnemiesSpawnedThisWave = 0;
                    
                    // Clear inventory components
                    var inventory_keys = variable_struct_get_names(obj_gameManager.inventory);
                    for (var i = 0; i < array_length(inventory_keys); i++) {
                        variable_struct_set(obj_gameManager.inventory, inventory_keys[i], 0);
                    }
                }
                
                // Destroy active enchantments
                if (instance_exists(obj_enchantments)) {
                    instance_destroy(obj_enchantments);
                }
                
                // Save before starting new run
                global.saveData.cumulativeGold = global.gold;
                global.saveData.currentScore = global.player1score;
                var pc = instance_find(obj_pc, 0);
                if (pc != noone) {
                    global.saveData.pcXP = pc.heroXP;
                }
                global.saveData.hasActiveRun = true;
                global.doSave = true;
                
                // Stop upgrade music before starting new run
                if (audio_is_playing(snd_musicUpgrades)) {
                    audio_stop_sound(snd_musicUpgrades);
                }
                
                // Go to RoomPlay
                global.isPaused = false;
                instance_destroy(); 
                room_goto(RoomPlay);
            } else if (exit_action == "menu") {
                // Save and return to title
                global.saveData.cumulativeGold = global.gold;
                global.saveData.currentScore = global.player1score;
                var pc = instance_find(obj_pc, 0);
                if (pc != noone) {
                    global.saveData.pcXP = pc.heroXP;
                }
                global.doSave = true;
                
                // Go to title
                global.isPaused = false;
                instance_destroy();
                room_goto(roomTitleScreen);
            }
        } else {
            // Cancel
            show_exit_confirmation = false;
        }
    }
    
    // Cancel with back button
    if (input_check_pressed("back")) {
        show_exit_confirmation = false;
        playSFX(snd_select, 1, 1, 1);
    }
    
    exit; // Don't process other inputs during exit confirmation
}

// Purchase confirmation handling
if (show_confirmation) {
    // Cursor hover on Yes/No buttons
    var conf_width = 600;
    var conf_height = 200;
    var conf_x = (menu_width / 2) - (conf_width / 2);
    var conf_y = (menu_height / 2) - (conf_height / 2);
    var button_width = 100;
    var button_height = 40;
    var button_y = conf_y + conf_height - button_height - 20;
    var no_x = conf_x + conf_width / 2 - button_width - 10;
    var yes_x = conf_x + conf_width / 2 + 10;
    
    if (point_in_rectangle(cursor_x, cursor_y, no_x, button_y, no_x + button_width, button_y + button_height)) {
        confirmation_selection = "no";
    }
    if (point_in_rectangle(cursor_x, cursor_y, yes_x, button_y, yes_x + button_width, button_y + button_height)) {
        confirmation_selection = "yes";
    }
    
    // Navigation
    if (input_check_pressed("left")) {
        confirmation_selection = "no";
        playSFX(snd_switch, 1, 1, 1);
    }
    if (input_check_pressed("right")) {
        confirmation_selection = "yes";
        playSFX(snd_switch, 1, 1, 1);
    }
    
    // Confirm
    if (input_check_pressed("accept")) {
        if (confirmation_selection == "yes") {
            if (confirmation_type == "skill") {
                var skill = confirmation_item;
                var current_level = variable_struct_get(global.saveData, skill.saveVar);
                var cost = skill.cost[current_level];
                
                // Check if player has enough XP
                var pc = instance_find(obj_pc, 0);
                if (pc != noone && pc.heroXP >= cost) {
                    // Deduct XP
                    pc.heroXP -= cost;
                    
                    // Increase upgrade level
                    variable_struct_set(global.saveData, skill.saveVar, current_level + 1);
                    
                    // Save immediately
                    global.saveData.pcXP = pc.heroXP;
                    global.doSave = true;
                    
                    // Play purchase sound
                    playSFX(snd_shopBuy, 1, 1, 1);
                    
                    show_debug_message("Purchased " + skill.name + " upgrade to level " + string(current_level + 1));
                } else {
                    // Show error message
                    show_error_message = true;
                    error_message_timer = error_message_duration;
                    error_type = "skill";
                    playSFX(snd_select, 1, 1, 1);
                }
            } else if (confirmation_type == "shop") {
                var item = confirmation_item;
                
                // Check if already owned
                var is_owned = variable_struct_get(global.saveData, item.saveVar);
                
                if (!is_owned && (global.gold + global.testGold) >= item.cost) {
                    // Deduct gold
                    global.gold -= item.cost;
                    
                    // Mark as purchased
                    variable_struct_set(global.saveData, item.saveVar, true);
                    
                    // Save immediately
                    global.saveData.cumulativeGold = global.gold;
                    global.doSave = true;
                    
                    // Play purchase sound
                    playSFX(snd_shopBuy, 1, 1, 1);
                    
                    show_debug_message("Purchased " + item.name);
                } else if (is_owned) {
                    show_debug_message("Item already owned");
                    playSFX(snd_select, 1, 1, 1);
                } else {
                    // Show error message for insufficient gold
                    show_error_message = true;
                    error_message_timer = error_message_duration;
                    error_type = "shop";
                    playSFX(snd_select, 1, 1, 1);
                }
            } else if (confirmation_type == "info") {
                // Just viewing info, no purchase
                playSFX(snd_select, 1, 1, 1);
            }
        } else {
            // Cancelled purchase
            playSFX(snd_select, 1, 1, 1);
        }
        
        // Close confirmation
        show_confirmation = false;
        confirmation_item = noone;
    }
    
    // Cancel with back button
    if (input_check_pressed("back")) {
        show_confirmation = false;
        confirmation_item = noone;
        playSFX(snd_select, 1, 1, 1);
    }
    
    exit; // Don't process other inputs during confirmation
}

// Error message timer countdown
if (show_error_message && error_message_timer > 0) {
    error_message_timer--;
    if (error_message_timer <= 0) {
        show_error_message = false;
    }
}

// Initialize flags
var skip_grid_hover = false; // Flag to skip grid hover detection this frame
var cursor_over_exit_button = false; // Track if cursor is over any exit button
hovered_exit_button = ""; // Reset each frame

// KEYBOARD NAVIGATION FOR EXIT BUTTONS (MUST RUN FIRST)
if (selected_exit_button >= 0) {
    var skip_hover_this_frame = false;
    
    // Navigate between exit buttons
    if (input_check_pressed("left")) {
        if (selected_exit_button == 1) {
            selected_exit_button = 0;
            prev_selected_exit_button = selected_exit_button;
            playSFX(snd_switch, 1, 1, 1);
        } else if (selected_exit_button == 0) {
            // Go to Ring of Arcane Might (bottom right of shop, index 5)
            selected_exit_button = -1;
            selected_side = "shop";
            selected_col = 1;
            selected_row = 2;
            show_debug_message("LEFT from New Run - Set to: " + selected_side + " row:" + string(selected_row) + " col:" + string(selected_col));
            prev_selected_exit_button = selected_exit_button;
            prev_selected_side = selected_side;
            prev_selected_col = selected_col;
            prev_selected_row = selected_row;
            playSFX(snd_switch, 1, 1, 1);
            skip_hover_this_frame = true;
            skip_grid_hover = true;
            exit; // Exit Step Event immediately - don't process cursor hover this frame
        }
    }
    if (input_check_pressed("right")) {
        if (selected_exit_button == 0) {
            selected_exit_button = 1;
            prev_selected_exit_button = selected_exit_button;
            playSFX(snd_switch, 1, 1, 1);
        } else if (selected_exit_button == 1) {
            // Go to Attack Speed (bottom left of skills, index 4)
            selected_exit_button = -1;
            selected_side = "skills";
            selected_col = 0;
            selected_row = 2;
            show_debug_message("RIGHT from Main Menu - Set to: " + selected_side + " row:" + string(selected_row) + " col:" + string(selected_col));
            prev_selected_exit_button = selected_exit_button;
            prev_selected_side = selected_side;
            prev_selected_col = selected_col;
            prev_selected_row = selected_row;
            playSFX(snd_switch, 1, 1, 1);
            exit; // Exit Step Event immediately - don't process cursor hover this frame
        }
    }
    
    // Navigate up from exit buttons
    if (input_check_pressed("up")) {
        if (selected_exit_button == 0) {
            // Go to Ring of Arcane Might (bottom right of shop, index 5)
            selected_exit_button = -1;
            selected_side = "shop";
            selected_col = 1;
            selected_row = 2;
            show_debug_message("UP from New Run - Set to: " + selected_side + " row:" + string(selected_row) + " col:" + string(selected_col));
            prev_selected_exit_button = selected_exit_button;
            prev_selected_side = selected_side;
            prev_selected_col = selected_col;
            prev_selected_row = selected_row;
            playSFX(snd_switch, 1, 1, 1);
            show_debug_message("EXITING STEP EVENT NOW");
            exit; // Exit Step Event immediately - don't process cursor hover this frame
        } else if (selected_exit_button == 1) {
            // Go to Attack Speed (bottom left of skills, index 4)
            selected_exit_button = -1;
            selected_side = "skills";
            selected_col = 0;
            selected_row = 2;
            show_debug_message("UP from Main Menu - Set to: " + selected_side + " row:" + string(selected_row) + " col:" + string(selected_col));
            prev_selected_exit_button = selected_exit_button;
            prev_selected_side = selected_side;
            prev_selected_col = selected_col;
            prev_selected_row = selected_row;
            playSFX(snd_switch, 1, 1, 1);
            show_debug_message("EXITING STEP EVENT NOW");
            exit; // Exit Step Event immediately - don't process cursor hover this frame
        }
    }
    
    // Activate selected exit button
    if (input_check_pressed("accept")) {
        playSFX(snd_select, 1, 1, 1);
        if (selected_exit_button == 0) {
            show_exit_confirmation = true;
            exit_action = "new_run";
            exit_selection = "no";
        } else if (selected_exit_button == 1) {
            show_exit_confirmation = true;
            exit_action = "menu";
            exit_selection = "no";
        }
    }
    
    // Skip cursor hover if we just used keyboard
    if (skip_hover_this_frame) {
        cursor_over_exit_button = true;
        skip_grid_hover = true;
    }
}

// CURSOR HOVER FOR EXIT BUTTONS (only if keyboard didn't just navigate to grid)
if (!skip_grid_hover) {
    if (point_in_rectangle(cursor_x, cursor_y, new_run_button_x, new_run_button_y, 
                            new_run_button_x + exit_button_width, new_run_button_y + exit_button_height)) {
        hovered_exit_button = "new_run";
        selected_exit_button = 0; // Auto-select on hover
        cursor_over_exit_button = true;
        // Clear grid selection when hovering exit button
        selected_side = "";
        selected_row = -1;
        selected_col = -1;
        if (input_check_pressed("accept")) {
            show_exit_confirmation = true;
            exit_action = "new_run";
            exit_selection = "no";
            playSFX(snd_select, 1, 1, 1);
        }
    }
    
    if (point_in_rectangle(cursor_x, cursor_y, menu_button_x, menu_button_y, 
                            menu_button_x + exit_button_width, menu_button_y + exit_button_height)) {
        hovered_exit_button = "menu";
        selected_exit_button = 1; // Auto-select on hover
        cursor_over_exit_button = true;
        // Clear grid selection when hovering exit button
        selected_side = "";
        selected_row = -1;
        selected_col = -1;
        if (input_check_pressed("accept")) {
            show_exit_confirmation = true;
            exit_action = "menu";
            exit_selection = "no";
            playSFX(snd_select, 1, 1, 1);
        }
    }
}

// Play sound when exit button selection changes via cursor hover (outside the skip check)
if (selected_exit_button != prev_selected_exit_button) {
    show_debug_message("Exit button changed from " + string(prev_selected_exit_button) + " to " + string(selected_exit_button));
    if (selected_exit_button >= 0) { // Only play when actually hovering an exit button
        show_debug_message("Playing sound");
        playSFX(snd_switch, 1, 1, 1);
    }
}
// Always update prev_selected_exit_button at the end
prev_selected_exit_button = selected_exit_button;

// Grid item cursor hover (only if not hovering exit button and not using keyboard navigation)
if (!skip_grid_hover && !cursor_over_exit_button) {
    var total_items = grid_rows * grid_cols;
    for (var i = 0; i < total_items; i++) {
        var row = i div grid_cols;
        var col = i mod grid_cols;
        
        // Skills side
        var skill_x = skills_start_x + (col * (item_size + item_spacing));
        var skill_y = skills_start_y + (row * (item_size + item_spacing));
        
        if (point_in_rectangle(cursor_x, cursor_y, skill_x, skill_y, skill_x + item_size, skill_y + item_size)) {
            // Check if selection changed
            if (selected_side != "skills" || selected_row != row || selected_col != col) {
                playSFX(snd_switch, 1, 1, 1);
            }
            
            selected_side = "skills";
            selected_row = row;
            selected_col = col;
            selected_exit_button = -1; // Deselect exit buttons
            
            if (input_check_pressed("accept") && i < array_length(skills)) {
                var skill = skills[i];
                var current_level = variable_struct_get(global.saveData, skill.saveVar);
                
                if (current_level < 5) {
                    show_confirmation = true;
                    confirmation_item = skill;
                    confirmation_type = "skill";
                    confirmation_selection = "no";
                    playSFX(snd_select, 1, 1, 1);
                }
            }
        }
        
        // Shop side
        var shop_x = shop_start_x + (col * (item_size + item_spacing));
        var shop_y = shop_start_y + (row * (item_size + item_spacing));
        
        if (point_in_rectangle(cursor_x, cursor_y, shop_x, shop_y, shop_x + item_size, shop_y + item_size)) {
            // Check if selection changed
            if (selected_side != "shop" || selected_row != row || selected_col != col) {
                playSFX(snd_switch, 1, 1, 1);
            }
            
            selected_side = "shop";
            selected_row = row;
            selected_col = col;
            selected_exit_button = -1; // Deselect exit buttons
            
            if (input_check_pressed("accept") && i < array_length(shop_items)) {
                var item = shop_items[i];
                var is_owned = variable_struct_get(global.saveData, item.saveVar);
                
                // Always show confirmation dialog, but mark as "info" if already owned
                show_confirmation = true;
                confirmation_item = item;
                confirmation_type = is_owned ? "info" : "shop";
                confirmation_selection = "no";
                playSFX(snd_select, 1, 1, 1);
            }
        }
    }
}

// Directional navigation (only when not on exit buttons)
if (selected_exit_button < 0) {
    if (input_check_pressed("up")) {
        selected_row--;
        if (selected_row < 0) selected_row = grid_rows - 1;
        prev_selected_row = selected_row;
        prev_selected_col = selected_col;
        prev_selected_side = selected_side;
        playSFX(snd_switch, 1, 1, 1);
    }
    if (input_check_pressed("down")) {
        selected_row++;
        if (selected_row >= grid_rows) {
            // Go to exit buttons when pressing down from bottom row
            if (selected_side == "shop" && selected_col == grid_cols - 1) {
                selected_exit_button = 0; // New Run
                prev_selected_exit_button = selected_exit_button;
                // Clear grid selection tracking
                selected_side = "";
                selected_row = -1;
                selected_col = -1;
                prev_selected_side = "";
                prev_selected_row = -1;
                prev_selected_col = -1;
                playSFX(snd_switch, 1, 1, 1);
            } else if (selected_side == "skills" && selected_col == 0) {
                selected_exit_button = 1; // Main Menu
                prev_selected_exit_button = selected_exit_button;
                // Clear grid selection tracking
                selected_side = "";
                selected_row = -1;
                selected_col = -1;
                prev_selected_side = "";
                prev_selected_row = -1;
                prev_selected_col = -1;
                playSFX(snd_switch, 1, 1, 1);
            } else {
                selected_row = 0;
                prev_selected_row = selected_row;
                prev_selected_col = selected_col;
                prev_selected_side = selected_side;
                playSFX(snd_switch, 1, 1, 1);
            }
        } else {
            prev_selected_row = selected_row;
            prev_selected_col = selected_col;
            prev_selected_side = selected_side;
            playSFX(snd_switch, 1, 1, 1);
        }
    }
    if (input_check_pressed("left")) {
        if (selected_side == "skills") {
            if (selected_col == 0) {
                // Go to Main Menu button
                selected_exit_button = 1;
                prev_selected_exit_button = selected_exit_button;
                // Clear grid selection tracking
                selected_side = "";
                selected_row = -1;
                selected_col = -1;
                prev_selected_side = "";
                prev_selected_row = -1;
                prev_selected_col = -1;
                playSFX(snd_switch, 1, 1, 1);
            } else {
                selected_col--;
                prev_selected_row = selected_row;
                prev_selected_col = selected_col;
                prev_selected_side = selected_side;
                playSFX(snd_switch, 1, 1, 1);
            }
        } else {
            selected_col--;
            if (selected_col < 0) {
                selected_side = "skills";
                selected_col = grid_cols - 1;
            }
            prev_selected_row = selected_row;
            prev_selected_col = selected_col;
            prev_selected_side = selected_side;
            playSFX(snd_switch, 1, 1, 1);
        }
    }
    if (input_check_pressed("right")) {
        if (selected_side == "shop") {
            if (selected_col == grid_cols - 1) {
                // Go to New Run button
                selected_exit_button = 0;
                prev_selected_exit_button = selected_exit_button;
                // Clear grid selection tracking
                selected_side = "";
                selected_row = -1;
                selected_col = -1;
                prev_selected_side = "";
                prev_selected_row = -1;
                prev_selected_col = -1;
                playSFX(snd_switch, 1, 1, 1);
            } else {
                selected_col++;
                prev_selected_row = selected_row;
                prev_selected_col = selected_col;
                prev_selected_side = selected_side;
                playSFX(snd_switch, 1, 1, 1);
            }
        } else {
            selected_col++;
            if (selected_col >= grid_cols) {
                selected_side = "shop";
                selected_col = 0;
            }
            prev_selected_row = selected_row;
            prev_selected_col = selected_col;
            prev_selected_side = selected_side;
            playSFX(snd_switch, 1, 1, 1);
        }
    }
}

// Accept on selected item
if (input_check_pressed("accept") && !show_confirmation && selected_exit_button < 0) {
    var index = (selected_row * grid_cols) + selected_col;
    
    if (selected_side == "skills") {
        if (index < array_length(skills)) {
            var skill = skills[index];
            var current_level = variable_struct_get(global.saveData, skill.saveVar);
            
            if (current_level < 5) {
                show_confirmation = true;
                confirmation_item = skill;
                confirmation_type = "skill";
                confirmation_selection = "no";
                playSFX(snd_select, 1, 1, 1);
            }
        }
    } else {
        if (index < array_length(shop_items)) {
            var item = shop_items[index];
            var is_owned = variable_struct_get(global.saveData, item.saveVar);
            
            // Always show confirmation dialog, but mark as "info" if already owned
            show_confirmation = true;
            confirmation_item = item;
            confirmation_type = is_owned ? "info" : "shop";
            confirmation_selection = "no";
            playSFX(snd_select, 1, 1, 1);
        }
    }
}

// Debug at very end
if (selected_exit_button < 0 && selected_side != "") {
    show_debug_message("END OF STEP - side:" + selected_side + " row:" + string(selected_row) + " col:" + string(selected_col));
}