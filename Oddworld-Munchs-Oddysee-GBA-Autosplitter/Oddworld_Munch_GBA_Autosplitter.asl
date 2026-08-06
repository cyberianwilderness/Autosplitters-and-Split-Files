/*
Oddworld: Munch's Oddysee (GBA) Autosplitter
Author: l1ndblum
Note:   Must use the mGBA emulator for this autosplitter to work
        Requires emu-help-v3.dll in LiveSplit Components folder.
*/
state("mGBA") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/emu-help-v3")).CreateInstance("GBA");
    vars.ScrubsLevel  = vars.Helper.Make<byte>(0x02000621);
    vars.FuzzlesLevel = vars.Helper.Make<byte>(0x02000625);
    vars.Followers    = vars.Helper.Make<byte>(0x02004E68);
}

init
{
    vars.levelEndIndex = 0;
    vars.runFinishedSeen = false;
    vars.finalRankDone = false;
    vars.resetPrimed = false;
    vars.firstPrint = true;
}

update
{
    if (timer.CurrentPhase == TimerPhase.NotRunning)
    {
        vars.levelEndIndex = 0;
        vars.runFinishedSeen = false;
        vars.finalRankDone = false;
        vars.resetPrimed = false;
    }
}

start
{
    bool shouldStart =
        timer.CurrentPhase == TimerPhase.NotRunning &&
        vars.ScrubsLevel.Current == 6 &&
        vars.FuzzlesLevel.Current == 6;

    if (shouldStart)
        vars.resetPrimed = true;

    return shouldStart;
}

split
{
    bool levelEndPulse =
        vars.ScrubsLevel.Old != 52 &&
        vars.ScrubsLevel.Current == 52;

    bool runFinishedPulse =
        vars.ScrubsLevel.Old != 153 &&
        vars.ScrubsLevel.Current == 153;

    if (runFinishedPulse)
    {
        vars.runFinishedSeen = true;
        return true;
    }

    if (levelEndPulse)
    {
        if (vars.runFinishedSeen && !vars.finalRankDone)
        {
            vars.finalRankDone = true;
            return true;
        }

        if (vars.levelEndIndex < 13)
        {
            vars.levelEndIndex++;
            return true;
        }
    }
    return false;
}

reset
{
    if (vars.resetPrimed && vars.ScrubsLevel.Current == 25 && vars.FuzzlesLevel.Current == 51 && vars.Followers.Current == 0)
    {
        vars.resetPrimed = false;
        return true;
    }
    return false;
}