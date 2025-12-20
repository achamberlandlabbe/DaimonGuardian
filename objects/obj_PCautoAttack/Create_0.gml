/// obj_PCautoAttack Create Event
// Inherit parent setup
event_inherited();

// Get target position from cursor object, fallback to mouse
var cursor = instance_find(obj_cursor, 0);
target_x = (cursor != noone) ? cursor.x : mouse_x;
target_y = (cursor != noone) ? cursor.y : mouse_y;

// Movement
direction = point_direction(x, y, target_x, target_y);
projectileSpeed = 20;  // 2x speed

// Stats
maxRange = 600;
damage = 10;  // Base damage, 20 on crit (2x multiplier)
