state("BlackTheFall")
{
    // We don't read game memory directly - the MelonLoader mod writes
    // state to a text file, and this script just reads that file.
}

startup
{
    // CHANGE THIS if your game is installed somewhere else.
    vars.statePath = @"C:\Program Files (x86)\Steam\steamapps\common\BlackTheFall\autosplitter_state.txt";

    vars.lastZoneID = -1;
    vars.lastSceneID = -1;
    vars.lastCheckpointSequence = -1;
    vars.hasStarted = false;
}

init
{
    // Nothing to attach to in memory - we're reading a file, so init is a no-op.
}

update
{
    if (game == null || game.HasExited) return false;

    if (!System.IO.File.Exists(vars.statePath))
    {
        return true; // mod hasn't written the file yet - keep waiting
    }

    try
    {
        string line = System.IO.File.ReadAllText(vars.statePath);
        string[] parts = line.Split(',');

        if (parts.Length < 7) return true;

        vars.gameStage          = parts[0];          // NONE / INIT / WAIT_FOR_CHECKPOINT / SPAWN_PLAYER / RUNNING
        vars.directorState      = parts[1];           // NONE / MENU / LOADING / RUNNING / PAUSED
        vars.zoneID             = int.Parse(parts[2]);
        vars.sceneID            = int.Parse(parts[3]);
        vars.checkpointSequence = int.Parse(parts[4]);
        vars.isPaused           = bool.Parse(parts[5]);
        vars.checkpointName     = parts[6];
    }
    catch (Exception e)
    {
        print("[BTF-ASL] error reading state file: " + e.Message);
        return true;
    }

    return true;
}

// Uncomment the print() lines below while testing - they show up in
// LiveSplit's ASL debug output (right-click layout > Edit Layout >
// double-click the Auto Splitter component's log, or Debug menu
// depending on your LiveSplit version) so you can watch values change
// live without touching Cheat Engine at all.

start
{
    // Fires once when GameDirector transitions into a fresh run.
    // NewGame() in the game's code starts at zoneID=1, sceneID=1.
    bool starting = vars.directorState == "LOADING" && vars.zoneID <= 1 && vars.sceneID <= 1 && !vars.hasStarted;

    // print("[BTF-ASL] stage=" + vars.gameStage + " director=" + vars.directorState + " zone=" + vars.zoneID + " scene=" + vars.sceneID + " seq=" + vars.checkpointSequence);

    if (starting)
    {
        vars.hasStarted = true;
        vars.lastZoneID = vars.zoneID;
        vars.lastSceneID = vars.sceneID;
        vars.lastCheckpointSequence = vars.checkpointSequence;
    }

    return starting;
}

split
{
    if (!vars.hasStarted) return false;

    bool progressed =
        vars.zoneID > vars.lastZoneID ||
        (vars.zoneID == vars.lastZoneID && vars.sceneID > vars.lastSceneID) ||
        (vars.zoneID == vars.lastZoneID && vars.sceneID == vars.lastSceneID && vars.checkpointSequence > vars.lastCheckpointSequence);

    // print("[BTF-ASL] progressed=" + progressed + " (" + vars.zoneID + "," + vars.sceneID + "," + vars.checkpointSequence + ") checkpoint=" + vars.checkpointName);

    if (progressed)
    {
        vars.lastZoneID = vars.zoneID;
        vars.lastSceneID = vars.sceneID;
        vars.lastCheckpointSequence = vars.checkpointSequence;
    }

    return progressed;
}

isLoading
{
    // Subtract time while GameDirector is mid-transition, or the
    // in-game respawn cycle is running (WAIT_FOR_CHECKPOINT/SPAWN_PLAYER).
    return vars.directorState == "LOADING"
        || vars.gameStage == "WAIT_FOR_CHECKPOINT"
        || vars.gameStage == "SPAWN_PLAYER";
}

reset
{
    // Back at the main menu after having started a run.
    return vars.hasStarted && vars.directorState == "MENU";
}

exit
{
    vars.hasStarted = false;
}
