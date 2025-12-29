/// obj_options Draw GUI Event – Nyaa Smack Transparent Black, Normal Text Size, No Outline

// Always use GUI coordinates in Draw GUI!
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// Menu panel coordinates (all GUI-based)
menu_x = gui_w * 0.3;
menu_y = gui_h * 0.2;
menu_width = gui_w * 0.4;
menu_height = gui_h * 0.6;

// Draw transparent black panel background and border
draw_set_color(c_black);
draw_set_alpha(bg_alpha);
draw_rectangle(menu_x, menu_y, menu_x + menu_width, menu_y + menu_height, false);
draw_set_alpha(1.0);
draw_set_color(border_color);
draw_rectangle(menu_x, menu_y, menu_x + menu_width, menu_y + menu_height, true);

// Draw title ("Options") in e9ff00, no outline
draw_set_font(Title);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
var title_y = menu_y + 20;
var title_x = menu_x + menu_width / 2;
var title_text = "Options";
draw_set_color(titleColor);
draw_text(title_x, title_y, title_text);

// Set up for options drawing (normal size)
draw_set_font(Font1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
var title_height = 80;
var title_bottom = title_y + title_height + 90;
var menu_bottom = menu_y + menu_height - 20;
var available_height = menu_bottom - title_bottom;
var total_gaps = array_length(optionsList) + 1;
var equal_spacing = available_height / total_gaps;

for (var i = 0; i < array_length(optionsList); i++) {
    var option_y = title_bottom + ((i + 1) * equal_spacing);
    var value_y = option_y + 30;

    // Move the first five options down by 20px, move Main Menu up by 20px
    if (i < 5) {
        option_y -= 80;
        value_y -= 80;
    } else if (i == 5) {
        option_y -= 20;
        value_y -= 20;
    }

    // Draw the option label: white if selected, grey if not
    if (i == optionsMenuSelection) {
        draw_set_color(c_white);
    } else {
        draw_set_color(c_gray);
    }
    draw_text(menu_x + menu_width / 2, option_y, optionsList[i]);

    // Draw the value below each option (white, no outline)
    var value_text = "";
    switch (i) {
        case 0:
            value_text = "< " + string(round(global.saveData.masterVolume * 100) div 1) + "% >";
            break;
        case 1:
            value_text = "< " + string(round(global.saveData.musicVolume * 100) div 1) + "% >";
            break;
        case 2:
            value_text = "< " + string(round(global.saveData.soundVolume * 100) div 1) + "% >";
            break;
        case 3:
            var sensitivity_percent = round(global.saveData.cursorSensitivity * 100);
            if (sensitivity_percent > 0) {
                value_text = "< +" + string(sensitivity_percent) + "% >";
            } else if (sensitivity_percent < 0) {
                value_text = "< " + string(sensitivity_percent) + "% >";
            } else {
                value_text = "< 0% >";
            }
            break;
        case 4:
            value_text = global.saveData.vibrations ? "ON" : "OFF";
            break;
        default:
            value_text = "";
            break;
    }
    if (value_text != "") {
        draw_set_color(c_white);
        draw_text(menu_x + menu_width / 2, value_y, value_text);
    }
}

// Main Menu Confirmation Dialog (all GUI-based)
if (show_main_menu_confirmation) {
    var conf_width = 630;
    var conf_height = 300;
    var conf_x = (gui_w / 2) - (conf_width / 2);
    var conf_y = (gui_h / 2) - (conf_height / 2);

    // Semi-transparent overlay
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, gui_w, gui_h, false);
    draw_set_alpha(1);

    // Confirmation box
    draw_set_color(c_black);
    draw_rectangle(conf_x, conf_y, conf_x + conf_width, conf_y + conf_height, false);
    draw_set_color(c_red);
    draw_rectangle(conf_x, conf_y, conf_x + conf_width, conf_y + conf_height, true);

    // Warning text
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_red);
    draw_text(conf_x + conf_width/2, conf_y + 15, "WARNING");

    draw_set_color(c_white);
    draw_text(conf_x + conf_width/2, conf_y + 75, "Exiting the game will cause you to lose");
    draw_text(conf_x + conf_width/2, conf_y + 105, "all unsaved progress.");

    draw_text(conf_x + conf_width/2, conf_y + 165, "Are you sure you want to exit?");

    // Yes/No buttons
    var button_width = 100;
    var button_height = 40;
    var button_y = conf_y + conf_height - button_height - 20;
    var no_x = conf_x + conf_width / 2 - button_width - 10;
    var yes_x = conf_x + conf_width / 2 + 10;

    draw_set_valign(fa_middle);

    // No button
    draw_set_color(main_menu_selection == "no" ? c_yellow : c_white);
    draw_rectangle(no_x, button_y, no_x + button_width, button_y + button_height, true);
    draw_set_color(c_white);
    draw_text(no_x + button_width/2, button_y + button_height/2, "No");

    // Yes button
    draw_set_color(main_menu_selection == "yes" ? c_yellow : c_white);
    draw_rectangle(yes_x, button_y, yes_x + button_width, button_y + button_height, true);
    draw_set_color(c_white);
    draw_text(yes_x + button_width/2, button_y + button_height/2, "Yes");
}

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
draw_set_font(Font1);
