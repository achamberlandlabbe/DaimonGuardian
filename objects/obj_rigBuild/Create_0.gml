/// obj_rigBuild Create Event
// Pause the game
global.isPaused = true;
// Menu depth (above most things, below tutorial)
depth = -10002;
// Tab hover tracking (initialize early before any events run)
hovered_tab_index = -1;
// Tab system
current_tab = "chassis"; // chassis, internal, external, armor, equipment
tabs = ["chassis", "internal", "external", "armor", "equipment"];
selected_tab_index = 0;
// Grid system
grid_square_size = 32; // Standardized 32x32 pixels per grid square
// Menu positioning
menu_width = display_get_gui_width() * 0.8;
menu_height = display_get_gui_height() * 0.8;
menu_x = (display_get_gui_width() - menu_width) / 2;
menu_y = (display_get_gui_height() - menu_height) / 2;
// Tab bar positioning
tab_bar_height = 60;
tab_width = menu_width / array_length(tabs);
// Content area (below tabs)
content_x = menu_x;
content_y = menu_y + tab_bar_height;
content_width = menu_width;
content_height = menu_height - tab_bar_height;
// Chassis selection list (left side)
chassis_list_width = content_width * 0.3;
chassis_list_x = content_x + 20;
chassis_list_y = content_y + 20;
chassis_list_height = content_height - 100;
// Chassis item dimensions
chassis_item_height = 80;
chassis_item_spacing = 10;
// Scrolling
chassis_scroll_offset = 0;
max_chassis_scroll = 0; // Will be calculated based on items
// Available chassis
chassis_options = [
    { 
        name: "Doombuggy",
        sprite: spr_frameSmall,
        wheel_sprite: spr_wheelSmall,
        wheelbase: 53,
        max_steering: 45,
        left_axle_x: 8,
        left_axle_y: 15,
        right_axle_x: 51,
        right_axle_y: 15,
        wheel_offset: 4,
        // Real-world physical properties for physics calculations
        chassis_weight: 800,        // Lightweight dune buggy frame (lbs)
        drag_coefficient: 0.45,     // Sleek, open design - good aerodynamics
        frontal_area: 20,           // Frontal area in sq ft (small, open buggy)
        wheel_radius: 1.0,          // Wheel radius in feet (24" dune buggy tires)
        // Grid dimensions
        grid_cols: 2,
        grid_rows: 3,
        unlocked: true
    },
    { 
        name: "Wreckup",
        sprite: spr_frameMedium,
        wheel_sprite: spr_wheelMedium,
        wheelbase: 129,
        max_steering: 45,
        left_axle_x: 11,
        left_axle_y: 49,
        right_axle_x: 72,
        right_axle_y: 49,
        wheel_offset: 4,
        // Real-world physical properties for physics calculations
        chassis_weight: 3500,       // Pickup truck frame (lbs)
        drag_coefficient: 0.50,     // Pickup-like aerodynamics
        frontal_area: 30,           // Frontal area in sq ft (pickup truck)
        wheel_radius: 1.25,         // Wheel radius in feet (30" pickup tires)
        // Grid dimensions
        grid_cols: 2,
        grid_rows: 7,
        unlocked: true
    },
    { 
        name: "Cargoon",
        sprite: spr_frameLarge,
        wheel_sprite: spr_wheelLarge,
        wheelbase: 143,
        max_steering: 45,
        left_axle_x: 18,
        left_axle_y: 27,
        right_axle_x: 75,
        right_axle_y: 27,
        wheel_offset: 4,
        // Real-world physical properties for physics calculations
        chassis_weight: 8000,       // Military truck frame (M35 "Deuce and a Half") (lbs)
        drag_coefficient: 0.70,     // Boxy truck - poor aerodynamics
        frontal_area: 40,           // Frontal area in sq ft (large military truck)
        wheel_radius: 1.5,          // Wheel radius in feet (36" military tires)
        // Grid dimensions
        grid_cols: 3,
        grid_rows: 8,
        unlocked: true
    }
];
// Determine which chassis the player currently has
var current_chassis_index = 1; // Default to Wreckup
if (instance_exists(obj_player)) {
    // Find which chassis matches the player's current frame
    for (var i = 0; i < array_length(chassis_options); i++) {
        if (obj_player.frame_sprite == chassis_options[i].sprite) {
            current_chassis_index = i;
            break;
        }
    }
}
// Selected chassis (yellow highlight - just hovering/navigating)
selected_chassis_index = current_chassis_index;
// Confirmed chassis (bright red - actually chosen to deploy with)
confirmed_chassis_index = current_chassis_index;

// Motor system
// Motor options (available motors to place)
motor_options = [
    {
        name: "Small Motor",
        sprite: spr_motorSmall,
        width: 1,  // Grid squares
        height: 1,
        weight: 200,
        horsepower: 55,
        unlocked: true
    },
    {
        name: "Medium Motor",
        sprite: spr_motorMedium,
        width: 2,
        height: 1,
        weight: 400,
        horsepower: 350,
        unlocked: true
    },
    {
        name: "Large Motor",
        sprite: spr_motorLarge,
        width: 2,
        height: 2,
        weight: 650,
        horsepower: 134,
        unlocked: true
    }
];

// Motor palette positioning (left side of internal tab)
motor_palette_width = 200;
motor_palette_x = content_x + 20;
motor_palette_y = content_y + 60;
motor_palette_item_height = 70;
motor_palette_spacing = 10;

// Dragging system
dragging_motor = noone; // Which motor index from motor_options, or noone
drag_offset_x = 0; // Offset from motor top-left to cursor
drag_offset_y = 0;

// Placed motors array - stores motors placed on the grid
// Each entry: { motor_index, grid_x, grid_y }
placed_motors = [];

// Load currently equipped motors from player
if (instance_exists(obj_player)) {
    // Check if player has equipped_internal_parts array
    if (variable_instance_exists(obj_player, "equipped_internal_parts")) {
        // Copy player's equipped motors into placed_motors
        for (var i = 0; i < array_length(obj_player.equipped_internal_parts); i++) {
            var equipped_part = obj_player.equipped_internal_parts[i];
            
            // Only load motors (in case we add other internal parts later)
            if (equipped_part.type == "motor") {
                var placed_motor = {};
                placed_motor.motor_index = equipped_part.motor_index;
                placed_motor.grid_x = equipped_part.grid_x;
                placed_motor.grid_y = equipped_part.grid_y;
                array_push(placed_motors, placed_motor);
            }
        }
    }
}

// Exit button
exit_button_text = "Deploy";
exit_button_width = 200;
exit_button_height = 50;
exit_button_x = menu_x + menu_width - exit_button_width - 20;
exit_button_y = menu_y + menu_height - exit_button_height - 20;