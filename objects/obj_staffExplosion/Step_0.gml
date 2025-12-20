/// obj_staffExplosion Step Event
if (global.isPaused) {
    exit;
}
// Collision detection with enemies
var collision = instance_place(x, y, obj_parentEnemies);
if (collision != noone) {
    // Check if we haven't hit this enemy yet
    if (ds_list_find_index(hit_enemies, collision) == -1) {
        // Apply pre-calculated damage using centralized function
        collision.takeDamage(explosion_damage);
        
        // Add to hit list
        ds_list_add(hit_enemies, collision);
    }
}
// Timer countdown
timer++;
if (timer >= duration) {
    ds_list_destroy(hit_enemies);
    instance_destroy();
}