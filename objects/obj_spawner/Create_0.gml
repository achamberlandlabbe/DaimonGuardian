/// obj_spawner Create Event
// Simple continuous enemy spawning system
persistent = true;  // Stay alive across room changes


// Spawn timing
spawn_timer = 0;
spawn_rate_current = 120;  // Start at 1 enemy per 2 seconds
spawn_rate_target = 60;   // Ramp to 1 enemy per 1 seconds 
spawn_rate_ramp_speed = 0.1;  // How fast spawn rate increases

// Spawn area (around camera edges)
spawn_margin = 100;  // How far outside camera to spawn

// Enemy types to spawn (for now just eidolons)
enemy_types = [obj_eidolon];

// Debug
show_debug_message("Spawner created! Will spawn enemies around camera view.");
