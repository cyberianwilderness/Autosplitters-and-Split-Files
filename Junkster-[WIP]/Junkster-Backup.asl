state("junkTest-Win64-Shipping")
{

}

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
                        break;
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
                        break;
                    }
                }
            }
        }

        current.puzzleEnding = foundComicFrontend;

        if (!((IDictionary<string, object>) old).ContainsKey("puzzleEnding"))
        {
            vars.Log("puzzleEnding (initial): " + current.puzzleEnding);
            return;
        }

        if (old.puzzleEnding != current.puzzleEnding)
            vars.Log("puzzleEnding: " + old.puzzleEnding + " -> " + current.puzzleEnding);

        // --- Level stats: GWorld -> AuthorityGameMode -> StatManager -> CurrentlyPlayingLevelSummary ---
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

        if (gameMode != IntPtr.Zero)
        {
            IntPtr statManager = vars.Helper.Read<IntPtr>(gameMode + 0x2E8);
            if (statManager != IntPtr.Zero)
            {
                IntPtr levelSummary = vars.Helper.Read<IntPtr>(statManager + 0x248);
                if (levelSummary != IntPtr.Zero)
                {
                    current.playState = vars.Helper.Read<byte>(levelSummary + 0x28);
                    current.timesDied = vars.Helper.Read<int>(levelSummary + 0x2C);
                    current.adventureLevelPlayTime = vars.Helper.Read<float>(levelSummary + 0x30);
                    current.timeTrialBestTime = vars.Helper.Read<float>(levelSummary + 0x38);
                    current.cogsCollected = vars.Helper.Read<int>(levelSummary + 0x3C);

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
gameTime
{
    var currentDict = (IDictionary<string, object>) current;
    if (!currentDict.ContainsKey("totalGamePlayTime"))
        return null;

    return TimeSpan.FromSeconds((double) current.totalGamePlayTime);
}
start
{
    var oldDict = (IDictionary<string, object>) old;
    if (!oldDict.ContainsKey("puzzleEnding")) return false;

    return old.puzzleEnding && !current.puzzleEnding;
}

split
{
    var oldDict = (IDictionary<string, object>) old;
    if (!oldDict.ContainsKey("puzzleEnding")) return false;

    return !old.puzzleEnding && current.puzzleEnding;
}