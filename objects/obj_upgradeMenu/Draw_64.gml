/// obj_upgradeMenu Draw GUI Event

#region Background and Titles
// Opaque background
draw_set_color(make_color_rgb(45, 79, 153)); // #2d4f99
draw_rectangle(0, 0, menu_width, menu_height, false);

// Section titles
draw_set_font(Title);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(menu_width * 0.25, 220, "Shop");
draw_text(menu_width * 0.75, 220, "Skills");

// Resource displays 50px above grids (grids start at 420, so resources at 370)
draw_set_font(Font1);
draw_text(menu_width * 0.25, 370, "Gold: " + string(global.gold));
var pc = instance_find(obj_pc, 0);
if (pc != noone) {
    draw_text(menu_width * 0.75, 370, "XP: " + string(pc.heroXP));
}
#endregion

#region Shop Grid (Left Side)
for (var i = 0; i < array_length(shop_items); i++) {
    var row = i div grid_cols;
    var col = i mod grid_cols;
    var item_x = shop_start_x + (col * (item_size + item_spacing));
    var item_y = shop_start_y + (row * (item_size + item_spacing));
    
    var is_selected = (selected_side == "shop" && selected_row == row && selected_col == col);
    var item = shop_items[i];
    
    // Check if item is already owned
    var is_owned = false;
    if (item.saveVar != "") {
        is_owned = variable_struct_get(global.saveData, item.saveVar);
    }
    
    // Draw selection highlight background (semi-transparent yellow)
    if (is_selected) {
        draw_set_color(c_yellow);
        draw_set_alpha(0.3);
        draw_rectangle(item_x, item_y, item_x + item_size, item_y + item_size, false);
        draw_set_alpha(1);
    }
    
    // Draw item sprite (centered in box)
    if (item.sprite != noone) {
	    var _decal = 0;
	    if col == 0
		_decal = 1;
        if (is_owned) {
            // Draw darkened sprite for owned items
            draw_sprite_ext(item.sprite, 0, item_x + item_size/2 + _decal, item_y + item_size/2, 1, 1, 0, c_gray, 0.5);
            // Draw "OWNED" text over the sprite
            draw_set_color(c_white);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(item_x + item_size/2, item_y + item_size/2, "OWNED");
        } else {
            // Draw normal sprite for unowned items
            draw_sprite(item.sprite, 0, item_x + item_size/2 + _decal, item_y + item_size/2);
        }
    }
    
    // Draw box border (thicker for selected, green for owned)
    if (is_selected) {
        draw_set_color(c_yellow);
        // Draw thick border by drawing 3 rectangles
        draw_rectangle(item_x, item_y, item_x + item_size, item_y + item_size, true);
        draw_rectangle(item_x + 1, item_y + 1, item_x + item_size - 1, item_y + item_size - 1, true);
        draw_rectangle(item_x + 2, item_y + 2, item_x + item_size - 2, item_y + item_size - 2, true);
    } else if (is_owned) {
        draw_set_color(c_green);
        draw_rectangle(item_x, item_y, item_x + item_size, item_y + item_size, true);
    } else {
        draw_set_color(c_white);
        draw_rectangle(item_x, item_y, item_x + item_size, item_y + item_size, true);
    }
}
#endregion

#region Skills Grid (Right Side)
for (var i = 0; i < array_length(skills); i++) {
    var skill = skills[i];
    var row = i div grid_cols;
    var col = i mod grid_cols;
    var item_x = skills_start_x + (col * (item_size + item_spacing));
    var item_y = skills_start_y + (row * (item_size + item_spacing));
    
    var is_selected = (selected_side == "skills" && selected_row == row && selected_col == col);
    var current_level = variable_struct_get(global.saveData, skill.saveVar);
    var is_maxed = (current_level >= 5);
    
    // Draw selection highlight background (semi-transparent yellow)
    if (is_selected) {
        draw_set_color(c_yellow);
        draw_set_alpha(0.3);
        draw_rectangle(item_x, item_y, item_x + item_size, item_y + item_size, false);
        draw_set_alpha(1);
    }
    
    // Draw box border (thicker for selected)
    if (is_selected) {
        draw_set_color(c_yellow);
        // Draw thick border by drawing 3 rectangles
        draw_rectangle(item_x, item_y, item_x + item_size, item_y + item_size, true);
        draw_rectangle(item_x + 1, item_y + 1, item_x + item_size - 1, item_y + item_size - 1, true);
        draw_rectangle(item_x + 2, item_y + 2, item_x + item_size - 2, item_y + item_size - 2, true);
    } else {
        draw_set_color(c_white);
        draw_rectangle(item_x, item_y, item_x + item_size, item_y + item_size, true);
    }
    
    // Draw skill name
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text(item_x + item_size/2, item_y + 5, skill.name);
    
    // Calculate next bonus display
    if (is_maxed) {
        // Show max indicator
        draw_set_valign(fa_middle);
        draw_text(item_x + item_size/2, item_y + item_size/2, "(Max)");
    } else {
        // All lines use fa_top for consistent spacing
        draw_set_valign(fa_top);
        
        // Line 2: Bonus display
        draw_text(item_x + item_size/2, item_y + 40, skill.displayBonus);
        
        // Line 3: Level progress
        draw_text(item_x + item_size/2, item_y + 75, "(" + string(current_level) + "/5)");
        
        // Line 4: Cost
        var cost = skill.cost[current_level];
        draw_text(item_x + item_size/2, item_y + 110, string(cost) + " XP");
    }
}
#endregion

#region Exit Buttons
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// New Run button
var new_run_highlighted = (hovered_exit_button == "new_run" || selected_exit_button == 0);

// Draw selection highlight background (semi-transparent yellow)
if (new_run_highlighted) {
    draw_set_color(c_yellow);
    draw_set_alpha(0.3);
    draw_rectangle(new_run_button_x, new_run_button_y, new_run_button_x + exit_button_width, new_run_button_y + exit_button_height, false);
    draw_set_alpha(1);
}

// Draw box border (thicker for selected)
if (new_run_highlighted) {
    draw_set_color(c_yellow);
    // Draw thick border by drawing 3 rectangles
    draw_rectangle(new_run_button_x, new_run_button_y, new_run_button_x + exit_button_width, new_run_button_y + exit_button_height, true);
    draw_rectangle(new_run_button_x + 1, new_run_button_y + 1, new_run_button_x + exit_button_width - 1, new_run_button_y + exit_button_height - 1, true);
    draw_rectangle(new_run_button_x + 2, new_run_button_y + 2, new_run_button_x + exit_button_width - 2, new_run_button_y + exit_button_height - 2, true);
} else {
    draw_set_color(c_white);
    draw_rectangle(new_run_button_x, new_run_button_y, new_run_button_x + exit_button_width, new_run_button_y + exit_button_height, true);
}

// Draw text
draw_set_color(c_white);
draw_text(new_run_button_x + exit_button_width/2, new_run_button_y + exit_button_height/2, "Start New Run");

// Main Menu button
var menu_highlighted = (hovered_exit_button == "menu" || selected_exit_button == 1);

// Draw selection highlight background (semi-transparent yellow)
if (menu_highlighted) {
    draw_set_color(c_yellow);
    draw_set_alpha(0.3);
    draw_rectangle(menu_button_x, menu_button_y, menu_button_x + exit_button_width, menu_button_y + exit_button_height, false);
    draw_set_alpha(1);
}

// Draw box border (thicker for selected)
if (menu_highlighted) {
    draw_set_color(c_yellow);
    // Draw thick border by drawing 3 rectangles
    draw_rectangle(menu_button_x, menu_button_y, menu_button_x + exit_button_width, menu_button_y + exit_button_height, true);
    draw_rectangle(menu_button_x + 1, menu_button_y + 1, menu_button_x + exit_button_width - 1, menu_button_y + exit_button_height - 1, true);
    draw_rectangle(menu_button_x + 2, menu_button_y + 2, menu_button_x + exit_button_width - 2, menu_button_y + exit_button_height - 2, true);
} else {
    draw_set_color(c_white);
    draw_rectangle(menu_button_x, menu_button_y, menu_button_x + exit_button_width, menu_button_y + exit_button_height, true);
}

// Draw text
draw_set_color(c_white);
draw_text(menu_button_x + exit_button_width/2, menu_button_y + exit_button_height/2, "Main Menu");
#endregion

#region Purchase Confirmation Popup
if (show_confirmation) {
    var conf_width = 600;
    var conf_height = 230;
    var conf_x = (menu_width / 2) - (conf_width / 2);
    var conf_y = (menu_height / 2) - (conf_height / 2);
    
    // Semi-transparent overlay
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, menu_width, menu_height, false);
    draw_set_alpha(1);
    
    // Confirmation box
    draw_set_color(c_black);
    draw_rectangle(conf_x, conf_y, conf_x + conf_width, conf_y + conf_height, false);
    draw_set_color(c_white);
    draw_rectangle(conf_x, conf_y, conf_x + conf_width, conf_y + conf_height, true);
    
    // Text
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    
    if (confirmation_type == "skill") {
        var skill = confirmation_item;
        var current_level = variable_struct_get(global.saveData, skill.saveVar);
        var cost = skill.cost[current_level];
        
        draw_text(conf_x + conf_width/2, conf_y + 20, "Purchase " + skill.name + " upgrade?");
        draw_text(conf_x + conf_width/2, conf_y + 60, "Cost: " + string(cost) + " XP");
        draw_text(conf_x + conf_width/2, conf_y + 90, "Level " + string(current_level) + " -> " + string(current_level + 1));
    } else if (confirmation_type == "shop") {
        draw_text(conf_x + conf_width/2, conf_y + 20, confirmation_item.name);
        draw_text_ext(conf_x + conf_width/2, conf_y + 60, confirmation_item.description, -1, conf_width - 40);
        draw_text(conf_x + conf_width/2, conf_y + 130, "Purchase for " + string(confirmation_item.cost) + " Gold?");
    } else if (confirmation_type == "info") {
        // Just showing info for owned item
        draw_text(conf_x + conf_width/2, conf_y + 20, confirmation_item.name);
        draw_set_valign(fa_middle);
        draw_text_ext(conf_x + conf_width/2, conf_y + conf_height/2, confirmation_item.description, -1, conf_width - 40);
        
        // Show OWNED status
        draw_set_valign(fa_bottom);
        draw_set_color(c_green);
        draw_text(conf_x + conf_width/2, conf_y + conf_height - 20, "OWNED");
        draw_set_color(c_white);
    }
    
    // Yes/No buttons (only for shop and skill purchases, not info)
    if (confirmation_type != "info") {
        var button_width = 100;
        var button_height = 40;
        var button_y = conf_y + conf_height - button_height - 20;
        var no_x = conf_x + conf_width / 2 - button_width - 10;
        var yes_x = conf_x + conf_width / 2 + 10;
        
        draw_set_valign(fa_middle);
        
        // No button
        draw_set_color(confirmation_selection == "no" ? c_yellow : c_white);
        draw_rectangle(no_x, button_y, no_x + button_width, button_y + button_height, true);
        draw_set_color(c_white);
        draw_text(no_x + button_width/2, button_y + button_height/2, "No");
        
        // Yes button
        draw_set_color(confirmation_selection == "yes" ? c_yellow : c_white);
        draw_rectangle(yes_x, button_y, yes_x + button_width, button_y + button_height, true);
        draw_set_color(c_white);
        draw_text(yes_x + button_width/2, button_y + button_height/2, "Yes");
    }
}
#endregion

#region Exit Confirmation Popup
if (show_exit_confirmation) {
    var conf_width = 400;
    var conf_height = 150;
    var conf_x = (menu_width / 2) - (conf_width / 2);
    var conf_y = (menu_height / 2) - (conf_height / 2);
    
    // Semi-transparent overlay
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, menu_width, menu_height, false);
    draw_set_alpha(1);
    
    // Confirmation box
    draw_set_color(c_black);
    draw_rectangle(conf_x, conf_y, conf_x + conf_width, conf_y + conf_height, false);
    draw_set_color(c_white);
    draw_rectangle(conf_x, conf_y, conf_x + conf_width, conf_y + conf_height, true);
    
    // Text
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text(conf_x + conf_width/2, conf_y + 20, "Are you sure?");
    
    // Yes/No buttons
    var button_width = 100;
    var button_height = 40;
    var button_y = conf_y + conf_height - button_height - 20;
    var no_x = conf_x + conf_width / 2 - button_width - 10;
    var yes_x = conf_x + conf_width / 2 + 10;
    
    draw_set_valign(fa_middle);
    
    // No button
    draw_set_color(exit_selection == "no" ? c_yellow : c_white);
    draw_rectangle(no_x, button_y, no_x + button_width, button_y + button_height, true);
    draw_set_color(c_white);
    draw_text(no_x + button_width/2, button_y + button_height/2, "No");
    
    // Yes button
    draw_set_color(exit_selection == "yes" ? c_yellow : c_white);
    draw_rectangle(yes_x, button_y, yes_x + button_width, button_y + button_height, true);
    draw_set_color(c_white);
    draw_text(yes_x + button_width/2, button_y + button_height/2, "Yes");
}
#endregion

#region Error Message
if (show_error_message) {
    var error_width = 600;
    var error_height = 100;
    var error_x = (menu_width / 2) - (error_width / 2);
    var error_y = (menu_height / 2) - (error_height / 2);
    
    // Semi-transparent overlay
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, menu_width, menu_height, false);
    draw_set_alpha(1);
    
    // Error box
    draw_set_color(c_black);
    draw_rectangle(error_x, error_y, error_x + error_width, error_y + error_height, false);
    draw_set_color(c_red);
    draw_rectangle(error_x, error_y, error_x + error_width, error_y + error_height, true);
    
    // Error text
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Determine error message based on type
    var error_text = "";
    if (error_type == "skill") {
        error_text = "You do not have the required\namount of XP to unlock this upgrade";
    } else {
        error_text = "You do not have the required\namount of Gold to purchase this item";
    }
    draw_text(error_x + error_width/2, error_y + error_height/2, error_text);
}
#endregion

#region Reset Draw Settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
#endregion