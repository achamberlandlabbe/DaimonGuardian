/// obj_gameManager Draw Event

// Exit if not in gameplay room
if (room != roomLevel1) {
    show_debug_message("Lighting: Not in roomLevel1, exiting");
    exit;
}

// Exit if tutorial or story is active
if (instance_exists(obj_tutorial)) {
    show_debug_message("Lighting: Tutorial exists, exiting");
    exit;
}
if (instance_exists(obj_story)) {
    show_debug_message("Lighting: Story exists, exiting");
    exit;
}

show_debug_message("Lighting: Drawing darkness overlay");

// Draw darkness overlay with lights
var cam = view_camera[0];
var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);

if (!surface_exists(darkness_surface)) {
    darkness_surface = surface_create(cam_w, cam_h);
}

surface_set_target(darkness_surface);
    draw_clear_alpha(c_black, darkness_alpha);
    gpu_set_blendmode(bm_subtract);
    
    var player = instance_find(obj_player, 0);
    if (player != noone) {
        var px = player.x - cam_x;
        var py = player.y - cam_y;
        var max_radius = light_radius + light_falloff;
        var steps = 50;
        for (var i = 0; i < steps; i++) {
            var r = max_radius * (i / steps);
            var a = 1 - (i / steps);
            draw_set_alpha(a);
            draw_circle(px, py, r, false);
        }
        draw_set_alpha(1);
    }
    
    var protect = instance_find(obj_protect, 0);
    if (protect != noone) {
        var protx = protect.x - cam_x;
        var proty = protect.y - cam_y;
        var max_radius = light_radius + light_falloff;
        var steps = 50;
        for (var i = 0; i < steps; i++) {
            var r = max_radius * (i / steps);
            var a = 1 - (i / steps);
            draw_set_alpha(a);
            draw_circle(protx, proty, r, false);
        }
        draw_set_alpha(1);
    }
    
    gpu_set_blendmode(bm_normal);
surface_reset_target();

draw_surface(darkness_surface, cam_x, cam_y);