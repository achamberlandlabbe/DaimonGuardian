/// obj_tutorial Draw GUI Event
// Semi-transparent black background
draw_set_color(c_black);
draw_set_alpha(0.85);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

// Tutorial box
var box_width = 1000;
var box_height = 300;
var box_x = (room_width / 2) - (box_width / 2);
var box_y = (room_height / 2) - (box_height / 2);

// Box background
draw_set_color(c_black);
draw_rectangle(box_x, box_y, box_x + box_width, box_y + box_height, false);

// Box border
draw_set_color(c_white);
draw_rectangle(box_x, box_y, box_x + box_width, box_y + box_height, true);

// Progress indicator at top (only show on screens 1-5)
if (current_screen < 5) {
    draw_set_font(Font1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text(box_x + box_width/2, box_y + 20, string(current_screen + 1) + " / 5");
}

// Tutorial text (shifted up for visual centering)
draw_set_font(Font1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(box_x + box_width/2, box_y + box_height/2 - 10, tutorial_text[current_screen]);

// Continue prompt at bottom (only on screens 1-5, not on 6th screen)
if (current_screen < 5) {
    draw_set_valign(fa_bottom);
    draw_text(box_x + box_width/2, box_y + box_height - 20, "Press " + get_button_name("accept") + " to continue");
}

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);