/// obj_parentProjectile Create Event
// Common projectile variables
startX = x;
startY = y;
maxRange = 400; // Default max range
distanceTraveled = 0;
projectileSpeed = 10; // Use this instead of built-in speed

// Get crit chance from player
var player = instance_find(obj_player, 0);
var crit_chance = (player != noone) ? player.heroCritChance : 0;
isCrit = (irandom_range(1, 100) < (crit_chance + 1));
