/* Golden Axe (Genesis) - cleaner RAM-based autosplitter idea */

state("Fusion")
{
    byte mode1      : 0x00C105; // 00 arcade, 04 beginner (per notes)
    byte mode2      : 0x00C106; // 00 arcade, 04 beginner (per notes)
    byte screen     : 0x00C172; // 04 menu, 08 char select, 0C in-game, 40 game over, etc.
    byte stage      : 0x00FE2C; // stage (arcade/beginner)
    byte duelA      : 0x00FE2A; // duel stage A
    byte duelB      : 0x00FE2B; // duel stage B
}

startup
{
    settings.Add("ModeSelection.", false, "==Choose one option below or it defaults to Arcade==");
    settings.Add("arcadeMode", true, "Arcade Mode");
    settings.Add("duelMode", false, "Duel Mode");
    settings.Add("beginnerMode", false, "Beginner Mode");
}

init
{
    vars.Debug = (Action<string>)((m) => print("[GA] " + m));

    vars.timerStarted = false;

    vars.lastStage = 0;
    vars.lastDuelA = 0;
    vars.lastDuelB = 0;

    vars.armedStageSplit = false;
    vars.armedDuelSplit  = false;

    vars.selectedMode = "Arcade";
    vars.mode1 = 0;
    vars.mode2 = 0;
    //vars.mode3 = 0;
    vars.screen = 0;
    vars.stage = 0;
    vars.duelA = 0;
    vars.duelB = 0;

}

update
{
    // keep mode synced with settings (don’t lock it in init)
    if (settings["duelMode"]) vars.selectedMode = "Duel";
    else if (settings["beginnerMode"]) vars.selectedMode = "Beginner";
    else vars.selectedMode = "Arcade";

    vars.mode1 = current.mode1;
    vars.mode2 = current.mode2;
    //vars.mode3 = current.mode3;
    vars.screen = current.screen;
    vars.stage = current.stage;
    vars.duelA = current.duelA;
    vars.duelB = current.duelB;
}

start
{
    // Start when you transition into real gameplay (screen: 08 -> 0C is a nice clean “go” signal)
    // If your game skips 08 sometimes, use (old.screen != 0x0C && current.screen == 0x0C)
    if (!vars.timerStarted && old.screen == 0x08 && current.screen == 0x0C)
    {
        vars.timerStarted = true;

        vars.lastStage = current.stage;
        vars.lastDuelA = current.duelA;
        vars.lastDuelB = current.duelB;

        vars.Debug("Start: mode=" + vars.selectedMode + " stage=" + current.stage);
        return true;
    }

    return false;
}

split
{
    if (!vars.timerStarted) return false;

    // -------- ARCADE / BEGINNER: split on stage increments --------
    if (vars.selectedMode != "Duel")
    {
        // Arm splits only while actually in-game, so menus/continue screens don’t cause nonsense
        if (current.screen == 0x0C)
            vars.armedStageSplit = true;

        // Split when stage changes while armed
        if (vars.armedStageSplit && current.stage != vars.lastStage)
        {
            vars.Debug("Stage split: " + vars.lastStage + " -> " + current.stage);
            vars.lastStage = current.stage;
            vars.armedStageSplit = false;
            return true;
        }

        // Final split (example): Game Over screen
        if (old.screen == 0x0C && current.screen == 0x40)
        {
            vars.Debug("Finish (Game Over).");
            return true;
        }

        return false;
    }

    // -------- DUEL: split when duel stage changes --------
    // (We don’t know exactly how duelA/duelB behave yet, so we use “either changes”)
    if (vars.selectedMode == "Duel")
    {
        if (current.screen == 0x0C)
            vars.armedDuelSplit = true;

        bool duelChanged = (current.duelA != vars.lastDuelA) || (current.duelB != vars.lastDuelB);

        if (vars.armedDuelSplit && duelChanged)
        {
            //vars.Debug($"Duel split: A {vars.lastDuelA}->{current.duelA}, B {vars.lastDuelB}->{current.duelB}");
            vars.lastDuelA = current.duelA;
            vars.lastDuelB = current.duelB;
            vars.armedDuelSplit = false;
            return true;
        }

        // Finish on game over / end screen if that’s what Duel uses in your run
        if (old.screen == 0x0C && current.screen == 0x40)
        {
            vars.Debug("Duel finish (Game Over).");
            return true;
        }

        return false;
    }

    return false;
}

reset
{
    // Reset when returning to main menu screen
    if (old.screen != 0x04 && current.screen == 0x04)
    {
        vars.timerStarted = false;
        vars.armedStageSplit = false;
        vars.armedDuelSplit  = false;
        vars.lastStage = 0;
        vars.lastDuelA = 0;
        vars.lastDuelB = 0;
        vars.Debug("Reset (back to main menu).");
        return true;
    }

    return false;
}
