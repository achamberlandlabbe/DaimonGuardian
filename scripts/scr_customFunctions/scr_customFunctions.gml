///scr_customFunctions

#region GLOBALS
global.halign = draw_get_halign();
global.valign = draw_get_valign();
global.savedFont = draw_get_font();
#endregion

#region ALIGNMENT

/// @desc Saves current halign & valign and sets default halign/valign or defined
function saveAlign(_halign = fa_center, _valign = fa_middle){
	global.halign = draw_get_halign();
	global.valign = draw_get_valign();
	draw_set_halign(_halign);
	draw_set_valign(_valign);
}

/// @desc Defines halign & valign, default Center/Middle
function setAlign(_halign = fa_center, _valign = fa_middle){
	draw_set_halign(_halign);
	draw_set_valign(_valign);
}

/// @desc Loads saved halign & valign
function loadAlign(){
	draw_set_halign(global.halign);
	draw_set_valign(global.valign);
}

#endregion

#region FONT

///@desc Saves current font used, and sets new font (-1 by default)
///@param _font Font to set
function saveFont(_font = -1){
	global.savedFont = draw_get_font();
	draw_set_font(_font);
}

///@desc Sets default font (-1) or defined one
function setFont(_font = -1){
	draw_set_font(_font);
}

///@desc Loads current font saved
function loadFont(){
	draw_set_font(global.savedFont);
}

#endregion

#region ROOMS

/// @desc Replaces room_goto with a fadeout/fadein transition
function roomTransition(_room, _fadeOutStart = 0, _fadeOutStep = 0.01, _fadeOutEnd = 1, _fadeInStart = 1, _fadeInStep = 0.01, _fadeInEnd = 0){  
	if !instance_exists(obj_roomTransition){
		instance_create_depth(0, 0, -1, obj_roomTransition, {
		        targetRoom : _room,
		        fadeOutStart : _fadeOutStart,
		        fadeOutStep : _fadeOutStep,
		        fadeOutEnd : _fadeOutEnd,
		        fadeInStart : _fadeInStart,
		        fadeInStep : _fadeInStep,
		        fadeInEnd : _fadeInEnd
	        });
	}
}

/// @arg {String} _tag
function tagRoom(_tag, _room = room){
	if asset_has_tags(_room, _tag, asset_room)
		return true;
	else
		return false;
}

#endregion

#region SOUND

/// @func playSound() For mid to long sounds/musics, looping or not
/// @arg {Asset.GMSound} soundID
/// @arg {Bool} looping
/// @arg {Bool} playOnController
/// @arg {Real} playerIndex
/// @arg {Bool} isHaptic
/// @arg {Asset.GMSound} hapticID
function playSound(soundID, looping, playOnController = false, playerIndex = 0, isHaptic = false, hapticID = undefined){
	
	if (os_type == os_ps4 or os_type == os_ps5) and global.saveData.controllerSpeaker and playOnController
		audio_play_sound_on(global.emit[playerIndex], soundID, looping, 1);
	else
		audio_play_sound(soundID, 1, looping);
		
	if os_type == os_ps5 and global.saveData.vibrations and isHaptic
		audio_play_sound_on(global.vemit[playerIndex], hapticID, looping, 1);
			
	//AUDIO LOOPS
	if looping and playOnController{
		if !array_contains(oAudioManager.audioLoops, soundID)
			array_push(oAudioManager.audioLoops, soundID);
	}
			
	//HAPTICS TO STOP
	if looping and isHaptic{
		if !array_contains(oAudioManager.hapticLoops, soundID){
			array_push(oAudioManager.hapticLoops, [soundID, hapticID]);
		}
	}
}

/// @func playSFX() For short sound effects, not looping, with a default random pitch
/// @arg {Asset.GMSound} soundID
/// @arg {Real} pitchLowerRange
/// @arg {Real} pitchHigherRange
/// @arg {Bool} playOnController
/// @arg {Real} playerIndex
/// @arg {Bool} isHaptic
/// @arg {Asset.GMSound} hapticID
function playSFX(soundID, pitchLowerRange = 0.95, pitchHigherRange = 1.05, playOnController = false, playerIndex = 0, isHaptic = false, hapticID = undefined){
	
	if (os_type == os_ps4 or os_type == os_ps5) and global.saveData.controllerSpeaker and playOnController
		audio_play_sound_on(global.emit[playerIndex], soundID, 0, 1, 1, 0, random_range(pitchLowerRange, pitchHigherRange));
	else
		audio_play_sound(soundID, 1, 0, 1, 0, random_range(pitchLowerRange, pitchHigherRange));
		
	if os_type == os_ps5 and global.saveData.vibrations and isHaptic
			audio_play_sound_on(global.vemit[playerIndex], hapticID, 0, 1);
}

#endregion

#region SPRITES

/// @arg {type} _sprite
/// @desc Replaces draw_sprite_ext
function spriteDraw(_sprite, _x, _y, _xScale = 1, _yScale = _xScale, _subimg = 0, _alpha = 1, _color = c_white, _rotation = 0){
	draw_sprite_ext(_sprite, _subimg, _x, _y, _xScale, _yScale, _rotation, _color, _alpha);
}

#endregion

#region TEXT

/// @arg {String} _string
/// @desc Replaces draw_text_ext_transformed_color
function txt(_string, _x = x, _y = y, _xScale = 1, _yScale = _xScale, _color = c_white, _alpha = 1, _sep = -1){
	var _colorCurrent = draw_get_color();
	draw_set_color(_color);
	
	var _str = string(_string);
	
	draw_text_ext_transformed_color(_x, _y, _str, _sep, 1000, _xScale, _yScale, 0, _color, _color, _color, _color, _alpha);
	
	draw_set_color(_colorCurrent);
}

#endregion

#region VIBRATIONS

/// @func vibrate() Plays only if vibrations activated in global.saveData
/// @arg {Real} _playerIndex 0 to 3
/// @arg {Bool} _chirp If making just a chirp (TRUE by default)
/// @arg {Real} _leftV Left Motor Value
/// @arg {Real} _rightV Right Motor Value
/// @arg {Real} _duration Duration in frames for method 2
/// @arg {Real} _method Choose between GM (1) or Input (2) if not using advanced vib
function vibrate(_playerIndex = 0, _chirp = true, _leftV = 0.06, _rightV = _leftV, _duration = 6, _method = 2){
	
	if global.saveData.vibrations{
		if _chirp{
			if os_type == os_ps5
				audio_play_sound_on(global.vemit[_playerIndex], Small_Chirp_Haptic, 0, 1);
			else{
				if os_type == os_switch
					vVibrate(_playerIndex, 0.2,,,0.1);
				else
					input_vibrate_constant(0.01, 0, 2, _playerIndex, 1);
			}
		}
		else if os_type == os_ps5
			audio_play_sound_on(global.vemit[_playerIndex], Chirp_Haptic, 0, 1);
		else if os_type == os_switch
			vVibrate(_playerIndex, _duration/10,,,max(_leftV, _rightV)*10);
		else if _method == 1
			gamepad_set_vibration(_playerIndex, _leftV, _rightV);
		else if _method == 2
			input_vibrate_constant(max(_leftV, _rightV), _rightV - _leftV, _duration, _playerIndex, 1);
	}
}

#endregion

#region TEXT WRAPPING

// Function: wrapText(text, maxWidth, font)
// Purpose: Automatically add line breaks to text based on pixel width
// Usage: var wrappedText = wrapText("Long text here", 800, Font1);
function wrapText(text, maxWidth, font) {
	// Set the font for width calculations
	draw_set_font(font);

	// If text is already shorter than max width, return as-is
	if (string_width(text) <= maxWidth) {
		return text;
	}

	// Split text into words
	var words = [];
	var currentWord = "";
	var textLength = string_length(text);

	for (var i = 1; i <= textLength; i++) {
		var char = string_char_at(text, i);
		
		if (char == " " || char == "\n") {
			if (currentWord != "") {
				array_push(words, currentWord);
				currentWord = "";
			}
			if (char == "\n") {
				array_push(words, "\n"); // Preserve existing line breaks
			}
		} else {
			currentWord += char;
		}
	}

	// Add the last word if there is one
	if (currentWord != "") {
		array_push(words, currentWord);
	}

	// Build lines that fit within maxWidth
	var result = "";
	var currentLine = "";

	for (var i = 0; i < array_length(words); i++) {
		var word = words[i];
		
		// Handle explicit line breaks
		if (word == "\n") {
			result += currentLine + "\n";
			currentLine = "";
			continue;
		}
		
		// Test if adding this word would exceed the width
		var testLine = (currentLine == "") ? word : currentLine + " " + word;
		
		if (string_width(testLine) <= maxWidth) {
			// Word fits, add it to current line
			currentLine = testLine;
		} else {
			// Word doesn't fit, start new line
			if (currentLine != "") {
				result += currentLine + "\n";
			}
			currentLine = word;
			
			// If single word is too long, we'll have to accept it overflowing
			// (Alternative would be to break mid-word, but that's rarely desired)
		}
	}

	// Add the final line
	if (currentLine != "") {
		result += currentLine;
	}

	return result;
}

#endregion

#region PLATFORM SPECIFIC INFORMATION

function get_button_name(action) {
    var buttons = []; // Array to collect all buttons for this action
    
    if (gamepad_is_connected(0)) {
        var gamepad_desc = gamepad_get_description(0);

        // PlayStation controller detection
        if (string_pos("PlayStation", gamepad_desc) > 0 || string_pos("PS", gamepad_desc) > 0) {
            switch(action) {
                case "accept": buttons = ["X"]; break;
                case "back": buttons = ["Circle"]; break;
                case "enchantmentMenu": buttons = ["Select"]; break;
                case "runAway": buttons = ["Triangle"]; break;
                case "pause": buttons = ["Options"]; break;
                case "up": buttons = ["↑", "Left Stick Up"]; break;
                case "down": buttons = ["↓", "Left Stick Down"]; break;
                case "left": buttons = ["←", "Left Stick Left"]; break;
                case "right": buttons = ["→", "Left Stick Right"]; break;
                case "spell1": buttons = ["L1"]; break;
                case "spell2": buttons = ["L2"]; break;
                case "spell3": buttons = ["R1"]; break;
                case "spell4": buttons = ["R2"]; break;
                default: buttons = [string_upper(action)]; break;
            }
        }
        // Nintendo Switch controller detection
        else if (string_pos("Nintendo", gamepad_desc) > 0 || string_pos("Switch", gamepad_desc) > 0) {
            switch(action) {
                case "accept": buttons = ["A"]; break;
                case "back": buttons = ["B"]; break;
                case "enchantmentMenu": buttons = ["-"]; break;
                case "runAway": buttons = ["Y"]; break;
                case "pause": buttons = ["+"]; break;
                case "up": buttons = ["↑", "Left Stick Up"]; break;
                case "down": buttons = ["↓", "Left Stick Down"]; break;
                case "left": buttons = ["←", "Left Stick Left"]; break;
                case "right": buttons = ["→", "Left Stick Right"]; break;
                case "spell1": buttons = ["L"]; break;
                case "spell2": buttons = ["ZL"]; break;
                case "spell3": buttons = ["R"]; break;
                case "spell4": buttons = ["ZR"]; break;
                default: buttons = [string_upper(action)]; break;
            }
        }
        // Xbox controller (default)
        else {
            switch(action) {
                case "accept": buttons = ["A"]; break;
                case "back": buttons = ["B"]; break;
                case "enchantmentMenu": buttons = ["Select"]; break;
                case "runAway": buttons = ["Y"]; break;
                case "pause": buttons = ["Menu"]; break;
                case "up": buttons = ["↑", "Left Stick Up"]; break;
                case "down": buttons = ["↓", "Left Stick Down"]; break;
                case "left": buttons = ["←", "Left Stick Left"]; break;
                case "right": buttons = ["→", "Left Stick Right"]; break;
                case "spell1": buttons = ["LB"]; break;
                case "spell2": buttons = ["LT"]; break;
                case "spell3": buttons = ["RB"]; break;
                case "spell4": buttons = ["RT"]; break;
                default: buttons = [string_upper(action)]; break;
            }
        }
    }
    // PC/Keyboard controls
    else {
        switch(action) {
            case "accept": buttons = ["Space", "Enter"]; break;
            case "back": buttons = ["Escape"]; break;
            case "enchantmentMenu": buttons = ["Tab"]; break;
            case "runAway": buttons = ["R"]; break;
            case "pause": buttons = ["Escape"]; break;
            case "up": buttons = ["W", "↑"]; break;
            case "down": buttons = ["S", "↓"]; break;
            case "left": buttons = ["A", "←"]; break;
            case "right": buttons = ["D", "→"]; break;
            case "spell1": buttons = ["1"]; break;
            case "spell2": buttons = ["2"]; break;
            case "spell3": buttons = ["3"]; break;
            case "spell4": buttons = ["4"]; break;
            case "spell5": buttons = ["5"]; break;
            case "spell6": buttons = ["6"]; break;
            case "spell7": buttons = ["7"]; break;
            case "spell8": buttons = ["8"]; break;
            case "spell9": buttons = ["9"]; break;
            default: buttons = [string_upper(action)]; break;
        }
    }
    
    // Join multiple buttons with " / " separator
    if (array_length(buttons) == 1) {
        return buttons[0];
    } else {
        var result = buttons[0];
        for (var i = 1; i < array_length(buttons); i++) {
            result += " / " + buttons[i];
        }
        return result;
    }
}

#endregion