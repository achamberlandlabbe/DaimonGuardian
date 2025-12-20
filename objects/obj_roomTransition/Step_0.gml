if (room == firstRoom) {
    if (fadeOutStart < fadeOutEnd) {
        fadeOutStart += fadeOutStep;
    }
    else {
        room_goto(targetRoom)
    }
}
if (room == targetRoom) {
    if (fadeInStart > fadeInEnd) {
            fadeInStart -= fadeInStep;
        }
    else {
            instance_destroy();
        }
}
if room != firstRoom and room != targetRoom
	instance_destroy();