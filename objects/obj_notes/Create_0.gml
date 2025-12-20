// ===== obj_notes - Create Event (FIXED with Hit Timing Window) =====
// CRITICAL FIX: Prevent double-drawing since we manually render in obj_levelDecor
visible = false;
// Set depth to draw on top of target circle
depth = -2000;

// Movement properties (will be set by obj_level when creating the note)
targetX = 0;
targetY = 0;
travelTime = 2 * room_speed; // Default 2 seconds
drumType = 0; // Will be set by obj_level

// Movement calculation
startX = x;
startY = y;
moveTimer = 0;

// Hit detection variables
wasHit = false;
missCheckDistance = 30; // Distance past target where we consider it missed
missProcessed = false; // Prevent double-processing misses

// NEW: Hit timing window variables (150ms total: 75ms before center, 75ms after center)
hitWindowFrames = 0.15 * room_speed; // 150ms total hit window (9 frames at 60fps)
hitWindowStart = travelTime - (0.075 * room_speed); // Start 75ms before reaching center
hitWindowEnd = travelTime + (0.075 * room_speed); // End 75ms after reaching center
reachedCenter = false;
centerReachedTime = 0;

// Optional scaling effect
noteScale = 1;

// MOVED: Hit timing function - determines if note can be hit right now
function canBeHit() {
// Note can be hit if:
// 1. It's within the timing window (0.5s before center to 0.5s after center)
// 2. It hasn't been hit already

if (wasHit) return false;

// Check if we're in the hit window
var inHitWindow = (moveTimer >= hitWindowStart && moveTimer <= hitWindowEnd);

if (inHitWindow) {
	show_debug_message("Note can be hit - moveTimer: " + string(moveTimer) + ", window: " + string(hitWindowStart) + " to " + string(hitWindowEnd));
}

return inHitWindow;
}
