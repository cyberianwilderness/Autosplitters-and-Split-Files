state("LiveSplit") {}

/*
_________________________________________________________________________________________________________
|                                                                                                        |
| LiveSplit Auto Splitter script for Oddworld Adventures 2 for Game Boy Color (GBC)                      |
| Supported Emulators:                                                                                   |
|   - Gambatte                                                                                           |
|                                                                                                        |
| Made by NanobotZ & l1ndblum                                                                            |
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
	vars.GameStart = vars.Helper.Make<short>(0xcff0); // unknown, sound ID? 0x0072 when game start sound plays

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
	vars.GameStart.ForceUpdate();
	
	return vars.LevelID.Current == 30 // menu level
		&& vars.MenuScreen.Current == 27 // difficulty screen
		&& (vars.GameStart.Changed && vars.GameStart.Current == 0x0072);
}

split
{
	if (vars.LevelID.Current == 27)
	{
		vars.FinalLevers.ForceUpdate();
		// print ("Final levers: " + vars.FinalLevers.Current.ToString("X8"));
		return vars.FinalLevers.Changed && vars.FinalLevers.Current == 0x01010101;
	}
	else
	{
		// Password/code screen (LevelID 32) after every level completion including the ending (albeit late).
		return vars.LevelID.Changed && vars.LevelID.Current == 32;
	}
}

reset
{
	return vars.LevelID.Current == 30 && vars.LevelID.Old == 0;
}