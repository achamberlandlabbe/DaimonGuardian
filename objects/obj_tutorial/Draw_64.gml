/// obj_tutorial Draw GUI Event
// Draw semi-transparent dark background (same as lighting system)
draw_set_color(c_black);
draw_set_alpha(0.6); // Match the lighting system's darkness level
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);
draw_set_color(c_white);

// Draw page counter centered above the text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var total_pages = array_length(tutorial_text);
var page_counter = string(current_screen + 1) + "/" + string(total_pages);
draw_set_alpha(0.7);
draw_text(display_get_gui_width()/2, display_get_gui_height()/2 - 100, page_counter);
draw_set_alpha(1);

// Draw tutorial text centered
draw_text(display_get_gui_width()/2, display_get_gui_height()/2, tutorial_text[current_screen]);

// Prompt to continue (keep centered alignment)
draw_set_alpha(0.5);
draw_text(display_get_gui_width()/2, display_get_gui_height() - 50, "Press " + get_button_name("accept") + " to continue");
draw_set_alpha(1);

// Reset alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);