/// obj_parentEnemies Draw Event
// Draw binding effect if enemy is bound
if (isBound) {
    draw_sprite_ext(spr_bindings, 0, x, y, 1, 1, image_angle, c_white, 0.8);
}
// Draw enemy sprite with damage flash effect
if (damage_flash_timer > 0) {
    // Draw red tinted version when taking damage (highest priority)
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_red, image_alpha);
} else if (poisoned) {
    // Draw green tinted version when poisoned
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_lime, image_alpha);
} else {
    // Draw normal sprite
    draw_self();
}
// Draw health bar (always visible)
var bar_width = 32;
var bar_height = 4;
var bar_x = x - (bar_width / 2);
var bar_y = y - sprite_height - 16; // Moved up from -8 to -16
// Background (black)
draw_set_color(c_black);
draw_rectangle(bar_x - 1, bar_y - 1, bar_x + bar_width + 1, bar_y + bar_height + 1, false);
// Health bar background (dark red)
draw_set_color(c_maroon);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);
// Current health (bright red)
var health_width = (enemyHP / enemyMaxHP) * bar_width;
draw_set_color(c_red);
draw_rectangle(bar_x, bar_y, bar_x + health_width, bar_y + bar_height, false);
// Reset color
draw_set_color(c_white);