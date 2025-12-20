/// obj_anima Draw Event
// Draw anima pickup with glow effect

// If sprite is assigned, draw it
if (sprite_index != -1) {
    draw_sprite_ext(sprite_index, image_index, x, y, pulse_scale, pulse_scale, 0, c_white, 1);
}

// Glow effect (cyan/aqua color to match theme)
draw_set_color(c_aqua);
draw_set_alpha(0.5 * abs(sin(pulse_timer * 2)));
draw_circle(x, y, 8 * pulse_scale, false);

draw_set_alpha(0.3);
draw_circle(x, y, 12 * pulse_scale, true);

// Reset
draw_set_alpha(1.0);
draw_set_color(c_white);

// Optional: Draw lifetime indicator when low (last 10 seconds)
var time_remaining = lifetime_max - lifetime_current;
if (time_remaining < 600) {  // Last 10 seconds
    // Flashing warning
    if (time_remaining mod 60 < 30) {
        draw_set_alpha(0.7);
        draw_set_color(c_yellow);
        draw_circle(x, y, 15, true);
        draw_set_alpha(1.0);
        draw_set_color(c_white);
    }
}
