state("InfiltrateAndExtract-Win64-Shipping.exe")
{
    // Module-relative offsets (ASLR-safe).
    int a : 0x68D4788;
    int b : 0x68D4738;
}

startup
{
    // Toggle per-level splitting + debug logs
    for (int i = 1; i <= 10; i++) settings.Add($"split_L{i}", true, $"Split on Level {i}");
    settings.Add("debug", false, "Debug logging to LiveSplit");

    // Index 0 = Main Menu, 1..10 = Levels
    vars.aVals = new [] { 562, 561, 560, 563, 560, 563, 562, 561, 562, 560, 561 };
    vars.bVals = new [] { 3218,3211,3209,3221,3211,3222,3216,3215,3218,3213,3219 };

    vars.EQ = (Func<int,int,bool>)((level, aa) => aa == vars.aVals[level]);
    vars.EQb = (Func<int,int,bool>)((level, bb) => bb == vars.bVals[level]);
    vars.PairMatch = (Func<int,int,int,bool>)((level, aa, bb) =>
        aa == vars.aVals[level] && bb == vars.bVals[level]);

    vars.resetState = (Action)(() =>
    {
        vars.currentLevel = 0;      // 0 = MM, 1..10 = levels, 11 = post-L10
        vars.lastSplitLevel = 0;    // highest level already split
        vars.didFinalLevelSplit = false;
        vars.didEndSplit = false;
    });

    vars.resetState();
}

init
{
    if (settings["debug"]) print("[ASL] Hooked InfiltrateAndExtract - awaiting Level 1 to start.");
}

update
{
    // No-op; we read current.a/current.b directly in sections
}

start
{
    // Start when Level 1 pair appears while timer is not running.
    if (timer.CurrentPhase == TimerPhase.NotRunning && vars.PairMatch(1, current.a, current.b))
    {
        vars.resetState();
        vars.currentLevel = 1;
        if (settings["debug"]) print("[ASL] Start detected: Level 1 pair seen. currentLevel=1");
        return true;
    }
    false
}

split
{
    // Extra end-game split AFTER Level 10 split when values change away from L10.
    if (vars.didFinalLevelSplit && !vars.didEndSplit)
    {
        if (!vars.PairMatch(10, current.a, current.b))
        {
            vars.didEndSplit = true;
            if (settings["debug"]) print("[ASL] End-game split: values changed away from Level 10 pair.");
            return true;
        }
    }

    // Only split on exact (a,b) match for the CURRENT level, then increment currentLevel.
    switch (vars.currentLevel)
    {
        case 1:
            if (settings["split_L1"] && vars.lastSplitLevel < 1 && vars.PairMatch(1, current.a, current.b))
            {
                vars.lastSplitLevel = 1;
                vars.currentLevel = 2;
                if (settings["debug"]) print("[ASL] Split: Level 1 -> set currentLevel=2");
                return true;
            }
            break;

        case 2:
            if (settings["split_L2"] && vars.lastSplitLevel < 2 && vars.PairMatch(2, current.a, current.b))
            {
                vars.lastSplitLevel = 2;
                vars.currentLevel = 3;
                if (settings["debug"]) print("[ASL] Split: Level 2 -> set currentLevel=3");
                return true;
            }
            break;

        case 3:
            if (settings["split_L3"] && vars.lastSplitLevel < 3 && vars.PairMatch(3, current.a, current.b))
            {
                vars.lastSplitLevel = 3;
                vars.currentLevel = 4;
                if (settings["debug"]) print("[ASL] Split: Level 3 -> set currentLevel=4");
                return true;
            }
            break;

        case 4:
            if (settings["split_L4"] && vars.lastSplitLevel < 4 && vars.PairMatch(4, current.a, current.b))
            {
                vars.lastSplitLevel = 4;
                vars.currentLevel = 5;
                if (settings["debug"]) print("[ASL] Split: Level 4 -> set currentLevel=5");
                return true;
            }
            break;

        case 5:
            if (settings["split_L5"] && vars.lastSplitLevel < 5 && vars.PairMatch(5, current.a, current.b))
            {
                vars.lastSplitLevel = 5;
                vars.currentLevel = 6;
                if (settings["debug"]) print("[ASL] Split: Level 5 -> set currentLevel=6");
                return true;
            }
            break;

        case 6:
            if (settings["split_L6"] && vars.lastSplitLevel < 6 && vars.PairMatch(6, current.a, current.b))
            {
                vars.lastSplitLevel = 6;
                vars.currentLevel = 7;
                if (settings["debug"]) print("[ASL] Split: Level 6 -> set currentLevel=7");
                return true;
            }
            break;

        case 7:
            if (settings["split_L7"] && vars.lastSplitLevel < 7 && vars.PairMatch(7, current.a, current.b))
            {
                vars.lastSplitLevel = 7;
                vars.currentLevel = 8;
                if (settings["debug"]) print("[ASL] Split: Level 7 -> set currentLevel=8");
                return true;
            }
            break;

        case 8:
            if (settings["split_L8"] && vars.lastSplitLevel < 8 && vars.PairMatch(8, current.a, current.b))
            {
                vars.lastSplitLevel = 8;
                vars.currentLevel = 9;
                if (settings["debug"]) print("[ASL] Split: Level 8 -> set currentLevel=9");
                return true;
            }
            break;

        case 9:
            if (settings["split_L9"] && vars.lastSplitLevel < 9 && vars.PairMatch(9, current.a, current.b))
            {
                vars.lastSplitLevel = 9;
                vars.currentLevel = 10;
                if (settings["debug"]) print("[ASL] Split: Level 9 -> set currentLevel=10");
                return true;
            }
            break;

        case 10:
            if (settings["split_L10"] && vars.lastSplitLevel < 10 && vars.PairMatch(10, current.a, current.b))
            {
                vars.lastSplitLevel = 10;
                vars.currentLevel = 11; // Post-L10 sentinel
                vars.didFinalLevelSplit = true;
                if (settings["debug"]) print("[ASL] Split: Level 10 -> set currentLevel=11 (post-L10), waiting for end-game change");
                return true;
            }
            break;

        default:
            // currentLevel 0 (MM) or 11+ (post-L10) -> no per-level split
            break;
    }

    return false;
}

reset
{
    // Reset when Main Menu pair is seen during a run.
    if (timer.CurrentPhase == TimerPhase.Running && vars.PairMatch(0, current.a, current.b))
    {
        if (settings["debug"]) print("[ASL] Reset: Main Menu pair detected.");
        return true;
    }
    return false;
}

onReset
{
    vars.resetState();
    if (settings["debug"]) print("[ASL] State cleared on reset.");
}

