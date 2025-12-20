// Set drawing depth and visibility
visible = true;
depth = -3000; // FIXED: Changed from -800 to draw over all menu objects

// Art Deco colors for UI
ui_gold = make_color_rgb(255, 215, 0);
ui_brass = make_color_rgb(184, 134, 11);
ui_dark_brass = make_color_rgb(120, 87, 7);
ui_cream = make_color_rgb(255, 248, 220);

// Progress bar settings
bar_width = 600;
bar_height = 40;
bar_x = (room_width - bar_width) / 2;
bar_y = 20;

// Light bulb colors for progress bar
bulb_off = make_color_rgb(60, 45, 30);
bulb_on = make_color_rgb(255, 255, 200);
bulb_glow = make_color_rgb(255, 215, 0);

// Text positioning settings
column_width = 60; // Match stage column width
hud_height = 80;   // Match stage HUD height
shift_amount = 60;

// ===== ART DECO PEACOCK FEATHER PERFORMANCE METERS =====
// Feather positioning (on left and right columns)
feather_left_x = column_width / 2;  // Center of left column
feather_right_x = room_width - (column_width / 2);  // Center of right column
feather_y = 350;  // Position at approximately 2/3 of column height (moved down from 200)
feather_height = 300;  // Total height of feather
feather_width = 45;   // Width of feather at widest point

// Feather visual properties
feather_segments = 12;  // Number of segments that can light up
feather_base_width = 15;  // FIXED: Removed extra period - Width at bottom (bulb area)
feather_tip_width = 5;   // Width at top

// Performance meter colors
perf_excellent = make_color_rgb(255, 215, 0);  // Gold
perf_good = make_color_rgb(0, 255, 100);       // Green
perf_warning = make_color_rgb(255, 165, 0);    // Orange
perf_danger = make_color_rgb(255, 50, 50);     // Red
perf_metal = make_color_rgb(150, 150, 150);    // Metal frame
perf_glass_dark = make_color_rgb(40, 40, 60);  // Dark glass

// Beat flash timing
beat_flash_timer = 0;
beat_flash_duration = 0.2; // How long the flash lasts (in seconds)
last_beat_time = 0;