/// obj_sound Room Start Event
if (room == roomTitleScreen || room == roomCredits) {
    if (!audio_is_playing(snd_musicTitleScreen))
        playSound(snd_musicTitleScreen, 1);
}
else {
    if (audio_is_playing(snd_musicTitleScreen))
        audio_stop_sound(snd_musicTitleScreen);
}

// Any gameplay room (not title/credits/start)
if (room != roomTitleScreen && room != roomCredits && room != RoomStart) {
    // Level music will be handled by step event fade-in logic
}
else {
    if (audio_is_playing(snd_musicLevels))
        audio_stop_sound(snd_musicLevels);
    introStarted = false;
}