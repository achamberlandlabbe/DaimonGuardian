// obj_sound Async - Save/Load Event
var ident = async_load[? "group_id"];
if (ident == BGM)
    audio_group_set_gain(BGM, global.saveData.musicVolume, 0);
if (ident == SFX)
    audio_group_set_gain(SFX, global.saveData.soundVolume, 0);