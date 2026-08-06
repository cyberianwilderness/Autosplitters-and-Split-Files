/*       
_________________________________________________________________________________________________________
|                                                                                                       |
| LiveSplit Auto Splitter script for FlashBack                                                          |
| Supported Emulators:                                                                                  |
|   - Kega Fusion v3.64                                                                                 |
|                                                                                                       |
| Made by l1ndblum                                                                                      |
|   <https://github.com/l1ndblum/Flashback-Autosplitter>                                                |
|    For Testing / Debugging purposes only (Easy Difficulty Only):                                      |
|                                                                                                       |
|    Level 1: Easy - PIXEL   || Level 2: Easy - BETSY    || Level 3: Easy - PANCHO                      |
|    Level 4: Easy - STUDIO  || Level 5: Easy - TOHO     || Level 6: Easy - AKANE                       |
|    Level 7: Easy - INCBIN  || Ending: Easy - CYGNUS                                                   |
|                                                                                                       |
|_______________________________________________________________________________________________________|

*/

state("Fusion")
{
    // These were the first 5 variables used for splitting, kept for additional markers in certain levels
    byte a : 0x174BC8; // 24 on main menu, Level 1 = 144, isLoading()
    //  Level 1 = 144 || Level 2 = 144 || Level 3 = 24 || Level 4 = 144 || Level 5 = 16 || Level 6 = 144 || Level 7 = 144

    byte b : 0x174B08; // 244 when reset, 240, main menu
    // Level 1 = 240 || Level 2 = 240 || Level 3 = 244 || Level 4 = 248 || Level 5 = 244 || Level 6 = 240 || Level 7 = 240

    byte c : 0x174B51; // reset = 255, 1 on opening cutscene
    // Level 1 = 0 || Level 2 = 1 || Level 3 = 1 || Level 4 = 0 || Level 5 = 0 || Level 6 = 0 || Level 7 = 0

    byte d : 0x174C10; // 236 = level 1
    // Level 1 = 236 || Level 2 = 236 || Level 3 = 244 || Level 4 = 236 || Level 5 = 236 || Level 6 = 236 || Level 7 = 236
   
    byte e : 0x1A1BF8;
    // Level 1:  0 || Level 2: 14 || Level 3: 10 || Level 4: 130 || Level 5: 10 || Level 6: 128 || Level 7: 128 ||
    
    // Variable consistently found to be 6 while in-game, different value while loading screens
    byte isLoadingVariable : 0x1B6E89;
    // In-Game = 6 || While Loading != 6

    // These variables were used when searching for consistent varaiables that change between levels
    byte  levelVar1 : 0x269401;
    // Level 1 = 0 || Level 2 = 6 || Level 3 = 2 || Level 4 = 136 || Level 5 = 0 || Level 6 = 4 || Level 7 = 10

    byte  levelVar2 : 0x2693F9;
    // Level 1 = 0 || Level 2 = 15 || Level 3 = 2 || Level 4 = 136 || Level 5 = 0 || Level 6 = 2 || Level 7 = 23

    byte  levelVar3 : 0x2693FB;
    // Level 1 = 0 || Level 2 = 6 || Level 3 = 2 || Level 4 = 136 || Level 5 = 0 || Level 6 = 3 || Level 7 = 23

    byte  levelVar4 : 0x2693FC;
    // Level 1 = 0 || Level 2 = 6 || Level 3 = 2 || Level 4 = 136 || Level 5 = 0 || Level 6 = 4 || Level 7 = 25

    short levelVar5 : 0x2693F8;
    // Level 1 = 3840 || Level 2 = 1542 || Level 3 = 514 || Level 4 = 34952 || Level 5 = 0 || Level 6 = 513 || Level 7 = 5913

    short levelVar6 : 0x2693FA;
    // Level 1 = 15 || Level 2 = 1542 || Level 3 = 514 || Level 4 = 34952 || Level 5 = 0 || Level 6 = 771 || Level 7 = 6168
}

startup
{
    // First split is when Level 2 starts
    vars.nextLevel = 2;   
}

init
{
    // To see values in ASLVarViewer
    vars.a = current.a;
    vars.b = current.b;
    vars.c = current.c;
    vars.d = current.d;
    vars.e = current.e;
    vars.isLoadingVariable = current.isLoadingVariable;
    vars.levelVar1 = current.levelVar1;
    vars.levelVar2 = current.levelVar2;
    vars.levelVar3 = current.levelVar3;
    vars.levelVar4 = current.levelVar4;
    vars.levelVar5 = current.levelVar5;
    vars.levelVar6 = current.levelVar6;
}

update
{
    vars.a = current.a;
    vars.b = current.b;
    vars.c = current.c;
    vars.d = current.d;
    vars.e = current.e;
    vars.isLoadingVariable = current.isLoadingVariable;
    vars.levelVar1 = current.levelVar1;
    vars.levelVar2 = current.levelVar2;
    vars.levelVar3 = current.levelVar3;
    vars.levelVar4 = current.levelVar4;
    vars.levelVar5 = current.levelVar5;
    vars.levelVar6 = current.levelVar6;
}

start
{
    // Opening cutscene → start run as per speedrun.com rules
    if (current.c == 1)
    {
        vars.nextLevel = 2; // prepare first split
        return true;
    }
}

split
{
    // Only split while the timer is running
    if (timer.CurrentPhase != TimerPhase.Running)
        return false;
    // No Split required for enterring Level 1 as start handles it

    // --- Entering Level 2 ---
    if (vars.nextLevel == 2         &&
        current.levelVar1 == 6      &&
        current.levelVar2 == 6      &&
        current.levelVar3 == 6      &&
        current.levelVar4 == 6      &&
        current.levelVar5 == 1542   &&
        current.levelVar6 == 1542)
    {
        vars.nextLevel = 3;
        return true;
    }

    // --- Entering Level 3 ---
    if (vars.nextLevel == 3      &&
        current.levelVar1 == 2   &&
        current.levelVar2 == 2   &&
        current.levelVar3 == 2   &&
        current.levelVar4 == 2   &&
        current.levelVar5 == 514 &&
        current.levelVar6 == 514)
    {
        vars.nextLevel = 4;
        return true;
    }

    // --- Entering Level 4 ---
    if (vars.nextLevel == 4         &&
        current.levelVar1 == 136    &&
        current.levelVar2 == 136    &&
        current.levelVar3 == 136    &&
        current.levelVar4 == 136    &&
        current.e == 130            &&
        current.d == 236)
    {
        vars.nextLevel = 5;
        return true;
    }

    // --- Entering Level 5 ---
    if (vars.nextLevel == 5     &&
        current.levelVar1 == 0  &&
        current.levelVar2 == 0  &&
        current.levelVar3 == 0  &&
        current.levelVar4 == 0  &&
        current.levelVar5 == 0  &&
        current.levelVar6 == 0  &&
        current.e        == 10  && 
        current.b        == 240)  // e==10 to avoid ending screen false positive
    {
        vars.nextLevel = 6;
        return true;
    }

    // --- Entering Level 6 ---
    if (vars.nextLevel == 6 &&
        current.levelVar1 == 4   &&
        current.levelVar2 == 2   &&
        current.levelVar3 == 3   &&
        current.levelVar4 == 4   &&
        current.levelVar5 == 513 &&
        current.levelVar6 == 771)
    {
        vars.nextLevel = 7;
        return true;
    }

    // --- Entering Level 7 ---
    if (vars.nextLevel == 7 &&
        current.levelVar1 == 10    &&
        current.levelVar2 == 23    &&
        current.levelVar3 == 24    &&
        current.levelVar4 == 25    &&
        current.levelVar5 == 5913  &&
        current.levelVar6 == 6168)
    {
        // There is not technically a level 8, it's just easier to think of level 8 as the ending for the purpose of this splitter.
        vars.nextLevel = 8;
        return true;
    }
    // --- Ending reached ---
    if (vars.nextLevel  == 8    &&
        vars.a          == 88   &&
        vars.b          == 240  &&
        vars.c          == 0    &&
        current.isLoadingVariable == 0
    )
    { 
        return true;
    }

    return false;
}

reset
{ 
    if (current.a == 24  &&
        current.b == 240 &&
        current.c == 0   &&
        current.isLoadingVariable == 253)
    {
        vars.nextLevel = 2; // Reset to Level 2
        return true;
    }
}

isLoading
{
    if (current.isLoadingVariable != 6) {
            return true;
        }

    return false;
}
