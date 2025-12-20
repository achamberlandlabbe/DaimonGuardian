/// obj_enchantmentMenu Create Event
show_debug_message("Enchantment menu created - ID: " + string(id));
global.isPaused = true;

// Menu positioning (matching obj_options style)
menu_x = room_width * 0.3;
menu_y = room_height * 0.2;
menu_width = room_width * 0.4;
menu_height = room_height * 0.6;

// UI styling
titleColor = make_color_rgb(125, 249, 255);    // #7DF9FF
border_color = c_white;
text_color = c_white;
bg_alpha = 0.8;

// Enchantment selection
selectedEnchantment = 0;

// Track previous selection for hover sounds
prev_selectedEnchantment = 0;

// Confirmation state
showConfirmation = false;
confirmSelection = 1; // 0 = Yes, 1 = No (default to No)
prev_confirmSelection = 1;

// Define enchantments
enchantments = [
    {
        name: "Biting Gale",
        description: "Every 15 seconds, fires 5 teeth at high speed towards the cursor, damaging the first enemy they hit.",
        cost: [
            {inventory_key: "intactTooth", sprite: spr_intactTooth, amount: 5},
            {inventory_key: "pristineFeather", sprite: spr_pristineFeather, amount: 1},
            {inventory_key: "crystallizedFocus", sprite: spr_crystallizedFocus, amount: 1}
        ]
    },
    {
        name: "Noxious Cloud",
        description: "Every 15 seconds, spawns poison fumes for 5 seconds. Enemies touching fumes take 1 damage per second for 5 seconds.",
        cost: [
            {inventory_key: "toxicMushroom", sprite: spr_toxicMushroom, amount: 3},
            {inventory_key: "pristineFeather", sprite: spr_pristineFeather, amount: 2},
            {inventory_key: "crystallizedIntensity", sprite: spr_crystallizedIntensity, amount: 1}
        ]
    },
    {
        name: "Preemptive Lash",
        description: "Automatically attacks nearby enemies, striking the closest one every 2 seconds.",
        cost: [
            {inventory_key: "sinew", sprite: spr_sinew, amount: 3},
            {inventory_key: "pristineFeather", sprite: spr_pristineFeather, amount: 2},
            {inventory_key: "crystallizedInstinct", sprite: spr_crystallizedInstinct, amount: 1}
        ]
    },
    {
        name: "Barbed Bindings",
        description: "Every 10 seconds, binds nearest enemy for up to 10 seconds dealing 1 damage per second. Immobilizes or slows weak enemies.",
        cost: [
            {inventory_key: "intactTooth", sprite: spr_intactTooth, amount: 1},
            {inventory_key: "sinew", sprite: spr_sinew, amount: 1},
            {inventory_key: "crystallizedIntensity", sprite: spr_crystallizedIntensity, amount: 1}
        ]
    },
    {
        name: "Hex Ward",
        description: "Grants a chance to resist curses that would hinder your abilities.",
        cost: [
            {inventory_key: "toxicMushroom", sprite: spr_toxicMushroom, amount: 1},
            {inventory_key: "pristineFeather", sprite: spr_pristineFeather, amount: 5},
            {inventory_key: "crystallizedTenacity", sprite: spr_crystallizedTenacity, amount: 1}
        ]
    }
];

// Track owned enchantment levels
ownedEnchantments = {
    barbedBindings: 0, // 0 = not owned, 1 = level 1, 2 = level 2, 3 = level 3
    bitingGale: 0,
    noxiousCloud: 0,
    preemptiveLash: 0,
    hexWard: 0
};

// Level 2 enchantment definitions
enchantmentsLevel2 = {
    barbedBindings: {
        name: "Barbed Bindings II",
        description: "Increases Barbed Bindings' duration by 20%, and can bind a second nearby enemy.",
        cost: [
            {inventory_key: "intactTooth", sprite: spr_intactTooth, amount: 1},
            {inventory_key: "sinew", sprite: spr_sinew, amount: 1},
            {inventory_key: "crystallizedIntensity", sprite: spr_crystallizedIntensity, amount: 2}
        ]
    },
    preemptiveLash: {
        name: "Preemptive Lash II",
        description: "Increases Preemptive Lash's range by 25%, damage by 20%, and knocks the target back a short distance.",
        cost: [
            {inventory_key: "sinew", sprite: spr_sinew, amount: 3},
            {inventory_key: "pristineFeather", sprite: spr_pristineFeather, amount: 2},
            {inventory_key: "crystallizedInstinct", sprite: spr_crystallizedInstinct, amount: 1},
            {inventory_key: "crystallizedIntensity", sprite: spr_crystallizedIntensity, amount: 1}
        ]
    },
    hexWard: {
        name: "Hex Ward II",
        description: "Increases curse resistance to 50%.",
        cost: [
            {inventory_key: "toxicMushroom", sprite: spr_toxicMushroom, amount: 1},
            {inventory_key: "pristineFeather", sprite: spr_pristineFeather, amount: 5},
            {inventory_key: "crystallizedTenacity", sprite: spr_crystallizedTenacity, amount: 1},
            {inventory_key: "crystallizedIntensity", sprite: spr_crystallizedIntensity, amount: 1}
        ]
    },
    bitingGale: {
        name: "Biting Gale II",
        description: "Fires 1 extra tooth (6 total).",
        cost: [
            {inventory_key: "intactTooth", sprite: spr_intactTooth, amount: 5},
            {inventory_key: "pristineFeather", sprite: spr_pristineFeather, amount: 1},
            {inventory_key: "crystallizedFocus", sprite: spr_crystallizedFocus, amount: 1},
            {inventory_key: "crystallizedIntensity", sprite: spr_crystallizedIntensity, amount: 1}
        ]
    },
    noxiousCloud: {
        name: "Noxious Cloud II",
        description: "Poison deals 20% more damage.",
        cost: [
            {inventory_key: "toxicMushroom", sprite: spr_toxicMushroom, amount: 3},
            {inventory_key: "pristineFeather", sprite: spr_pristineFeather, amount: 2},
            {inventory_key: "crystallizedIntensity", sprite: spr_crystallizedIntensity, amount: 2}
        ]
    }
};

// Level 3 enchantment definitions
enchantmentsLevel3 = {
    barbedBindings: {
        name: "Barbed Bindings III",
        description: "Increases Barbed Bindings' duration by an additional 20%, and can bind up to 2 additional nearby enemies.",
        cost: [
            {inventory_key: "intactTooth", sprite: spr_intactTooth, amount: 1},
            {inventory_key: "sinew", sprite: spr_sinew, amount: 1},
            {inventory_key: "crystallizedIntensity", sprite: spr_crystallizedIntensity, amount: 3}
        ]
    },
    preemptiveLash: {
        name: "Preemptive Lash III",
        description: "Increases Preemptive Lash's range and damage by an additional 25% and 20% respectively, and knocks the target back further.",
        cost: [
            {inventory_key: "sinew", sprite: spr_sinew, amount: 3},
            {inventory_key: "pristineFeather", sprite: spr_pristineFeather, amount: 2},
            {inventory_key: "crystallizedInstinct", sprite: spr_crystallizedInstinct, amount: 1},
            {inventory_key: "crystallizedIntensity", sprite: spr_crystallizedIntensity, amount: 2}
        ]
    },
    hexWard: {
        name: "Hex Ward III",
        description: "Increases curse resistance to 75%.",
        cost: [
            {inventory_key: "toxicMushroom", sprite: spr_toxicMushroom, amount: 1},
            {inventory_key: "pristineFeather", sprite: spr_pristineFeather, amount: 5},
            {inventory_key: "crystallizedTenacity", sprite: spr_crystallizedTenacity, amount: 1},
            {inventory_key: "crystallizedIntensity", sprite: spr_crystallizedIntensity, amount: 2}
        ]
    },
    bitingGale: {
        name: "Biting Gale III",
        description: "Fires 2 extra teeth (7 total).",
        cost: [
            {inventory_key: "intactTooth", sprite: spr_intactTooth, amount: 5},
            {inventory_key: "pristineFeather", sprite: spr_pristineFeather, amount: 1},
            {inventory_key: "crystallizedFocus", sprite: spr_crystallizedFocus, amount: 1},
            {inventory_key: "crystallizedIntensity", sprite: spr_crystallizedIntensity, amount: 2}
        ]
    },
    noxiousCloud: {
        name: "Noxious Cloud III",
        description: "Poison deals an additional 20% more damage.",
        cost: [
            {inventory_key: "toxicMushroom", sprite: spr_toxicMushroom, amount: 3},
            {inventory_key: "pristineFeather", sprite: spr_pristineFeather, amount: 2},
            {inventory_key: "crystallizedIntensity", sprite: spr_crystallizedIntensity, amount: 3}
        ]
    }
};

// Sync owned enchantments from obj_enchantments if it exists
if (instance_exists(obj_enchantments)) {
    if (obj_enchantments.bitingGale) {
        // Check level
        ownedEnchantments.bitingGale = obj_enchantments.bitingGaleLevel;
    }
    if (obj_enchantments.noxiousCloud) {
        // Check level
        ownedEnchantments.noxiousCloud = obj_enchantments.noxiousCloudLevel;
    }
    if (obj_enchantments.preemptiveLash) {
        // Check level
        ownedEnchantments.preemptiveLash = obj_enchantments.preemptiveLashLevel;
    }
    if (obj_enchantments.barbedBindings) {
        // Check level
        ownedEnchantments.barbedBindings = obj_enchantments.barbedBindingsLevel;
    }
    if (variable_instance_exists(obj_enchantments, "hexWard") && obj_enchantments.hexWard) {
        // Check level
        ownedEnchantments.hexWard = obj_enchantments.hexWardLevel;
    }
}

// Filter out already-owned enchantments and add their upgrades
var filtered_enchantments = [];

for (var i = 0; i < array_length(enchantments); i++) {
    var enchant = enchantments[i];
    var should_include = true;
    
    // Check if this enchantment is already owned
    if (enchant.name == "Biting Gale" && ownedEnchantments.bitingGale >= 1) {
        should_include = false;
    }
    if (enchant.name == "Noxious Cloud" && ownedEnchantments.noxiousCloud >= 1) {
        should_include = false;
    }
    if (enchant.name == "Preemptive Lash" && ownedEnchantments.preemptiveLash >= 1) {
        should_include = false;
    }
    if (enchant.name == "Barbed Bindings" && ownedEnchantments.barbedBindings >= 1) {
        should_include = false;
    }
    if (enchant.name == "Hex Ward" && ownedEnchantments.hexWard >= 1) {
        should_include = false;
    }
    
    if (should_include) {
        array_push(filtered_enchantments, enchant);
    }
}

// Replace enchantments array with filtered version
enchantments = filtered_enchantments;

// Add Level 2 versions for owned Level 1 enchantments
if (ownedEnchantments.barbedBindings == 1) {
    array_push(enchantments, enchantmentsLevel2.barbedBindings);
}
if (ownedEnchantments.preemptiveLash == 1) {
    array_push(enchantments, enchantmentsLevel2.preemptiveLash);
}
if (ownedEnchantments.hexWard == 1) {
    array_push(enchantments, enchantmentsLevel2.hexWard);
}
if (ownedEnchantments.bitingGale == 1) {
    array_push(enchantments, enchantmentsLevel2.bitingGale);
}
if (ownedEnchantments.noxiousCloud == 1) {
    array_push(enchantments, enchantmentsLevel2.noxiousCloud);
}

// Add Level 3 versions for owned Level 2 enchantments
if (ownedEnchantments.barbedBindings == 2) {
    array_push(enchantments, enchantmentsLevel3.barbedBindings);
}
if (ownedEnchantments.preemptiveLash == 2) {
    array_push(enchantments, enchantmentsLevel3.preemptiveLash);
}
if (ownedEnchantments.hexWard == 2) {
    array_push(enchantments, enchantmentsLevel3.hexWard);
}
if (ownedEnchantments.bitingGale == 2) {
    array_push(enchantments, enchantmentsLevel3.bitingGale);
}
if (ownedEnchantments.noxiousCloud == 2) {
    array_push(enchantments, enchantmentsLevel3.noxiousCloud);
}

// Error message display
errorMessageTimer = 0;