/// obj_gameManager Draw GUI Event

// Only draw HUD in gameplay rooms
if (room == roomTitleScreen || room == roomCredits || room == RoomStart) exit;

// HUD drawing happens in obj_player Draw_64 event
// Level and Score display removed from here

// Reset draw settings
draw_set_color(c_white);
draw_set_font(Font1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);