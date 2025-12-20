/// obj_parentEnemies Create Event
image_xscale = 2;
image_yscale = 2;
is_ranged = false; // Default to melee
enemySpeed = 2;
attackRange = 200;
attackSpeed = 120;
attackDamage = 1;
enemyHP = 5;
enemyMaxHP = 5;
enemyGold = 5;
enemyXP = 5;
enemyPoints = enemyGold+enemyXP;
enemyDefense = 0; // Base defense (reduces damage taken)
// Walking animation variables
rock_timer = 0;
tilt_amplitude = 8; // Maximum tilt angle in degrees
// Jump attack variables
attack_state = "moving";
jump_timer = 0;
jump_duration = 20; // frames for jump
jump_height = 50; // height of arc
start_x = 0;
start_y = 0;
target_x = 0;
target_y = 0;
attack_cooldown = 0;
// Bad luck protection - guarantee drop within max kills
drop_counter = irandom_range(1, 20);
// Damage flash effect
damage_flash_timer = 0; // Frames to flash red when taking damage
crit_flash_timer = 0; // Frames to show crit starburst effect
previous_hp = enemyHP; // Track HP from last frame to detect damage
// Poison status tracking
poisoned = false;
poisonTimer = 0;
poisonDamageTimer = 0;
// Barbed Bindings variables
isBound = false;
// Loot drop function that reads from loot_table
function dropLoot() {
    if (!variable_instance_exists(id, "loot_table")) return; // No loot table = no drops
    if (array_length(loot_table) == 0) return; // Empty table = no drops
    
    // Calculate total weight
    var total_weight = 0;
    for (var i = 0; i < array_length(loot_table); i++) {
        total_weight += loot_table[i].weight;
    }
    
    // Roll for loot
    var roll = irandom(total_weight - 1);
    var cumulative = 0;
    
    for (var i = 0; i < array_length(loot_table); i++) {
        cumulative += loot_table[i].weight;
        if (roll < cumulative) {
            instance_create_depth(x, y, depth - 1, loot_table[i].item);
            break;
        }
    }
}
// Centralized damage function for enemies
function takeDamage(_damage) {
    var damage_to_deal = _damage;
    
    // 1. Shield absorption (if enemy has shield)
    if (variable_instance_exists(id, "enemyShield") && enemyShield > 0 && damage_to_deal > 0) {
        var shield_absorbed = min(damage_to_deal, enemyShield);
        enemyShield -= shield_absorbed;
        damage_to_deal -= shield_absorbed;
    }
    
    // 2. Defense (armor) reduction
    if (damage_to_deal > 0) {
        var damage_after_armor = max(0, damage_to_deal - enemyDefense);
        enemyHP -= damage_after_armor;
    }
}