state("LiveSplit") {}

/*
________________________________________________________________________________________________________
|                                                                                                        |
| LiveSplit Auto Splitter script for Oddworld Adventures 2 for Game Boy Color (GBC)                      |
| Supported Emulators:                                                                                   |
|   - Gambatte                                                                                           |
|                                                                                                        |
| Made by NanobotZ & l1ndblum                                                                                       |
|   Each split occurs when the password screen is on screen (including the ending).                      |
|                                                                                                        |
|    Massive thank you to the Code Notes on RetroAchievements                                            |
|________________________________________________________________________________________________________|
*/

startup
{
    Assembly.Load(File.ReadAllBytes("Components/emu-help-v3")).CreateInstance("GBC");

    vars.LevelID = vars.Helper.Make<byte>(0xc59d); // "Level ID 8bit"
    
    vars.MenuScreen = vars.Helper.Make<byte>(0xc4f4); // 8 - password input, 27 - difficulty screen, 37 - gamespeak, 39 - main menu
    vars.MenuSelectedOption = vars.Helper.Make<byte>(0xc12b); // 0 - game start, 1 - gamespeak, 2 - password, 3 - normal, 4 - easy
    // vars.InputButton = vars.Helper.Make<byte>(0xff8b); // bit field = 1 - A, 2 - B, 4 - select, 9 - start, 16 - right, 32 - left, 64 - up, 128 - down
    // vars.Interrupt = vars.Helper.Make<byte>(0xff8d);
    
    // vars.Mask_A_or_Start = (uint)9;

    // vars.MudokonsLeftLevelWatcher = vars.Helper.Make<byte>(0xc610);
    // vars.TotalMudokonsLeftWatcher = vars.Helper.Make<byte>(0xc611);
    vars.FinalLevers = vars.Helper.Make<int>(0xc618); // represented in memory as 4 bytes, one next to each other, 00 = off, 01 = on; 0x01010101 means all 4 levers are on
}

update
{
    vars.LevelID.ForceUpdate();
    // vars.MudokonsLeftLevel = vars.MudokonsLeftLevelWatcher.Current;
    // vars.TotalMudokonsLeft = vars.TotalMudokonsLeftWatcher.Current;
}

start
{
    vars.MenuScreen.ForceUpdate();
    vars.MenuSelectedOption.ForceUpdate();
    // print ("LevelID: " + vars.LevelID.Current + ", MenuScreen: " + vars.MenuScreen.Current + ", MenuSelectedOption: " + vars.MenuSelectedOption.Current);
    
    return vars.LevelID.Current == 30
        && vars.MenuScreen.Current == 0 && vars.MenuScreen.Old == 27
        && (vars.MenuSelectedOption.Old == 3 || vars.MenuSelectedOption.Old == 4) && vars.MenuSelectedOption.Current == 0;
}

split
{
    if (vars.LevelID.Current == 27)
    {
        vars.FinalLevers.ForceUpdate();
        // print ("Final levers: " + vars.FinalLevers.Current.ToString("X8"));
        return vars.FinalLevers.Current != vars.FinalLevers.Old && vars.FinalLevers.Current == 0x01010101;
    }
    else
    {
        // Password/code screen (LevelID 32) after every level completion including the ending (albeit late).
        return vars.LevelID.Current == 32 && vars.LevelID.Old != 32;
    }
}

reset
{
    return vars.LevelID.Current == 30 && vars.LevelID.Old == 0;
}