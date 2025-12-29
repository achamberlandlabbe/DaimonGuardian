/// obj_sharedSystems Draw GUI Event
// Skip drawing UI if tutorial or story is active
if (instance_exists(obj_tutorial) || instance_exists(obj_story)) {
    exit;
}

// Set GUI alignment
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Draw confirmation dialog if active
if (showNewGameConfirmation) {
    var conf_width = 630;
    var conf_height = 300;
    var conf_x = display_get_gui_width()/2 - conf_width/2;
    var conf_y = display_get_gui_height()/2 - conf_height/2;
    
    // Draw semi-transparent background
    draw_set_alpha(0.8);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
    
    // Draw dialog box - BLACK background
    draw_set_color(c_black);
    draw_rectangle(conf_x, conf_y, conf_x + conf_width, conf_y + conf_height, false);
    
    // Draw RED outline
    draw_set_color(c_red);
    draw_rectangle(conf_x, conf_y, conf_x + conf_width, conf_y + conf_height, true);
    
    // Draw "Warning!" in RED
    draw_set_color(c_red);
    draw_text(conf_x + conf_width/2, conf_y + 60, "Warning!");
    
    // Draw message text in WHITE
    draw_set_color(c_white);
    draw_text(conf_x + conf_width/2, conf_y + 110, "Starting a new game will erase");
    draw_text(conf_x + conf_width/2, conf_y + 140, "your previous save data.");
    draw_text(conf_x + conf_width/2, conf_y + 180, "Are you sure you want to");
    draw_text(conf_x + conf_width/2, conf_y + 210, "start a new game?");
    
    // Draw buttons - MATCH Step Event hitbox positions
    var button_width = 100;
    var button_height = 40;
    var button_y = conf_y + conf_height - button_height - 20;
    var no_x = conf_x + conf_width / 2 - button_width - 10;
    var yes_x = conf_x + conf_width / 2 + 10;
    
    draw_text(no_x + button_width/2, button_y + button_height/2, "[No]");
    draw_text(yes_x + button_width/2, button_y + button_height/2, "[Yes]");
}

// Reset alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);