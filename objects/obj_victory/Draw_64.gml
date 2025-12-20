/// obj_victory Draw GUI Event
// Get display dimensions
var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();
var center_x = gui_width / 2;
var center_y = gui_height / 2;

// Position text 10% above vertical center
var victory_y = center_y * 0.9;

// Draw semi-transparent black background
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(0, 0, gui_width, gui_height, false);
draw_set_alpha(1);

// Draw "Congratulations!" in TitleFont
draw_set_font(Title);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(center_x, victory_y, "Congratulations!");

// Draw "You successfully repelled the goblin army!" in Font1
draw_set_font(Font1);
draw_text(center_x, victory_y + 80, "You successfully repelled the goblin army!");

// Draw final score
draw_text(center_x, victory_y + 140, "Final Score: " + string(global.player1score));

// Draw continue prompt with platform-appropriate button name
var button_name = get_button_name("accept");
draw_text(center_x, victory_y + 200, "Press " + button_name + " to continue");

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);