// obj_titleScreen Create Event - Initialize surface caching for Nyaa Smack
deco_angle_offset = 0;
grid_phase = random(360);
pulse_timer = 0;

// Nyaa Smack color scheme - powder blue background with white text
ui_powder_blue = make_color_rgb(176, 196, 222);
ui_light_blue = make_color_rgb(173, 216, 230);
ui_dark_blue = make_color_rgb(119, 136, 153);
ui_white = c_white;

background_surface = -1;
background_needs_redraw = true;