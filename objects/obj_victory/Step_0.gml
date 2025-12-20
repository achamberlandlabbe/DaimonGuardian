/// obj_victory Step Event
// Wait for accept button to go to credits
if (input_check_pressed("accept")) {
    // Save gold and XP earned this run
    global.saveData.cumulativeGold = global.gold;
    global.saveData.currentScore = global.player1score;
    var pc = instance_find(obj_pc, 0);
    if (pc != noone) {
        global.saveData.pcXP = pc.heroXP;
    }
    // DO NOT set hasActiveRun = false - player needs to continue to spend gold/XP
    global.doSave = true;
    
    global.isPaused = false;
    room_goto(roomCredits);
}