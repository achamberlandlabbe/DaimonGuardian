/// obj_player Step Event - Guardian Daimon
// Exit early if game is paused
if (global.isPaused) {
    exit;
}

// === MOVEMENT INPUT (WASD or Left Stick) ===
var move_x = input_check("right") - input_check("left");
var move_y = input_check("down") - input_check("up");

// Normalize diagonal movement
if (move_x != 0 && move_y != 0) {
    move_x *= 0.707;  // 1/sqrt(2)
    move_y *= 0.707;
}

// Apply acceleration or friction
if (move_x != 0 || move_y != 0) {
    // Accelerate toward target velocity
    var target_hspeed = move_x * playerSpeed;
    var target_vspeed = move_y * playerSpeed;
    
    hspeed_current = lerp(hspeed_current, target_hspeed, move_acceleration);
    vspeed_current = lerp(vspeed_current, target_vspeed, move_acceleration);
} else {
    // Apply friction when no input
    hspeed_current *= move_friction;
    vspeed_current *= move_friction;
    
    // Stop completely when very slow
    if (abs(hspeed_current) < 0.1) hspeed_current = 0;
    if (abs(vspeed_current) < 0.1) vspeed_current = 0;
}

// Move player
x += hspeed_current;
y += vspeed_current;

// Keep player in room bounds (with margin)
var margin = 32;
x = clamp(x, margin, room_width - margin);
y = clamp(y, margin, room_height - margin);

// === AIM DIRECTION (Mouse or Right Stick) ===
// Try gamepad right stick first
var aim_x = input_value("aim_right") - input_value("aim_left");
var aim_y = input_value("aim_down") - input_value("aim_up");

if (aim_x != 0 || aim_y != 0) {
    // Gamepad right stick is being used
    aim_direction = point_direction(0, 0, aim_x, aim_y);
} else {
    // No gamepad input - use mouse position
    aim_direction = point_direction(x, y, mouse_x, mouse_y);
}

// Update sprite direction based on aim
image_angle = aim_direction - 90;

// === ABILITY USAGE ===
// Update cooldowns
for (var i = 0; i < array_length(abilities); i++) {
    if (ability_cooldowns[i] > 0) {
        ability_cooldowns[i]--;
    }
}

// Use basic attack (ability 0) with mouse button held or attack button held
if (array_length(abilities) > 0) {
    if ((mouse_check_button(mb_left) || input_check("attack")) 
        && ability_cooldowns[0] <= 0) {
        
        // Use the ability
        var ability = abilities[0];
        ability_cooldowns[0] = ability.cooldown_max;
        
        // Spawn projectile at player position
        var projectile = instance_create_depth(x, y, depth - 1, obj_PCautoAttack);
        
        // Apply upgrade bonuses from skill_upgrades
        // Row 0 = Base Attack: [0]=Range, [1]=Damage, [2]=Speed
        if (variable_instance_exists(id, "skill_upgrades")) {
            var range_rank = skill_upgrades[0][0];   // Range upgrade rank (0-5)
            var damage_rank = skill_upgrades[0][1];  // Damage upgrade rank (0-5)
            var speed_rank = skill_upgrades[0][2];   // Speed upgrade rank (0-5)
            
            // Each rank adds 20% (1.2x per rank)
            // Formula: base * (1 + 0.2 * rank)
            projectile.maxRange *= (1 + 0.2 * range_rank);
            projectile.damage *= (1 + 0.2 * damage_rank);
            projectile.projectileSpeed *= (1 + 0.2 * speed_rank);
            
            show_debug_message("Projectile created with bonuses - Range: " + string(range_rank) + 
                             ", Damage: " + string(damage_rank) + ", Speed: " + string(speed_rank));
        }
        
        // Projectile will automatically aim toward mouse/cursor in its Create event
        projectile.image_angle = projectile.direction;
    }
}

// === COMBO SYSTEM ===
if (combo_count > 0) {
    combo_timer--;
    if (combo_timer <= 0) {
        // Combo expired
        combo_count = 0;
    }
}

// === XP AND LEVELING ===
// Check if we've earned enough anima to level up
if (player_anima >= anima_to_next_level) {
    player_anima -= anima_to_next_level;
    player_level++;
    
    // Scale XP requirement
    anima_to_next_level = floor(anima_to_next_level * 1.2);
    
    // Heal to full on level up
    playerHP = playerMaxHP;
    
    // Show level up menu
    instance_create_depth(x, y, -9999, obj_levelUpMenu);
    show_debug_message("LEVEL UP! Now level " + string(player_level));
}

// Update depth for proper layering
depth = -y;

// Check for death
if (playerHP <= 0) {
    // CONTINUE MECHANIC DISABLED FOR NOW
    /*
    if (continues > 0) {
        continues--;
        playerHP = playerMaxHP;
        show_debug_message("Continue used! " + string(continues) + " remaining");
    } else {
    */
        // Game over - spawn game over screen
        if (!instance_exists(obj_victory)) {
            instance_create_depth(0, 0, -10004, obj_victory);
        }
        global.gameOver = true;
        global.isPaused = true;
    //}
}

// Camera follows player
var cam = view_camera[0];
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);
camera_set_view_pos(cam, x - cam_w/2, y - cam_h/2);