/// obj_eidolon Draw Event
// Draw enemy with hit flash effect

// Draw smoke trail
var trail_count = array_length(trail_positions);
for (var i = 0; i < trail_count; i++) {
    var pos = trail_positions[i];
    var progress = i / trail_length;
    var scale = 1.0 - (progress * 0.8);
    var alpha = 0.6 - (progress * 0.5);
    draw_sprite_ext(sprite_index, image_index, pos.x, pos.y, 
                    scale * image_xscale, scale * image_yscale, 
                    0, c_white, alpha);
}

// Flash white when hit
if (hit_flash_timer > 0) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, 1);
    gpu_set_blendmode(bm_add);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, 0.5);
    gpu_set_blendmode(bm_normal);
} else {
    draw_self();
}

// HP bar above enemy
var bar_width = 30;
var bar_height = 3;
var bar_x = x - bar_width/2;
var bar_y = y - 20;

// Only draw HP bar if damaged
if (enemyHP < enemyMaxHP) {
    // Background
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(bar_x - 1, bar_y - 1, bar_x + bar_width + 1, bar_y + bar_height + 1, false);
    
    // HP fill
    var hp_percent = enemyHP / enemyMaxHP;
    draw_set_color(c_red);
    draw_set_alpha(1.0);
    draw_rectangle(bar_x, bar_y, bar_x + (bar_width * hp_percent), bar_y + bar_height, false);
    
    // Reset
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}
