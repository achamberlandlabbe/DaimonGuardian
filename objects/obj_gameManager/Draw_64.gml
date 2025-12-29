/// obj_gameManager Draw GUI Event

// Don't draw HUD during tutorial/story
if (instance_exists(obj_tutorial) || instance_exists(obj_story)) exit;

// Only draw HUD in gameplay rooms
if (room == roomTitleScreen || room == roomCredits || room == RoomStart) exit;

draw_set_color(c_white);
draw_set_font(Font1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(20, 20, "Level: " + string(global.currentLevel));
draw_text(20, 50, "Score: " + string(global.player1score));