// ===== obj_notes - Step Event (FIXED with Hit Timing Window + Visibility) =====
// Move toward target over time
moveTimer++;
var progress = moveTimer / travelTime;

if (progress <= 1) {
// Interpolate position in straight line
x = lerp(startX, targetX, progress);
y = lerp(startY, targetY, progress);

// number when note reaches center (progress = 1)
if (progress >= 1 && !reachedCenter) {
	reachedCenter = true;
	centerReachedTime = moveTimer;
	show_debug_message("Note reached center at frame " + string(moveTimer) + " (drum type " + string(drumType) + ")");
}

// Optional: Scale effect as it approaches
symbolScale = 1 + (progress * 0.5); // Gets slightly bigger as it approaches
} else {
// Symbol has reached/passed target - check for miss
if (!wasHit && !missProcessed && instance_exists(obj_gameManager)) {
	// This note was not hit and has expired
	var gameManager = obj_gameManager;
	
	// Only apply performance penalties during normal gameplay, not tutorial
	if (gameManager.gameState != "tutorial") {
	gameManager.performanceMeter -= 0.04; // Same penalty as wrong button press
	gameManager.performanceMeter = clamp(gameManager.performanceMeter, 0, gameManager.meterMaxValue);
	gameManager.combo = 0; // Break combo
	
	show_debug_message("NOTE EXPIRED MISS! Performance meter: " + string(gameManager.performanceMeter));
	} else {
	show_debug_message("TUTORIAL NOTE EXPIRED (no penalty)");
	}
	
	missProcessed = true; // Prevent double-processing
}
}

// NEW: Destroy note immediately when it can no longer be hit (75ms after reaching center)
if (!wasHit && reachedCenter && (moveTimer > centerReachedTime + (0.075 * room_speed))) {
show_debug_message("Note destroyed - outside hit window (drum type " + string(drumType) + ")");
instance_destroy();
exit;
}

// Fallback: Destroy symbol if it gets too far past target (safety measure)
if (progress > 2) {
show_debug_message("Note destroyed - fallback safety (drum type " + string(drumType) + ")");
instance_destroy();
}
