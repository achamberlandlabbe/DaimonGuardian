/// obj_eidolon Destroy Event
// Drop anima pickup on death

// Create anima pickup at death location
instance_create_depth(x, y, depth, obj_anima);

// TODO: Add death particles/effects
// TODO: Add death sound

show_debug_message("Eidolon destroyed, dropped anima at " + string(x) + "," + string(y));
