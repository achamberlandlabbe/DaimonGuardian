if y <= _limit                    //reset text pos
    y = ystart;
else if y >= room_height + abs(_limitBase)    //reset text pos if going down
    y = _limit + 1;

if input_check_released("accept", 0){
    input_verb_consume("accept");//INPUT 6-8
    room_goto(roomTitleScreen);//remplace par ta room de menu ou crées dans tes macros des macros dédiées aux Rooms
}
if input_check("down", 0)
    _angle = DOWN;
else if input_check("up", 0)
    _angle = UP;
if input_check("speed_credit", 0)
    _speed = _fastSpeed;
else
    _speed = _baseSpeed;

motion_set(_angle, _speed);