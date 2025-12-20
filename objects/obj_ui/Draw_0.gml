#region Room and Pause Check
// Only draw in gameplay room
if (room != RoomPlay) exit;

// Check if we're in pause state
var is_paused = global.isPaused;
#endregion

#region Universal Countdown Display
if (instance_exists(obj_gameManager) && obj_gameManager.countdownActive) {
draw_set_font(Title);
setAlign(fa_center);
draw_set_color(ui_gold);
txt(string(obj_gameManager.countdownNumber), room_width / 2, room_height / 2);
draw_set_font(Font1);
draw_set_color(c_white);
setAlign(fa_left);
// Don't exit - continue drawing other UI elements
}
#endregion

#region Progress Bar System
// ===== PROGRESS BAR WITH LIGHT BULBS - FIXED =====
var progress = 0;
if (instance_exists(obj_level) && !is_paused) {
// FIXED: Persistent completion detection
if (instance_exists(obj_gameManager) && obj_gameManager.gameState == "victory") {
	// If victory screen is showing, progress is 100%
	progress = 1.0;
} else if (variable_instance_exists(obj_level, "numberComplete") && obj_level.numberComplete) {
	// If number is complete, progress is 100% (regardless of remaining symbols)
	progress = 1.0;
} else {
	// During gameplay, use note spawning progress
	var totalNotes = array_length(obj_level.drumnumber);
	if (totalNotes > 0) {
	progress = obj_level.currentNoteIndex / totalNotes;
	} else {
	progress = 0;
	}
}
}
// During pause, keep the last known progress (don't update, but still draw)

draw_set_color(ui_dark_brass);
draw_rectangle(bar_x - 2, bar_y - 2, bar_x + bar_width + 2, bar_y + bar_height + 2, false);
draw_set_color(c_black);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);
draw_set_color(make_color_rgb(40, 30, 20));
draw_rectangle(bar_x + 4, bar_y + 4, bar_x + bar_width - 4, bar_y + bar_height - 4, false);

var bulb_count = 16;
var bulbs_lit = floor(progress * bulb_count);
var bulb_spacing = (bar_width - 20) / (bulb_count - 1);
var bulb_y = bar_y + (bar_height / 2);

for (var i = 0; i < bulb_count; i++) {
var bulb_x = bar_x + 10 + (i * bulb_spacing);
var is_lit = (i < bulbs_lit) || (i < bulbs_lit && progress * bulb_count > i);

if (is_lit) {
	draw_set_alpha(0.6);
	draw_set_color(bulb_glow);
	draw_circle(bulb_x, bulb_y, 8, false);
	draw_set_alpha(1.0);
	draw_set_color(bulb_on);
	draw_circle(bulb_x, bulb_y, 6, false);
	draw_set_color(c_white);
	draw_circle(bulb_x, bulb_y, 3, false);
} else {
	draw_set_color(bulb_off);
	draw_circle(bulb_x, bulb_y, 5, false);
	draw_set_color(make_color_rgb(80, 60, 40));
	draw_circle(bulb_x, bulb_y, 5, true);
}
}
draw_set_alpha(1.0);
#endregion

#region Game Info Display
if (!instance_exists(obj_gameManager)) exit;

draw_set_font(Font1);
draw_set_color(ui_cream);

var level_x = column_width + 30 + shift_amount;
var score_x = level_x + ((bar_x - (column_width + 30)) / 2);
var max_x = room_width - column_width - 30 - shift_amount;
var combo_x = (bar_x + bar_width) + ((max_x - (bar_x + bar_width)) / 2);
var text_y = 15 + ((hud_height - 30) / 2);

setAlign(fa_left);
txt("NUMBER: " + string(obj_gameManager.currentLevel), level_x, text_y);
setAlign(fa_center);
txt("SCORE: " + string(global.player1score), score_x, text_y);
txt("COMBO: " + string(obj_gameManager.combo), combo_x, text_y);
setAlign(fa_right);
txt("LONGEST COMBO: " + string(obj_gameManager.maxCombo), max_x, text_y);

draw_set_color(c_white);
setAlign(fa_left);
#endregion

#region Performance Lighting Setup
// ALWAYS show feathers - only control whether they react to performance or stay static
var should_show_feathers = true;
var tutorial_static_mode = false;

// During initial tutorial (before performance system is explained), show static lights
if (instance_exists(obj_gameManager) && obj_gameManager.gameState == "tutorial" && obj_gameManager.currentLevel == 0) {
var tutorial_step = obj_gameManager.tutorialStep;
// Use static mode until step 14 (performance explanation) is completed
if (tutorial_step < 15) {
	tutorial_static_mode = true;
}
}

if (should_show_feathers) {
// Reposition feathers to one-third down the column height
var column_height = room_height - hud_height;
var feather_y = hud_height + (column_height / 3);

// Calculate beat pulse brightness multiplier
var beat_pulse = 1.0;
if (instance_exists(obj_level) && !is_paused && variable_instance_exists(obj_level, "beatTimer") && variable_instance_exists(obj_level, "beatInterval")) {
	var beat_progress = (obj_level.beatTimer) / obj_level.beatInterval;
	// Create a pulse that peaks at beat and fades quickly
	var pulse_strength = max(0, 1 - (beat_progress * 4)); // Sharp fade after beat
	beat_pulse = 1.0 + (pulse_strength * 0.8); // Increase brightness by up to 80%
}
// During pause, use default beat_pulse of 1.0 (no pulsing)

// Calculate performance-based spotlight color
var spotlight_color = c_white;
var spotlight_alpha = 0;
if (instance_exists(obj_gameManager)) {
	if (tutorial_static_mode) {
	// During tutorial practice - show static yellow lights (neutral performance)
	spotlight_color = c_yellow;
	spotlight_alpha = 0.4; // Static, no beat pulse
	} else {
	// Normal gameplay - dynamic performance-based lighting
	var performance_ratio = obj_gameManager.performanceMeter / obj_gameManager.meterMaxValue;
	spotlight_alpha = 0.4 * beat_pulse; // Spotlights pulse with beat

	if (performance_ratio >= 0.5) {
		// 50% to 100%: Yellow to Green
		var green_amount = (performance_ratio - 0.5) * 2; // 0 to 1
		spotlight_color = merge_color(c_yellow, c_lime, green_amount);
	} else {
		// 0% to 50%: Red to Yellow
		var yellow_amount = performance_ratio * 2; // 0 to 1
		spotlight_color = merge_color(c_red, c_yellow, yellow_amount);
	}
	}
}

// Apply beat pulse to all colors (unless in tutorial static mode)
var gold_outline, peacock_teal, peacock_blue, peacock_purple;
if (tutorial_static_mode) {
	// Static colors during tutorial
	gold_outline = make_color_rgb(255, 215, 0);
	peacock_teal = make_color_rgb(0, 150, 150);
	peacock_blue = make_color_rgb(30, 80, 150);
	peacock_purple = make_color_rgb(80, 40, 120);
} else {
	// Dynamic pulsing colors during normal gameplay
	gold_outline = make_color_rgb(min(255, 255 * beat_pulse), min(255, 215 * beat_pulse), 0);
	peacock_teal = make_color_rgb(0, min(255, 150 * beat_pulse), min(255, 150 * beat_pulse));
	peacock_blue = make_color_rgb(min(255, 30 * beat_pulse), min(255, 80 * beat_pulse), min(255, 150 * beat_pulse));
	peacock_purple = make_color_rgb(min(255, 80 * beat_pulse), min(255, 40 * beat_pulse), min(255, 120 * beat_pulse));
}

#region Art Deco Light Fixtures
for (var f = 0; f < 2; f++) {
	var fx = (f == 0) ? feather_left_x : feather_right_x;
	
	// Draw directional spotlights illuminating the column
	if (spotlight_alpha > 0) {
	// Calculate proper light cone width (4/5 of column width)
	var spotlight_column_width = room_width / 4; // Each column is 1/4 of screen width
	var max_light_width = (spotlight_column_width * 4) / 5; // 4/5 of column width
	
	// Feather total length is approximately 120px (eye + 5 sections of 20px each)
	var feather_length = 120;
	
	// Art Deco light fixture positions (with spacing from feather)
	var fixture_above_y = feather_y - 60; // 60px above feather
	var fixture_below_y = feather_y + 180; // 60px below feather end
	var fixture_radius = 25; // Much larger for Art Deco details
	
	// Draw Art Deco light fixtures as brass half-circles
	draw_set_alpha(1.0);
	
	// Upper fixture (half-circle pointing down)
	draw_set_color(make_color_rgb(180, 150, 90)); // Darker brass base
	for (var angle = 0; angle <= 180; angle += 6) {
		var x1 = fx + cos(degtorad(angle)) * fixture_radius;
		var y1 = fixture_above_y + sin(degtorad(angle)) * fixture_radius;
		var x2 = fx + cos(degtorad(angle + 6)) * fixture_radius;
		var y2 = fixture_above_y + sin(degtorad(angle + 6)) * fixture_radius;
		draw_triangle(fx, fixture_above_y, x1, y1, x2, y2, false);
	}
	
	// Art Deco decorative elements on upper fixture
	draw_set_color(make_color_rgb(255, 215, 0)); // Bright gold accents
	// Radiating lines
	for (var ray = 30; ray <= 150; ray += 30) {
		var inner_x = fx + cos(degtorad(ray)) * (fixture_radius * 0.3);
		var inner_y = fixture_above_y + sin(degtorad(ray)) * (fixture_radius * 0.3);
		var outer_x = fx + cos(degtorad(ray)) * (fixture_radius * 0.9);
		var outer_y = fixture_above_y + sin(degtorad(ray)) * (fixture_radius * 0.9);
		draw_line_width(inner_x, inner_y, outer_x, outer_y, 2);
	}
	// Concentric arcs
	draw_set_color(make_color_rgb(220, 180, 100));
	for (var arc_radius = fixture_radius * 0.6; arc_radius <= fixture_radius * 0.8; arc_radius += 6) {
		for (var angle = 15; angle <= 165; angle += 6) {
		var x1 = fx + cos(degtorad(angle)) * arc_radius;
		var y1 = fixture_above_y + sin(degtorad(angle)) * arc_radius;
		var x2 = fx + cos(degtorad(angle + 3)) * arc_radius;
		var y2 = fixture_above_y + sin(degtorad(angle + 3)) * arc_radius;
		draw_line_width(x1, y1, x2, y2, 2);
		}
	}
	
	// Lower fixture (half-circle pointing up)
	draw_set_color(make_color_rgb(180, 150, 90)); // Darker brass base
	for (var angle = 180; angle <= 360; angle += 6) {
		var x1 = fx + cos(degtorad(angle)) * fixture_radius;
		var y1 = fixture_below_y + sin(degtorad(angle)) * fixture_radius;
		var x2 = fx + cos(degtorad(angle + 6)) * fixture_radius;
		var y2 = fixture_below_y + sin(degtorad(angle + 6)) * fixture_radius;
		draw_triangle(fx, fixture_below_y, x1, y1, x2, y2, false);
	}
	
	// Art Deco decorative elements on lower fixture  
	draw_set_color(make_color_rgb(255, 215, 0)); // Bright gold accents
	// Radiating lines
	for (var ray = 210; ray <= 330; ray += 30) {
		var inner_x = fx + cos(degtorad(ray)) * (fixture_radius * 0.3);
		var inner_y = fixture_below_y + sin(degtorad(ray)) * (fixture_radius * 0.3);
		var outer_x = fx + cos(degtorad(ray)) * (fixture_radius * 0.9);
		var outer_y = fixture_below_y + sin(degtorad(ray)) * (fixture_radius * 0.9);
		draw_line_width(inner_x, inner_y, outer_x, outer_y, 2);
	}
	// Concentric arcs
	draw_set_color(make_color_rgb(220, 180, 100));
	for (var arc_radius = fixture_radius * 0.6; arc_radius <= fixture_radius * 0.8; arc_radius += 6) {
		for (var angle = 195; angle <= 345; angle += 6) {
		var x1 = fx + cos(degtorad(angle)) * arc_radius;
		var y1 = fixture_below_y + sin(degtorad(angle)) * arc_radius;
		var x2 = fx + cos(degtorad(angle + 3)) * arc_radius;
		var y2 = fixture_below_y + sin(degtorad(angle + 3)) * arc_radius;
		draw_line_width(x1, y1, x2, y2, 2);
		}
	}
	
	#region Spotlight Beam Effects
	// Draw realistic diffused spotlight beams
	draw_set_color(spotlight_color);
	
	// Upper spotlight - shining UPWARD with diffusion
	var upper_beam_start_y = fixture_above_y;
	var upper_beam_end_y = fixture_above_y - feather_length;
	var beam_distance = abs(upper_beam_end_y - upper_beam_start_y);
	
	// Create multiple segments for smooth diffusion
	var segments = 8;
	for (var seg = 0; seg < segments; seg++) {
		var seg_progress = seg / segments;
		var next_seg_progress = (seg + 1) / segments;
		
		var seg_y1 = upper_beam_start_y - (seg_progress * beam_distance);
		var seg_y2 = upper_beam_start_y - (next_seg_progress * beam_distance);
		
		// Calculate diffusion: less opacity as distance increases
		var diffusion_alpha1 = spotlight_alpha * (1 - seg_progress * 0.8);
		var diffusion_alpha2 = spotlight_alpha * (1 - next_seg_progress * 0.8);
		
		// Calculate beam expansion
		var beam_width1 = fixture_radius + (seg_progress * 20);
		var beam_width2 = fixture_radius + (next_seg_progress * 20);
		beam_width1 = min(beam_width1, max_light_width);
		beam_width2 = min(beam_width2, max_light_width);
		
		// Draw trapezoid segment with gradient effect
		draw_set_alpha(diffusion_alpha1);
		draw_triangle(fx - beam_width1/2, seg_y1, fx + beam_width1/2, seg_y1, fx - beam_width2/2, seg_y2, false);
		draw_triangle(fx + beam_width1/2, seg_y1, fx + beam_width2/2, seg_y2, fx - beam_width2/2, seg_y2, false);
	}

	// Lower spotlight - shining DOWNWARD with diffusion
	var lower_beam_start_y = fixture_below_y;
	var lower_beam_end_y = fixture_below_y + feather_length;
	beam_distance = abs(lower_beam_end_y - lower_beam_start_y);

	for (var seg = 0; seg < segments; seg++) {
		var seg_progress = seg / segments;
		var next_seg_progress = (seg + 1) / segments;
		
		var seg_y1 = lower_beam_start_y + (seg_progress * beam_distance);
		var seg_y2 = lower_beam_start_y + (next_seg_progress * beam_distance);
		
		// Calculate diffusion: less opacity as distance increases
		var diffusion_alpha1 = spotlight_alpha * (1 - seg_progress * 0.8);
		var diffusion_alpha2 = spotlight_alpha * (1 - next_seg_progress * 0.8);
		
		// Calculate beam expansion
		var beam_width1 = fixture_radius + (seg_progress * 20);
		var beam_width2 = fixture_radius + (next_seg_progress * 20);
		beam_width1 = min(beam_width1, max_light_width);
		beam_width2 = min(beam_width2, max_light_width);
		
		// Draw trapezoid segment with gradient effect
		draw_set_alpha(diffusion_alpha1);
		draw_triangle(fx - beam_width1/2, seg_y1, fx + beam_width1/2, seg_y1, fx - beam_width2/2, seg_y2, false);
		draw_triangle(fx + beam_width1/2, seg_y1, fx + beam_width2/2, seg_y2, fx - beam_width2/2, seg_y2, false);
	}
	
	draw_set_alpha(1.0);
	#endregion
	}

	#region Peacock Feather Drawing
	var eye_radius = 16;
	var eye_center_y = feather_y + eye_radius;
	var left_end_x = fx - eye_radius;
	var right_end_x = fx + eye_radius;
	var semicircle_end_y = eye_center_y;
	var meeting_point_y = semicircle_end_y + eye_radius;
	var curve_points = 20;
	
	// Fill feather tip
	draw_set_alpha(0.8);
	draw_set_color(peacock_teal);
	for (var p = 0; p < 12; p++) {
	var angle1 = pi + (p / 12) * pi;
	var angle2 = pi + ((p + 1) / 12) * pi;
	var x1 = fx + cos(angle1) * eye_radius;
	var y1 = eye_center_y + sin(angle1) * eye_radius;
	var x2 = fx + cos(angle2) * eye_radius;
	var y2 = eye_center_y + sin(angle2) * eye_radius;
	draw_triangle(fx, eye_center_y, x1, y1, x2, y2, false);
	}
	
	// Fill curved bottom and draw all chevron sections
	var copy_offsets = [0, 20, 40, 60, 80, 100];
	for (var s = 0; s < 6; s++) {
	var section_start_y = semicircle_end_y + copy_offsets[s];
	var section_meeting_y = meeting_point_y + copy_offsets[s];
	
	if (s > 0) {
		draw_set_alpha(0.7);
		for (var p = 0; p < 15; p++) {
		var progress = p / 15;
		var next_progress = (p + 1) / 15;
		var top_x1 = left_end_x + progress * (right_end_x - left_end_x);
		var top_x2 = left_end_x + next_progress * (right_end_x - left_end_x);
		
		var curve_factor1 = sin(progress * pi) * 0.8;
		var curve_x1 = (top_x1 <= fx) ? 
			left_end_x + progress * (fx - left_end_x) + curve_factor1 * (fx - (left_end_x + progress * (fx - left_end_x))) * 0.3 :
			right_end_x + progress * (fx - right_end_x) + curve_factor1 * (fx - (right_end_x + progress * (fx - right_end_x))) * 0.3;
		var curve_y1 = section_start_y + progress * (section_meeting_y - section_start_y);
		
		draw_triangle(top_x1, section_start_y, top_x2, section_start_y, curve_x1, curve_y1, false);
		}
	}
	}
	
	// Draw all outlines
	draw_set_alpha(1.0);
	draw_set_color(gold_outline);
	
	// Draw semicircle outline
	for (var p = 0; p < 12; p++) {
	var angle1 = pi + (p / 12) * pi;
	var angle2 = pi + ((p + 1) / 12) * pi;
	var x1 = fx + cos(angle1) * eye_radius;
	var y1 = eye_center_y + sin(angle1) * eye_radius;
	var x2 = fx + cos(angle2) * eye_radius;
	var y2 = eye_center_y + sin(angle2) * eye_radius;
	draw_line_width(x1, y1, x2, y2, 2);
	}
	
	// Draw all curved lines and vertical connectors
	for (var s = 0; s < 6; s++) {
	var section_start_y = semicircle_end_y + copy_offsets[s];
	var section_meeting_y = meeting_point_y + copy_offsets[s];
	
	// Draw left and right curved lines
	for (var side = 0; side < 2; side++) {
		var start_x = (side == 0) ? left_end_x : right_end_x;
		for (var p = 0; p < curve_points; p++) {
		var progress = p / curve_points;
		var next_progress = (p + 1) / curve_points;
		
		var base_x1 = start_x + progress * (fx - start_x);
		var base_y1 = section_start_y + progress * (section_meeting_y - section_start_y);
		var base_x2 = start_x + next_progress * (fx - start_x);
		var base_y2 = section_start_y + next_progress * (section_meeting_y - section_start_y);
		
		var curve_factor1 = sin(progress * pi) * 0.8;
		var curve_factor2 = sin(next_progress * pi) * 0.8;
		
		var x1 = base_x1 + curve_factor1 * (fx - base_x1) * 0.3;
		var x2 = base_x2 + curve_factor2 * (fx - base_x2) * 0.3;
		
		draw_line_width(x1, base_y1, x2, base_y2, 2);
		}
	}
	
	// Draw vertical connectors (except for last section)
	if (s < 5) {
		var next_start_y = semicircle_end_y + copy_offsets[s + 1];
		draw_line_width(left_end_x, section_start_y, left_end_x, next_start_y, 2);
		draw_line_width(right_end_x, section_start_y, right_end_x, next_start_y, 2);
	}
	}
	
	// Draw central spine
	draw_line_width(fx, meeting_point_y, fx, meeting_point_y + 100, 2);
	
	// Draw eye circles
	var tip_height = eye_radius * 2;
	var spacing = tip_height / 4;
	var circles_center_y = feather_y + eye_radius;
	
	draw_set_alpha(0.9);
	draw_set_color(peacock_blue);
	draw_circle(fx, circles_center_y, spacing * 1.5, false);
	draw_set_color(peacock_purple);
	draw_circle(fx, circles_center_y, spacing * 0.75, false);
	
	draw_set_alpha(1.0);
	draw_set_color(gold_outline);
	draw_circle(fx, circles_center_y, spacing * 1.5, true);
	draw_circle(fx, circles_center_y, spacing * 0.75, true);
	#endregion
}
#endregion
}
draw_set_alpha(1.0);
draw_set_color(c_white);
#endregion

#region Danger Overlay System
// Only show danger overlay after performance system has been explained (step 15+)
if (instance_exists(obj_gameManager)) {
var should_show_danger = true;

// Don't show danger during initial tutorial before performance system is explained
if (obj_gameManager.gameState == "tutorial" && obj_gameManager.currentLevel == 0) {
	var tutorial_step = obj_gameManager.tutorialStep;
	if (tutorial_step < 15) {
	should_show_danger = false;
	}
}

if (should_show_danger) {
	var performance_ratio = obj_gameManager.performanceMeter / obj_gameManager.meterMaxValue;

	// Only show danger overlay when performance is below 30%
	if (performance_ratio < 0.3) {
	// Calculate danger intensity: 0.3 = no overlay, 0.0 = maximum overlay
	var danger_intensity = (0.3 - performance_ratio) / 0.3; // 0 to 1 scale
	
	// Use the same beat pulse as the feathers (matches song beat)
	var danger_pulse = 1.0;
	if (instance_exists(obj_level) && !is_paused && variable_instance_exists(obj_level, "beatTimer") && variable_instance_exists(obj_level, "beatInterval")) {
		var beat_progress = (obj_level.beatTimer) / obj_level.beatInterval;
		var pulse_strength = max(0, 1 - (beat_progress * 4)); // Sharp fade after beat
		danger_pulse = 1.0 + (pulse_strength * 0.5); // Moderate pulse intensity
	}
	// During pause, use default danger_pulse of 1.0 (no pulsing)
	
	// Combine danger intensity with beat pulse for final alpha
	var base_alpha = danger_intensity * 0.3; // Maximum 30% base opacity
	var final_alpha = base_alpha * danger_pulse; // Modulated by beat
	
	// Draw red danger overlay over entire screen
	draw_set_alpha(final_alpha);
	draw_set_color(c_red);
	draw_rectangle(0, 0, room_width, room_height, false);
	
	draw_set_alpha(1.0);
	draw_set_color(c_white);
	}
}
}
#endregion
