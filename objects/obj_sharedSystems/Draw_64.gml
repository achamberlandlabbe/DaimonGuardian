/// obj_sharedSystems Draw GUI Event
// New Game Confirmation Dialog
if (showNewGameConfirmation) {
    var conf_width = 630;
    var conf_height = 300;
    var conf_x = (room_width / 2) - (conf_width / 2);
    var conf_y = (room_height / 2) - (conf_height / 2);
    
    // Semi-transparent overlay
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
    
    // Confirmation box
    draw_set_color(c_black);
    draw_rectangle(conf_x, conf_y, conf_x + conf_width, conf_y + conf_height, false);
    draw_set_color(c_red);
    draw_rectangle(conf_x, conf_y, conf_x + conf_width, conf_y + conf_height, true);
    
    // Warning text
    draw_set_font(Font1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_red);
    draw_text(conf_x + conf_width/2, conf_y + 15, "WARNING");
    
    draw_set_color(c_white);
    draw_text(conf_x + conf_width/2, conf_y + 45, "Starting a new game will reset ALL current");
    draw_text(conf_x + conf_width/2, conf_y + 75, "progression. If you wish to keep your");
    draw_text(conf_x + conf_width/2, conf_y + 105, "progress, use Continue instead.");
    
    draw_text(conf_x + conf_width/2, conf_y + 150, "Are you sure you want to start a new game?");
    
    // Yes/No buttons
    var button_width = 100;
    var button_height = 40;
    var button_y = conf_y + conf_height - button_height - 20;
    var no_x = conf_x + conf_width / 2 - button_width - 10;
    var yes_x = conf_x + conf_width / 2 + 10;
    
    draw_set_valign(fa_middle);
    
    // No button
    draw_set_color(newGameSelection == "no" ? c_yellow : c_white);
    draw_rectangle(no_x, button_y, no_x + button_width, button_y + button_height, true);
    draw_set_color(c_white);
    draw_text(no_x + button_width/2, button_y + button_height/2, "No");
    
    // Yes button
    draw_set_color(newGameSelection == "yes" ? c_yellow : c_white);
    draw_rectangle(yes_x, button_y, yes_x + button_width, button_y + button_height, true);
    draw_set_color(c_white);
    draw_text(yes_x + button_width/2, button_y + button_height/2, "Yes");
    
    // Reset draw settings
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1.0);
}