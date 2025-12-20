/// obj_eidolon Collision with obj_player
// Deal contact damage to player

// Only deal damage if cooldown is ready
if (contact_damage_cooldown <= 0) {
    // Damage player
    other.playerHP -= damage_to_player;
    
    // Reset cooldown
    contact_damage_cooldown = contact_damage_cooldown_max;
    
    // Visual/audio feedback
    // TODO: Add sound effect
    show_debug_message("Player hit! HP: " + string(other.playerHP));
}
