/// roomLevel1 - Room Creation Code
// This runs when the room is created, before any instances

// Create obj_protect at room center (20000x20000 room = 10000,10000 center)
var protect = instance_create_depth(10000, 10000, 0, obj_protect);

// Create obj_player 64px below obj_protect
var player = instance_create_depth(10000, 10064, 0, obj_player);

show_debug_message("RoomCreationCode: Created protect at " + string(protect.x) + ", " + string(protect.y));
show_debug_message("RoomCreationCode: Created player at " + string(player.x) + ", " + string(player.y));

// Center camera on player
var cam = view_camera[0];
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);
camera_set_view_pos(cam, player.x - cam_w/2, player.y - cam_h/2);
