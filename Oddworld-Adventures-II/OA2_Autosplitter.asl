state("LiveSplit") {}

/*
________________________________________________________________________________________________________
|                                                                                                        |
| LiveSplit Auto Splitter script for Oddworld Adventures 2 for Game Boy Color (GBC)                      |
| Supported Emulators:                                                                                   |
|   - Gambatte                                                                                           |
|                                                                                                         |
| Made by l1ndblum                                                                                        |
|   Each split occurs when the password screen is on screen (including the ending).                       |
|                                                                                                         |
|    Massive thank you to the Code Notes on RetroAchievements                                            |
|________________________________________________________________________________________________________|
*/

startup
{
    Assembly.Load(File.ReadAllBytes("Components/emu-help-v3")).CreateInstance("GBC");

    vars.LevelID = vars.Helper.Make<byte>(0xc59d); // "Level ID 8bit"

   // vars.MudokonsLeftLevelWatcher = vars.Helper.Make<byte>(0xc610);
   // vars.TotalMudokonsLeftWatcher = vars.Helper.Make<byte>(0xc611);
}

update
{
    //if (vars.LevelID.Current != vars.LevelID.Old)
    //    print("LevelID: " + vars.LevelID.Old + " -> " + vars.LevelID.Current);

  //  vars.MudokonsLeftLevel = vars.MudokonsLeftLevelWatcher.Current;
  //  vars.TotalMudokonsLeft = vars.TotalMudokonsLeftWatcher.Current;
}

start
{
    return vars.LevelID.Current == 0 && vars.LevelID.Old == 30;
}

split
{
    // Password/code screen (LevelID 32) after every level completion including the ending (albeit late).
    return vars.LevelID.Current == 32 && vars.LevelID.Old != 32;
}

reset
{
    return vars.LevelID.Current == 30 && vars.LevelID.Old == 0;
}
