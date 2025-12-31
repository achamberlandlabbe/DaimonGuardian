/// @description Initialize skill system - BARE MINIMUM VERSION

function init_skill_system() {
    // Track player's owned skills and their upgrade levels
    global.playerBuild = {
        ownedSkills: ["Basic Attack"],
        upgradeRanks: {
            "Basic Attack": {
                "Damage": 0,
                "Fire Rate": 0,
                "Speed": 0
            }
        }
    };
    
    show_debug_message("Skill system initialized");
}