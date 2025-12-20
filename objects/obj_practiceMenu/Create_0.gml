// obj_practiceMenu Create Event - Practice Lesson Selection (20 Steps, No Introduction, Preserve Selection)

// Menu state
if (variable_global_exists("lastPracticeMenuSelection") && global.lastPracticeMenuSelection < 20) {
selectedLesson = global.lastPracticeMenuSelection;
} else {
selectedLesson = 0;
}
hasSelectedSomething = false;
scrollOffset = 0;
maxVisibleItems = 8;

depth = -1600;

// Hold-to-scroll state tracking
up_key_held = false;
up_hold_timer = 0;
up_continuous_timer = 0;

down_key_held = false;
down_hold_timer = 0;
down_continuous_timer = 0;

hold_delay = 30;
continuous_scroll_interval = 9;

// Art Deco colors (matching other UI objects)
ui_gold = make_color_rgb(255, 215, 0);
ui_brass = make_color_rgb(184, 134, 11);
ui_dark_brass = make_color_rgb(120, 87, 7);
ui_cream = make_color_rgb(255, 248, 220);

// Build lesson list (20 steps, no introduction)
availableLessons = [];

// 5 core lessons
for (var i = 1; i <= 5; i++) {
array_push(availableLessons, {
	type: "lesson",
	level: i,
	name: "Lesson " + string(i) + ": [Add descriptive title]",
	functionName: "createLevel" + string(i) + "Track",
	selectable: true
});
}

// 5 beginner songs
for (var i = 1; i <= 5; i++) {
array_push(availableLessons, {
	type: "song",
	level: 5 + i,
	name: "Beginner Song " + string(i),
	functionName: "createBeginnerSong" + string(i),
	selectable: true
});
}

// 5 bridging lessons
for (var i = 1; i <= 5; i++) {
array_push(availableLessons, {
	type: "lesson",
	level: 10 + i,
	name: "Bridging Lesson " + string(i) + ": [Add descriptive title]",
	functionName: "createBridgingLesson" + string(i),
	selectable: true
});
}

// 5 easy songs
for (var i = 1; i <= 5; i++) {
array_push(availableLessons, {
	type: "song",
	level: 15 + i,
	name: "Easy Song " + string(i),
	functionName: "createEasySong" + string(i),
	selectable: true
});
}

totalItems = array_length(availableLessons);

// Find first selectable item (all lessons are selectable)
while (selectedLesson < totalItems && !availableLessons[selectedLesson].selectable) {
selectedLesson++;
}
if (selectedLesson >= totalItems) selectedLesson = 0;

// UI positioning
menu_x = room_width * 0.3;
menu_y = room_height * 0.2;
menu_width = room_width * 0.4;
menu_height = room_height * 0.6;
item_height = 35;

// Colors (Art Deco style)
bg_color = c_black;
bg_alpha = 0.8;
selected_color = make_color_rgb(255, 215, 0);
unselected_color = c_white;
border_color = make_color_rgb(255, 215, 0);
