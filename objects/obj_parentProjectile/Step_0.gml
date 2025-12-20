/// obj_parentProjectile Step Event
// Exit early if game is paused
if (global.isPaused) {
    exit;
}

// Manual movement (replace GameMaker's automatic speed/direction system)
x += lengthdir_x(projectileSpeed, direction);
y += lengthdir_y(projectileSpeed, direction);

// Track distance traveled
distanceTraveled = point_distance(startX, startY, x, y);

// Check if exceeded max range
if (distanceTraveled >= maxRange) {
    instance_destroy();
    exit;
}