/// obj_sharedSystems Draw Event
// Draw splash screen logos
if (room == RoomStart) {
    var _scale = room_height / 5760;
    spriteDraw(spr_logos, room_width / 2, room_height / 2, _scale, _scale, currentSplashScreen);
}

// Draw title screen menu
if (room == roomTitleScreen) {
    draw_set_alpha(1.0);
    setAlign(fa_left);
    
    // Calculate menu positioning
    var title_y = room_height * 0.290 - 20;
    var actual_title_height = 75;
    var _x = room_width * 0.07;
    
    // Build menu items array based on active run status
    var menu_items = [];
    if (global.saveData.hasActiveRun) {
        menu_items = ["Continue", "New Game", "Options", "Credits"];
    } else {
        menu_items = ["New Game", "Options", "Credits"];
    }
    
    // Calculate menu area bounds for background rectangle
    draw_set_font(Font1);
    var max_width = 0;
    for (var i = 0; i < array_length(menu_items); i++) {
        max_width = max(max_width, string_width(menu_items[i]));
    }
    
    var menu_left = _x;
    var menu_top = room_height * 0.40;
    var spacing = room_height * 0.06; // Spacing between menu items
    var text_height = string_height("A");
    var menu_bottom = menu_top + (array_length(menu_items) - 1) * spacing + text_height;
    var menu_right = menu_left + max_width;
    
    // Draw menu background
    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_rectangle(menu_left - 10, menu_top - 30, menu_right + 10, menu_bottom + 10, false);
    draw_set_alpha(1.0);
    
    // Draw menu options with selection highlighting
    for (var i = 0; i < array_length(menu_items); i++) {
        var color = (selectedOption == i) ? c_white : c_grey;
        draw_set_color(color);
        draw_text(_x, menu_top + (i * spacing), menu_items[i]);
    }
}