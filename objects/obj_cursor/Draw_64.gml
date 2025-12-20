/// obj_cursor Draw GUI Event
// Convert room coordinates to GUI coordinates
var cam = view_camera[0];
var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);

// Calculate GUI position (cursor position relative to camera view)
var gui_x = x - cam_x;
var gui_y = y - cam_y;

// Draw cursor sprite
draw_sprite(spr_cursor, 0, gui_x, gui_y);