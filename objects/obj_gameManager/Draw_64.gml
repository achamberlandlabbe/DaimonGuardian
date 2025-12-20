/// obj_gameManager Draw GUI Event

// Only draw HUD in gameplay rooms
if (room == roomTitleScreen || room == roomCredits || room == RoomStart) exit;

// Your new HUD will go here
draw_set_color(c_white);
draw_set_font(Font1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Simple placeholder HUD
draw_text(20, 20, "Level: " + string(global.currentLevel));
draw_text(20, 50, "Score: " + string(global.player1score));