/// obj_gameManager Room Start Event
// Create cursor object (works in all rooms)
if (!instance_exists(obj_cursor)) {
    instance_create_depth(0, 0, -9999, obj_cursor);
}