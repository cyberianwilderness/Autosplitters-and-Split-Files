state("FF4A")
{
    byte gameStart        : 0x1EB111; // FF4A.exe+1EB111
    int  gold             : 0x23FFD0;
    short gil: 0x23FFD0;

    byte locationMarker   : 0x1F378D;

    /*
        locationMarker notes:
        0   = Battle
        4   = Mythril, first time
        200 = First Main Map?
        13  = Adamant Isle Entry
        9   = Adamant Isle B1
        6   = Adamant Isle B2
        90  = Adamant Isle B3
        10 = Adamant Isle B3, second time
        111 = Adamant Isle B4
        204 = After first boss fight
        188 = Mysidia Overworld
        7   = Mysidia
    */
    int test: 0x1F47B0;
    int interestingInBattle: 0x2797B4;
    int interestingInBattle2: 0x279838;
    int ceodoreHP         : 0x23D434;
    int ceodoreMP         : 0x23D43C;
    int ceodoreEXP        : 0x23D428;
    int ceodoreLevel      : 0x23D42C;

    int rosaHP            : 0x23C854;

    int hoodedManHP       : 0x23C724;
    int hoodedManMP       : 0x23C72C;

    int whiteMageCurrentHP: 0x23ED20;
    int whiteMageHP       : 0x23ED24;
    int whiteMageMP       : 0x23ED2C;

    int blackMageCurrentHP: 0x23EBF0;
    int blackMageHP       : 0x23EBF4;
    int blackMageMP       : 0x23EBFC;

    int locationVariable1 : 0x213CF0;
    int locationVariable2 : 0x233D5C;
    int locationVariable3 : 0x233D28;
    int locationVariable4 : 0x233D00;
    /*
            0   = Battle
          2911 = Mythril, first time
         = First Main Map?
          = Adamant Isle Entry
          362 = Adamant Isle B1 [3695 after a battle]
           2228  = Adamant Isle B2 Save Room
          388  = Adamant Isle B2
          = Adamant Isle B3
        352 = Adamant Isle B3, second time
        442 - Adaman Isle Save Point
        5528 = Adamant Isle B4
         = After first boss fight
         = Mysidia Overworld
           = Mysidia
        */
        int locationVariable5: 0x2135C0;
        int locationVariable6: 0x213C30;
        int locationVariable7: 0x213C30;
        int locationVariable8: 0x275984;
        int locationVariable9: 0x27598C;
        int locationVariable10: 0x2757EC;

        byte mainMenuOpen128: 0x21E6DC;
        byte mainMenuOpen144: 0x21E67C;
        byte mainMenuOpen200: 0x21E62C; 
}

startup
{
    //settings.Add("FullGame", true, "Play Full Game (Start to Finish)");
    //settings.Add("IL", false, "Play Individual Level");

   // settings.Add("Level1", false, "Level 1");
   // settings.Add("Level2", false, "Level 2");
   // settings.Add("Level3", false, "Level 3");
   // settings.Add("Level4", false, "Level 4");
   // settings.Add("Level5", false, "Level 5");
   // settings.Add("Level6", false, "Level 6");

    // settings.Add("showDebug", false, "Show Debug Output");
}

init
{
    
}

update
{
    
}

start
{
    return current.gameStart == 1;  
}

split
{

}

reset
{

}
