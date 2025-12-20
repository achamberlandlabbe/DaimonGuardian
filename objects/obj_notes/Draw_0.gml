// ===== obj_notes - Draw Event (FIXED - No draw_set_line_width) =====
// Replace your entire obj_notes Draw Event with this:

// Symbol properties
var symbol_size = 32;
var center_x = x;
var center_y = y;

// Base circle for all symbols (brass)
draw_set_color(make_color_rgb(184, 134, 11)); // Brass color
draw_circle(center_x, center_y, symbol_size, false);

draw_set_color(make_color_rgb(120, 87, 7)); // Dark brass
draw_circle(center_x, center_y, symbol_size - 4, false);

// Draw the specific pattern based on drumType with main colors AND complementary outlines
switch (drumType) {
case 0: // Crash - Explosive starburst (RED with CYAN outline)
	// Draw cyan outline first (complementary to red)
	draw_set_color(make_color_rgb(0, 255, 255)); // Cyan outline
	for (var i = 0; i < 8; i++) {
	var angle = i * 45;
	var inner_radius = 8;
	var outer_radius = 24;
	var inner_x = center_x + lengthdir_x(inner_radius, angle);
	var inner_y = center_y + lengthdir_y(inner_radius, angle);
	var outer_x = center_x + lengthdir_x(outer_radius, angle);
	var outer_y = center_y + lengthdir_y(outer_radius, angle);
	draw_line_width(inner_x, inner_y, outer_x, outer_y, 5); // Thicker for outline
	}
	// Draw red main pattern
	draw_set_color(make_color_rgb(255, 50, 50)); // Bright red
	for (var i = 0; i < 8; i++) {
	var angle = i * 45;
	var inner_radius = 8;
	var outer_radius = 24;
	var inner_x = center_x + lengthdir_x(inner_radius, angle);
	var inner_y = center_y + lengthdir_y(inner_radius, angle);
	var outer_x = center_x + lengthdir_x(outer_radius, angle);
	var outer_y = center_y + lengthdir_y(outer_radius, angle);
	draw_line_width(inner_x, inner_y, outer_x, outer_y, 3);
	}
	break;
	
case 1: // Ride - Double chevron (CYAN with RED outline)
	// Draw red outline first
	draw_set_color(make_color_rgb(255, 50, 50)); // Red outline
	draw_line_width(center_x - 16, center_y - 8, center_x, center_y - 16, 5);
	draw_line_width(center_x, center_y - 16, center_x + 16, center_y - 8, 5);
	draw_line_width(center_x - 12, center_y + 4, center_x, center_y - 4, 5);
	draw_line_width(center_x, center_y - 4, center_x + 12, center_y + 4, 5);
	// Draw cyan main pattern
	draw_set_color(make_color_rgb(0, 200, 255)); // Bright cyan
	draw_line_width(center_x - 16, center_y - 8, center_x, center_y - 16, 3);
	draw_line_width(center_x, center_y - 16, center_x + 16, center_y - 8, 3);
	draw_line_width(center_x - 12, center_y + 4, center_x, center_y - 4, 3);
	draw_line_width(center_x, center_y - 4, center_x + 12, center_y + 4, 3);
	break;
	
case 2: // Snare - Diamonds in circle (WHITE with BLACK outline)
	// Draw black outline first
	draw_set_color(c_black); // Black outline for white
	for (var i = 0; i < 4; i++) {
	var angle = i * 90;
	var diamond_x = center_x + lengthdir_x(12, angle);
	var diamond_y = center_y + lengthdir_y(12, angle);
	var diamond_size = 6;
	
	draw_line_width(diamond_x - diamond_size, diamond_y, diamond_x, diamond_y - diamond_size, 4);
	draw_line_width(diamond_x, diamond_y - diamond_size, diamond_x + diamond_size, diamond_y, 4);
	draw_line_width(diamond_x + diamond_size, diamond_y, diamond_x, diamond_y + diamond_size, 4);
	draw_line_width(diamond_x, diamond_y + diamond_size, diamond_x - diamond_size, diamond_y, 4);
	}
	// Draw white main pattern
	draw_set_color(c_white); // Pure white
	for (var i = 0; i < 4; i++) {
	var angle = i * 90;
	var diamond_x = center_x + lengthdir_x(12, angle);
	var diamond_y = center_y + lengthdir_y(12, angle);
	var diamond_size = 6;
	
	draw_line_width(diamond_x - diamond_size, diamond_y, diamond_x, diamond_y - diamond_size, 2);
	draw_line_width(diamond_x, diamond_y - diamond_size, diamond_x + diamond_size, diamond_y, 2);
	draw_line_width(diamond_x + diamond_size, diamond_y, diamond_x, diamond_y + diamond_size, 2);
	draw_line_width(diamond_x, diamond_y + diamond_size, diamond_x - diamond_size, diamond_y, 2);
	}
	break;
	
case 3: // High Tom - Sunburst in circle (GREEN with MAGENTA outline)
	// Draw magenta outline first
	draw_set_color(make_color_rgb(255, 50, 255)); // Magenta outline
	for (var i = 0; i < 12; i++) {
	var angle = i * 30;
	var inner_radius = 6;
	var outer_radius = 20;
	var inner_x = center_x + lengthdir_x(inner_radius, angle);
	var inner_y = center_y + lengthdir_y(inner_radius, angle);
	var outer_x = center_x + lengthdir_x(outer_radius, angle);
	var outer_y = center_y + lengthdir_y(outer_radius, angle);
	draw_line_width(inner_x, inner_y, outer_x, outer_y, 4);
	}
	// Draw green main pattern
	draw_set_color(make_color_rgb(50, 255, 50)); // Bright green
	for (var i = 0; i < 12; i++) {
	var angle = i * 30;
	var inner_radius = 6;
	var outer_radius = 20;
	var inner_x = center_x + lengthdir_x(inner_radius, angle);
	var inner_y = center_y + lengthdir_y(inner_radius, angle);
	var outer_x = center_x + lengthdir_x(outer_radius, angle);
	var outer_y = center_y + lengthdir_y(outer_radius, angle);
	draw_line_width(inner_x, inner_y, outer_x, outer_y, 2);
	}
	break;
	
case 4: // Mid Tom - Concentric rings in circle (YELLOW with PURPLE outline)
	// Draw purple outline first (using thick circles)
	draw_set_color(make_color_rgb(150, 50, 255)); // Purple outline
	for (var i = 1; i <= 3; i++) {
	var ring_radius = i * 6;
	// Draw thick circles by drawing multiple circles
	draw_circle(center_x, center_y, ring_radius + 1, true);
	draw_circle(center_x, center_y, ring_radius, true);
	draw_circle(center_x, center_y, ring_radius - 1, true);
	}
	for (var i = 0; i < 4; i++) {
	var angle = i * 90;
	var inner_x = center_x + lengthdir_x(6, angle);
	var inner_y = center_y + lengthdir_y(6, angle);
	var outer_x = center_x + lengthdir_x(18, angle);
	var outer_y = center_y + lengthdir_y(18, angle);
	draw_line_width(inner_x, inner_y, outer_x, outer_y, 4);
	}
	// Draw yellow main pattern
	draw_set_color(make_color_rgb(255, 255, 50)); // Bright yellow
	for (var i = 1; i <= 3; i++) {
	var ring_radius = i * 6;
	draw_circle(center_x, center_y, ring_radius, true);
	}
	for (var i = 0; i < 4; i++) {
	var angle = i * 90;
	var inner_x = center_x + lengthdir_x(6, angle);
	var inner_y = center_y + lengthdir_y(6, angle);
	var outer_x = center_x + lengthdir_x(18, angle);
	var outer_y = center_y + lengthdir_y(18, angle);
	draw_line_width(inner_x, inner_y, outer_x, outer_y, 2);
	}
	break;
	
case 5: // Floor Tom - Horizontal steps in circle (PURPLE with YELLOW outline)
	// Draw yellow outline first
	draw_set_color(make_color_rgb(255, 255, 50)); // Yellow outline
	for (var i = 0; i < 5; i++) {
	var step_y = center_y - 16 + (i * 8);
	var step_width = 20 - (i * 3);
	draw_line_width(center_x - step_width, step_y, center_x + step_width, step_y, 5);
	}
	// Draw purple main pattern
	draw_set_color(make_color_rgb(200, 50, 255)); // Bright purple
	for (var i = 0; i < 5; i++) {
	var step_y = center_y - 16 + (i * 8);
	var step_width = 20 - (i * 3);
	draw_line_width(center_x - step_width, step_y, center_x + step_width, step_y, 3);
	}
	break;
	
case 6: // Hi-hat - Nested triangles (ORANGE with BLUE outline)
	// Draw blue outline first
	draw_set_color(make_color_rgb(50, 100, 255)); // Blue outline
	// Outer triangle
	draw_line_width(center_x, center_y - 18, center_x - 16, center_y + 12, 5);
	draw_line_width(center_x - 16, center_y + 12, center_x + 16, center_y + 12, 5);
	draw_line_width(center_x + 16, center_y + 12, center_x, center_y - 18, 5);
	// Inner triangle
	draw_line_width(center_x, center_y + 8, center_x - 10, center_y - 8, 4);
	draw_line_width(center_x - 10, center_y - 8, center_x + 10, center_y - 8, 4);
	draw_line_width(center_x + 10, center_y - 8, center_x, center_y + 8, 4);
	
	// Draw orange main pattern
	draw_set_color(make_color_rgb(255, 150, 0)); // Bright orange
	// Outer triangle
	draw_line_width(center_x, center_y - 18, center_x - 16, center_y + 12, 3);
	draw_line_width(center_x - 16, center_y + 12, center_x + 16, center_y + 12, 3);
	draw_line_width(center_x + 16, center_y + 12, center_x, center_y - 18, 3);
	// Inner triangle
	draw_line_width(center_x, center_y + 8, center_x - 10, center_y - 8, 2);
	draw_line_width(center_x - 10, center_y - 8, center_x + 10, center_y - 8, 2);
	draw_line_width(center_x + 10, center_y - 8, center_x, center_y + 8, 2);
	break;
	
case 7: // Bass - Nested squares (BLUE with ORANGE outline)
	// Draw orange outline first (using thick rectangles)
	draw_set_color(make_color_rgb(255, 150, 0)); // Orange outline
	// Draw thick rectangles by drawing multiple rectangles
	for (var j = 0; j < 3; j++) {
	draw_rectangle(center_x - 18 - j, center_y - 18 - j, center_x + 18 + j, center_y + 18 + j, true);
	draw_rectangle(center_x - 12 - j, center_y - 12 - j, center_x + 12 + j, center_y + 12 + j, true);
	draw_rectangle(center_x - 6 - j, center_y - 6 - j, center_x + 6 + j, center_y + 6 + j, true);
	}
	draw_circle(center_x, center_y, 4, false);
	
	// Draw blue main pattern
	draw_set_color(make_color_rgb(50, 100, 255)); // Bright blue
	draw_rectangle(center_x - 18, center_y - 18, center_x + 18, center_y + 18, true);
	draw_rectangle(center_x - 12, center_y - 12, center_x + 12, center_y + 12, true);
	draw_rectangle(center_x - 6, center_y - 6, center_x + 6, center_y + 6, true);
	draw_circle(center_x, center_y, 2, false);
	break;
	
default:
	// Fallback pattern
	draw_set_color(c_white);
	draw_text(center_x - 10, center_y - 5, "?");
	break;
}

// Reset drawing properties
draw_set_color(c_white);
