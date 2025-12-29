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

// === CONTINUES (Top-right) ===
var continues_x = gui_w - 120;
var continues_y = 20;

draw_set_halign(fa_right);
draw_set_color(c_yellow);
draw_text(continues_x, continues_y, "Continues: " + string(continues));

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

// === ABILITY COOLDOWNS (Bottom center) ===
var ability_display_y = gui_h - 60;
var ability_spacing = 60;
var ability_start_x = (gui_w / 2) - ((array_length(abilities) * ability_spacing) / 2);

for (var i = 0; i < array_length(abilities); i++) {
    var ability_x = ability_start_x + (i * ability_spacing);
    var ability_icon_size = 40;
    
    // Background
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(ability_x - ability_icon_size/2 - 2, ability_display_y - ability_icon_size/2 - 2, 
                   ability_x + ability_icon_size/2 + 2, ability_display_y + ability_icon_size/2 + 2, false);
    draw_set_alpha(1);
    
    // Icon placeholder (would be sprite in final version)
    if (ability_cooldowns[i] > 0) {
        // On cooldown - darker
        draw_set_color(c_dkgray);
    } else {
        // Ready - bright
        draw_set_color(c_white);
    }
    draw_rectangle(ability_x - ability_icon_size/2, ability_display_y - ability_icon_size/2,
                   ability_x + ability_icon_size/2, ability_display_y + ability_icon_size/2, false);
    
    // Cooldown overlay
    if (ability_cooldowns[i] > 0) {
        var cooldown_percent = ability_cooldowns[i] / abilities[i].cooldown_max;
        draw_set_color(c_black);
        draw_set_alpha(0.6);
        var cooldown_height = ability_icon_size * cooldown_percent;
        draw_rectangle(ability_x - ability_icon_size/2, ability_display_y - ability_icon_size/2,
                       ability_x + ability_icon_size/2, ability_display_y - ability_icon_size/2 + cooldown_height, false);
        draw_set_alpha(1);
    }
    
    // Ability number
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(ability_x, ability_display_y, string(i + 1));
}

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
