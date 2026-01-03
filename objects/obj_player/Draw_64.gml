/// obj_player Draw GUI Event - Guardian Daimon HUD

// Don't draw HUD during tutorial/story
if (instance_exists(obj_tutorial) || instance_exists(obj_story)) exit;

// Get GUI dimensions
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// === XP BAR ===
var xp_bar_x = 0;
var xp_bar_y = 0;
var xp_bar_width = gui_w;
var xp_bar_height = 30;

// Background
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(xp_bar_x - 2, xp_bar_y - 2, xp_bar_x + xp_bar_width + 2, xp_bar_y + xp_bar_height + 2, false);
draw_set_alpha(1);

// XP fill
var xp_percent = player_anima / anima_to_next_level;
draw_set_color(c_aqua);
draw_rectangle(xp_bar_x, xp_bar_y, xp_bar_x + (xp_bar_width * xp_percent), xp_bar_y + xp_bar_height, false);

// Level text
draw_set_color(c_white);
var text_width = string_width("Level " + string(player_level));
draw_text(xp_bar_x + (gui_w/2) - (text_width/2), xp_bar_y - 2, "Level " + string(player_level));

// === CONTINUES DISPLAY REMOVED - Continue mechanic disabled ===

// === COMBO COUNTER (if active) ===
if (combo_count > 0) {
    var combo_x = gui_w / 2;
    var combo_y = 50;
    
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    
    // Draw combo with slight pulse effect
    var pulse = 1.0 + 0.1 * sin(current_time / 100);
    draw_text_transformed(combo_x, combo_y, "COMBO x" + string(combo_count), pulse, pulse, 0);
    
    // Draw combo timer bar
    var combo_timer_percent = combo_timer / combo_timer_max;
    var timer_bar_width = 100;
    var timer_bar_height = 4;
    var timer_bar_x = combo_x - timer_bar_width / 2;
    var timer_bar_y = combo_y + 30;
    
    draw_set_color(c_dkgray);
    draw_rectangle(timer_bar_x, timer_bar_y, timer_bar_x + timer_bar_width, timer_bar_y + timer_bar_height, false);
    
    draw_set_color(c_yellow);
    draw_rectangle(timer_bar_x, timer_bar_y, timer_bar_x + (timer_bar_width * combo_timer_percent), timer_bar_y + timer_bar_height, false);
}

// === ABILITY COOLDOWNS DISPLAY REMOVED ===
// (Will be re-implemented when multiple abilities are added)

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);