/// obj_parentEnemies Step Event

// Set depth based on y position
depth = -y;

// Don't move or animate during game start sequence
var game_manager = instance_find(obj_gameManager, 0);
if (game_manager != noone && game_manager.gameStartSequence) {
    exit; // Stop all enemy logic during start sequence
}

// Exit early if game is paused
if (global.isPaused) {
    exit;
}

// Reset sprite scale back to normal (2x2) gradually after attack
if (image_xscale != 2 || image_yscale != 2) {
    image_xscale = lerp(image_xscale, 2, 0.3);
    image_yscale = lerp(image_yscale, 2, 0.3);
    
    // Snap to exactly 2 when close enough
    if (abs(image_xscale - 2) < 0.01) image_xscale = 2;
    if (abs(image_yscale - 2) < 0.01) image_yscale = 2;
}

// Poison damage over time
if (poisoned) {
    poisonTimer--;
    poisonDamageTimer--;
    
    // Deal damage every second (60 frames)
    if (poisonDamageTimer <= 0) {
        enemyHP -= 1; // 1 damage per second
        poisonDamageTimer = 60; // Reset for next damage tick
    }
    
    // Remove poison when timer expires
    if (poisonTimer <= 0) {
        poisoned = false;
        poisonTimer = 0;
        poisonDamageTimer = 0;
    }
}

// Damage flash timer countdown
if (damage_flash_timer > 0) {
    damage_flash_timer--;
}

// Crit flash timer countdown
if (crit_flash_timer > 0) {
    crit_flash_timer--;
}

// Check if enemy took damage this frame
if (enemyHP < previous_hp) {
    damage_flash_timer = 5; // Flash red for 5 frames
}

// Update previous HP for next frame
previous_hp = enemyHP;

// Calculate speed modifier based on binding status
var speed_multiplier = 1;
if (isBound) {
    if (enemyMaxHP <= 10) {
        speed_multiplier = 0; // Immobilized
    } else if (enemyMaxHP <= 20) {
        speed_multiplier = 0.5; // Slowed by 50%
    }
    // else: >20 HP, no speed penalty (speed_multiplier stays 1)
}

// Check distance to nearest hero (player or allies)
var nearest_hero = instance_nearest(x, y, obj_parentHero);

if (nearest_hero != noone) {
    
    if (attack_state == "moving") {
        var distance_to_hero = point_distance(x, y, nearest_hero.x, nearest_hero.y);
        
        // Check if we need to move toward hero (ranged enemies stop at attackRange, melee get closer)
        if (distance_to_hero > attackRange) {
            // Apply speed multiplier from binding
            var effective_speed = enemySpeed * speed_multiplier;
            
            // Check if close enough to start moving toward player
            var x_distance = abs(x - nearest_hero.x);
            
            if (x_distance <= irandom(300)) {
                // Move toward the player
                var move_direction = point_direction(x, y, nearest_hero.x, nearest_hero.y);
                x += lengthdir_x(effective_speed, move_direction);
                y += lengthdir_y(effective_speed, move_direction);
            } else {
                // Move left until close enough to player
                x -= effective_speed;
            }
            
            // Only rock if not immobilized
            if (speed_multiplier > 0) {
                // Snappy rocking motion while moving
                rock_timer++;
                
                if (rock_timer <= 2) {
                    // Quick transition to right tilt
                    image_angle = (rock_timer / 2) * tilt_amplitude;
                } else if (rock_timer <= 12) {
                    // Hold right tilt for longer
                    image_angle = tilt_amplitude;
                } else if (rock_timer <= 14) {
                    // Quick transition to left tilt
                    var progress = (rock_timer - 12) / 2; // 0 to 1
                    image_angle = tilt_amplitude - (progress * tilt_amplitude * 2);
                } else if (rock_timer <= 24) {
                    // Hold left tilt for longer
                    image_angle = -tilt_amplitude;
                } else {
                    rock_timer = 0; // Reset cycle
                }
            } else {
                // Immobilized - stop rocking
                image_angle = 0;
            }
        } else {
            // In attack range - stop rocking
            image_angle = 0;
            
            // Check if can attack (immobilized enemies cannot attack)
            if (attack_cooldown <= 0 && speed_multiplier > 0) {
                if (is_ranged) {
                    // Ranged attack - fire projectile
                    var projectile = instance_create_depth(x, y, depth - 1, obj_shamanSpell);
                    projectile.direction = point_direction(x, y, nearest_hero.x, nearest_hero.y);
                    projectile.speed = 8;
                    projectile.damage = attackDamage;
                    
                    // Add attack squish animation
                    image_xscale = 1.5;  // Squish horizontally
                    image_yscale = 2.5;  // Stretch vertically
                    
                    // Start cooldown
                    attack_cooldown = attackSpeed;
                } else {
                    // Melee attack - start jump
                    attack_state = "jumping_to";
                    jump_timer = 0;
                    start_x = x;
                    start_y = y;
                    target_x = nearest_hero.x;
                    target_y = nearest_hero.y;
                }
            }
        }
    }
    
    else if (attack_state == "jumping_to") {
        // Jump in arc to target
        jump_timer++;
        var jump_progress = jump_timer / jump_duration;
        
        if (jump_progress >= 1) {
            // Reached target, start jumping back
            attack_state = "jumping_back";
            jump_timer = 0;
            
            // Damage the hero using centralized damage function
            if (instance_exists(nearest_hero)) {
                nearest_hero.takeDamage(attackDamage);
            }
        } else {
            // Calculate arc position
            x = start_x + (target_x - start_x) * jump_progress;
            y = start_y + (target_y - start_y) * jump_progress - (4 * jump_progress * (1 - jump_progress) * jump_height);
        }
    }
    
    else if (attack_state == "jumping_back") {
        // Jump back to original position
        jump_timer++;
        var jump_progress = jump_timer / jump_duration;
        
        if (jump_progress >= 1) {
            // Back to original position, start cooldown
            attack_state = "cooldown";
            attack_cooldown = attackSpeed;
            x = start_x;
            y = start_y;
        } else {
            // Calculate arc position back
            x = target_x + (start_x - target_x) * jump_progress;
            y = target_y + (start_y - target_y) * jump_progress - (4 * jump_progress * (1 - jump_progress) * jump_height);
        }
    }
    
    else if (attack_state == "cooldown") {
        // Wait for cooldown to finish
        attack_cooldown--;
        if (attack_cooldown <= 0) {
            attack_state = "moving";
        }
    }
}

// Always count down attack cooldown
if (attack_cooldown > 0) {
    attack_cooldown--;
}

// Check for death
if (enemyHP <= 0) {
    instance_destroy();
}

// Remove enemy if it somehow goes off screen left
if (x < -sprite_width) {
    instance_destroy();
}