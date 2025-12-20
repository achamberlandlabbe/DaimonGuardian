/// obj_eidolon Collision with obj_protect
// Deal damage to protected one (game over if shield is down)

// Only deal damage if cooldown is ready
if (contact_damage_cooldown <= 0) {
    if (!other.is_invulnerable) {
        // Shield is down - game over!
        global.gameOver = true;
        global.isPaused = true;
        show_debug_message("Protected one hit with shield down! GAME OVER");
    }
    
    // Reset cooldown regardless
    contact_damage_cooldown = contact_damage_cooldown_max;
}
