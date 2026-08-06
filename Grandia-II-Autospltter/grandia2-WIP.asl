/*
Grandia II Speedrun LiveSplit Script
Author: Llndblum

ToDo
Work out markers for all splits
Test splits work
Hardcore certain places to ensure the split count is correct
Add in the rest of the splits
Find markers related to party member health
Find out how much hp is at each level so I can see how much exp to next level
Is item count possible, it must be stored somewhere?

The ability to overwrite mareg hp with roan hp for later in the game would be nice - can you dynamically change livesplit labels or do I need to make a variable and display it underneath?

*/

/**
EXP TABLE
LVL         EXP     Point to get to this level from previous
11	        634	    0
12	        798	    164
13	        991	    193
14		    1203	212
15	        1479	276
16		    1794	315
17		    2159	365
18		    2584	425
19		    3064	480
20		    3604	540
21		    4200	596
22		    4864	664
23		    5587	723
24		    6385	798
25		    7254	869
26		    8205	951
27		    9236	1031
28		    10364	1128
29		    11604	1240
30		    12961	1357
31		    14257	1296
32		    16079	1822
33		    17959	1880
34		    19808	1849
35		    21903	2095
36		    24144	2241
37		    26530	2386
38		    29047	2517
39		    31677	2630
40		    34448	2771
**/


state("grandia2")
{
 
    int start : 0x61EE1C;     // Address for start condition
        
    
    int ryudoEXP : 0x61C37C;             // Address for Ryudo EXP
    int elena_milleniaEXP : 0x61C5D0;    // when these are seperate characters this will get interesting
    int roanEXP : 0x61C824;
    int maregEXP : 0x61CA78;
   // int tioEXP =  // don't know this one yet


    int bossHP : 0x61CCD4; // this duplicated the variable underneath, it is purely for ease of referencing later
    int enemy1HP : 0x61CCD4; // this is used bosses
    int enemy2HP : 0x61CF28;
    int enemy3HP : 0x61D17C;
    int enemy4HP : 0x61D3D0;
    int enemy5HP : 0x61D624;
    int enemy6HP : 0x61D878;

//    int specialCoin : 0x2C35C8; - // think it is wrong
    int specialCoin : 0x707262;
    int goldCoin : 0x2C35C4;

    int locationMarker1 : 0x2B59B8; // green on cheat engine 2B59B8
    int locationMarker2 : 0x2C54D8; // pink on cheat engine
    int locationMarker3 : 0x2C53FC;

    int resetTrigger1 :  0x2C7EF0;
    int resetTrigger2 :  0x2C7E10;
    int resetTrigger : 0x2B59B8; // sane as locationMarker1 but this = 65535 when reset and keeping here just for ease of coding
    // create a split name dictionary or data structure for debugging so I can test what split I am in based on split number
    // create a split counter to keep track of what split I am in
    int splitCount : 0;
  
}
startup
{
    // Add settings to provide additional Vars Viewer context
    settings.Add("showDebug", true, "Show Debug Messages");
    settings.SetToolTip("showDebug", "Toggle debug messages in the log.");
}

init
{
//   int splitCount : 0;
    vars.DebugMessage = (Action<string>)((message) =>
    {
        if ((bool)settings["showDebug"])
        {
            print("[Debug] " + message);
        }
    });





    vars.locationName = "Unknown";
    vars.locationName2 = "Unknown";
    vars.locationName3 = "Unknown";
    // Initialize vars for Vars Viewer
    vars.ryudoEXP = 0;

    vars.start = 0;
    vars.timerStarted = false;
    vars.finalTimeRecorded = false;
    vars.bossHP = 0;
    vars.locationMarker1 = 0;
    vars.locationMarker2 = 0;
    vars.locationMarker3 = 0;

    vars.enemy1HP = 0;
    vars.enemy2HP = 0;
    vars.enemy3HP = 0;
    vars.enemy4HP = 0;
    vars.enemy5HP = 0;
    vars.enemy6HP = 0;
    vars.specialCoin = 0;
    vars.splitCount = 0;
    vars.splitCountforLivesplitDebugging = 0;
}

update
{
    // Dynamically update variables

    vars.start = current.start;
    vars.splitCountforLivesplitDebugging = vars.splitCount;
    // Debugging - need to comment in the first part of init to get this to work
    vars.DebugMessage("Ryudo EXP: " + vars.ryudoEXP);
    vars.DebugMessage("Start Condition: " + vars.start);
    vars.DebugMessage("Location Marker 1: " + vars.locationMarker1);
    vars.DebugMessage("Location Name: " + vars.locationName);

    // Party Experience
    vars.ryudoEXP = current.ryudoEXP;
    vars.elena_milleniaEXP = current.elena_milleniaEXP;
    vars.roanEXP = current.roanEXP;
    vars.maregEXP = current.maregEXP;


    // Boss and enemy HP
    vars.bossHP = current.bossHP;
    vars.enemy1HP = current.enemy1HP;
    vars.enemy2HP = current.enemy2HP;
    vars.enemy3HP = current.enemy3HP;
    vars.enemy4HP = current.enemy4HP;
    vars.enemy5HP = current.enemy5HP;
    vars.enemy6HP = current.enemy6HP;
    vars.specialCoin = current.specialCoin;
    vars.goldCoin = current.goldCoin;
    
    // Location markers
    vars.locationMarker1 = current.locationMarker1;
    vars.locationMarker2 = current.locationMarker2;
    vars.locationMarker3 = current.locationMarker3;
    


switch ((int)current.locationMarker1)
{
  
    // Black Forest
    case 9216:
        vars.locationName = "Black ForestLevel 1";
        break;
    case 10752:
        vars.locationName = "Garmia Tower Opening Cutscene";
        break;
    case 10241:
        vars.locationName = "Garmia Tower - Outside";
        break;
    case 10257:
        vars.locationName = "Garmia Tower - 1st Floor";
        break;
    case 10273:
        vars.locationName = "Garmia Tower - 2nd Floor";
        break;
    case 10289:
        vars.locationName = "Garmia Tower - 3rd Floor";
        break;
    case 10481:
        vars.locationName = "Garmia Tower - Top Floor";
        break;

    // Inor Mountains
    case 11264:
        vars.locationName = "Inor Mountains - Level 1";
        break;
    case 11280:
        vars.locationName = "Inor Mountains - Level 2";
        break;

    // Durham Cave
    case 13312:
        vars.locationName = "Durham Cave - Level 1";
        break;
    case 13328:
        vars.locationName = "Durham Cave - Level 2";
        break;
    case 13552:
        vars.locationName = "Durham Cave - Depths";
        break;

    // Baked Plains
    case 14336:
        vars.locationName = "Baked Plains - Level 1";
        break;
    case 14352:
        vars.locationName = "Baked Plains - Level 2";
        break;
    case 14368:
        vars.locationName = "Baked Plains - Level 3";
        break;
    case 57360:
        vars.locationName = "Baked Plains - Cutscene 'Stop It'";
        break;

    // Liligue
    case 15360:
        vars.locationName = "Liligue - Overworld";
        break;
    case 15392:
        vars.locationName = "Liligue - General Store";
        break;
    case 15376:
        vars.locationName = "Liligue - Inn";
        break;
    case 15408:
        vars.locationName = "Liligue - Engineer's House";
        break;
    case 15520:
        vars.locationName = "Liligue - House 1 (H1)";
        break;
    case 15536:
        vars.locationName = "Liligue - House 2 (H2)";
        break;
    case 15552:
        vars.locationName = "Liligue - House 3 (H3)";
        break;
    case 15568:
        vars.locationName = "Liligue - House 4 (H4)";
        break;
    case 15364:
        vars.locationName = "Multiple (Liligue - Skyway Station, Granacliff Cutscene)";
        break;
    case 15488:
        vars.locationName = "Liligue - Church (Downstairs)";
        break;
    case 15492:
        vars.locationName = "Liligue - Church (Upstairs)";
        break;
    case 15424:
        vars.locationName = "Liligue - Gadans House";
        break;

    // Mirumu Village
    case 19456:
        vars.locationName = "Mirumu - Overworld";
        break;
    case 19520:
        vars.locationName = "Mirumu - Chief's House";
        break;
    case 19616:
        vars.locationName = "Mirumu - House 1";
        break;
    case 19632:
        vars.locationName = "Mirumu - House 2";
        break;
    case 19648:
        vars.locationName = "Mirumu - House 3";
        break;
    case 19504:
        vars.locationName = "Mirumu - Town Hall";
        break;
    case 19472:
        vars.locationName = "Mirumu - Inn";
        break;
    case 19480:
        vars.locationName = "Mirumu - Managers Room";
        break;
    case 19476:
        vars.locationName = "Mirumu - Guestroom";
        break;
    case 19488:
        vars.locationName = "Mirumu - General Store";
        break;
    case 19536:
        vars.locationName = "Mirumu - Sandra's House";
        break;
    case 20544:
        vars.locationName = "Mirumu - Ryudo Dream";
        break;

    // Lumir Forest
    case 17408:
        vars.locationName = "Lumir Forest - Crash Site + Millenia/Elena Cutscene";
        break;
    case 17424:
        vars.locationName = "Lumir Forest";
        break;
    case 17440:
        vars.locationName = "Lumir Forest - Cavern 1";
        break;
    case 17456:
        vars.locationName = "Lumir Forest - Cavern 2";
        break;
    case 18432:
        vars.locationName = "Lumir Forest - Garden of Dreams";
        break;

    // Liligue Cave
    case 16384:
        vars.locationName = "Multiple (Liligue Cave - Level 1, Level 2)";
        break;
    case 16432:
        vars.locationName = "Liligue Cave - Level 3";
        break;
    case 16416:
        vars.locationName = "Liligue Cave - Caverns";
        break;
    case 16624:
        vars.locationName = "Liligue Cave - Temple Ruins";
        break;
    case 15888:
        vars.locationName = "Granacliff Cutscene";
        break;

    default:
        vars.locationName = "Unknown Location";
        break;
}

vars.locationMarker2 = current.locationMarker2;


switch ((int)current.locationMarker2) {
    /* commented out as baked plains also uses case 88
    case 88:
        vars.locationName2 = "Witt Forest - Forest Path";
        break;
        */
    case 308:
        vars.locationName2 = "Carbos - General Area";
        break;
    case 17:
        vars.locationName2 = "Carbos - House 1";
        break;
    case 14:
        vars.locationName2 = "Carbos - House 2 | House 4";
        break;
   // case 16:
    //    vars.locationName2 = "Carbos - House 3"; // ommitted due to it clashing with agear town room 2
      //  break;
    case 8208:
        vars.locationName2 = "Carbos - Inn";
        break;
    case 171:
        vars.locationName2 = "Carbos - Church";
        break;
    case 19:
        vars.locationName2 = "Carbos - Store";
        break;
    case 440:
        vars.locationName2 = "Carbos - Millenia Cutscene";
        break;
    case 204:
        vars.locationName2 = "Carbos - Inn Cutscene After Millenia";
        break;
    case 92:
        vars.locationName2 = "Black Forest - Level 1";
        break;
    case 24:
        vars.locationName2 = "Black Forest - Level 2";
        break;
    case 297:
        vars.locationName2 = "Garmia Tower - Outside";
        break;
    case 32:
        vars.locationName2 = "Garmia Tower - 1st Floor";
        break;
    case 11:
        vars.locationName2 = "Garmia Tower - 2nd or 3rd Floor or General Store in Liligue";
        break;
    case 223:
        vars.locationName2 = "Garmia Tower - Top Floor";
        break;
    case 186:
        vars.locationName2 = "Garmia Tower - Cutscene in Purple";
        break;
    case 140:
        vars.locationName2 = "Inor Mountains - Level 1";
        break;
    case 319:
        vars.locationName2 = "Inor Mountains - Level 2";
        break;
    case 240:
        vars.locationName2 = "Agear Town - Overworld";
        break;
    case 289:
        vars.locationName2 = "Agear Town - Inn";
        break;
    case 47:
        vars.locationName2 = "Agear Town - Inn Corridor";
        break;
    case 219:
        vars.locationName2 = "Agear Town - Room 1";
        break;
    case 16:
        vars.locationName2 = "Agear Town - Room 2";
        break;
    case 23:
        vars.locationName2 = "Agear Town - Guard's Tent";
        break;
    case 262:
        vars.locationName2 = "Durham Cave - Level 1";
        break;
    case 314:
        vars.locationName2 = "Durham Cave - Level 2";
        break;
    case 162:
        vars.locationName2 = "Durham Cave - Depths";
        break;
    case 88:
        vars.locationName2 = "Baked Plains - Level 1";
        break;
    case 102:
        vars.locationName2 = "Baked Plains - Level 2";
        break;
    case 304:
        vars.locationName2 = "Baked Plains - Level 3";
        break;
    case 423:
        vars.locationName2 = "Liligue - Overworld";
        break;
    //case 11:
    //    vars.locationName2 = "Liligue - General Store";
    //    break;
    case 119:
        vars.locationName2 = "Liligue - Inn";
        break;
    case 107:
        vars.locationName2 = "Liligue - Engineer's House or Church Upstairs";
        break;
    case 29:
        vars.locationName2 = "Liligue - House 1 (H1)";
        break;
    case 27:
        vars.locationName2 = "Liligue - House 2 (H2)";
        break;
    case 18:
        vars.locationName2 = "Liligue - House 3 (H3) or House 4 (H4)";
        break;
    case 153:
        vars.locationName2 = "Granacliffe Cutscene";
        break;
    case 1430:
        vars.locationName2 = "Lumir Forest";
        break;
    case 175:
        vars.locationName2 = "Lumir Forest - Crash Site + Millenia/Elena Cutscene";
        break;
    case 76:
        vars.locationName2 = "Lumir Forest - Cavern 1";
        break;
    case 137:
        vars.locationName2 = "Lumir Forest - Cavern 2";
        break;
    case 438:
        vars.locationName2 = "Lumir Forest - Garden of Dreams";
        break;
    case 1005:
        vars.locationName2 = "Mirumu - Overworld";
        break;
    case 68:
        vars.locationName2 = "Mirumu - Chiefs House";
        break;
    case 36:
        vars.locationName2 = "Mirumu - House 1";
        break;
    case 37:
        vars.locationName2 = "Mirumu - House 2";
        break;
    case 40:
        vars.locationName2 = "Mirumu - House 3";
        break;
    case 62:
        vars.locationName2 = "Mirumu - Town Hall";
        break;
    case 243:
        vars.locationName2 = "Mirumu - Inn";
        break;
    case 129:
        vars.locationName2 = "Mirumu - Managers Room";
        break;
    case 78:
        vars.locationName2 = "Mirumu - Guest Room";
        break;
    case 33:
        vars.locationName2 = "Mirumu - General Store";
        break;
    case 228:
        vars.locationName2 = "Mirumu - Sandra House";
        break;
    case 142:
        vars.locationName2 = "Mirumu - Ryudo Dream";
        break;
    default:
        vars.locationName2 = "Unknown Location";
        break;
}

switch ((int)current.locationMarker3)
{
    // Mirumu Inn and related locations
    case 16128:
        vars.locationName3 = "Multiple (Mirumu - Inn, Town Hall, Liligue Cave - Level 3, Temple Ruins, Skyway Station, Inor Mountains - Level 1, Agear Town - Inn, Rooms 1 and 2, Guard's Tent)";
        break;
    case 512:
        vars.locationName3 = "Multiple (Mirumu - Managers Room, Granacliff Cutscene - Part 2, Liligue City - Cutscene with Boy)";
        break;
    case 1280:
        vars.locationName3 = "Multiple (Mirumu - Aira Cutscene, Baked Plains - Cutscene)";
        break;
    case 768:
        vars.locationName3 = "Multiple (Mirumu - General Cutscene, Granacliff Cutscene - Voice Acted Part, Agear Town - Roan Cutscene)";
        break;
    case 7936:
        vars.locationName3 = "Multiple (Carbos - Overworld, Chiefs House, Liligue Cave - Caverns, Granacliff Cutscene Part 1, Durham Cave - Depths, Agear Town - Overworld, Inn Corridor, Inor Mountains - Level 2, Liligue City - Engineer's House, Church Downstairs)";
        break;

    // Lumir Forest
    case 256:
        vars.locationName3 = "Multiple (Lumir Forest - Crash Site, Millenia/Elena Cutscene, Garden of Dreams, Inor Mountains - Skye Cutscene, Garmia Tower - 1st Floor)";
        break;
    case 8960:
        vars.locationName3 = "Multiple (Lumir Forest, Cavern 2, Durham Cave - Level 2)";
        break;
    case 33684:
        vars.locationName3 = "Lumir Forest - Cavern 1";
        break;

    // Liligue Cave
    case 8704:
        vars.locationName3 = "Liligue Cave - Level 1";
        break;
    case 9984:
        vars.locationName3 = "Liligue Cave - Level 2";
        break;

    // Liligue City
    case 24064:
        vars.locationName3 = "Liligue City - Overworld";
        break;


    // Baked Plains
    case 8448:
        vars.locationName3 = "Multiple (Baked Plains - Level 1, Black Forest - Level 2)";
        break;
    case 2048:
        vars.locationName3 = "Baked Plains - Level 3";
        break;

    // Durham Cave
    case 7680:
        vars.locationName3 = "Durham Cave - Level 1";
        break;

    // Garmia Tower
    case 15360:
        vars.locationName3 = "Garmia Tower - Outside";
        break;

    // Black Forest
    case 17936:
        vars.locationName3 = "Black Forest - Level 1";
        break;

    // Carbos
    case 329216:
        vars.locationName3 = "Carbos - Door Open with Text";
        break;
    case 1536:
        vars.locationName3 = "Carbos - Door Closed";
        break;

    default:
        vars.locationName3 = "Unknown Location";
        break;
}

}
start
{
    // Start the timer if the start condition is met
    if (current.locationMarker1 == 53248 && current.locationMarker2 == 433)
    { 
        // vars.DebugMessage("Timer started.");
        vars.splitCount = 0;
        return true;
    }
    return false;
}

split
{
    // debug message

    // Initialies variables required for splitting
   
  //  vars.locationMarker1 = current.locationMarker1;
  //  vars.locationMarker2 = current.locationMarker2;
  //  vars.locationMarker3 = current.locationMarker3;

 //   vars.enemy1HP = current.enemy1HP;
 //   vars.enemy2HP = current.enemy2HP;
  //  vars.enemy3HP = current.enemy3HP;
 //   vars.enemy4HP = current.enemy4HP;
 //   vars.enemy5HP = current.enemy5HP;
 //   vars.enemy6HP = current.enemy6HP;

    // I want hard coded places to ensure we are in the correct place
    // i.e if locationmarker 1 == x, locationmarker2= x, locationmarker3 = x then I am in this split for sure and split count = x
    switch ((int)vars.splitCount)
    {
        case 0:
        if (vars.locationMarker2 == 88)
        {
            vars.DebugMessage("Split 1 - Opening Cutscene completed");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 1:
        if (vars.locationMarker2 == 308)
        {
            vars.DebugMessage("Split 2 - Forest Path completed");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 2:
        if (vars.locationMarker1 == 9216 && vars.locationMarker2 == 92 && vars.locationMarker3 == 7936)
        {   
            vars.DebugMessage("Split 3 - Carbo village completed, enterring Black Forest");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 3:
        if (vars.locationMarker1 == 10257 && vars.locationMarker2 == 32 && vars.locationMarker3 == 256)
        {   
            vars.DebugMessage("Split 4 - Black Forest completed, enterring Garmia Tower");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 4:
        if (vars.enemy1HP == 380 && vars.enemy2HP == 380) // get location marker for this too
        {   
            vars.DebugMessage("Split 5 - Garmia Tower completed, enterring Gargoyles Fight");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 5:
        if (vars.enemy1HP == 0 && vars.enemy2HP == 0) // get location marker for this too
        {   
            vars.DebugMessage("Split 6 - Gargoyles Fight completed, enterring Carius");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 6:
        if (vars.locationMarker1 == 8240 && vars.locationMarker2 == 171)
        {   
            vars.DebugMessage("Split 7 - Carius completed, enterring Millenia I");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 7:
        if (vars.locationMarker2 == 204)
        {   
            vars.DebugMessage("Split 7 - Millenia defeated");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        // next split happens when inor mountains 1 is entered
        /**
    int locationMarker1 : 0x2B59B8; // green on cheat engine 2B59B8
    int locationMarker2 : 0x2C54D8; // pink on cheat engine
    int locationMarker3 : 0x2C53FC;
        **/
        case 8:
        if (vars.locationMarker1 == 11264 && vars.locationMarker2 == 140 && vars.locationMarker3 == 16128)
        {   
            vars.DebugMessage("Split 8 - Exit Carbos completed, enterring Inor Mountains");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 9: 
        if (vars.locationMarker1 == 11280 && vars.locationMarker2 == 319 && vars.locationMarker3 == 7936)
        {   
            vars.DebugMessage("Split 9 - Inor Mountains completed, enterring Agear Town");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        default:
        {
            return false;
            break;
        }

    }

    /* as of 18/01/25
    
 Split Name                     Split End COndition   
-Opening Cutscene               Ends when location marker2 == 88 
{Witt Forest}Forest Path        End when locationmarkers are in carbo
-Carbo Village                  End when location markers are in blackforest 1
-Black Forest 1                 End when garmia tower is enterred
-Garmia Tower                   When gargoyle health is spawned, split
-Gargoyles                      When gargoyle health == 0, split
-Carius,                        When game is back in carbos church (might need to be the church) Millenia Cutscene 8193 59b8 locationMarker2 == 204
-Millenia I                     Ends when in the inn after the fight (location Marker 2 == 204 & 
{Carius Contract}               Enter Igor Mountains 1
-Inor Mountains                 Enter Agear Town
-Agear Town                     Enter Durham Cave
-Durham Cave                    Minotaur Health spawns 4200
-Minotaur 4200                  Minotaur Health == 0
{Agear} Exit Agear              Enter Baked Plains 1
-Baked Plains 1                 Enter Baked Plains 1
-Baked Plains 2                 Enter baked plains 3
-Cutscene & Camping             Ends when maregs health spawns
-Beast-Man 4800                 Ends when mareg health == 0
{Baked Plains}Baked Plains 3    End when enter lilligue
-Gadan                          Ends when gadans house is enterred and then split occurs when party leaves
-Church                         Ends when Church is enterred and then split occurs when party leaves
-Lilligue Cave                  Ends when caverns are enterred
-Lilligue Caverns               Ends when temple ruins first enterred
-Temple Ruins                   Ends when valmar tongue healht is spawned
-Tongue of Valmar (8000)        Ends when tongue killed
{Liligue} Skyway                Ends when lumir forest is reached
-Lumir Forest                   Ends when garden of dreams reached
-Garden of Dreams               Ends when mirumu first reached
-Mirumu Village #1              Ends when you enter mysterious fissure
-Mysterious Fissure             Ends when eyeball bat health spawns
-Eyeball Bat 3000               Ends when fight over
-Mirumu Village #2              Ends when enterring Aira's space
-Aira's Space                   Ends when Eye of Valmar HP (12000) spawns
-Eye of Valmar (12000)          Ends when Eye of Valmar HP (12000) = 0
{Mirumu} Leave Mirumu           Ends when enterring St. Heim Mountains
-St. Heim Mountains             Ends when entering St. Heim Papal State
-Papal St. Heim #1              Ends when exiting cutscene with Zera
{Papal St. Heim}Shopping & Exit Ends when entering Pilgrim Road
-Pilgrim Road                   Ends when entering Raul Hills 1
-Raul Hills 1                   Ends when entering Raul Hills 2
-Raul Hills 2                   Ends when entering Raul Hills 3
{Journey to Cyrum}Raul Hills 3  Ends when Cyrum is enterred
-Shopping & Armwrestling        Ends when enterring secret passage
-Secret Passage                 Ends when entering Cyrum Castle
-Cyrum Castle                   Ends when enterring underground plant 1
-Underground Plant 1            Ends when entering underground plant 2
-Underground Plant 2            Ends when entering underground plant 3
-Underground Plant 3            Ends when claw of valmar health spawns
-Claw of Valmar                 Ends when claw of valmar health == 0
-Melfice                        Ends when the location melfice is fought in changes back to the next palce
{Cyrum #1} Bakala               Ends when the trigger for 5050 cutscene starts
-50/50 Cutscene
-Ceceile Reef
-Crimson Tail
-Garlan Village
-Grail Mountain Road 1
-Grail Mountain Road 2
-Grail Mountain Shrine
-Plateau of Memories
-Melfice
-{Garlan} Bakala
-50/50 Cutscene
-Ghoss Forest West
-Nanan Village
-Ghoss Forest West
-Ghoss Forest East
-The Great Rift 1
-The Great Rift 2
-The Great Rift 3
-Leck Guarder (17,000 HP)
-Naga Queens (15,000 HP each)
-Tio Clone (25,000 HP)
{Demon's Law}
-Valmar's Body
-Valmar's Core
{Valmar's Body} Cutscene
-Granasaber
-Granas Knight
-Shopping & Cathedral
-Valmar Heart
{St. Heim Papal State #2} Zera Cutscene
-Valmar's Moon 1
-Valmar's Moon 2
-Valmar's Moon 3
-Valmar's Womb
-Egg Guardian
{Valmar Moon} Farewell, Mareg
-Cyrum Kingdom
*/

}

func currentLevel(int currentExp)
{
 
 array<int> ExpThresholds =
{
    0,       // Level 10
    634,     // Level 11
    798,     // Level 12
    991,     // Level 13
    1203,    // Level 14
    1479,    // Level 15
    1794,    // Level 16
    2159,    // Level 17
    2584,    // Level 18
    3064,    // Level 19
    3604,    // Level 20
    4200,    // Level 21
    4864,    // Level 22
    5587,    // Level 23
    6385,    // Level 24
    7254,    // Level 25
    8205,    // Level 26
    9236,    // Level 27
    10364,   // Level 28
    11604,   // Level 29
    12961,   // Level 30
    14257,   // Level 31
    16079,   // Level 32
    17959,   // Level 33
    19808,   // Level 34
    21903,   // Level 35
    24144,   // Level 36
    26530,   // Level 37
    29047,   // Level 38
    31677,   // Level 39
    34448    // Level 40
};
array<int> ExpThresholds = [0, 634, 798, 991, 1203, 1479, 1794, 2159, 2584, 3064, 3604, 4200, 4864, 5587, 6385, 7254, 8205, 9236, 10364, 11604, 12961, 14257, 16079, 17959, 19808, 21903, 24144, 26530, 29047, 31677, 34448];


    // If we’re already level 40, no XP needed
    if (currentLevel >= 40)
        return 0;

    // The array index for the current level
    int levelIndex = currentLevel - 10;

    // The XP threshold for the *next* level is at ExpThresholds[levelIndex + 1]
    int nextThreshold = ExpThresholds[levelIndex + 1];
    return nextThreshold - currentExp;
}

    // activate this function for each character when the gold amount changes, as this only changes after a battle
    // check current experience total

    // I want to do this section neatly by splitting it into 3 sections
    // 10-20, 21-30, 31-40
    // I will need to do a check to see if the exp is in the range of the level
    bool underLevel20 = false;
    bool underLevel30 = false;
    bool underLevel40 = false;
    bool aboveLevel40 = false;
    if (exp < 3604) {   
        underLevel20 = true;
    }
    else if (exp < 12961) {
        underLevel30 = true;
    }
    else if (exp < 34448) {
        underLevel40 = true;
    }
    else {  
        aboveLevel40 = true;
    }
    // Now work out the level based on the exp
    if (underLevel20 == true)
    switch(exp)
    {
    case 634:
        return 11;
    case 798:
        return 12;
    case 991:
        return 13;
    case 1203:
        return 14;
    case 1479:
        return 15;
    case 1794:
        return 16;
    case 2159:
        return 17;
    case 2584:
        return 18;
    case 3064:
        return 19;
    default: 
        return 10;

    }
    else if (underLevel30 == true)
    switch(exp)
    {
    case 3604:
        return 20;
    case 4200:
        return 21;  
    case 4864:
        return 22;
    case 5587:
        return 23;
    case 6385:
        return 24;
    case 7254:
        return 25;
    case 8205:  
        return 26;
    case 9236:  
        return 27;
    case 10364: 
        return 28;
    case 11604: 
        return 29;
    default:    
        return 20;
    }
    else if (underLevel40 == true)
    switch(exp)
    {
    case 12961:
        return 30;
    case 14257:
        return 31;
    case 16079:
        return 32;
    case 17959:
        return 33;
    case 19808:
        return 34;
    case 21903: 
        return 35;
    case 24144: 
        return 36;
    case 26530:
        return 37;
    case 29047:
        return 38;
    case 31677: 
        return 39;
    default:
        return 30;
    }
    else if (aboveLevel40 == true)
    {
        return 40;
    }
    else
    {
        return 0;
    }

// An array of experience thresholds corresponding to levels 10 through 40.
//
// Index 0 -> start of level 10 (we’ll treat that as 0 XP to keep things straightforward).
// Index 1 -> start of level 11, and so on...
array<int> ExpThresholds =
{
    0,       // Level 10
    634,     // Level 11
    798,     // Level 12
    991,     // Level 13
    1203,    // Level 14
    1479,    // Level 15
    1794,    // Level 16
    2159,    // Level 17
    2584,    // Level 18
    3064,    // Level 19
    3604,    // Level 20
    4200,    // Level 21
    4864,    // Level 22
    5587,    // Level 23
    6385,    // Level 24
    7254,    // Level 25
    8205,    // Level 26
    9236,    // Level 27
    10364,   // Level 28
    11604,   // Level 29
    12961,   // Level 30
    14257,   // Level 31
    16079,   // Level 32
    17959,   // Level 33
    19808,   // Level 34
    21903,   // Level 35
    24144,   // Level 36
    26530,   // Level 37
    29047,   // Level 38
    31677,   // Level 39
    34448    // Level 40
};

/// <summary>
/// Returns the current level (10..40) based on the player's total XP.
/// </summary>
int GetLevel(int currentExp)
{
    // We'll assume the lowest possible level is 10 (index 0).
    int levelIndex = 0;

    // Traverse thresholds from highest to lowest
    for (int i = int(ExpThresholds.length()) - 1; i >= 0; i--)
    {
        if (currentExp >= ExpThresholds[i])
        {
            levelIndex = i;
            break;
        }
    }

    // The actual level is arrayIndex + 10
    int level = levelIndex + 10;

    // If the XP is beyond or at the last threshold, we clamp to level 40
    if (level > 40)
        level = 40;

    return level;
}

/// <summary>
/// Returns how much XP is needed for the next level.
/// If already level 40 or beyond the threshold for 40, returns 0.
/// </summary>
int GetExpNeededForNext(int currentExp)
{
    int currentLevel = GetLevel(currentExp);

    // If we’re already level 40, no XP needed
    if (currentLevel >= 40)
        return 0;

    // The array index for the current level
    int levelIndex = currentLevel - 10;

    // The XP threshold for the *next* level is at ExpThresholds[levelIndex + 1]
    int nextThreshold = ExpThresholds[levelIndex + 1];
    return nextThreshold - currentExp;
}

//--------------------------------------------------
// EXAMPLE USAGE:

void main()
{
    int someCurrentXP = 8000;

    int level    = GetLevel(someCurrentXP);
    int xpToNext = GetExpNeededForNext(someCurrentXP);

    // Print or log the result (depends on your environment)
    // E.g.:
    // print("Level = " + level + ", XP to next = " + xpToNext);
}




11  	    634	
12	        798	    
13	        991	    
14		    1203	
15	        1479	
16		    1794	
17		    2159	
18		    2584	
19		    3064	
20		    3604	
21		    4200	
22		    4864	
23		    5587	
24		    6385	
25		    7254	
26		    8205	
27		    9236	
28		    10364	
29		    11604	
30		    12961	
31		    14257	
32		    16079	
33		    17959	
34		    19808	
35		    21903	
36		    24144	
37		    26530	
38		    29047	
39		    31677	
40		    34448	
}
func pointsToNextLevel()
{
    func currentLevel(int exp);
    int currentLevel = currentLevel(exp);
   
11	        634	    0
12	        798	    164
13	        991	    193
14		    1203	212
15	        1479	276
16		    1794	315
17		    2159	365
18		    2584	425
19		    3064	480
20		    3604	540
21		    4200	596
22		    4864	664
23		    5587	723
24		    6385	798
25		    7254	869
26		    8205	951
27		    9236	1031
28		    10364	1128
29		    11604	1240
30		    12961	1357
31		    14257	1296
32		    16079	1822
33		    17959	1880
34		    19808	1849
35		    21903	2095
36		    24144	2241
37		    26530	2386
38		    29047	2517
39		    31677	2630
40		    34448	2771
}
reset
{

    // Placeholder for reset logic
    // there is a variable that  = 65535 and lots of variables go to 0, worth getting many so that accidental resets don't occur
    if (current.resetTrigger1 == 65535 && current.resetTrigger2 == 0 && current.resetTrigger == 0)
    {
        vars.DebugMessage("Timer reset.");
        // reset variables
        vars.splitCount = 0;
        vars.splitCountforLivesplitDebugging = 0;
        
        return true;
    }
    return false;
}