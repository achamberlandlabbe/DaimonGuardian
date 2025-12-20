/// obj_PCautoAttack Collision Event with obj_parentEnemies

// Calculate final damage
var final_damage = damage;
if (isCrit) {
    final_damage = damage * 2;  // 2x damage on crit
    other.crit_flash_timer = 15;  // Visual feedback
}

// Deal damage to the enemy
if (variable_instance_exists(other.id, "takeDamage")) {
    other.takeDamage(final_damage);
}

// Destroy the projectile
instance_destroy();
