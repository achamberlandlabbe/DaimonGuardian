/// obj_tutorial Create Event
depth = -10003; // Above upgrade menu (-10002)
current_screen = 0;
total_screens = 6; // Changed from 5 to 6

// Tutorial text for each screen
tutorial_text = [
    "Aim the mage's targetable attacks using the cursor.",
    
    "While he can throw arcane bolts indefinitely, the other spells\nfound in your spell bar consume mana, which regenerates over time.",
    
    "Enemies drop components which you collect using the telekinesis spell.\nAccess the enchantments menu by pressing " + get_button_name("enchantmentMenu") + " to weave\npowerful effects.",
    
    "If you die, you lose your entire progression, so know when to retreat.\nBy pressing " + get_button_name("runAway") + ", you can leave the current run, and while\ncomponents and enchantments expire, you keep the gold and XP earned.",
    
    "In between runs, you can spend those resources to buy powerful items\nand increase your skills, which you keep between runs.",
    
    "Press " + get_button_name("accept") + " to start"
];

// Pause game during tutorial
global.isPaused = true;