#region PLAYSTATION
if os_type == os_ps4 or os_type == os_ps5{
	for (var i = 0; i < INPUT_MAX_PLAYERS; i++){
		if gamepad_is_connected(i){
			if !input_player_connected(i){
				input_source_set(INPUT_GAMEPAD[i], i);
				input_profile_set("gamepad", i);
			}
		}
	}
}
#endregion