//v25.3.15

/// @desc Returns sub-image of the sprite, corresponding to the correct console
function getGamepadIcon(){
	if os_type == os_xboxone or os_type == os_xboxseriesxs or
	(input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_XBOX_360 or input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_XBOX_ONE)
	{
		return 0;
	}
	else if os_type == os_ps4 or os_type == os_ps5 or
	(input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_PS4 or input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_PS5
	or input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_PSX)
	{
		return 1;
	}
	else if os_type == os_switch or
	(input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_GAMECUBE or input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_SWITCH
	or input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_JOYCON_LEFT or input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_JOYCON_RIGHT)
	{
		return 2;
	}
	else
		return 0;
	//else if global.Desktop or global.HTML or os_get_config() == "Default"
	//	return 3;
}

/// @desc Returns gamepad type
function getGamepadType(){
	if os_type == os_xboxone or os_type == os_xboxseriesxs or
	(input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_XBOX_360 or input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_XBOX_ONE)
	{
		return 0;
	}
	else if os_type == os_ps4 or
	(input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_PS4
	or input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_PSX)
	{
		return 1;
	}
	else if os_type == os_switch or
	(input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_GAMECUBE or input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_SWITCH
	or input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_JOYCON_LEFT or input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_JOYCON_RIGHT)
	{
		return 2;
	}
	else if os_type == os_ps5 or input_player_get_gamepad_type(0) == INPUT_GAMEPAD_TYPE_PS5
	{
		return 3;
	}
	else
		return 0;
	//else if global.Desktop or global.HTML or os_get_config() == "Default"
	//	return 3;
}

/// @desc Draws a gamepad icon with the correct console by default
function drawGamepadIcon(_sprite, _x, _y, _xScale = 1, _yScale = _xScale, _alpha = 1, _subimg = getGamepadIcon(), _rotation = 0){
	
	_xScale = _xScale/**(global.spriteScale/4)*/;
	_yScale = _yScale/**(global.spriteScale/4)*/;
		
	spriteDraw(_sprite, _x, _y, _xScale, _yScale, _subimg, _alpha, , _rotation);
}