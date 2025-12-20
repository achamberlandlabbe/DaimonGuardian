/// obj_player Create Event - Guardian Daimon
// Daimon stats
playerHP = 100;
playerMaxHP = 100;
playerSpeed = 10;  // Base movement speed in pixels per frame

// Movement
hspeed_current = 0;
vspeed_current = 0;
move_acceleration = 0.5;
move_friction = 0.85;

// Aim direction (for mouse/right stick aiming)
aim_direction = 0;

// Level anima system
player_level = 1;
player_anima = 0;  // Anima collected from kills (physical pickups)
anima_to_next_level = 25;  // Will scale with each level

// Abilities array - player starts with one basic attack
abilities = [];
ability_cooldowns = [];

// Add starting ability
array_push(abilities, {
    name: "basic_strike",
    type: "melee",
    damage: 10,
    range: 40,
    cooldown_max: 30,  // frames (0.5 seconds at 60fps)
    cooldown_current: 0
});
array_push(ability_cooldowns, 0);

// Combat stats
combo_count = 0;
combo_timer = 0;
combo_timer_max = 120;  // 2 seconds at 60fps

// Continues system
continues = 3;
combo_threshold_for_continue = 50;

// Position and depth
depth = -y;

// Crit chance for projectiles
heroCritChance = 0;  // 0-100
