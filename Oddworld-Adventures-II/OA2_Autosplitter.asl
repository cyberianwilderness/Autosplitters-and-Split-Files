state("LiveSplit") {}

/*       
________________________________________________________________________________________________________
|                                                                                                       |
| LiveSplit Auto Splitter script for Oddworld Adventures 2 for Game Boy Color (GBC)                     |
| Supported Emulators:                                                                                  |
|   - Gambatte                                                                                          |
|                                                                                                       |
| Made by l1ndblum                                                                                      |
|   Each split should occur when the password screen is on screen.                                      |
|   Final split occurs when the final lever press is pulled in the boiler room.                         |
|                                                                                                       |
|    Massive thank you to the Code Notes on RetroAchievements                                           |
|_______________________________________________________________________________________________________|
*/

startup
{
    Assembly.Load(File.ReadAllBytes("Components/emu-help-v3")).CreateInstance("GBC");

    vars.LevelID = vars.Helper.Make<byte>(0xc59d); // "Level ID 8bit"

    vars.LeverProcess = (System.Diagnostics.Process)null;
    vars.LeverAddress = IntPtr.Zero;
    vars.LeverValueCurrent = (byte)0;
    vars.LeverValueOld = (byte)0;

    vars.RefreshLeverProcess = (Action)(() =>
    {
        var p = System.Diagnostics.Process.GetProcessesByName("gambatte_speedrun").FirstOrDefault();
        vars.LeverProcess = p;
        if (p != null && !p.HasExited)
            vars.LeverAddress = (IntPtr)((long)p.MainModule.BaseAddress + 0xDCD293);
    });
    vars.RefreshLeverProcess();
}

update
{
    if (vars.LevelID.Current != vars.LevelID.Old)
    {
        print("LevelID: " + vars.LevelID.Old + " -> " + vars.LevelID.Current);
    }
    if (vars.LeverProcess == null || ((System.Diagnostics.Process)vars.LeverProcess).HasExited)
    {
        vars.RefreshLeverProcess();
    }
    if (vars.LeverProcess != null && !((System.Diagnostics.Process)vars.LeverProcess).HasExited)
    {
        vars.LeverValueOld = vars.LeverValueCurrent;
        vars.LeverValueCurrent = ((System.Diagnostics.Process)vars.LeverProcess).ReadValue<byte>((IntPtr)vars.LeverAddress);
    }
}

start
{
        return vars.LevelID.Current == 0 && vars.LevelID.Old == 30;
}

split
{
    // Final Split (Lever Pull) conditions
    if (vars.LevelID.Current == 27 && vars.LeverValueCurrent == 3 && vars.LeverValueOld == 0)
        return true;
    // split on Password Screen
    return vars.LevelID.Current == 32 && vars.LevelID.Old != 32;
}

reset
{
    return vars.LevelID.Current == 30 && vars.LevelID.Old == 0;
    // return false;
}
