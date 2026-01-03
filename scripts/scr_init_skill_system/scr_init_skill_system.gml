/// init_skill_system()
// Initialize the skill upgrade system for Guardian Daimon
// This creates a 2D array to track upgrade ranks for all 36 upgrades (12 rows x 3 columns)

// Create global player build if it doesn't exist
if (!variable_global_exists("playerBuild")) {
    global.playerBuild = {};
}

// Legacy structure (kept for compatibility)
global.playerBuild.ownedSkills = ["Basic Attack"];
global.playerBuild.upgradeRanks = {
    "Basic Attack": {
        "Damage": 0,
        "Fire Rate": 0,
        "Speed": 0
    }
};

// Initialize skill_upgrades 2D array in global.playerBuild
// [row, column] = upgrade rank (0-5)
// Row 0 = Base Attack (Range, Damage, Speed)
// Rows 1-11 = Future upgrade tiers

global.playerBuild.skill_upgrades = [];

// Initialize 12 rows (tiers) with 3 columns (upgrades per tier)
for (var row = 0; row < 12; row++) {
    global.playerBuild.skill_upgrades[row] = [];
    for (var col = 0; col < 3; col++) {
        global.playerBuild.skill_upgrades[row][col] = 0; // All start at rank 0
    }
}

show_debug_message("Skill system initialized: 12 tiers x 3 upgrades = 36 total upgrades");