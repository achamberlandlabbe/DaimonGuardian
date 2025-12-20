// obj_sound Create Event
audio_group_load(BGM);
audio_group_load(SFX);
audio_set_master_gain(0, global.saveData.masterVolume);
introStarted = false;
introFade = false;
fadeInMusic = false;
fadeInStartTime = 0;
musicFadeOut = false;
musicFadeOutStart = 0;