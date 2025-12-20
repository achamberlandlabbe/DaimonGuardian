/// obj_parentEnemies Destroy Event

// Play death sound with pitch variation
playSFX(snd_enemyDeath, random_range(0.9, 1.1), 1, 1);

// Add rewards to global variables
global.player1score += enemyPoints;
global.gold += enemyGold;
obj_gameManager.goldThisRun += enemyGold;

// Add XP to game manager once (represents XP earned this run)
obj_gameManager.xpThisRun += enemyXP;

// Add XP to all heroes present
with (obj_parentHero) {
    heroXP += other.enemyXP;
}

// Decrement all living enemies' drop counters
with (obj_parentEnemies) {
    if (id != other.id) { // Don't affect the dying enemy
        drop_counter--;
    }
}

// Check if this enemy should drop loot
if (drop_counter <= 1) {
    dropLoot();
    
    // Reset all remaining enemies' counters
    with (obj_parentEnemies) {
        if (id != other.id) { // Don't affect the dying enemy
            drop_counter = irandom_range(1, 20);
        }
    }
}

// Increment kill counter in game manager
with (obj_gameManager) {
    enemiesKilledThisWave++;
}