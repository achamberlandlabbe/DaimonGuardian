// obj_parentEnemies Draw GUI Event
// Draw crit starburst effect (drawn in GUI layer so it appears above everything)
if (crit_flash_timer > 0) {
    var starburst_alpha = crit_flash_timer / 15; // Fade out over 15 frames
    var starburst_scale = 1.5 + ((15 - crit_flash_timer) / 15) * 1.5; // Grow from 1.5x to 3x
    
    draw_set_color(c_red);
    draw_set_alpha(starburst_alpha);
    
    // Draw 8-pointed starburst (bigger: 40px inner, 60px outer at base scale)
    var num_points = 8;
    var inner_radius = 40 * starburst_scale;
    var outer_radius = 60 * starburst_scale;
    
    for (var i = 0; i < num_points; i++) {
        var angle1 = (i / num_points) * 360;
        var angle2 = ((i + 0.5) / num_points) * 360;
        var angle3 = ((i + 1) / num_points) * 360;
        
        // Outer point
        var x1 = x + lengthdir_x(outer_radius, angle2);
        var y1 = y + lengthdir_y(outer_radius, angle2);
        
        // Inner point 1
        var x2 = x + lengthdir_x(inner_radius, angle1);
        var y2 = y + lengthdir_y(inner_radius, angle1);
        
        // Inner point 2
        var x3 = x + lengthdir_x(inner_radius, angle3);
        var y3 = y + lengthdir_y(inner_radius, angle3);
        
        // Draw triangle
        draw_triangle(x1, y1, x2, y2, x3, y3, false);
    }
    
    draw_set_alpha(1);
    draw_set_color(c_white);
}