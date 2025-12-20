/// obj_sound Step Event
var roomName = room_get_name(room);

// Volume controls
if (audio_get_master_gain(0) != global.saveData.masterVolume) {
    audio_set_master_gain(0, global.saveData.masterVolume);
}

// Only set group gain if not fading in
if (!fadeInMusic) {
    if (audio_group_get_gain(BGM) != global.saveData.musicVolume) {
        audio_group_set_gain(BGM, global.saveData.musicVolume, 0);
    }
}

if (audio_group_get_gain(SFX) != global.saveData.soundVolume) {
    audio_group_set_gain(SFX, global.saveData.soundVolume, 0);
}

// Music fade-out on game over or level complete
if ((global.gameOver || global.levelComplete) && audio_is_playing(snd_musicLevels) && !musicFadeOut) {
    audio_sound_gain(snd_musicLevels, 0, 1000); // Fade out over 1 second
    musicFadeOut = true;
    musicFadeOutStart = current_time;
}

// Complete fade-out after 1 second
if (musicFadeOut && audio_is_playing(snd_musicLevels)) {
    if (current_time - musicFadeOutStart > 1000) {
        audio_stop_sound(snd_musicLevels);
        audio_sound_gain(snd_musicLevels, 1, 0); // Reset for next play
        musicFadeOut = false;
    }
}

// Music fade-in for gameplay rooms (not title/credits/start) and not during upgrade menu
if (!audio_is_playing(snd_musicLevels) && 
    (room != roomTitleScreen && room != roomCredits && room != RoomStart) && 
    !instance_exists(obj_upgradeMenu)) {
    audio_play_sound(snd_musicLevels, 1, true); // Play music, looped
    audio_sound_gain(snd_musicLevels, 0, 0); // Set initial volume to 0
    audio_sound_gain(snd_musicLevels, 1, 1000); // Fade in to full volume over 1 second
    fadeInMusic = true;
    fadeInStartTime = current_time;
}

// End fade-in after 1 second
if (fadeInMusic && (current_time - fadeInStartTime > 1000)) {
    fadeInMusic = false;
}