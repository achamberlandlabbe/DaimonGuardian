/// obj_enchantmentMenu Step Event

#region Options Menu Check
// Don't process input if options menu is open
if (instance_exists(obj_options)) {
    exit;
}
#endregion

#region Enchantment Sorting
// Sort enchantments: affordable first (alphabetically), then unaffordable (alphabetically)
var affordable = [];
var unaffordable = [];

for (var i = 0; i < array_length(enchantments); i++) {
    var enchant = enchantments[i];
    
    // Check if player has ALL components
    var has_all = true;
    for (var c = 0; c < array_length(enchant.cost); c++) {
        var cost_item = enchant.cost[c];
        var owned_amount = 0;
        if (instance_exists(obj_gameManager)) {
            owned_amount = variable_struct_get(obj_gameManager.inventory, cost_item.inventory_key);
        }
        if (owned_amount < cost_item.amount) {
            has_all = false;
            break;
        }
    }
    
    if (has_all) {
        array_push(affordable, enchant);
    } else {
        array_push(unaffordable, enchant);
    }
}

// Sort both arrays alphabetically
array_sort(affordable, function(a, b) {
    if (a.name < b.name) return -1;
    if (a.name > b.name) return 1;
    return 0;
});

array_sort(unaffordable, function(a, b) {
    if (a.name < b.name) return -1;
    if (a.name > b.name) return 1;
    return 0;
});

// Rebuild enchantments array: affordable first, then unaffordable
enchantments = array_concat(affordable, unaffordable);
#endregion

#region Mouse Wheel Scrolling
// Mouse wheel scrolling
var enchantment_count = array_length(enchantments);
if (mouse_wheel_up() && selectedEnchantment > 0) {
    selectedEnchantment--;
    playSFX(snd_switch, 1, 1, 1);
}
if (mouse_wheel_down() && selectedEnchantment < enchantment_count - 1) {
    selectedEnchantment++;
    playSFX(snd_switch, 1, 1, 1);
}
#endregion

#region Confirmation Dialog
if (showConfirmation) {
    #region Confirmation Cursor Hover
    // Cursor-based selection for Yes/No confirmation
    var cursor = instance_find(obj_cursor, 0);
    if (cursor != noone) {
        // Calculate menu dimensions with extra 100px width
        var display_menu_x = menu_x - 50;
        var display_menu_width = menu_width + 100;
        
        var confirm_width = 700;
        var confirm_height = 150;
        var confirm_x = (display_get_gui_width() - confirm_width) / 2;
        var confirm_y = (display_get_gui_height() - confirm_height) / 2;
        
        var button_y = confirm_y + confirm_height - 50;
        var button_spacing = 150;
        var yes_x = confirm_x + confirm_width/2 - button_spacing/2;
        var no_x = confirm_x + confirm_width/2 + button_spacing/2;
        
        draw_set_font(Font1);
        var yes_width = string_width("Yes");
        var no_width = string_width("No");
        var button_height = string_height("Yes");
        
        // Check Yes button (with padding)
        if (cursor.x >= yes_x - 20 && cursor.x <= yes_x + yes_width + 20 &&
            cursor.y >= button_y - 10 && cursor.y <= button_y + button_height + 10) {
            confirmSelection = 0;
        }
        
        // Check No button (with padding)
        if (cursor.x >= no_x - 20 && cursor.x <= no_x + no_width + 20 &&
            cursor.y >= button_y - 10 && cursor.y <= button_y + button_height + 10) {
            confirmSelection = 1;
        }
    }
    #endregion
    
    #region Confirmation Hover Sound
    // Play sound when confirmation selection changes via cursor hover
    if (confirmSelection != prev_confirmSelection) {
        playSFX(snd_switch, 1, 1, 1);
        prev_confirmSelection = confirmSelection;
    }
    #endregion
    
    #region Confirmation Navigation
    // Confirmation dialog is active - navigate Yes/No with directional keys
    if (input_check_pressed("left") && confirmSelection > 0) {
        confirmSelection--;
        playSFX(snd_switch, 1, 1, 1);
    }
    if (input_check_pressed("right") && confirmSelection < 1) {
        confirmSelection++;
        playSFX(snd_switch, 1, 1, 1);
    }
    #endregion
    
    #region Confirmation Accept
    // Accept choice
    if (input_check_pressed("accept")) {
        if (confirmSelection == 0) {
            // Yes - cast the enchantment
            var selected_enchantment = enchantments[selectedEnchantment];
            
            // Deduct components from inventory
            for (var i = 0; i < array_length(selected_enchantment.cost); i++) {
                var cost_item = selected_enchantment.cost[i];
                var current_amount = variable_struct_get(obj_gameManager.inventory, cost_item.inventory_key);
                variable_struct_set(obj_gameManager.inventory, cost_item.inventory_key, current_amount - cost_item.amount);
            }
            
            // Play purchase sound
            playSFX(snd_shopBuy, 1, 1, 1);
            
            // Cast the enchantment based on which one was selected
            // Create enchantments controller if it doesn't exist
            if (!instance_exists(obj_enchantments)) {
                instance_create_depth(0, 0, 0, obj_enchantments);
            }
            
            // Determine base enchantment name (remove " II" or " III" suffix if present)
            var base_name = selected_enchantment.name;
            var enchant_level = 1;
            if (string_pos(" III", base_name) > 0) {
                base_name = string_replace(base_name, " III", "");
                enchant_level = 3;
            } else if (string_pos(" II", base_name) > 0) {
                base_name = string_replace(base_name, " II", "");
                enchant_level = 2;
            }
            
            switch(base_name) {
                case "Biting Gale":
                    obj_enchantments.bitingGale = true;
                    if (enchant_level == 1) {
                        ownedEnchantments.bitingGale = 1;
                        obj_enchantments.bitingGaleLevel = 1;
                        obj_enchantments.bitingGaleTotalTeeth = 5;
                        // Remove Level 1 from list
                        for (var i = 0; i < array_length(enchantments); i++) {
                            if (enchantments[i].name == "Biting Gale") {
                                array_delete(enchantments, i, 1);
                                if (selectedEnchantment >= array_length(enchantments)) {
                                    selectedEnchantment = max(0, array_length(enchantments) - 1);
                                }
                                break;
                            }
                        }
                        // Add Level 2 to list
                        array_push(enchantments, enchantmentsLevel2.bitingGale);
                    } else if (enchant_level == 2) {
                        ownedEnchantments.bitingGale = 2;
                        // Upgrade to Level 2 effect
                        obj_enchantments.bitingGaleLevel = 2;
                        obj_enchantments.bitingGaleTotalTeeth = 6;
                        // Remove Level 2 from list
                        for (var i = 0; i < array_length(enchantments); i++) {
                            if (enchantments[i].name == "Biting Gale II") {
                                array_delete(enchantments, i, 1);
                                if (selectedEnchantment >= array_length(enchantments)) {
                                    selectedEnchantment = max(0, array_length(enchantments) - 1);
                                }
                                break;
                            }
                        }
                        // Add Level 3 to list
                        array_push(enchantments, enchantmentsLevel3.bitingGale);
                    } else if (enchant_level == 3) {
                        ownedEnchantments.bitingGale = 3;
                        // Upgrade to Level 3 effect
                        obj_enchantments.bitingGaleLevel = 3;
                        obj_enchantments.bitingGaleTotalTeeth = 7;
                        // Remove Level 3 from list
                        for (var i = 0; i < array_length(enchantments); i++) {
                            if (enchantments[i].name == "Biting Gale III") {
                                array_delete(enchantments, i, 1);
                                if (selectedEnchantment >= array_length(enchantments)) {
                                    selectedEnchantment = max(0, array_length(enchantments) - 1);
                                }
                                break;
                            }
                        }
                    }
                    break;
                    
                case "Noxious Cloud":
                    obj_enchantments.noxiousCloud = true;
                    if (enchant_level == 1) {
                        ownedEnchantments.noxiousCloud = 1;
                        obj_enchantments.noxiousCloudLevel = 1;
                        // Remove Level 1 from list
                        for (var i = 0; i < array_length(enchantments); i++) {
                            if (enchantments[i].name == "Noxious Cloud") {
                                array_delete(enchantments, i, 1);
                                if (selectedEnchantment >= array_length(enchantments)) {
                                    selectedEnchantment = max(0, array_length(enchantments) - 1);
                                }
                                break;
                            }
                        }
                        // Add Level 2 to list
                        array_push(enchantments, enchantmentsLevel2.noxiousCloud);
                    } else if (enchant_level == 2) {
                        ownedEnchantments.noxiousCloud = 2;
                        // Upgrade to Level 2 effect
                        obj_enchantments.noxiousCloudLevel = 2;
                        // Remove Level 2 from list
                        for (var i = 0; i < array_length(enchantments); i++) {
                            if (enchantments[i].name == "Noxious Cloud II") {
                                array_delete(enchantments, i, 1);
                                if (selectedEnchantment >= array_length(enchantments)) {
                                    selectedEnchantment = max(0, array_length(enchantments) - 1);
                                }
                                break;
                            }
                        }
                        // Add Level 3 to list
                        array_push(enchantments, enchantmentsLevel3.noxiousCloud);
                    } else if (enchant_level == 3) {
                        ownedEnchantments.noxiousCloud = 3;
                        // Upgrade to Level 3 effect
                        obj_enchantments.noxiousCloudLevel = 3;
                        // Remove Level 3 from list
                        for (var i = 0; i < array_length(enchantments); i++) {
                            if (enchantments[i].name == "Noxious Cloud III") {
                                array_delete(enchantments, i, 1);
                                if (selectedEnchantment >= array_length(enchantments)) {
                                    selectedEnchantment = max(0, array_length(enchantments) - 1);
                                }
                                break;
                            }
                        }
                    }
                    break;
                    
                case "Preemptive Lash":
                    obj_enchantments.preemptiveLash = true;
                    if (enchant_level == 1) {
                        ownedEnchantments.preemptiveLash = 1;
                        // Remove Level 1 from list
                        for (var i = 0; i < array_length(enchantments); i++) {
                            if (enchantments[i].name == "Preemptive Lash") {
                                array_delete(enchantments, i, 1);
                                if (selectedEnchantment >= array_length(enchantments)) {
                                    selectedEnchantment = max(0, array_length(enchantments) - 1);
                                }
                                break;
                            }
                        }
                        // Add Level 2 to list
                        array_push(enchantments, enchantmentsLevel2.preemptiveLash);
                    } else if (enchant_level == 2) {
                        ownedEnchantments.preemptiveLash = 2;
                        // Upgrade to Level 2 effect
                        obj_enchantments.preemptiveLashLevel = 2;
                        obj_enchantments.preemptiveLashRange = 500;
                        // Remove Level 2 from list
                        for (var i = 0; i < array_length(enchantments); i++) {
                            if (enchantments[i].name == "Preemptive Lash II") {
                                array_delete(enchantments, i, 1);
                                if (selectedEnchantment >= array_length(enchantments)) {
                                    selectedEnchantment = max(0, array_length(enchantments) - 1);
                                }
                                break;
                            }
                        }
                        // Add Level 3 to list
                        array_push(enchantments, enchantmentsLevel3.preemptiveLash);
                    } else if (enchant_level == 3) {
                        ownedEnchantments.preemptiveLash = 3;
                        // Upgrade to Level 3 effect
                        obj_enchantments.preemptiveLashLevel = 3;
                        obj_enchantments.preemptiveLashRange = 600;
                        // Remove Level 3 from list
                        for (var i = 0; i < array_length(enchantments); i++) {
                            if (enchantments[i].name == "Preemptive Lash III") {
                                array_delete(enchantments, i, 1);
                                if (selectedEnchantment >= array_length(enchantments)) {
                                    selectedEnchantment = max(0, array_length(enchantments) - 1);
                                }
                                break;
                            }
                        }
                    }
                    break;
                    
                case "Barbed Bindings":
                    obj_enchantments.barbedBindings = true;
                    if (enchant_level == 1) {
                        ownedEnchantments.barbedBindings = 1;
                        // Remove Level 1 from list
                        for (var i = 0; i < array_length(enchantments); i++) {
                            if (enchantments[i].name == "Barbed Bindings") {
                                array_delete(enchantments, i, 1);
                                if (selectedEnchantment >= array_length(enchantments)) {
                                    selectedEnchantment = max(0, array_length(enchantments) - 1);
                                }
                                break;
                            }
                        }
                        // Add Level 2 to list
                        array_push(enchantments, enchantmentsLevel2.barbedBindings);
                    } else if (enchant_level == 2) {
                        ownedEnchantments.barbedBindings = 2;
                        // Upgrade to Level 2 effect
                        obj_enchantments.barbedBindingsLevel = 2;
                        obj_enchantments.barbedBindingsMaxDuration = 720; // 12 seconds
                        // Remove Level 2 from list
                        for (var i = 0; i < array_length(enchantments); i++) {
                            if (enchantments[i].name == "Barbed Bindings II") {
                                array_delete(enchantments, i, 1);
                                if (selectedEnchantment >= array_length(enchantments)) {
                                    selectedEnchantment = max(0, array_length(enchantments) - 1);
                                }
                                break;
                            }
                        }
                        // Add Level 3 to list
                        array_push(enchantments, enchantmentsLevel3.barbedBindings);
                    } else if (enchant_level == 3) {
                        ownedEnchantments.barbedBindings = 3;
                        // Upgrade to Level 3 effect
                        obj_enchantments.barbedBindingsLevel = 3;
                        obj_enchantments.barbedBindingsMaxDuration = 840; // 14 seconds
                        // Remove Level 3 from list
                        for (var i = 0; i < array_length(enchantments); i++) {
                            if (enchantments[i].name == "Barbed Bindings III") {
                                array_delete(enchantments, i, 1);
                                if (selectedEnchantment >= array_length(enchantments)) {
                                    selectedEnchantment = max(0, array_length(enchantments) - 1);
                                }
                                break;
                            }
                        }
                    }
                    break;
                    
                case "Hex Ward":
                    obj_enchantments.hexWard = true;
                    if (enchant_level == 1) {
                        ownedEnchantments.hexWard = 1;
                        obj_enchantments.hexWardLevel = 1;
                        // Remove Level 1 from list
                        for (var i = 0; i < array_length(enchantments); i++) {
                            if (enchantments[i].name == "Hex Ward") {
                                array_delete(enchantments, i, 1);
                                if (selectedEnchantment >= array_length(enchantments)) {
                                    selectedEnchantment = max(0, array_length(enchantments) - 1);
                                }
                                break;
                            }
                        }
                        // Add Level 2 to list
                        array_push(enchantments, enchantmentsLevel2.hexWard);
                    } else if (enchant_level == 2) {
                        ownedEnchantments.hexWard = 2;
                        // Upgrade to Level 2 effect
                        obj_enchantments.hexWardLevel = 2;
                        // Remove Level 2 from list
                        for (var i = 0; i < array_length(enchantments); i++) {
                            if (enchantments[i].name == "Hex Ward II") {
                                array_delete(enchantments, i, 1);
                                if (selectedEnchantment >= array_length(enchantments)) {
                                    selectedEnchantment = max(0, array_length(enchantments) - 1);
                                }
                                break;
                            }
                        }
                        // Add Level 3 to list
                        array_push(enchantments, enchantmentsLevel3.hexWard);
                    } else if (enchant_level == 3) {
                        ownedEnchantments.hexWard = 3;
                        // Upgrade to Level 3 effect
                        obj_enchantments.hexWardLevel = 3;
                        // Remove Level 3 from list
                        for (var i = 0; i < array_length(enchantments); i++) {
                            if (enchantments[i].name == "Hex Ward III") {
                                array_delete(enchantments, i, 1);
                                if (selectedEnchantment >= array_length(enchantments)) {
                                    selectedEnchantment = max(0, array_length(enchantments) - 1);
                                }
                                break;
                            }
                        }
                    }
                    break;
            }
            
            // Hide confirmation dialog and return to menu
            showConfirmation = false;
            confirmSelection = 1; // Reset to No
        } else {
            // No - cancel confirmation
            playSFX(snd_select, 1, 1, 1);
            showConfirmation = false;
            confirmSelection = 1; // Reset to No
        }
    }
    #endregion
    
    #region Confirmation Cancel
    // Cancel button also cancels confirmation
    if (input_check_pressed("back")) {
        playSFX(snd_select, 1, 1, 1);
        showConfirmation = false;
        confirmSelection = 1;
    }
    #endregion
    
} else {
    // Normal navigation mode
    
    #region Cursor-Based Enchantment Selection
    // Cursor-based selection for enchantments
    var cursor = instance_find(obj_cursor, 0);
    if (cursor != noone) {
        // Calculate menu dimensions with extra 100px width
        var display_menu_x = menu_x - 50;
        var display_menu_width = menu_width + 100;
        
        // Right column for enchantments (matching Draw GUI calculations)
        var enchant_x = display_menu_x + (display_menu_width / 2) + 20;
        var inventory_y = menu_y + 170;
        var ench_y = inventory_y + 60;
        var enchant_width = (display_menu_width / 2) - 60;
        
        var max_visible = 2;
        var scroll_start = selectedEnchantment;
        
        // Check each visible enchantment's bounding box
        for (var e = scroll_start; e < min(scroll_start + max_visible, array_length(enchantments)); e++) {
            var ench_start_y = ench_y - 10;
            var item_height = 120; // Approximate height per enchantment
            
            // Adjust height if this is the selected one (has description)
            if (e == selectedEnchantment) {
                var enchant = enchantments[e];
                draw_set_font(Font1);
                var desc_height = string_height_ext(enchant.description, -1, enchant_width);
                item_height = 120 + desc_height;
            }
            
            // Check if cursor is inside this enchantment's rectangle
            if (cursor.x >= enchant_x - 10 && cursor.x <= enchant_x + enchant_width + 10 &&
                cursor.y >= ench_start_y && cursor.y <= ench_start_y + item_height) {
                selectedEnchantment = e;
                break;
            }
            
            ench_y += item_height + 30;
        }
        
        // Scrollbar dragging
        if (array_length(enchantments) > max_visible) {
            var scrollbar_x = enchant_x + enchant_width + 20;
            var scrollbar_y = inventory_y + 55;
            var scrollbar_height = 350;
            var scrollbar_width = 8;
            
            // Check if cursor is over scrollbar
            if (cursor.x >= scrollbar_x && cursor.x <= scrollbar_x + scrollbar_width &&
                cursor.y >= scrollbar_y && cursor.y <= scrollbar_y + scrollbar_height) {
                
                // If mouse button is held, update scroll position
                if (mouse_check_button(mb_left)) {
                    var relative_y = cursor.y - scrollbar_y;
                    var scroll_percent = clamp(relative_y / scrollbar_height, 0, 1);
                    selectedEnchantment = floor(scroll_percent * (array_length(enchantments) - 1));
                }
            }
        }
    }
    #endregion
    
    #region Enchantment Hover Sound
    // Play sound when enchantment selection changes via cursor hover
    if (selectedEnchantment != prev_selectedEnchantment) {
        playSFX(snd_switch, 1, 1, 1);
        prev_selectedEnchantment = selectedEnchantment;
    }
    #endregion
    
    #region Keyboard Navigation
	// Navigate enchantments with directional keys (up/down)
	var enchantment_count = array_length(enchantments);
	
	if (input_check_pressed("up") && selectedEnchantment > 0) {
	    selectedEnchantment--;
	    prev_selectedEnchantment = selectedEnchantment; // Update prev to prevent double sound
	    playSFX(snd_switch, 1, 1, 1);
	}
	
	if (input_check_pressed("down") && selectedEnchantment < enchantment_count - 1) {
	    selectedEnchantment++;
	    prev_selectedEnchantment = selectedEnchantment; // Update prev to prevent double sound
	    playSFX(snd_switch, 1, 1, 1);
	}
	#endregion
    
    #region Enchantment Casting
    // Try to cast selected enchantment
    if (input_check_pressed("accept")) {
        // Check if cursor is over scrollbar - if so, don't cast
        var cursor = instance_find(obj_cursor, 0);
        var cursor_over_scrollbar = false;
        
        if (cursor != noone && array_length(enchantments) > 2) {
            // Calculate scrollbar position (matching Draw GUI calculations)
            var display_menu_x = menu_x - 50;
            var display_menu_width = menu_width + 100;
            var enchant_x = display_menu_x + (display_menu_width / 2) + 20;
            var enchant_width = (display_menu_width / 2) - 60;
            var inventory_y = menu_y + 170;
            
            var scrollbar_x = enchant_x + enchant_width + 20;
            var scrollbar_y = inventory_y + 55;
            var scrollbar_height = 350;
            var scrollbar_width = 8;
            
            // Check if cursor is over scrollbar
            if (cursor.x >= scrollbar_x && cursor.x <= scrollbar_x + scrollbar_width &&
                cursor.y >= scrollbar_y && cursor.y <= scrollbar_y + scrollbar_height) {
                cursor_over_scrollbar = true;
            }
        }
        
        // Only proceed with casting if not over scrollbar
        if (!cursor_over_scrollbar) {
            // Check if player has all required components
            var selected_enchantment = enchantments[selectedEnchantment];
            var has_all_components = true;
            
            for (var i = 0; i < array_length(selected_enchantment.cost); i++) {
                var cost_item = selected_enchantment.cost[i];
                var owned_amount = 0;
                
                if (instance_exists(obj_gameManager)) {
                    owned_amount = variable_struct_get(obj_gameManager.inventory, cost_item.inventory_key);
                }
                
                if (owned_amount < cost_item.amount) {
                    has_all_components = false;
                    break;
                }
            }
            
            if (has_all_components) {
                // Show confirmation dialog
                playSFX(snd_select, 1, 1, 1);
                showConfirmation = true;
                confirmSelection = 1; // Default to No
            } else {
                // Show error message for 3 seconds
                playSFX(snd_select, 1, 1, 1);
                errorMessageTimer = 180;
            }
        }
    }
    #endregion
}
#endregion

#region Error Message Timer
// Count down error message timer
if (errorMessageTimer > 0) {
    errorMessageTimer--;
}
#endregion