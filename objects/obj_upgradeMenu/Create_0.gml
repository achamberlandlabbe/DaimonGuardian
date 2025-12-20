/// obj_upgradeMenu Create Event
global.isPaused = true; // Pause the game while menu is open

depth = -10002;

menu_width = room_width;
menu_height = room_height;

// Grid layout
grid_rows = 3;
grid_cols = 2;
item_size = 144;
item_spacing = 20;

// Calculate grid positions (centered in each half)
shop_start_x = (menu_width * 0.25) - ((grid_cols * item_size + (grid_cols - 1) * item_spacing) / 2);
shop_start_y = 420;
skills_start_x = (menu_width * 0.75) - ((grid_cols * item_size + (grid_cols - 1) * item_spacing) / 2);
skills_start_y = 420;

// Selection tracking
selected_side = "shop"; // "shop" or "skills"
selected_row = 0;
selected_col = 0;

// Track previous selection for hover sounds
prev_selected_side = "shop";
prev_selected_row = 0;
prev_selected_col = 0;

// Exit button tracking
hovered_exit_button = ""; // "new_run", "menu", or ""
selected_exit_button = -1; // -1 = none, 0 = new_run, 1 = menu
prev_selected_exit_button = -1;

// Confirmation dialog
show_confirmation = false;
confirmation_item = noone;
confirmation_type = ""; // "skill" or "shop"
confirmation_selection = "no"; // "yes" or "no"

// Exit confirmation
show_exit_confirmation = false;
exit_action = ""; // "new_run" or "menu"
exit_selection = "no";

// Error message
show_error_message = false;
error_message_timer = 0;
error_message_duration = 180; // 3 seconds
error_type = ""; // "skill" or "shop"

// Exit buttons
exit_button_width = 300;
exit_button_height = 60;
new_run_button_x = menu_width / 2 - exit_button_width - 20;
new_run_button_y = menu_height - 100;
menu_button_x = menu_width / 2 + 20;
menu_button_y = menu_height - 100;

// Shop items array
shop_items = [
    {
        name: "Ring of Deflection",
        sprite: spr_ringOfDeflection,
        description: "25% chance to dodge attacks",
        cost: 1000,
        saveVar: "hasRingOfDeflection"
    },
    {
        name: "Rod of Draconic Fury",
        sprite: spr_rodOfDraconicFury,
        description: "Auto-attacks explode and deal AOE damage on hit.",
        cost: 1500,
        saveVar: "hasRodOfDraconicFury"
    },
    {
        name: "Archmage's Robe",
        sprite: spr_archmageRobe,
        description: "Mana regenerates 50% faster",
        cost: 2000,
        saveVar: "hasArchmageRobe"
    },
    {
        name: "Talisman of Regeneration",
        sprite: spr_talismanOfRegeneration,
        description: "Regain 1 HP every 15 seconds",
        cost: 2000,
        saveVar: "hasTalismanOfRegeneration"
    },
    {
        name: "Circlet of Mind Expansion",
        sprite: spr_circletOfMindExpansion,
        description: "All spell cooldowns reduced by 50%",
        cost: 2500,
        saveVar: "hasCircletOfMindExpansion"
    },
    {
        name: "Ring of Arcane Might",
        sprite: spr_ringOfArcaneMight,
        description: "Critical hits deal 400% damage instead of 200%",
        cost: 3000,
        saveVar: "hasRingOfArcaneMight"
    }
];

// Skills array
skills = [
    {
        name: "Max HP",
        displayBonus: "+2 HP",
        cost: [500, 1000, 2000, 4000, 8000],
        saveVar: "pcUpgradeHP"
    },
    {
        name: "Max MP",
        displayBonus: "+2 MP",
        cost: [500, 1000, 2000, 4000, 8000],
        saveVar: "pcUpgradeMP"
    },
    {
        name: "Damage",
        displayBonus: "+20%",
        cost: [500, 1000, 2000, 4000, 8000],
        saveVar: "pcUpgradeDamage"
    },
    {
        name: "Crit Chance",
        displayBonus: "+5%",
        cost: [500, 1000, 2000, 4000, 8000],
        saveVar: "pcUpgradeCrit"
    },
    {
        name: "Attack Spd",
        displayBonus: "+10%",
        cost: [500, 1000, 2000, 4000, 8000],
        saveVar: "pcUpgradeAttackSpeed"
    },
    {
        name: "Range",
        displayBonus: "+20%",
        cost: [500, 1000, 2000, 4000, 8000],
        saveVar: "pcUpgradeRange"
    }
];

// Stop level music and start upgrade music
if (audio_is_playing(snd_musicLevels)) {
    audio_stop_sound(snd_musicLevels);
}
audio_play_sound(snd_musicUpgrades, 1, true);