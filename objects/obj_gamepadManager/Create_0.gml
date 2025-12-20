#region PLAYSTATION
//GAMEPADS
if os_type == os_ps4 or os_type == os_ps5{
	input_source_mode_set(INPUT_SOURCE_MODE.FIXED);
	input_source_set(INPUT_GAMEPAD[0], 0);
}

//TOUCHPAD PS4
if os_type == os_ps4
	ps4_touchpad_mouse_enable(false);
#endregion