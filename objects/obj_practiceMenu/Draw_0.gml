// obj_practiceMenu Draw Event - DRAWING ONLY (Updated to match Freeplay style)

// Draw overlay background
draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1.0);

// Draw main menu background
draw_set_color(bg_color);
draw_set_alpha(bg_alpha);
draw_rectangle(menu_x, menu_y, menu_x + menu_width, menu_y + menu_height, false);
draw_set_alpha(1.0);

// Draw border
draw_set_color(border_color);
draw_rectangle(menu_x, menu_y, menu_x + menu_width, menu_y + menu_height, true);

// Draw title
draw_set_font(Title);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(selected_color);
var title_y = menu_y + 20;
draw_text(menu_x + menu_width/2, title_y, "Practice Lessons");

// Calculate content positioning (matching freeplay menu)
var title_height = 80; // Empirically determined
var title_bottom = title_y + title_height + 90; // 90px buffer
var items_start_y = title_bottom;
var instruction_height = 50; // Reserve space for bottom instructions
var available_height = (menu_y + menu_height - instruction_height) - items_start_y;

// Set up item drawing
draw_set_font(Font1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Draw lessons (no clipping - exactly like freeplay menu)
for (var i = 0; i < totalItems; i++) {
var item_y = items_start_y + (i - scrollOffset) * item_height;

// Check if item is within visible bounds
if (item_y + item_height < items_start_y || item_y > items_start_y + available_height) {
	continue;
}

var lesson_data = availableLessons[i];

// Draw selection highlight
if (i == selectedLesson && lesson_data.selectable) {
	draw_set_color(selected_color);
	draw_set_alpha(0.3);
	draw_rectangle(menu_x + 15, item_y - 2, menu_x + menu_width - 15, item_y + item_height - 8, false);
	draw_set_alpha(1.0);
}

// Draw lesson text with description
draw_set_color(i == selectedLesson ? c_black : unselected_color);

// Create lesson descriptions (for real lessons 1-5)
var lesson_description = "";
switch(lesson_data.level) {
	case 1: lesson_description = " - Basic coordination patterns"; break;
	case 2: lesson_description = " - Cross-stick and hi-hat work"; break;
	case 3: lesson_description = " - Swing rhythm fundamentals"; break;
	case 4: lesson_description = " - Complex jazz timing"; break;
	case 5: lesson_description = " - Advanced swing mastery"; break;
	default: lesson_description = " - Advanced techniques"; break;
}

draw_text(menu_x + 25, item_y, lesson_data.name + lesson_description);
}

// Draw scrollbar if needed (matching freeplay menu)
if (totalItems > maxVisibleItems) {
var scrollbar_x = menu_x + menu_width - 20;
var scrollbar_y = items_start_y;
var scrollbar_height = available_height;
var scrollbar_width = 8;

// Scrollbar background
draw_set_color(c_gray);
draw_rectangle(scrollbar_x, scrollbar_y, scrollbar_x + scrollbar_width, scrollbar_y + scrollbar_height, false);

// Scrollbar thumb
var thumb_height = (maxVisibleItems / totalItems) * scrollbar_height;
var thumb_y = scrollbar_y + (scrollOffset / (totalItems - maxVisibleItems)) * (scrollbar_height - thumb_height);

draw_set_color(border_color); // Gold thumb
draw_rectangle(scrollbar_x, thumb_y, scrollbar_x + scrollbar_width, thumb_y + thumb_height, false);
}

// Draw instructions at bottom
draw_set_font(Font1);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(unselected_color);
var button_name = get_button_name("pause");
draw_text(menu_x + menu_width/2, menu_y + menu_height - 10, "Enter: Select Lesson    " + button_name + ": Back to Menu");

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
