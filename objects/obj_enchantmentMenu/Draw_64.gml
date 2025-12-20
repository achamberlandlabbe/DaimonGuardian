/// obj_enchantmentMenu Draw GUI Event

// Calculate menu dimensions with extra 100px width (50px on each side)
var display_menu_x = menu_x - 50;
var display_menu_width = menu_width + 100;

// Draw menu panel background
draw_set_color(c_black);
draw_set_alpha(bg_alpha);
draw_rectangle(display_menu_x, menu_y, display_menu_x + display_menu_width, menu_y + menu_height, false);
draw_set_alpha(1);

// Draw menu border
draw_set_color(border_color);
draw_rectangle(display_menu_x, menu_y, display_menu_x + display_menu_width, menu_y + menu_height, true);

// Draw title
draw_set_font(Title);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(titleColor);
draw_text(display_menu_x + display_menu_width/2, menu_y + 20, "Enchantments");

// Define component data (shared by both sides)
var components = [
    {sprite: spr_intactTooth, inventory_key: "intactTooth", name: "Intact Tooth"},
    {sprite: spr_pristineFeather, inventory_key: "pristineFeather", name: "Pristine Feather"},
    {sprite: spr_toxicMushroom, inventory_key: "toxicMushroom", name: "Toxic Mushroom"},
    {sprite: spr_sinew, inventory_key: "sinew", name: "Sinew"},
    {sprite: spr_crystallizedIntensity, inventory_key: "crystallizedIntensity", name: "Crystallized Intensity"},
    {sprite: spr_crystallizedFocus, inventory_key: "crystallizedFocus", name: "Crystallized Focus"},
    {sprite: spr_crystallizedInstinct, inventory_key: "crystallizedInstinct", name: "Crystallized Instinct"},
    {sprite: spr_crystallizedTenacity, inventory_key: "crystallizedTenacity", name: "Crystallized Tenacity"}
];

// LEFT SIDE - Components List
draw_set_font(Font1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

var inventory_y = menu_y + 170;
var inventory_x = display_menu_x + 40;

// Section header
draw_text(inventory_x, inventory_y, "Components List:");

// Component display
var icon_spacing = 50;
var start_y = inventory_y + 80;

// Loop through components
for (var i = 0; i < array_length(components); i++) {
    var comp = components[i];
    var current_x = inventory_x;
    var current_y = start_y + (i * icon_spacing);
    
    if (sprite_exists(comp.sprite)) {
        // Get quantity from gameManager inventory
        var quantity = 0;
        if (instance_exists(obj_gameManager)) {
            quantity = variable_struct_get(obj_gameManager.inventory, comp.inventory_key);
        }
        
        // Determine color based on quantity
        var text_color = (quantity > 0) ? c_white : c_dkgray;
        var icon_alpha = (quantity > 0) ? 1 : 0.3;
        
        // Draw icon (offset down to align with middle-aligned text)
        var icon_offset = sprite_get_height(comp.sprite) / 2;
        draw_sprite_ext(comp.sprite, 0, current_x, current_y + icon_offset, 1, 1, 0, c_white, icon_alpha);
        
        // Draw component name and quantity (aligned with icon center)
        draw_set_color(text_color);
        draw_set_valign(fa_middle);
        draw_text(current_x + 40, current_y, comp.name + ": " + string(quantity));
        draw_set_valign(fa_top);
    }
}

// RIGHT SIDE - Enchantments
var enchant_x = display_menu_x + (display_menu_width / 2) + 20;
var enchant_y = inventory_y;
var enchant_width = (display_menu_width / 2) - 60;

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

// Section header
draw_text(enchant_x, enchant_y, "Enchantments:");

// Loop through enchantments (using instance variable from Create Event)
var ench_y = inventory_y + 60;
var max_visible = 2; // Maximum number of enchantments to show at once
var scroll_start = selectedEnchantment; // Start drawing from selected enchantment

for (var e = scroll_start; e < min(scroll_start + max_visible, array_length(enchantments)); e++) {
    var enchant = enchantments[e];
    var ench_start_y = ench_y - 10;
    
    // Check if player has ALL of the required components
    var has_all_components = true;
    for (var c = 0; c < array_length(enchant.cost); c++) {
        var cost_item = enchant.cost[c];
        var owned_amount = 0;
        if (instance_exists(obj_gameManager)) {
            owned_amount = variable_struct_get(obj_gameManager.inventory, cost_item.inventory_key);
        }
        if (owned_amount < cost_item.amount) {
            has_all_components = false;
            break;
        }
    }
    
    // Set colors based on availability
    var enchant_name_color = has_all_components ? c_white : c_dkgray;
    var enchant_text_color = has_all_components ? c_white : c_dkgray;
    var enchant_desc_color = has_all_components ? c_ltgray : c_dkgray;
    var enchant_icon_alpha = has_all_components ? 1 : 0.3;
    
    // Draw enchantment name
    draw_set_color(enchant_name_color);
    draw_text(enchant_x, ench_y, enchant.name);
    ench_y += 50;
    
    // Draw component cost
    draw_set_color(enchant_text_color);
    var cost_x = enchant_x;
    
    for (var c = 0; c < array_length(enchant.cost); c++) {
        var cost_item = enchant.cost[c];
        
        if (sprite_exists(cost_item.sprite)) {
            // Draw amount text
            draw_set_valign(fa_middle);
            draw_text(cost_x, ench_y, string(cost_item.amount));
            draw_set_valign(fa_top);
            
            // Draw icon (with 10px more spacing from number)
            var icon_offset = sprite_get_height(cost_item.sprite) / 2;
            draw_sprite_ext(cost_item.sprite, 0, cost_x + 30, ench_y + icon_offset * 0.75, 0.75, 0.75, 0, c_white, enchant_icon_alpha);
            
            cost_x += 60;
        }
    }
    
    ench_y += 20;
    
    // Draw enchantment description (wrapped text) - ONLY if selected
    if (e == selectedEnchantment) {
        draw_set_color(enchant_desc_color);
        draw_text_ext(enchant_x, ench_y, enchant.description, -1, enchant_width);
        
        // Calculate actual height of description
        var desc_height = string_height_ext(enchant.description, -1, enchant_width);
        ench_y += desc_height + 10;
    } else {
        // If not selected, just add small spacing (no description height)
        ench_y += 10;
    }
    
    // Draw outline rectangle around entire enchantment
    // Use titleColor if this is the selected enchantment
    var outline_color = (e == selectedEnchantment) ? titleColor : c_white;
    var outline_alpha = (e == selectedEnchantment) ? 0.8 : 0.3;
    draw_set_color(outline_color);
    draw_set_alpha(outline_alpha);
    draw_rectangle(enchant_x - 10, ench_start_y, enchant_x + enchant_width + 10, ench_y, true);
    draw_set_alpha(1);
    
    // Add spacing between enchantments
    ench_y += 30;
}

// Draw scrollbar if there are more enchantments than can be shown
if (array_length(enchantments) > max_visible) {
    var scrollbar_x = enchant_x + enchant_width + 20;
    var scrollbar_y = inventory_y + 55;
    var scrollbar_height = 350; // Adjust based on available space
    var scrollbar_width = 8;
    
    // Draw scrollbar track
    draw_set_color(c_dkgray);
    draw_set_alpha(0.3);
    draw_rectangle(scrollbar_x, scrollbar_y, scrollbar_x + scrollbar_width, scrollbar_y + scrollbar_height, false);
    draw_set_alpha(1);
    
    // Calculate scrollbar thumb position and size
    var thumb_height = (max_visible / array_length(enchantments)) * scrollbar_height;
    var thumb_y = scrollbar_y + (selectedEnchantment / (array_length(enchantments) - 1)) * (scrollbar_height - thumb_height);
    
    // Draw scrollbar thumb
    draw_set_color(titleColor);
    draw_set_alpha(0.8);
    draw_rectangle(scrollbar_x, thumb_y, scrollbar_x + scrollbar_width, thumb_y + thumb_height, false);
    draw_set_alpha(1);
}

// Draw error message if active
if (errorMessageTimer > 0) {
    var error_width = 600;
    var error_height = 80;
    var error_x = (display_get_gui_width() - error_width) / 2;
    var error_y = (display_get_gui_height() - error_height) / 2;
    
    // Draw black background
    draw_set_color(c_black);
    draw_set_alpha(0.9);
    draw_rectangle(error_x, error_y, error_x + error_width, error_y + error_height, false);
    draw_set_alpha(1);
    
    // Draw white border
    draw_set_color(c_white);
    draw_rectangle(error_x, error_y, error_x + error_width, error_y + error_height, true);
    
    // Draw error text
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_ext(error_x + error_width/2, error_y + error_height/2, "You do not have all of the required components to cast this enchantment", -1, error_width - 40);
}

// Draw confirmation dialog if active
if (showConfirmation) {
    var confirm_width = 700;
    var confirm_height = 220;
    var confirm_x = (display_get_gui_width() - confirm_width) / 2;
    var confirm_y = (display_get_gui_height() - confirm_height) / 2;
    
    // Get the enchantment being confirmed
    var enchant = enchantments[selectedEnchantment];
    
    // Build cost string
    var cost_string = "";
    for (var i = 0; i < array_length(enchant.cost); i++) {
        var cost_item = enchant.cost[i];
        if (i > 0) cost_string += ", ";
        cost_string += string(cost_item.amount) + " ";
        
        // Get component name from components array
        for (var c = 0; c < array_length(components); c++) {
            if (components[c].inventory_key == cost_item.inventory_key) {
                cost_string += components[c].name;
                break;
            }
        }
    }
    
    // Draw black background
    draw_set_color(c_black);
    draw_set_alpha(0.95);
    draw_rectangle(confirm_x, confirm_y, confirm_x + confirm_width, confirm_y + confirm_height, false);
    draw_set_alpha(1);
    
    // Draw border
    draw_set_color(titleColor);
    draw_rectangle(confirm_x, confirm_y, confirm_x + confirm_width, confirm_y + confirm_height, true);
    
    // Draw question text
    draw_set_font(Font1);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_ext(confirm_x + confirm_width/2, confirm_y + 20, "Spend " + cost_string + " to cast " + enchant.name + "?", -1, confirm_width - 40);
    
    // Draw Yes/No buttons
    var button_y = confirm_y + confirm_height - 50;
    var button_spacing = 150;
    var yes_x = confirm_x + confirm_width/2 - button_spacing/2;
    var no_x = confirm_x + confirm_width/2 + button_spacing/2;
    
    // Draw Yes
    if (confirmSelection == 0) {
        draw_set_color(titleColor);
    } else {
        draw_set_color(c_gray);
    }
    draw_text(yes_x, button_y, "Yes");
    
    // Draw No
    if (confirmSelection == 1) {
        draw_set_color(titleColor);
    } else {
        draw_set_color(c_gray);
    }
    draw_text(no_x, button_y, "No");
}

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);