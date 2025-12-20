//To prevent speeding up the credits right away
input_verb_consume(all);//INPUT 6-8

_angle = UP;//direction rajoute cette macro dans les macros, copie de ton autre projet j'avais mis les directions
_speed = 1;//text speed
_baseSpeed = _speed;
_fastSpeed = 10;
_limit = 0;//before reset
_limitBase = -50;

_font = Font1;
_scale = 1;//font scale
_sep = 20;//separation between lines in pixels

motion_set(_angle, _speed);//to move the text up

xstart = room_width/2;
ystart = room_height;

x = xstart;
y = ystart;