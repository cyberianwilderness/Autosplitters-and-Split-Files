/*       
_________________________________________________________________________________________________________
|                                                                                                       |
| LiveSplit Auto Splitter script for Golden Axe (SEGA Mega Drive/Genesis Version).                      |
| Supported Emulators:                                                                                  |
|   - Kega Fusion v3.64                                                                                 |
|                                                                                                       |
| Made by l1ndblum                                                                                      |                                 
|   Note: Finding variables to split with that align with the timing rules were diffucult.              |
|    Therefore, each category will not have the timer start at 0                                        |
|    This is so that your end time should be the same time given by frame counting                      |
|    Beginner: Starts at -1.329                                                                         |
|    Arcade: Starts at -6.268                                                                           |                       |        
|    Duel: Starts at 2.752                                                                              |                      |
|_______________________________________________________________________________________________________|

*/


// Define memory addresses
state("Fusion")
{
    int gameState : 0x174CD4;           // General game state
    int arcadeSplit : 0x1A1460;         // Arcade split logic
    int gameState2 : 0x174C44;          // Additional split logic for Duel mode
    int reset : 0x174BD8;               // Reset condition at Sega screen
    int live : 0x174C24;                // Live game status: 2048 when live, 0 when not
    int extraSplit : 0x174E88;          // Extra split condition for Arcade mode
    int extraIndicator : 0x174B78;      // Extra split indicator for Arcade mode
    int lvl6extraIndicator : 0x174BD8;  // Level 6 indicator for Beginner mode
    int gameOver : 0x398AE8;            // Game Over: 320 when live, 288 when game ends
    int flag : 0x174ECC;                // Flag indicator
    int gameState3: 0x174ea0;           // needed for duel
   
}

startup
{
    // Define the mode selection options in the LiveSplit settings
    settings.Add("ModeSelection.", false, "==Choose one option below or it defaults to Arcade==");
    settings.Add("arcadeMode", true, "Arcade Mode");
    settings.SetToolTip("arcadeMode", "Main version of the game with 8 stages.");

    settings.Add("duelMode", false, "Duel Mode");
    settings.SetToolTip("duelMode", "12 rounds of enemies to clear.");

    settings.Add("beginnerMode", false, "Beginner Mode");
    settings.SetToolTip("beginnerMode", "Contains three stages.");
}

init
{
    vars.DebugMessage = (Action<string>)((message) =>
    {
        print("[Debug] " + message);
    });

    // Default mode
    vars.selectedMode = "Arcade";

    // Check which mode is selected
    if (settings["arcadeMode"])
    {
        vars.selectedMode = "Arcade";
    }
    else if (settings["duelMode"])
    {
        vars.selectedMode = "Duel";
    }
    else if (settings["beginnerMode"])
    {
        vars.selectedMode = "Beginner";
    }

    vars.DebugMessage("Init: Selected Mode - " + vars.selectedMode);

    // Initial variable setup
    vars.timerStarted = false;
    vars.inGame = false;
    vars.finalTimeRecorded = false;
    vars.splitState = 1;
    vars.extraSplitTriggered = false;
    vars.gameState2Triggered = false;
    vars.currentStage = 1;
    vars.selectedMode = "Arcade";
    vars.inBattle = false;
    vars.gameState = 0;
    vars.arcadeSplit = 0;
}

update
{
}

start
{
    if (settings["arcadeMode"])
    {
        vars.selectedMode = "Arcade";
    }
    else if (settings["duelMode"])
    {
        vars.selectedMode = "Duel";
    }
    else if (settings["beginnerMode"])
    {
        vars.selectedMode = "Beginner";
    }
    else
    {
        vars.selectedMode = "Arcade";
    }
    // Start timer based on selected mode
    if (!vars.timerStarted)
    {
        if (vars.selectedMode == "Arcade" && current.arcadeSplit == 40 && current.gameState == 176)
        {
            vars.timerStarted = true;
            vars.DebugMessage("Starting Arcade Mode.");
            return true;
        }
        else if (vars.selectedMode == "Duel" && current.gameState == 112)
        {
            vars.timerStarted = true;
            vars.DebugMessage("Starting Duel Mode.");
            return true;
        }
        else if (vars.selectedMode == "Beginner" && current.arcadeSplit == 40 && current.gameState == 176)
        {
            vars.timerStarted = true;
            vars.DebugMessage("Starting Beginner Mode.");
            return true;
        }
    }
    return false;
}

split
{
    // Only split if the timer has started
    if (vars.timerStarted)
    {
        int currentTime = (int)(DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond);

        // Arcade Mode Logic
        if (vars.selectedMode == "Arcade")
        {
            if (vars.currentStage == 1 && current.gameState == 96 && current.extraIndicator == 280)  // Thief Round 1
            {
                vars.currentStage++;
                return true;
            }
            else if (vars.currentStage == 2 && current.gameState == 80)  // Round 2
            {
                vars.currentStage++;
                return true;
            }
            else if (vars.currentStage == 3 && current.gameState == 96 && current.extraIndicator == 280)  // Thief Round 2
            {
                vars.currentStage++;
                return true;
            }
            else if (vars.currentStage == 4 && current.gameState == 80)  // Round 3
            {
                vars.currentStage++;
                return true;
            }
            else if (vars.currentStage == 5 && current.gameState == 96 && current.extraIndicator == 280)  // Thief Round 3
            {
                vars.currentStage++;
                return true;
            }
            else if (vars.currentStage == 6 && current.gameState == 64)  // Round 4
            {
                vars.currentStage++;
                return true;
            }
            else if (vars.currentStage == 7 && current.gameState == 96 && current.extraIndicator == 280)  // Thief Round 4
            {
                vars.currentStage++;
                return true;
            }
            else if (vars.currentStage == 8 && current.gameState == 112 && current.arcadeSplit == 40 && current.extraIndicator == 240)  // Round 5
            {
                vars.currentStage++;
                return true;
            }
            else if (vars.currentStage == 9 && current.gameState == 184 && current.arcadeSplit == 40 && current.extraIndicator == 168)  // Round 6
            {
                vars.currentStage++;
                return true;
            }
            else if (vars.currentStage == 10 && current.gameState == 264 && current.extraIndicator == 160 && current.arcadeSplit == 40)  // Round 7 260 40 160
            {
                vars.currentStage++;
                return true;
            }
            else if (vars.currentStage == 11 && current.gameState == 80 && current.extraIndicator == 216)  // Round 8
            {
                vars.currentStage++;
                return true;
            }
            else if (vars.currentStage == 12 && current.gameState == 264)  // RunFinish
            {
                vars.DebugMessage("Split: Arcade run finished.");
                return true;
            }
        }

 
        // Duel Mode Logic
        else if (vars.selectedMode == "Duel")
        {
            vars.DebugMessage("Duel Mode Logic");
            if (current.gameState2 == 328 && !vars.inBattle)
            {
                vars.inBattle = true;
                vars.inLoadingScreen = false;
                return false;
            }
            else if (current.gameState2 == 0 && vars.inBattle && !vars.inLoadingScreen)
            {
                vars.inBattle = false;
                vars.inLoadingScreen = true;
                return true;
            }
            else if (current.gameState3 == 64 && !vars.finalTimeRecorded)
            {
                vars.DebugMessage("End of Duel Run.");
                vars.finalTimeRecorded = true;
                return true;
            }
        }

        // Beginner Mode Logic
        else if (vars.selectedMode == "Beginner")
        {
            if (current.lvl6extraIndicator == 144 && current.gameState == 80 && current.flag == 104 && vars.currentStage == 1)
            {
                vars.currentStage++;
                return true;
            }
            else if (current.lvl6extraIndicator == 232 && current.gameState == 80 && current.flag == 232 && vars.currentStage == 2)
            {
                vars.currentStage++;
                return true;
            }
            else if (vars.currentStage == 3 && current.gameOver == 288)
            {
                vars.DebugMessage("Split: Beginner run finished.");
                return true;
            }
        }
    }
    return false;
}

reset
{
    if (current.reset == 1016 && current.live == 0)
    {
        vars.DebugMessage("Game Reset Detected at Sega screen.");
        vars.timerStarted = false;
        vars.inGame = false;
        vars.finalRunTime = 0;
        vars.finalTimeRecorded = false;
        vars.splitState = 1;
        vars.extraSplitTriggered = false;
        vars.gameState2Triggered = false;
        vars.currentStage = 1;
        return true;
    }
    return false;
}