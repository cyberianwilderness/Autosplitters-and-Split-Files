state("LiveSplit") {}
/*
________________________________________________________________________________________________________
|                                                                                                       |
| LiveSplit Auto Splitter script for Oddworld Adventures 1 for Game Boy Color (GBC)                    |
| Supported Emulators:                                                                                 |
|   - Gambatte                                                                                          |
|                                                                                                       |
| Split logic:                                                                                          |
|   Start: CurrentArea 0 -> 1                                                                           |
|   Split: section done (CurrentArea 1 -> 2)                                                            |
|   Split: entering the temple (CurrentArea 2 -> 0)                                                     |
|   Split: all 6 trials completed, back at hub for the last time (CurrentArea 0 -> 9)                   |
|   Split: each subsequent area increment (9->10->11->12->13->14)                                       |
|   Final split: sustained PasswordState==0 hold (debounced) once in CurrentArea 14,                    |
|                requiring the hold to have started from a flicker-cycle value (16/20/24/28)             |
|                to filter out earlier chaotic dips to 0 during the ending cutscene                     |
|_______________________________________________________________________________________________________|
*/
startup
{
    Assembly.Load(File.ReadAllBytes("Components/emu-help-v3")).CreateInstance("GBC");

    vars.PasswordState = vars.Helper.Make<byte>(0xc015);
    vars.CurrentArea    = vars.Helper.Make<byte>(0xc6dd);

    vars.ZeroHoldTicks = 0;
}
update
{
    if (vars.CurrentArea.Current == 14)
    {
        bool validZeroEntry = vars.PasswordState.Old == 16 || vars.PasswordState.Old == 20
                            || vars.PasswordState.Old == 24 || vars.PasswordState.Old == 28;

        if (vars.PasswordState.Current == 0 && (validZeroEntry || vars.ZeroHoldTicks > 0))
            vars.ZeroHoldTicks++;
        else
            vars.ZeroHoldTicks = 0;
    }
    else
    {
        vars.ZeroHoldTicks = 0;
    }
}
start
{
    return vars.CurrentArea.Current == 1 && vars.CurrentArea.Old == 0;
}
split
{
    // Section done
    if (vars.CurrentArea.Current == 2 && vars.CurrentArea.Old == 1)
        return true;

    // Section done -> entering temple
    if (vars.CurrentArea.Current == 0 && vars.CurrentArea.Old == 2)
        return true;

    // All 6 trials done -> back to hub for the last time
    if (vars.CurrentArea.Current == 9 && vars.CurrentArea.Old == 0)
        return true;

    // From area 9 onward it just increments
    if (vars.CurrentArea.Current > vars.CurrentArea.Old && vars.CurrentArea.Old >= 9)
        return true;

    // Final split: debounced zero-hold on the true ending - sometimes it flickers to 0 during the final level but instantly goes to another value.
    // However this is the only value I found that reliably changes at the end of the game and stays to 0,
    // therefore it splits when only when it stays for a prolonged period and you are on the last level (current level 14)
    if (vars.CurrentArea.Current == 14 && vars.ZeroHoldTicks > 60)
        return true;

    return false;
}