/// obj_victory Draw GUI Event - Guardian Daimon
// Game Over / Victory Screen
// This draws on the GUI layer (always visible on screen)

// Semi-transparent black overlay
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

// Determine if victory or defeat
var is_victory = false; // You can set this based on a victory condition
var title_text = is_victory ? "VICTORY!" : "GAME OVER";
var title_color = is_victory ? c_lime : c_red;

// Draw title
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(Title); // Make sure you have this font, or use -1 for default

// Title shadow
draw_set_color(c_black);
draw_text(display_get_gui_width()/2 + 4, display_get_gui_height()/2 - 100 + 4, title_text);

// Title
draw_set_color(title_color);
draw_text(display_get_gui_width()/2, display_get_gui_height()/2 - 100, title_text);

// Menu options
draw_set_font(Font1);
var menu_y = display_get_gui_height()/2 + 50; // Move down from title
var spacing = 60; // Increase spacing for better visibility

// Safety check - ensure menu_options exists (Create event may not have run yet)
if (!variable_instance_exists(id, "menu_options")) {
    draw_set_color(c_red);
    draw_text(100, 100, "ERROR: menu_options not initialized!");
    exit;
}

// Draw menu options
show_debug_message("Drawing " + string(array_length(menu_options)) + " menu options");
for (var i = 0; i < array_length(menu_options); i++) {
    var y_pos = menu_y + (i * spacing);
    
    // Highlight selected option
    if (i == selected_option) {
        draw_set_color(c_yellow);
    } else {
        draw_set_color(c_white);
    }
    
    draw_text(display_get_gui_width()/2, y_pos, menu_options[i]);
}

// Draw action prompt at bottom
draw_set_color(c_gray);
var action_button = input_binding_get_name("accept");
draw_text(display_get_gui_width()/2, display_get_gui_height() - 50, "Press " + action_button + " to confirm");

// Reset alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);