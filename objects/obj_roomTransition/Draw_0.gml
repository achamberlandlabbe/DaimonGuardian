if (room == firstRoom) {
    draw_set_alpha(fadeOutStart);
}
else {
    draw_set_alpha(fadeInStart);
}
draw_rectangle_color(0, 0, room_width, room_height, c_black, c_black, c_black, c_black, false);
draw_set_alpha(1);