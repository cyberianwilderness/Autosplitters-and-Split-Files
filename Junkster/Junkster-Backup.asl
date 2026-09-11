state("junkTest-Win64-Shipping")
{

}
//backup splitter, does work but the ToatlGamePlayTime is the IGT at the end, not a collective Sum of CurrentIL Time

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Helper.GameName = "Junkster";
}

init
{
    vars.GWorld = vars.Helper.ScanRel(8, "0F 2E ?? 74 ?? 48 8B 1D ?? ?? ?? ?? 48 85 DB 74");
    vars.Log("GWorld: 0x" + vars.GWorld.ToString("X"));

    vars.FNamePool = vars.Helper.ScanRel(13, "89 5C 24 ?? 89 44 24 ?? 74 ?? 48 8D 15");
    vars.Log("FNamePool: 0x" + vars.FNamePool.ToString("X"));

    // cached once we've discovered ComicFrontend's raw FName value - avoids repeated string decoding
    vars.ComicFrontendFName = null;

    // classification caches for detecting "actually in a level" vs hub/menu/cutscene
    vars.NonPuzzleFNames = new HashSet<long>(); // hub + cutscene sublevel names, once identified
    vars.PuzzleFNames = new HashSet<long>();    // any other sublevel name, once identified as real puzzle content
    vars.CutsceneFNames = new HashSet<long>();  // puzzle-content sublevels that are themselves a cutscene (e.g. "LaunchOrders_cutscenes")

    // live run-scoped IGT accumulator
    vars.CompletedLevelsTime = 0.0;
    vars.LevelStartBaseline = null;
    vars.NeedsBaselineCapture = false;
    vars.StatManagerAddress = null;

    var cachedFNames = new Dictionary<long, string>();
    vars.ReadFName = (Func<long, string>)(fname =>
    {
        string name;
        if (cachedFNames.TryGetValue(fname, out name))
            return name;

        int name_offset  = (int) fname & 0xFFFF;
        int chunk_offset = (int) (fname >> 0x10) & 0xFFFF;

        var base_ptr = new DeepPointer((IntPtr) vars.FNamePool + chunk_offset * 0x8 + 0x10, name_offset * 0x2);
        byte[] name_metadata = base_ptr.DerefBytes(game, 2);
        if (name_metadata == null) return null;

        int size = name_metadata[1] << 2 | (name_metadata[0] & 0xC0) >> 6;

        IntPtr name_addr;
        base_ptr.DerefOffsets(game, out name_addr);
        name = game.ReadString(name_addr + 0x2, size);

        cachedFNames[fname] = name;
        return name;
    });
}

update
{
    if (vars.GWorld == IntPtr.Zero || vars.FNamePool == IntPtr.Zero) return;

    try
    {
        IntPtr world = vars.Helper.Read<IntPtr>((IntPtr) vars.GWorld);
        if (world == IntPtr.Zero) return;

        // Levels TArray<ULevel*>: data ptr at +0x138, count at +0x140
        IntPtr levelsData = vars.Helper.Read<IntPtr>(world + 0x138);
        int levelsCount = vars.Helper.Read<int>(world + 0x140);

        bool foundComicFrontend = false;
        bool foundPuzzleContent = false;
        bool foundLevelCutscene = false;

        if (levelsData != IntPtr.Zero && levelsCount > 0 && levelsCount < 64) // sanity clamp against a bad read
        {
            for (int i = 0; i < levelsCount; i++)
            {
                IntPtr level = vars.Helper.Read<IntPtr>(levelsData + i * 0x8);
                if (level == IntPtr.Zero) continue;

                IntPtr outer = vars.Helper.Read<IntPtr>(level + 0x20); // UOBJECT_OUTER
                if (outer == IntPtr.Zero) continue;

                long outerFName = vars.Helper.Read<long>(outer + 0x18);

                if (vars.ComicFrontendFName != null)
                {
                    // fast path: cheap integer compare, no string decode
                    if (outerFName == (long) vars.ComicFrontendFName)
                    {
                        foundComicFrontend = true;
                    }
                }
                else
                {
                    // slow path: only runs until we've discovered and cached the target FName once
                    string name = vars.ReadFName(outerFName);
                    if (name == "ComicFrontend")
                    {
                        vars.ComicFrontendFName = outerFName;
                        foundComicFrontend = true;
                    }
                }

                // classify this sublevel: known hub/cutscene name, or real puzzle content?
                if (!vars.NonPuzzleFNames.Contains(outerFName) && !vars.PuzzleFNames.Contains(outerFName))
                {
                    string classifyName = vars.ReadFName(outerFName);
                    bool isKnownNonPuzzle = classifyName == "StrmMaster_Adventure"
                        || classifyName == "AlienOverworld_LightingScenario"
                        || classifyName == "AlienOverworld_DioramaArt"
                        || classifyName == "AlienOverworld_Main"
                        || classifyName == "ComicFrontend"
                        || classifyName == "AlienOverworld_ending_cutscene"
                        || classifyName == "AlienOverworld_FinalCutsceneEnvironment";

                    if (isKnownNonPuzzle)
                    {
                        vars.NonPuzzleFNames.Add(outerFName);
                    }
                    else
                    {
                        vars.PuzzleFNames.Add(outerFName);
                        if (classifyName != null && classifyName.ToLower().Contains("cutscene"))
                            vars.CutsceneFNames.Add(outerFName);
                    }
                }

                if (vars.PuzzleFNames.Contains(outerFName))
                {
                    foundPuzzleContent = true;
                    if (vars.CutsceneFNames.Contains(outerFName))
                        foundLevelCutscene = true;
                }
            }
        }

        current.inLevel = foundPuzzleContent;
        current.levelCutscenePlaying = foundLevelCutscene;

        current.puzzleEnding = foundComicFrontend;

        if (!((IDictionary<string, object>) old).ContainsKey("puzzleEnding"))
        {
            vars.Log("puzzleEnding (initial): " + current.puzzleEnding);
            return;
        }

        if (old.puzzleEnding != current.puzzleEnding)
        {
            vars.Log("puzzleEnding: " + old.puzzleEnding + " -> " + current.puzzleEnding);
        }

        // --- Level stats: GWorld -> AuthorityGameMode -> StatManager -> CurrentlyPlayingLevelSummary ---
        // --- StatManager: found once via PersistentLevel's Actors array, then cached permanently ---
        if (vars.StatManagerAddress == null)
        {
            IntPtr persistentLevel = vars.Helper.Read<IntPtr>(world + 0x30); // UWorld::PersistentLevel
            current.persistentLevelDebug = persistentLevel.ToString("X");
            if (!((IDictionary<string, object>) old).ContainsKey("persistentLevelDebug"))
                vars.Log("DEBUG persistentLevel: 0x" + current.persistentLevelDebug);
            else if (old.persistentLevelDebug != current.persistentLevelDebug)
                vars.Log("DEBUG persistentLevel: 0x" + current.persistentLevelDebug);

            if (persistentLevel != IntPtr.Zero)
            {
                IntPtr actorsData = vars.Helper.Read<IntPtr>(persistentLevel + 0x90); // ULevel::Actors data
                int actorsCount = vars.Helper.Read<int>(persistentLevel + 0x98);       // ULevel::Actors count

                current.actorsDataDebug = actorsData.ToString("X");
                current.actorsCountDebug = actorsCount;
                if (!((IDictionary<string, object>) old).ContainsKey("actorsDataDebug"))
                    vars.Log("DEBUG actorsData: 0x" + current.actorsDataDebug + " | actorsCount: " + current.actorsCountDebug);
                else if (old.actorsDataDebug != current.actorsDataDebug || old.actorsCountDebug != current.actorsCountDebug)
                    vars.Log("DEBUG actorsData: 0x" + current.actorsDataDebug + " | actorsCount: " + current.actorsCountDebug);

                if (actorsData != IntPtr.Zero && actorsCount > 0 && actorsCount < 10000) // sanity clamp
                {
                    for (int i = 0; i < actorsCount; i++)
                    {
                        IntPtr actor = vars.Helper.Read<IntPtr>(actorsData + i * 0x8);
                        if (actor == IntPtr.Zero) continue;

                        IntPtr actorClass = vars.Helper.Read<IntPtr>(actor + 0x10); // UOBJECT_CLASS
                        if (actorClass == IntPtr.Zero) continue;

                        long actorClassFName = vars.Helper.Read<long>(actorClass + 0x18);
                        string actorClassName = vars.ReadFName(actorClassFName);

                        if (actorClassName == "StatManager_BP_C")
                        {
                            vars.StatManagerAddress = actor;
                            vars.Log("Found StatManager at 0x" + actor.ToString("X") + " (actor " + i + " of " + actorsCount + ")");
                            break;
                        }
                    }
                }
            }
        }

        IntPtr gameMode = vars.Helper.Read<IntPtr>(world + 0x118); // UWorld::AuthorityGameMode
        IntPtr gameState = vars.Helper.Read<IntPtr>(world + 0x120); // UWorld::GameState

        current.gameModeDebug = gameMode.ToString("X");
        current.gameStateDebug = gameState.ToString("X");

        string gameModeClassName = null;
        if (gameMode != IntPtr.Zero)
        {
            IntPtr gameModeClass = vars.Helper.Read<IntPtr>(gameMode + 0x10); // UOBJECT_CLASS
            if (gameModeClass != IntPtr.Zero)
            {
                long gameModeClassFName = vars.Helper.Read<long>(gameModeClass + 0x18);
                gameModeClassName = vars.ReadFName(gameModeClassFName);
            }
        }
        current.gameModeClassName = gameModeClassName;

        if (!((IDictionary<string, object>) old).ContainsKey("gameModeDebug"))
        {
            vars.Log("DEBUG gameMode: 0x" + current.gameModeDebug + " (class: " + current.gameModeClassName + ") | gameState: 0x" + current.gameStateDebug);
        }
        else if (old.gameModeDebug != current.gameModeDebug || old.gameStateDebug != current.gameStateDebug)
        {
            vars.Log("DEBUG gameMode: 0x" + current.gameModeDebug + " (class: " + current.gameModeClassName + ") | gameState: 0x" + current.gameStateDebug);
        }

        if (vars.StatManagerAddress != null)
        {
            IntPtr statManager = (IntPtr) vars.StatManagerAddress;
            IntPtr levelSummary = vars.Helper.Read<IntPtr>(statManager + 0x248);

            current.statManagerDebug = statManager.ToString("X");
            current.levelSummaryDebug = levelSummary.ToString("X");
            if (!((IDictionary<string, object>) old).ContainsKey("statManagerDebug"))
            {
                vars.Log("DEBUG statManager: 0x" + current.statManagerDebug + " | levelSummary: 0x" + current.levelSummaryDebug);
            }
            else if (old.statManagerDebug != current.statManagerDebug || old.levelSummaryDebug != current.levelSummaryDebug)
            {
                vars.Log("DEBUG statManager: 0x" + current.statManagerDebug + " | levelSummary: 0x" + current.levelSummaryDebug);
            }

            {
                if (levelSummary != IntPtr.Zero)
                {
                    current.playState = vars.Helper.Read<byte>(levelSummary + 0x28);
                    current.timesDied = vars.Helper.Read<int>(levelSummary + 0x2C);
                    current.adventureLevelPlayTime = vars.Helper.Read<float>(levelSummary + 0x30);
                    current.timeTrialBestTime = vars.Helper.Read<float>(levelSummary + 0x38);
                    current.cogsCollected = vars.Helper.Read<int>(levelSummary + 0x3C);

                    if (vars.NeedsBaselineCapture)
                    {
                        vars.LevelStartBaseline = (double) current.adventureLevelPlayTime;
                        vars.NeedsBaselineCapture = false;
                        vars.Log("Baseline captured: " + vars.LevelStartBaseline);
                    }

                    if (vars.LevelStartBaseline != null)
                        current.liveLevelDelta = (double) current.adventureLevelPlayTime - (double) vars.LevelStartBaseline;

                    if (!((IDictionary<string, object>) old).ContainsKey("timesDied"))
                    {
                        vars.Log("stats (initial): playState=" + current.playState + " timesDied=" + current.timesDied + " advTime=" + current.adventureLevelPlayTime + " ttBest=" + current.timeTrialBestTime + " cogs=" + current.cogsCollected);
                    }
                    else
                    {
                        if (old.playState != current.playState) vars.Log("playState: " + old.playState + " -> " + current.playState);
                        if (old.timesDied != current.timesDied) vars.Log("timesDied: " + old.timesDied + " -> " + current.timesDied);
                        if (old.adventureLevelPlayTime != current.adventureLevelPlayTime) vars.Log("adventureLevelPlayTime: " + old.adventureLevelPlayTime + " -> " + current.adventureLevelPlayTime);
                        if (old.timeTrialBestTime != current.timeTrialBestTime) vars.Log("timeTrialBestTime: " + old.timeTrialBestTime + " -> " + current.timeTrialBestTime);
                        if (old.cogsCollected != current.cogsCollected) vars.Log("cogsCollected: " + old.cogsCollected + " -> " + current.cogsCollected);
                    }
                }
            }
        }

        // --- Save-file total playtime: GWorld -> GameState -> SaveManager -> CurrentGlobalSaveData ---
        if (gameState != IntPtr.Zero)
        {
            IntPtr saveManager = vars.Helper.Read<IntPtr>(gameState + 0x4B0);
            if (saveManager != IntPtr.Zero)
            {
                // --- Local level timer: SaveManager -> CurrentLevelSaveData -> TimeSave.LevelTimeSecs ---
                IntPtr levelSaveData = vars.Helper.Read<IntPtr>(saveManager + 0x160);
                if (levelSaveData != IntPtr.Zero)
                {
                    current.levelTimeSecs = vars.Helper.Read<float>(levelSaveData + 0xD0);

                    if (!((IDictionary<string, object>) old).ContainsKey("levelTimeSecs"))
                    {
                        vars.Log("levelTimeSecs (initial): " + current.levelTimeSecs);
                    }
                    else
                    {
                        if (old.levelTimeSecs != current.levelTimeSecs)
                        {
                            vars.Log("levelTimeSecs: " + old.levelTimeSecs + " -> " + current.levelTimeSecs);
                        }

                        // a drop to near-zero means the level just ended and this reset for the next one -
                        // bank the just-finished level's time ourselves rather than trust totalGamePlayTime's timing.
                        // skip banking if the save itself still looks fresh - that means this drop is just stale
                        // data settling after switching to a new save, not a genuine level completion
                        if (old.levelTimeSecs > current.levelTimeSecs && current.levelTimeSecs < 5.0)
                        {
                            bool saveLooksFresh = ((IDictionary<string, object>) old).ContainsKey("totalGamePlayTime")
                                && (double) old.totalGamePlayTime < 2.0;

                            if (!saveLooksFresh)
                            {
                                vars.CompletedLevelsTime += (double) old.levelTimeSecs;
                                vars.Log("Banked level time: " + old.levelTimeSecs + " (completed total: " + vars.CompletedLevelsTime + ")");
                            }
                            else
                            {
                                vars.Log("Skipped banking stale level time (fresh save): " + old.levelTimeSecs);
                            }
                        }
                    }
                }

                IntPtr globalSave = vars.Helper.Read<IntPtr>(saveManager + 0x100);
                if (globalSave != IntPtr.Zero)
                {
                    current.totalGamePlayTime = vars.Helper.Read<float>(globalSave + 0x1C8);

                    if (!((IDictionary<string, object>) old).ContainsKey("totalGamePlayTime"))
                    {
                        vars.Log("totalGamePlayTime (initial): " + current.totalGamePlayTime);
                    }
                    else if (old.totalGamePlayTime != current.totalGamePlayTime)
                    {
                        vars.Log("totalGamePlayTime: " + old.totalGamePlayTime + " -> " + current.totalGamePlayTime);
                    }
                }
            }
        }
    }
    catch (Exception e)
    {
        vars.Log("update() exception: " + e.Message);
        return;
    }
}

start
{
    var currentDict = (IDictionary<string, object>) current;
    var oldDict = (IDictionary<string, object>) old;
    if (!oldDict.ContainsKey("inLevel") || !currentDict.ContainsKey("totalGamePlayTime")) return false;

    // just walked into a level, on a save that hasn't finished one yet - this can only be a fresh run
    bool justEnteredLevel = !old.inLevel && current.inLevel;
    bool looksFresh = (double) current.totalGamePlayTime < 2.0;

    bool shouldStart = justEnteredLevel && looksFresh;
    if (shouldStart)
    {
        vars.CompletedLevelsTime = 0.0;
        vars.Log("Run starting (fresh save detected) - reset CompletedLevelsTime to 0");
    }

    return shouldStart;
}

split
{
    var oldDict = (IDictionary<string, object>) old;
    if (!oldDict.ContainsKey("puzzleEnding")) return false;

    return !old.puzzleEnding && current.puzzleEnding;
}

gameTime
{
    var currentDict = (IDictionary<string, object>) current;
    if (!currentDict.ContainsKey("levelTimeSecs"))
        return null;

    return TimeSpan.FromSeconds((double) vars.CompletedLevelsTime + (double) current.levelTimeSecs);
}

onReset
{
    vars.CompletedLevelsTime = 0.0;
    vars.Log("onReset fired - cleared CompletedLevelsTime");
}