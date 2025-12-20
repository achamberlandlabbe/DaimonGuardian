/// obj_player Draw Event - Guardian Daimon
// Draw player sprite (rotated to aim direction)
draw_self();

// Draw HP bar above player
var bar_width = 40;
var bar_height = 4;
var bar_x = x - bar_width/2;
var bar_y = y - 30;

// Background
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(bar_x - 1, bar_y - 1, bar_x + bar_width + 1, bar_y + bar_height + 1, false);

// HP bar color
var hp_percent = playerHP / playerMaxHP;
var hp_color;
if (hp_percent > 0.6) {
    hp_color = c_lime;
} else if (hp_percent > 0.3) {
    hp_color = c_yellow;
} else {
    hp_color = c_red;
}

// Fill bar
draw_set_color(hp_color);
draw_set_alpha(1.0);
var fill_width = hp_percent * bar_width;
draw_rectangle(bar_x, bar_y, bar_x + fill_width, bar_y + bar_height, false);

// Reset
draw_set_alpha(1.0);
draw_set_color(c_white);
