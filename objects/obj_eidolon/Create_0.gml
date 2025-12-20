/// obj_eidolon Create Event
// Weak, fast rusher enemy

// Stats
enemyHP = 20;
enemyMaxHP = 20;
enemySpeed = 2.5;  // Slightly slower than player base speed
damage_to_player = 10;
damage_to_protect = 999;  // Instant game over if shield is down

// Anima dropped
anima_dropped = 1;  // Drops 1 anima on death

// Target tracking
current_target = noone;

// Contact damage cooldown (so it doesn't deal damage every frame)
contact_damage_cooldown = 0;
contact_damage_cooldown_max = 60;  // 1 second between hits

// Visual
hit_flash_timer = 0;
crit_flash_timer = 0;

// Depth
depth = -y;

// Damage function
takeDamage = function(damage_amount) {
    enemyHP -= damage_amount;
    hit_flash_timer = 5;  // Flash white for 5 frames
    
    show_debug_message("Eidolon took " + string(damage_amount) + " damage. HP: " + string(enemyHP) + "/" + string(enemyMaxHP));
    
    if (enemyHP <= 0) {
        instance_destroy();
    }
};

// Smoke trail system
trail_positions = [];
trail_length = 8;
trail_spacing = 8;
trail_distance = 0;
