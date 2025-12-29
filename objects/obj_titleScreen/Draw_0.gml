// obj_titleScreen Draw Event
#region Surface Management
if (!surface_exists(background_surface) || background_needs_redraw) {
    if (surface_exists(background_surface)) {
        surface_free(background_surface);
    }
    background_surface = surface_create(room_width, room_height);
    surface_set_target(background_surface);
    draw_set_alpha(1.0);
    surface_reset_target();
    background_needs_redraw = false;
}
#endregion
#region Draw Cached Background
if (surface_exists(background_surface)) {
    draw_surface(background_surface, 0, 0);
}
#endregion
#region Title Treatment with Neon Pink Outline
var menu_x = room_width * 0.07;
var actual_title_x = menu_x - 8;
var version_y = room_height * 0.290;
var title_y = version_y - 20 - 50 - 50 + 75; // Moved down 75px total (was +100, now +75)
var title_text = global.gameTitle;
var version_text = string(global.versionNumber);
draw_set_font(Title);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
var neon_pink = make_color_rgb(51, 3, 4); // #ff4fa3
// Neon pink outline for the title
draw_set_color(neon_pink);
for (var out_r = 1; out_r <= 2; out_r++) {
    for (var outline_angle = 0; outline_angle < 360; outline_angle += 45) {
        var ox = round(out_r * cos(degtorad(outline_angle)));
        var oy = round(out_r * sin(degtorad(outline_angle)));
        if (ox != 0 || oy != 0) {
            draw_text_transformed(actual_title_x + ox, title_y + oy, title_text, 1.4, 1.4, 0);
        }
    }
}
// Main title in white
draw_set_color(c_white);
draw_text_transformed(actual_title_x, title_y, title_text, 1.4, 1.4, 0);
// Version number
draw_set_font(Font1);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
var title_width = string_width(title_text) * 1.4;
var title_right_x = actual_title_x + title_width;
var version_draw_x = title_right_x + 400 + 50 + 60; // Total: +110px right
var version_draw_y = version_y - 20 - 50 - 50 + 120 + 50 + 10; // Uses original title_y calculation, then adds the relative offset
// Neon pink outline for version string
draw_set_color(neon_pink);
for (var out_r = 1; out_r <= 2; out_r++) {
    for (var outline_angle = 0; outline_angle < 360; outline_angle += 45) {
        var ox = round(out_r * cos(degtorad(outline_angle)));
        var oy = round(out_r * sin(degtorad(outline_angle)));
        if (ox != 0 || oy != 0) {
            draw_text(version_draw_x + ox, version_draw_y + oy, version_text);
        }
    }
}
// Main version string in white
draw_set_color(c_white);
draw_text(version_draw_x, version_draw_y, version_text);
// Reset alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);
#endregion
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_set_font(Font1);