/*
Grandia II Speedrun LiveSplit Script
Author: Llndblum

TODO
- [ ] Put safeguards that if a current location is met then the split number is set to x
- [ ] Do the same with Boss HP (Might be much easier)
- [ ] Offer a version of the splits for Boss Fights Only

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
41
42
43
44
45
46
47
48
49
50
**/


/*
Embed this, should make life alot cleaner

state("Grandia2.exe") // <- whatever your EXE is called
{
    int enemy1HP : 0x12345678;   // replace with real addresses
    int enemy2HP : 0x1234567C;
    int enemy3HP : 0x12345680;
}

// ───────────────────────────────────
//  Variables that persist at runtime
// ───────────────────────────────────
init
{
    vars.splitCount  = 0;
    vars.bossActive  = false;

    // Table of all bosses
    vars.bosses = new [] {
        new Boss("Gargoyles",          380,   380, null,      0,    0,  null),
        new Boss("Minotaur",          4200,  null, null,      0, null,  null),
        new Boss("Beast-Man",         4800,  null, null,      0, null,  null),
        new Boss("Tongue of Valmar",  8000,  null, null,      0, null,  null),
        // … keep going …
        new Boss("Zera Valmar",      36000,  null, null,      0, null,  null),
    };
}

// ───────────────────────────────────
//  Plain-old C# “struct” for a boss
// ───────────────────────────────────
public class Boss
{
    public string Name;
    public int? Spawn1, Spawn2, Spawn3;
    public int? Dead1,  Dead2,  Dead3;

    public Boss(string name,
                int? s1, int? s2, int? s3,
                int? d1, int? d2, int? d3)
    {
        Name   = name;
        Spawn1 = s1; Spawn2 = s2; Spawn3 = s3;
        Dead1  = d1; Dead2  = d2; Dead3  = d3;
    }
}

// ───────────────────────────────────
//  Helper – matches nullable HP values
// ───────────────────────────────────
bool HPMatches(int? want1, int? want2, int? want3,
               int  cur1,  int  cur2,  int  cur3)
{
    return (!want1.HasValue || cur1 == want1) &&
           (!want2.HasValue || cur2 == want2) &&
           (!want3.HasValue || cur3 == want3);
}

// ───────────────────────────────────
//  The single-split routine
// ───────────────────────────────────
split
{
    if (vars.splitCount >= vars.bosses.Length)
        return false;                              // all done

    var b  = vars.bosses[vars.splitCount];
    int e1 = current.enemy1HP;
    int e2 = current.enemy2HP;
    int e3 = current.enemy3HP;

    if (!vars.bossActive)                          // not armed yet
    {
        if (HPMatches(b.Spawn1, b.Spawn2, b.Spawn3, e1, e2, e3))
        {
            vars.bossActive = true;
            print($"Armed: {b.Name} fight started");
        }
    }
    else                                           // armed – wait for kill
    {
        if (HPMatches(b.Dead1, b.Dead2, b.Dead3, e1, e2, e3))
        {
            vars.bossActive = false;
            vars.splitCount++;
            print($"Split {vars.splitCount} – {b.Name} fight completed");
            return true;                           // ***one split per boss***
        }
    }
    return false;
}

// ───────────────────────────────────
//  Optional quality-of-life handlers
// ───────────────────────────────────
reset
{
    vars.splitCount = 0;
    vars.bossActive = false;
}

*/

state("grandia2")
{

    /**  ___________________________________________________
        | ASL Var Variables that may be useful in the run   |
        |___________________________________________________|       **/

    int start : 0x61EE1C;     // Address for start condition
    
    /**
    Party Member Experience
    **/
    int RyudoEXP : 0x61C37C;        // Address for Ryudo EXP [Party Member 1]
    int PartyMember2EXP : 0x61C5D0; // Millenia or Elena mainly, Tio at one pointwhen these are seperate characters this will get interesting [Party Member 2 Millenia or Elena]
    int PartyMember3EXP : 0x61C824; // Roan, Mareg or Tio depending on progress
    int PartyMember4EXP : 0x61CA78; // Mareg or Tio depending on progress
   
    uint SpecialCoin: "grandia2.exe", 0x2C48E4, 0x8;
    uint MagicCoin: "grandia2.exe", 0x2C48E4, 0xC;


    int bossHP : 0x61CCD4; // this duplicated the variable underneath, it is purely for ease of referencing later
    int enemy1HP : 0x61CCD4; // this is used bosses
    int enemy2HP : 0x61CF28;
    int enemy3HP : 0x61D17C;
    int enemy4HP : 0x61D3D0;
    int enemy5HP : 0x61D624;
    int enemy6HP : 0x61D878;

    int goldCoin : 0x2C35C4;
    int magicCoin : 0x2C35CC; // not sure if this is correct, need to check it

    int locationMarker1 : 0x2B59B8; // green on cheat engine 2B59B8
    int locationMarker2 : 0x2C54D8; // pink on cheat engine
    int locationMarker3 : 0x2C53FC;

    int resetTrigger1 :  0x2C7EF0;
    int resetTrigger2 :  0x2C7E10;
    int resetTrigger : 0x2B59B8; 
    int splitCount : 0;
}
startup
{
    // Add settings to provide additional Vars Viewer context
    settings.Add("showDebug", true, "Show Debug Messages");
    settings.SetToolTip("showDebug", "Toggle debug messages in the log.");
    // GIVE OPTION FOR USERS TO SPLIT BY BOSS FIGHTS OR MORE FULL SPLITS
    settings.Add("splitByBoss", false, "Split by Boss Fights");
    settings.SetToolTip("splitByBoss", "If enabled, splits will be made at boss fights only. If disabled, splits will be made at key locations & Boss Fights.");
}
init
{
    vars.DebugMessage = (Action<string>)((message) =>
    {
        if ((bool)settings["showDebug"])
        {
            print("[Debug] " + message);
        }
    });

    vars.PartyMember1Name = "Ryudo";
    vars.PartyMember2Name = "N/A";
    vars.PartyMember3Name = "N/A";
    vars.PartyMember4Name = "N/A";

    vars.RyudoLevel = 0;
    vars.Party2Level = 0;
    vars.Party3Level = 0;
    vars.Party4Level = 0;

    vars.locationName = "Unknown";
    vars.locationName2 = "Unknown";
    vars.locationName3 = "Unknown";
 

    vars.RyudoEXP = 0; 
    vars.PartyMember2EXP = 0; 
    vars.PartyMember3EXP = 0; 
    vars.PartyMember4EXP = 0; 
    vars.RyudoEXPToNextLevel = 0;
    vars.PartyMember2EXPToNextLevel = 0;
    vars.PartyMember3EXPToNextLevel = 0;
    vars.PartyMember4EXPToNextLevel = 0;

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
    vars.SpecialCoin = current.SpecialCoin; // Not yet working as offset is weird
    vars.MagicCoin = current.MagicCoin;
    
    vars.start = current.start;
    vars.splitCountforLivesplitDebugging = vars.splitCount;
  
    // Party Experience
    vars.RyudoEXP = current.RyudoEXP;
    vars.PartyMember2EXP = current.PartyMember2EXP;
    vars.PartyMember3EXP = current.PartyMember3EXP;
    vars.PartyMember4EXP = current.PartyMember4EXP;

    vars.PartyMember1Name = "Ryudo";
    vars.PartyMember2Name = "N/A";
    vars.PartyMember3Name = "N/A";
    vars.PartyMember4Name = "N/A";
    // Boss and enemy HP
    vars.bossHP = current.bossHP;
    vars.enemy1HP = current.enemy1HP;
    vars.enemy2HP = current.enemy2HP;
    vars.enemy3HP = current.enemy3HP;
    vars.enemy4HP = current.enemy4HP;
    vars.enemy5HP = current.enemy5HP;
    vars.enemy6HP = current.enemy6HP;
    // vars.specialCoin = current.specialCoin;
    vars.goldCoin = current.goldCoin;
    
    // Location markers
    vars.locationMarker1 = current.locationMarker1;
    vars.locationMarker2 = current.locationMarker2;
    vars.locationMarker3 = current.locationMarker3;
    
    // If you run away the enemy values stick, this clears it
    
    // if the location marker changes or the gold changes, make sure all enemy HP is reset
    if (current.locationMarker1 != vars.locationMarker1 || current.goldCoin != vars.goldCoin) {
        vars.enemy1HP = 0;
        vars.enemy2HP = 0;
        vars.enemy3HP = 0;
        vars.enemy4HP = 0;
        vars.enemy5HP = 0;
        vars.enemy6HP = 0;
    }


    /**  ___________________________________________________________________________________________________________________________________________
        |                                                            Experience Checker                                                             | 
        |   Note:   Ryudo is always in the party so this is always true, but if he dies and takes no exp other characters have been included        |
        |           Therefore, if ANYONE gets EXP calculate new EXP                                                                                 |
        |           Checks for if exp = 0 for a character, so they either died or are not in the party at that time                                 |
        |__________________________________________________________________________________________________________________________________________ | **/
            
    if (current.RyudoEXP > old.RyudoEXP || current.PartyMember2EXP > old.PartyMember2EXP || 
        current.PartyMember3EXP > old.PartyMember3EXP ||  current.PartyMember4EXP > old.PartyMember4EXP) {
        // Character 1
        if (current.RyudoEXP == 0) {
            vars.RyudoLevel = 0;
            vars.RyudoEXPToNextLevel = 0;
        } 
        else {
            if (current.RyudoEXP < 634) { vars.RyudoLevel = 10; vars.RyudoEXPToNextLevel = 634 - current.RyudoEXP; }
            else if (current.RyudoEXP < 798)   { vars.RyudoLevel = 11; vars.RyudoEXPToNextLevel = 798 - current.RyudoEXP; }
            else if (current.RyudoEXP < 991)   { vars.RyudoLevel = 12; vars.RyudoEXPToNextLevel = 991 - current.RyudoEXP; }
            else if (current.RyudoEXP < 1203)  { vars.RyudoLevel = 13; vars.RyudoEXPToNextLevel = 1203 - current.RyudoEXP; }
            else if (current.RyudoEXP < 1479)  { vars.RyudoLevel = 14; vars.RyudoEXPToNextLevel = 1479 - current.RyudoEXP; }
            else if (current.RyudoEXP < 1794)  { vars.RyudoLevel = 15; vars.RyudoEXPToNextLevel = 1794 - current.RyudoEXP; }
            else if (current.RyudoEXP < 2159)  { vars.RyudoLevel = 16; vars.RyudoEXPToNextLevel = 2159 - current.RyudoEXP; }
            else if (current.RyudoEXP < 2584)  { vars.RyudoLevel = 17; vars.RyudoEXPToNextLevel = 2584 - current.RyudoEXP; }
            else if (current.RyudoEXP < 3064)  { vars.RyudoLevel = 18; vars.RyudoEXPToNextLevel = 3064 - current.RyudoEXP; }
            else if (current.RyudoEXP < 3604)  { vars.RyudoLevel = 19; vars.RyudoEXPToNextLevel = 3604 - current.RyudoEXP; }
            else if (current.RyudoEXP < 4200)  { vars.RyudoLevel = 20; vars.RyudoEXPToNextLevel = 4200 - current.RyudoEXP; }
            else if (current.RyudoEXP < 4864)  { vars.RyudoLevel = 21; vars.RyudoEXPToNextLevel = 4864 - current.RyudoEXP; }
            else if (current.RyudoEXP < 5587)  { vars.RyudoLevel = 22; vars.RyudoEXPToNextLevel = 5587 - current.RyudoEXP; }
            else if (current.RyudoEXP < 6385)  { vars.RyudoLevel = 23; vars.RyudoEXPToNextLevel = 6385 - current.RyudoEXP; }
            else if (current.RyudoEXP < 7254)  { vars.RyudoLevel = 24; vars.RyudoEXPToNextLevel = 7254 - current.RyudoEXP; }
            else if (current.RyudoEXP < 8205)  { vars.RyudoLevel = 25; vars.RyudoEXPToNextLevel = 8205 - current.RyudoEXP; }
            else if (current.RyudoEXP < 9236)  { vars.RyudoLevel = 26; vars.RyudoEXPToNextLevel = 9236 - current.RyudoEXP; }
            else if (current.RyudoEXP < 10364) { vars.RyudoLevel = 27; vars.RyudoEXPToNextLevel = 10364 - current.RyudoEXP; }
            else if (current.RyudoEXP < 11604) { vars.RyudoLevel = 28; vars.RyudoEXPToNextLevel = 11604 - current.RyudoEXP; }
            else if (current.RyudoEXP < 12961) { vars.RyudoLevel = 29; vars.RyudoEXPToNextLevel = 12961 - current.RyudoEXP; }
            else if (current.RyudoEXP < 14257) { vars.RyudoLevel = 30; vars.RyudoEXPToNextLevel = 14257 - current.RyudoEXP; }
            else if (current.RyudoEXP < 16079) { vars.RyudoLevel = 31; vars.RyudoEXPToNextLevel = 16079 - current.RyudoEXP; }
            else if (current.RyudoEXP < 17859) { vars.RyudoLevel = 32; vars.RyudoEXPToNextLevel = 17859 - current.RyudoEXP; }
            else if (current.RyudoEXP < 19808) { vars.RyudoLevel = 33; vars.RyudoEXPToNextLevel = 19808 - current.RyudoEXP; }
            else if (current.RyudoEXP < 21903) { vars.RyudoLevel = 34; vars.RyudoEXPToNextLevel = 21903 - current.RyudoEXP; }
            else if (current.RyudoEXP < 24144) { vars.RyudoLevel = 35; vars.RyudoEXPToNextLevel = 24144 - current.RyudoEXP; }
            else if (current.RyudoEXP < 26530) { vars.RyudoLevel = 36; vars.RyudoEXPToNextLevel = 26530 - current.RyudoEXP; }
            else if (current.RyudoEXP < 29047) { vars.RyudoLevel = 37; vars.RyudoEXPToNextLevel = 29047 - current.RyudoEXP; }
            else if (current.RyudoEXP < 31677) { vars.RyudoLevel = 38; vars.RyudoEXPToNextLevel = 31677 - current.RyudoEXP; }
            else if (current.RyudoEXP < 34448) { vars.RyudoLevel = 39; vars.RyudoEXPToNextLevel = 34448 - current.RyudoEXP; }
            else { vars.RyudoLevel = 40; vars.RyudoEXPToNextLevel = 0; }
        }
            // === Party Member 2 [Elena/Millenia] ===
        if (current.PartyMember2EXP == 0) {
            vars.Party2Level = 0;
            vars.Party2ToNext = 0; 
        } 
        else {
            if (current.PartyMember2EXP < 634) { vars.PartyMember2EXPToNextLevel = 10; vars.Party2ToNext = 634 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 798) { vars.Party2Level = 11; vars.PartyMember2EXPToNextLevel = 798 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 991) { vars.Party2Level = 12; vars.PartyMember2EXPToNextLevel = 991 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 1203) { vars.Party2Level = 13; vars.PartyMember2EXPToNextLevel = 1203 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 1479) { vars.Party2Level = 14; vars.PartyMember2EXPToNextLevel = 1479 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 1794) { vars.Party2Level = 15; vars.PartyMember2EXPToNextLevel = 1794 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 2159) { vars.Party2Level = 16; vars.PartyMember2EXPToNextLevel = 2159 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 2584) { vars.Party2Level = 17; vars.PartyMember2EXPToNextLevel = 2584 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 3064) { vars.Party2Level = 18; vars.PartyMember2EXPToNextLevel = 3064 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 3604) { vars.Party2Level = 19; vars.PartyMember2EXPToNextLevel = 3604 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 4200) { vars.Party2Level = 20; vars.PartyMember2EXPToNextLevel = 4200 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 4864) { vars.Party2Level = 21; vars.PartyMember2EXPToNextLevel = 4864 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 5587) { vars.Party2Level = 22; vars.PartyMember2EXPToNextLevel = 5587 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 6385) { vars.Party2Level = 23; vars.PartyMember2EXPToNextLevel = 6385 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 7254) { vars.Party2Level = 24; vars.PartyMember2EXPToNextLevel = 7254 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 8205) { vars.Party2Level = 25; vars.PartyMember2EXPToNextLevel = 8205 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 9236) { vars.Party2Level = 26; vars.PartyMember2EXPToNextLevel = 9236 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 10364) { vars.Party2Level = 27; vars.PartyMember2EXPToNextLevel = 10364 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 11604) { vars.Party2Level = 28; vars.PartyMember2EXPToNextLevel = 11604 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 12961) { vars.Party2Level = 29; vars.PartyMember2EXPToNextLevel = 12961 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 14257) { vars.Party2Level = 30; vars.PartyMember2EXPToNextLevel = 14257 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 16079) { vars.Party2Level = 31; vars.PartyMember2EXPToNextLevel = 16079 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 17859) { vars.Party2Level = 32; vars.PartyMember2EXPToNextLevel = 17859 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 19808) { vars.Party2Level = 33; vars.PartyMember2EXPToNextLevel = 19808 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 21903) { vars.Party2Level = 34; vars.PartyMember2EXPToNextLevel = 21903 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 24144) { vars.Party2Level = 35; vars.PartyMember2EXPToNextLevel = 24144 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 26530) { vars.Party2Level = 36; vars.PartyMember2EXPToNextLevel = 26530 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 29047) { vars.Party2Level = 37; vars.PartyMember2EXPToNextLevel = 29047 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 31677) { vars.Party2Level = 38; vars.PartyMember2EXPToNextLevel = 31677 - current.PartyMember2EXP; }
            else if (current.PartyMember2EXP < 34448) { vars.Party2Level = 39; vars.PartyMember2EXPToNextLevel = 34448 - current.PartyMember2EXP; }
            else { vars.Party2Level = 40; vars.PartyMember2EXPToNextLevel = 0; }
        }
            // === Party Member 3 ===
        if (current.PartyMember3EXP == 0) {
            vars.Party3Level = 0;
            vars.PartyMember3EXPToNextLevel = 0;
        } 
        else {
            if (current.PartyMember3EXP < 634) { vars.Party3Level = 10; vars.PartyMember3EXPToNextLevel = 634 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 798) { vars.Party3Level = 11; vars.PartyMember3EXPToNextLevel = 798 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 991) { vars.Party3Level = 12; vars.PartyMember3EXPToNextLevel = 991 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 1203) { vars.Party3Level = 13; vars.PartyMember3EXPToNextLevel = 1203 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 1479) { vars.Party3Level = 14; vars.PartyMember3EXPToNextLevel = 1479 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 1794) { vars.Party3Level = 15; vars.PartyMember3EXPToNextLevel = 1794 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 2159) { vars.Party3Level = 16; vars.PartyMember3EXPToNextLevel = 2159 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 2584) { vars.Party3Level = 17; vars.PartyMember3EXPToNextLevel = 2584 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 3064) { vars.Party3Level = 18; vars.PartyMember3EXPToNextLevel = 3064 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 3604) { vars.Party3Level = 19; vars.PartyMember3EXPToNextLevel = 3604 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 4200) { vars.Party3Level = 20; vars.PartyMember3EXPToNextLevel = 4200 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 4864) { vars.Party3Level = 21; vars.PartyMember3EXPToNextLevel = 4864 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 5587) { vars.Party3Level = 22; vars.PartyMember3EXPToNextLevel = 5587 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 6385) { vars.Party3Level = 23; vars.PartyMember3EXPToNextLevel = 6385 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 7254) { vars.Party3Level = 24; vars.PartyMember3EXPToNextLevel = 7254 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 8205) { vars.Party3Level = 25; vars.PartyMember3EXPToNextLevel = 8205 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 9236) { vars.Party3Level = 26; vars.PartyMember3EXPToNextLevel = 9236 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 10364) { vars.Party3Level = 27; vars.PartyMember3EXPToNextLevel = 10364 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 11604) { vars.Party3Level = 28; vars.PartyMember3EXPToNextLevel = 11604 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 12961) { vars.Party3Level = 29; vars.PartyMember3EXPToNextLevel = 12961 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 14257) { vars.Party3Level = 30; vars.PartyMember3EXPToNextLevel = 14257 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 16079) { vars.Party3Level = 31; vars.PartyMember3EXPToNextLevel = 16079 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 17859) { vars.Party3Level = 32; vars.PartyMember3EXPToNextLevel = 17859 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 19808) { vars.Party3Level = 33; vars.PartyMember3EXPToNextLevel = 19808 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 21903) { vars.Party3Level = 34; vars.PartyMember3EXPToNextLevel = 21903 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 24144) { vars.Party3Level = 35; vars.PartyMember3EXPToNextLevel = 24144 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 26530) { vars.Party3Level = 36; vars.PartyMember3EXPToNextLevel = 26530 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 29047) { vars.Party3Level = 37; vars.PartyMember3EXPToNextLevel = 29047 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 31677) { vars.Party3Level = 38; vars.PartyMember3EXPToNextLevel = 31677 - current.PartyMember3EXP; }
            else if (current.PartyMember3EXP < 34448) { vars.Party3Level = 39; vars.PartyMember3EXPToNextLevel = 34448 - current.PartyMember3EXP; }
            else { vars.Party3Level = 40; vars.PartyMember3EXPToNextLevel = 0; }
        }
                // === Party Member 4 ===
        if (current.PartyMember4EXP == 0) {
            vars.Party4Level = 0;
            vars.PartyMember4EXPToNextLevel = 0;
        } 
        else {
            if (current.PartyMember4EXP < 634) { vars.Party4Level = 10; vars.PartyMember4EXPToNextLevel = 634 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 798) { vars.Party4Level = 11; vars.PartyMember4EXPToNextLevel = 798 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 991) { vars.Party4Level = 12; vars.PartyMember4EXPToNextLevel = 991 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 1203) { vars.Party4Level = 13; vars.PartyMember4EXPToNextLevel = 1203 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 1479) { vars.Party4Level = 14; vars.PartyMember4EXPToNextLevel = 1479 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 1794) { vars.Party4Level = 15; vars.PartyMember4EXPToNextLevel = 1794 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 2159) { vars.Party4Level = 16; vars.PartyMember4EXPToNextLevel = 2159 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 2584) { vars.Party4Level = 17; vars.PartyMember4EXPToNextLevel = 2584 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 3064) { vars.Party4Level = 18; vars.PartyMember4EXPToNextLevel = 3064 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 3604) { vars.Party4Level = 19; vars.PartyMember4EXPToNextLevel = 3604 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 4200) { vars.Party4Level = 20; vars.PartyMember4EXPToNextLevel = 4200 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 4864) { vars.Party4Level = 21; vars.PartyMember4EXPToNextLevel = 4864 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 5587) { vars.Party4Level = 22; vars.PartyMember4EXPToNextLevel = 5587 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 6385) { vars.Party4Level = 23; vars.PartyMember4EXPToNextLevel = 6385 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 7254) { vars.Party4Level = 24; vars.PartyMember4EXPToNextLevel = 7254 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 8205) { vars.Party4Level = 25; vars.PartyMember4EXPToNextLevel = 8205 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 9236) { vars.Party4Level = 26; vars.PartyMember4EXPToNextLevel = 9236 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 10364) { vars.Party4Level = 27; vars.PartyMember4EXPToNextLevel = 10364 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 11604) { vars.Party4Level = 28; vars.PartyMember4EXPToNextLevel = 11604 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 12961) { vars.Party4Level = 29; vars.PartyMember4EXPToNextLevel = 12961 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 14257) { vars.Party4Level = 30; vars.PartyMember4EXPToNextLevel = 14257 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 16079) { vars.Party4Level = 31; vars.PartyMember4EXPToNextLevel = 16079 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 17859) { vars.Party4Level = 32; vars.PartyMember4EXPToNextLevel = 17859 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 19808) { vars.Party4Level = 33; vars.PartyMember4EXPToNextLevel = 19808 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 21903) { vars.Party4Level = 34; vars.PartyMember4EXPToNextLevel = 21903 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 24144) { vars.Party4Level = 35; vars.PartyMember4EXPToNextLevel = 24144 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 26530) { vars.Party4Level = 36; vars.PartyMember4EXPToNextLevel = 26530 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 29047) { vars.Party4Level = 37; vars.PartyMember4EXPToNextLevel = 29047 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 31677) { vars.Party4Level = 38; vars.PartyMember4EXPToNextLevel = 31677 - current.PartyMember4EXP; }
            else if (current.PartyMember4EXP < 34448) { vars.Party4Level = 39; vars.PartyMember4EXPToNextLevel = 34448 - current.PartyMember4EXP; }
            else { vars.Party3Level = 40; vars.PartyMember4EXPToNextLevel = 0; }
        }
    }

    /**  _______________________________________________________________________________________________________________________________________________________
        |                                                            Location Markers                                                                           |
        |   Note:   The location markers are used to determine the current location of the player.                                                              |
        |           Sometimes the game has negative values for location markers, which when you reload a save into that location it reverts to a positive value.|
        |           Where possible, I have multiple markers for the same location to account for this.                                                          |
        |_______________________________________________________________________________________________________________________________________________________| **/

    switch ((int)current.locationMarker1)
    {
        case 65535:
            vars.locationName = "Main Menu"; 
            break;

        // ====================================    Map Markers    ==================================== \\
        case 4112:
            vars.locationName = "East Silesia Map"; 
            break;
        case 4096:
            vars.locationName = "North Silesia Map"; 
            break;
        case 4128:
            vars.locationName = "Island of Garlan & Vicinity Map";  
            break;
        case 4144:
            vars.locationName = "Great Cleft Island of Arachna Map"; 
            break;
        case 4160:
            vars.locationName = "East Silesia Map";  
            break;

        // ====================================    Black Forest    ==================================== \\
        case 9216:
            vars.locationName = "Black Forest 1"; 
            break;

        // ====================================    Garmia Tomer    ==================================== \\
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

        // ====================================    Inor Mountains    ==================================== \\
        case 11264:
            vars.locationName = "Inor Mountains - Level 1"; 
			break;
        case 11280:
            vars.locationName = "Inor Mountains - Level 2"; 
			break;

        // ====================================    Durham Cave    ==================================== \\
        case 13312:
            vars.locationName = "Durham Cave - Level 1"; 
			break;
        case 13328:
            vars.locationName = "Durham Cave - Level 2"; 
			break;
        case 13552:
            vars.locationName = "Durham Cave - Depths"; 
			break;

        // ====================================    Baked Plains    ==================================== \\
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

        // ====================================    Liligue City    ==================================== \\
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
            vars.locationName = "Liligue - Skyway Station)"; 
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

        // ====================================    Liligue Cave    ==================================== \\
        case 16384:
            if (vars.locationMarker3 == 8704) { 
                vars.locationName = "Liligue Cave - Level 1";
            }
            else if (vars.locationMarker3 == 9984) {
                vars.locationName = "Liligue Cave - Level 2";
            }
            else {
                vars.locationName = "Liligue Cave - Unknown Location";
            } 
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

        // ====================================    Mirumu Village    ==================================== \\
        case 19456:
            vars.locationName = "Mirumu - Overworld"; 
            break;
        case 19520:
            vars.locationName = "Mirumu - Chief's House"; 
            break;
            case -10176:
            vars.locationName = "Mirumu - Chief's House"; 
            break;
        case 19616:
            vars.locationName = "Mirumu - House 1"; 
            break;
        case -10080:
            vars.locationName = "Mirumu - House 1"; 
            break;
        case 19632:
            vars.locationName = "Mirumu - House 2"; 
            break;
        case -10064:
            vars.locationName = "Mirumu - House 2"; 
            break;
        case 19648:
            vars.locationName = "Mirumu - House 3"; 
            break;
        case 19504:
            vars.locationName = "Mirumu - Town Hall"; 
            break;
        case -10192:
            vars.locationName = "Mirumu - Town Hall"; 
            break;
        case 19472:
            vars.locationName = "Mirumu - Inn"; 
            break;
        case -10224:
            vars.locationName = "Mirumu - Inn"; 
            break;
        case 19480:
            vars.locationName = "Mirumu - Managers Room"; 
            break;
        case -10216:
            vars.locationName = "Mirumu - Managers Room"; 
            break;
        case 19476:
            vars.locationName = "Mirumu - Guestroom"; 
            break;
        case -10220:
            vars.locationName = "Mirumu - Guestroom"; 
            break;
        case 19488:
            vars.locationName = "Mirumu - General Store"; 
            break;
        case 19536:
            vars.locationName = "Mirumu - Sandra's House"; 
            break;
        case -10160:
            vars.locationName = "Mirumu - Sandra's House"; 
            break;
        case 20544:
            vars.locationName = "Mirumu - Ryudo Dream"; 
            break;

        // ====================================    Lumir Forest    ==================================== \\
        case 17408:
            vars.locationName = "Lumir Forest - Crash Site"; 
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

        // ====================================    St Heim Mountains    ==================================== \\
        case 21504:
            vars.locationName = "St. Heim Mountains - Base"; 
            break;
        case 21536:
            vars.locationName = "St. Heim Mountains - Caverns"; 
            break; 
        case 21552:
            vars.locationName = "St. Heim Mountains - Waterfall"; 
            break;
        case 21520:
            vars.locationName = "St. Heim Mountains - Halfway Up"; 
            break;
        
        // ====================================    Cyrum Kingdom    ==================================== \\
        case 25600:
            vars.locationName = "Cyrum Kingdom"; 
            break;
        case 28672:
            vars.locationName = "Cyrum Kingdom"; 
            break;
        case 25616:        
            vars.locationName = "Cyrum Inn - Downstairs"; 
            break;
        case 28688:        
            vars.locationName = "Cyrum Inn - Downstairs"; 
            break;
        case 25628:
            vars.locationName = "Cyrum Inn - Corridor"; 
            break;
        case 28700:
            vars.locationName = "Cyrum Inn - Corridor"; 
            break;
        case 25620:
            vars.locationName = "Cyrum Inn - Upstairs"; 
            break;
        case 28692:
            vars.locationName = "Cyrum Inn - Guestroom"; 
            break;
        case 25632:
            vars.locationName = "Cyrum Kingdom - General Store"; 
            break;
        case 28704:
            vars.locationName = "Cyrum Kingdom - General Store"; 
            break;
        case 25760:
            vars.locationName = "Cyrum Kingdom - House 1 (Downstairs)"; 
            break;
        case 25740:
            vars.locationName = "Cyrum Kingdom - House 1 (Upstairs)"; 
            break;
        case 25776:
            vars.locationName = "Cyrum Kingdom - House 2 (Downstairs)"; 
            break;
        case 25780:
            vars.locationName = "Cyrum Kingdom - House 2 (Upstairs)"; 
            break;
        case 25792:
            vars.locationName = "Cyrum Kingdom - House 3"; 
            break;
        case 25808:
            vars.locationName = "Cyrum Kingdom - House 4"; 
            break;
        case 25648:
            vars.locationName = "Cyrum Kingdom - Informant's Tent"; 
            break;
        case 25608:
            vars.locationName = "Cyrum Kingdom - Port"; 
            break;
        case -24576:
            vars.locationName = "Cyrum Kingdom - South"; 
            break;
        case -24572:
            vars.locationName = "Cyrum Royal Mausoleum"; 
            break;

        // ====================================    Cyrum Castle    ==================================== \\
        case 26800:
            vars.locationName = "Cyrum Castle - Backyard"; 
            break;
        case 26816:
            vars.locationName = "Cyrum Castle - Audience Square"; 
            break;
        case 26112:
            vars.locationName = "Cyrum Castle - Secret Passage"; 
            break; // 200
        case 26672:
            vars.locationName = "Cyrum Castle - Downstairs Hall"; 
            break;
        case 26784:
            vars.locationName = "Cyrum Castle - Room of Demon-Sealing"; 
            break;
        case 26640:
            vars.locationName = "Cyrum Castle - Downstairs Lobby"; 
            break;
        case 26688:
            vars.locationName = "Cyrum Castle - Room 1"; 
            break;
        case 26696:
            vars.locationName = "Cyrum Castle - Room 2"; 
            break;
        case 26624:
            vars.locationName = "Cyrum Castle - Front Game"; 
            break;
        case 26656:
            vars.locationName = "Cyrum Castle - Audience Chamber"; 
            break;
        case 26768:
            vars.locationName = "Cyrum Castle - Kings Office"; 
            break;
        case 26752:
            vars.locationName = "Cyrum Castle - King's Chamber"; 
            break;

        // ====================================    Underground Plant    ==================================== \\
        case 27648:
            vars.locationName = "Underground Plant 1"; 
            break;
        case 27664:
            vars.locationName = "Underground Plant 2"; 
            break;
        case 27680:
            vars.locationName = "Underground Plant 3"; 
            break;
        case 27892:
            vars.locationName = "Underground Plant Control Room"; 
            break;

        // ====================================    St. Heim Papal State    ==================================== \\
        case 22528:
            vars.locationName = "St. Heim Papal State"; 
            break;
        case 22608:
            vars.locationName = "St. Heim - Pastures"; 
            break;
        case 22560:
            vars.locationName = "St. Heim Papal State - General Store"; 
            break;
        case 22576:
            vars.locationName = "St. Heim Papal State - Library";
            break;
        case 22592:
            vars.locationName = "St. Heim Papal State - Bakery";
            break;
        case 22544:
            vars.locationName = "St. Heim Papal State - Inn"; 
            break;
        case 22624:
            vars.locationName = "St. Heim Papal State - Church"; 
            break;
        case 22692:
            vars.locationName = "St. Heim Papal State - House 1 (Upstairs)"; 
            break;
        case 22704:
            vars.locationName = "St. Heim Papal State - House 2"; 
            break;
        case 22736:
            vars.locationName = "St. Heim Papal State - House 4"; 
            break;
        case 22688:
            if (vars.locationMarker2 == 13) {
                vars.locationName = "St. Heim Papal State - House 1 (Downstairs)";
            }
            else if (vars.locationMarker2 == 12) {
                vars.locationName = "St. Heim Papal State - Guestroom Corridor";
            }
            else if (vars.locationMarker2 == 25) {
                vars.locationName = "St. Heim Papal State - Library";
            }
            else if (vars.locationMarker2 == 31) {
                vars.locationName = "St. Heim Papal State - Cathedral Library";
            }
            else if (vars.locationMarker2 == 38) {
                vars.locationName = "St. Heim Papal State - Pope's Room Corridor"; 
            }  
            else if (vars.locationMarker2 == 40) {
                vars.locationName = "Pope's Room";
            }
            else if (vars.locationMarker2 == 65){
                vars.locationName = "St. Heim Papal State - Cathedral Lobby";
            }
            else if (vars.locationMarker2 == 67){
                vars.locationName = "St. Heim Papal State - Cathedral Balcony"; 
            }
            else if (vars.locationMarker2 == 71){
                vars.locationName = "St. Heim Papal State - Guestroom";
            }
            else if (vars.locationMarker2 == 81 || vars.locationMarker2 == 296) {
                vars.locationName = "St. Heim Papal State - Zera Cutscene";
            }           
            else if (vars.locationMarker2 == 462) {
                vars.locationName = "St. Heim Papal State - Cathedral";
            }
            else {
                vars.locationName = "St. Heim Papal State - Cathedral";
            }
            break;

        //  ====================    Granas Cathedral    ==================================== \\

        case 23552:
            vars.locationName = "Granas Cathedral"; 
            break;
        case 23553:
            vars.locationName = "Granas Cathedral"; 
            break;
        case 23568:
            vars.locationName = "Granas Cathedral - Lobby"; 
            break;
        case 23572:
            vars.locationName = "Granas Cathedral - Guestroom Corridor"; 
            break;
        case 23656:
            vars.locationName = "Granas Cathedral - Guestroom"; 
            break;
        case 23728:
            vars.locationName = "Granas Cathedral Library"; 
            break;    
        case 23632:
            vars.locationName = "Granas Cathedral Balcony"; 
            break;
        case 23584:
            vars.locationName = "Granas Cathedral - Audience Chamber"; 
            break;
        case 23696:
            vars.locationName = "Granas Cathedral - Pope's Room Corridor"; 
            break;
        case 23600:
            vars.locationName = "Granas Cathedral - Pope's Room"; 
            break;
        case 23664:
            vars.locationName = "Granas Cathedral - Holy Room"; 
            break;
        case 23680:
            vars.locationName = "Granas Cathedral - Room of Truth"; 
            break;
        case 23616:
            vars.locationName = "Granas Cathedral - Forbidden Room"; 
            break;

        // ====================================    Raul Hills    ==================================== \\
        case 21568:
            vars.locationName = "Pilgrim Road"; 
            break;
        case 24576:
            vars.locationName = "Raul Hills 1"; 
            break;
        case 24592:
            vars.locationName = "Raul Hills 2"; 
            break;

        // ====================================    Mysterious Fissure    ==================================== \\
        case 20496:
            vars.locationName = "Mysterious Fissure - Depths"; 
            break;
        case 20480:
            vars.locationName = "Mysterious Fissure - Underground"; 
            break;
        case 19552:
            vars.locationName = "Shed"; 
            break;

        // ====================================    The 50/50    ==================================== \\
        case 29696:
            vars.locationName = "The 50/50 - Deck"; 
            break;
        case 29712:
            vars.locationName = "The 50/50 - Cabin"; 
            break;
        case 29728:
            vars.locationName = "The 50/50 - Sleeping Cabin"; 
            break;

        // ====================================    Ceceile Reef    ==================================== \\
        case 30720:
            vars.locationName = "Ceceile Reef - Point"; 
            break;
        case 30752:
            vars.locationName = "Ceceile Reef 1"; 
            break;
        case 30768:
            vars.locationName = "Ceceile Reef 2"; 
            break;

        // ====================================    Garlan Village    ==================================== \\
        case 31744:
            vars.locationName = "Garlan Village"; 
			break; 
        case 31760:
            vars.locationName = "Garlan Village - Inn"; 
			break;
        case 31772:
            vars.locationName = "Garlan Village - Inn Corridor"; 
			break;
        case 31764:
            vars.locationName = "Garlan Village - Room 1"; 
			break;
        case 31768:
            vars.locationName = "Garlan Village - Room 2"; 
			break;
        case 31776:
            vars.locationName = "Garlan Village - General Store"; 
			break;
        case 31904:
            vars.locationName = "Garlan Village - House 1"; 
			break;
        case 31920:
            vars.locationName = "Garlan Village - House 2"; 
			break;
        case 31936:
            vars.locationName = "Garlan Village - House 3"; 
			break;
        case 31952:
            vars.locationName = "Garlan Village - House 4"; 
			break;
        case 31792:
            vars.locationName = "Garlan Village - Chief's House"; 
			break;

        // ====================================    Grail Mountain Road    ==================================== \\      
        // Variable starting being negative sometimes, so additional cases added for these use cases
        case -32768:
            vars.locationName = "Grail Mountain Road 1"; 
			break;
        case 32768:
            vars.locationName = "Grail Mountain Road 1"; 
			break;
        case 32784:
            vars.locationName = "Grail Mountain Road 2"; 
			break;
        case -32752:
            vars.locationName = "Grail Mountain Road 2"; 
			break;
        case -32704:
            vars.locationName = "Grail Mountain Road 3"; 
			break;
        case -32736:
            vars.locationName = "Grail Mountain Road Shrine Square"; 
			break;
        case -32720:
            vars.locationName = "Grail Mountain Road Shrine"; 
			break;
        case -32688:
            vars.locationName = "Grail Mountain Road - Plateau of Memories"; 
			break;
        case -31744:
            vars.locationName = "Ryudo & Melfice Dream Cutscene"; 
			break;

        // ====================================    Ghoss Forest    ==================================== \\
        case 34816:
            vars.locationName = "Ghoss Forest, West 1"; 
			break;
        case -30704:
            vars.locationName = "Ghoss Forest, West 2"; 
			break;

        // ====================================    Nanan Village    ==================================== \\
        case -29696:
            vars.locationName = "Nanan Village"; 
			break;
        case -29680:
            vars.locationName = "Nanan Village - Inn"; 
			break;
        case -29664:
            vars.locationName = "Nanan Village - General Store"; 
			break;
        case -29536:
            vars.locationName = "Nanan Village - House 1"; 
			break;
        case -29520:
            vars.locationName = "Nanan Village - House 2"; 
			break;
        case -29504:
            vars.locationName = "Nanan Village - House 3"; 
			break;
        case -29600:
            vars.locationName = "Nanan Village - Weaving Hut"; 
			break;
        case -29632:
            vars.locationName = "Nanan Village - Mareg's House"; 
			break;
        case -29648:
            vars.locationName = "Nanan Village - Elder's House"; 
			break;
        case -29616:
            vars.locationName = "Nanan Village - Hut of Trials"; 
			break;
        case -29184:
            vars.locationName = "Hut of Trials, Underground"; 
			break;
        case -29584:
            vars.locationName = "Nanan Spring"; 
			break;

        // ====================================    Ghoss Forest, East    ==================================== \\
        case -30688:
            vars.locationName = "Ghoss Forest, East 1"; 
			break;
        case -30672:
            vars.locationName = "Ghoss Forest, East 2"; 
			break;

        // ====================================    The Great Rift    ==================================== \\
        case -28672:
            vars.locationName = "The Great Rift 1"; 
			break;
        case -28656:
            vars.locationName = "The Great Rift 2"; 
			break;
        case -28640:
            vars.locationName = "The Great Rift 3"; 
			break;
        case -28624:
            vars.locationName = "The Great Rift 4"; 
			break;

        // ====================================    Demon's Law    ==================================== \\
        case -28160:
            vars.locationName = "Demon's Law"; 
			break;
        case -27920:
            vars.locationName = "Demon's Law - Control Room"; 
			break;

        // ====================================    Valmar's Body    ==================================== \\
        case -26624:
            vars.locationName = "Valmar's Body - Point of Entry"; 
			break;
        case -26608:
            vars.locationName = "Valmar's Body - Tentacle Passage"; 
			break;
        case -26592:
            vars.locationName = "Valmar's Body - Vein Passage"; 
			break;
        case -26576:
            vars.locationName = "Valmar's Body - Artery Passage"; 
			break;
        case -26560:
            vars.locationName = "Valmar's Body - Spherical Room"; 
			break;
        case -26384:
            vars.locationName = "Valmar's Body - Core"; 
			break;

        // ====================================    Valmar's Moon    ==================================== \\
       case -25600:
            vars.locationName = "Valmar's Moon - Surface"; 
			break;
        case -25596:
            vars.locationName = "Valmar's Moon - Surface"; 
			break;
        case -25584:
            vars.locationName = "Valmar's Moon 1"; 
			break;
        case -25568:
            vars.locationName = "Valmar's Moon 2"; 
			break;
        case -25552:
            vars.locationName = "Valmar's Moon 3"; 
			break;
        case -25360:
            vars.locationName = "Valmar's Womb"; 
			break;

        // ====================================    Birthplace of the God    ==================================== \\
        case -24560:
            vars.locationName = "Birthplace of the Gods 1"; 
			break;
        case 40976:
            vars.locationName = "Birthplace of the Gods 1"; 
			break;
        case -24544:
            vars.locationName = "Birthplace of the Gods 2"; 
			break;
        case -24528:
            vars.locationName = "Birthplace of the Gods 3"; 
			break;
        case -24512:
            vars.locationName = "Birthplace of the Gods - Control Room"; 
			break;
        case -24480:
            vars.locationName = "Birthplace of the Gods - Open Thought"; 
			break;

        // ====================================    New Valmar   ==================================== \\
        case -23552:
            vars.locationName = "New Valmar 1"; 
			break;
        case -23536:
            vars.locationName = "New Valmar 2"; 
			break;
        case 42000:
            vars.locationName = "New Valmar 2"; 
			break;
        case -23520:
            vars.locationName = "New Valmar 3"; 
			break;
        case 42016:
            vars.locationName = "New Valmar 3"; 
			break;
        case -23504:
            vars.locationName = "New Valmar -  Core"; 
			break;
        case -23500:
            vars.locationName ="New Valmar - Core"; 
			break;
        case -23300:
            vars.locationName = "New Valmar - Room of Chaos"; 
			break;
        case -23304:
            vars.locationName = "New Valmar - Room of Chaos"; 
			break;
        case -23308:
            vars.locationName = "New Valmar - Room of Chaos"; 
			break;
        case -23128:
            vars.locationName = "New Valmar - Room of Chaos"; 
			break;
        case 42232:
            vars.locationName = "New Valmar - Room of Chaos"; 
			break;

        // ====================================    Post-Game    ==================================== \\
        case -11264:
            vars.locationName = "Ending - Tio & Roan"; 
			break;
        case -11248:
            vars.locationName = "Ending - Ryudo, Millenia & Elena"; 
			break;
        case 25602:
            vars.locationName = "Cyrum - One Year Later"; 
			break;
        case 15362:
            vars.locationName = "Liligue - One Year Later"; 
			break;
        case 15366:
            vars.locationName = "Liligue Skyway - One Year Later"; 
			break;
        case -10238:
            vars.locationName = "Mirumu Village - One Year Later"; 
			break;
        case -8114:
            vars.locationName = "Travelling Nanan to Mirumu - One Year Later"; 
			break;
        case -32687:
            vars.locationName = "Gatta training soldiers - One Year Later"; 
			break;
        case -10240:
            vars.locationName = "Ryudo Final Cutscene"; 
			break;
        default:
            vars.locationName = "Unknown Location";
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
    /** ____________________________________________________________________________________________________________________________________________________
        |                                                            Splits                                                                                 |
        |   Note:   I want hard coded places to ensure we are in the correct place                                                                          |
        |           - this will be the start and end of boss fightsThe splits are used to determine the current location of the player.                     |                                                |
        |           - i.e if locationmarker 1 == x, locationmarker2= x, locationmarker3 = x then I am in this split for sure and split count = x            |           
        |           The split's need to be updated for just boss fights                                                                                     |
        |___________________________________________________________________________________________________________________________________________________|  **/
 
    // here we need an option for if boss splts, skip if not boss skips use this logic
    // only use the split logic below if the user has selected the boss splits option, otherwise use the other split logic
    if (vars.bossSplits == false)
    {
        vars.DebugMessage("Boss splits are disabled, using normal splits.");
  
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
        if (vars.enemy1HP == 380 && vars.enemy2HP == 380) 
        {   
            vars.DebugMessage("Split 5 - Garmia Tower completed, enterring Gargoyles Fight");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 5:
        if (vars.enemy1HP == 0 && vars.enemy2HP == 0) 
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
            vars.PartyMember2Name = "Elena";
            return true;
            break;
        }
        else {return false; break;}
        // next split happens when inor mountains 1 is entered31
        case 8:
        if (vars.locationMarker1 == 11264 && vars.locationMarker2 == 140 && vars.locationMarker3 == 16128)
        {   
            vars.DebugMessage("Split 8 - Exit Carbos completed, entering Inor Mountains");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 9: 
        if (vars.locationMarker1 == 11280)
        {   
            vars.DebugMessage("Split 9 - Inor Mountains completed, enterring Agear Town");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 10:
        if (vars.locationMarker1 == 13312)
        {   
            vars.DebugMessage("Split 10 - Agear Town completed, enterring Durham Cave");
            vars.splitCount++;
            vars.PartyMember2Name = "Millenia";
            vars.PartyMember3Name = "Roan";
            return true;
            break;
        }
        else {return false; break;}
        case 11:
        if (vars.enemy1HP == 4200)
        {   
            vars.DebugMessage("Split 11 - Durham Cave completed, Minotaur fight");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 12:
        if (vars.enemy1HP == 0)
        {   
            vars.DebugMessage("Split 12 - Minotaur fight completed, now to rwap up Agear and enter Baked Plains");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 13:
        if (vars.locationMarker1 == 14336)
        {   
            vars.DebugMessage("Split 13 - Exit Agear completed, entering Baked Plains");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 14:
        if (vars.locationMarker1 == 14352)
        {   
            vars.DebugMessage("Split 14 - Baked Plains completed, entering Baked Plains 2");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 15:
        if (vars.locationMarker1 == 14368)
        {   
            vars.DebugMessage("Split 15 - Baked Plains 2 completed, entering Baked Plains 3 (Cutscene & Camping)");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 16:
        if (vars.enemy1HP == 4800)
        {   
            vars.DebugMessage("Split 16 - Baked Plains 3 completed, Mareg fight");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 17:
        if (vars.enemy1HP == 0)
        {   
            vars.DebugMessage("Split 17 - Mareg fight completed, finishing up Baked PLains 3 before enterring Liligue CIty");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 18:
        // enter Liligue City]
        if (vars.locationMarker1 == 15360)
        {   
            vars.DebugMessage("Split 18 -Baked Plains 3 finished, enterring Liligue City to go to Gadan's house");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 19:
        if (vars.locationMarker1 == 15424)
        {   
            vars.DebugMessage("Split 18 - Gadan completed, entering Church");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 20:
        if (vars.locationMarker1 == 15492)
        {   
            vars.DebugMessage("Split 19 - Church completed, entering Lilligue Cave");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 21:
        if (vars.locationMarker1 == 15376)
        {   
            vars.DebugMessage("Split 20 - Lilligue Cave completed, entering Lilligue Caverns");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 22:
        if (vars.locationMarker1 == 16624)
        {   
            vars.DebugMessage("Split 21 - Lilligue Caverns completed, entering Temple Ruins");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 23:
        if (vars.enemy1HP == 8000)
        {   
            vars.DebugMessage("Split 22 - Temple Ruins completed, starting valmar tongue fight");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 24:
        if (vars.enemy1HP == 0)
        {   
            vars.DebugMessage("Split 23 - Valmar Tongue fight finished");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        // enter Lumir Forest
        case 25:
        if (vars.locationMarker1 == 17408)
        {   
            vars.DebugMessage("Split 24 - Liligue, entering Lumir Forest");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 26:
        if (vars.locationMarker1 == 17424)
        {   
            vars.DebugMessage("Split 25 - Lumir Forest completed, entering Garden of Dreams");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 27:
        if (vars.locationMarker1 == 18432)
        {   
            vars.DebugMessage("Split 26 - Garden of Dreams completed, entering Mirumu Village");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 28:
        if (vars.locationMarker1 == 19456)
        {   
            vars.DebugMessage("Split 27 - Mirumu Village completed, entering Mysterious Fissure");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 29:
        if (vars.enemy1HP == 3000)
        {   
            vars.DebugMessage("Split 28 - Mysterious Fissure completed, entering Eyeball Bat fight");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 30:
        if (vars.enemy1HP == 0)
        {   
            vars.DebugMessage("Split 29 - Eyeball Bat fight completed, entering Mirumu Village #2");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 31:
        if (vars.locationMarker1 == 19520)
        {   
            vars.DebugMessage("Split 30 - Mirumu Village #2 completed, entering Aira's Space");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 32:
        if (vars.enemyHP == 12000)
        {   
            vars.DebugMessage("Split 31 - Aira's Space completed, entering Eye of Valmar fight");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 33:
        if (vars.enemyHP == 0)
        {   
            vars.DebugMessage("Split 32 - Eye of Valmar fight completed, entering St. Heim Mountains");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 34:
        if (vars.locationMarker1 == 21504)
        {   
            vars.DebugMessage("Split 33 - St. Heim Mountains completed, entering St. Heim Papal State");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 35:
        if (vars.locationMarker1 == 22528)
        {   
            vars.DebugMessage("Split 34 - St. Heim Papal State completed, entering Papal St. Heim");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 36:
        if (vars.locationMarker1 == 22544)
        {   
            vars.DebugMessage("Split 35 - Papal St. Heim completed, entering Pilgrim Road");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 37:
        if (vars.locationMarker1 == 21568)
        {   
            vars.DebugMessage("Split 36 - Pilgrim Road completed, entering Raul Hills 1");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 38:
        if (vars.locationMarker1 == 24576)
        {   
            vars.DebugMessage("Split 37 - Raul Hills 1 completed, entering Raul Hills 2");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 39:
        if (vars.locationMarker1 == 24592)
        {   
            vars.DebugMessage("Split 38 - Raul Hills 2 completed, entering Raul Hills 3");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 40:
        if (vars.locationMarker1 == 24608)
        {   
            vars.DebugMessage("Split 39 - Raul Hills 3 completed, entering Cyrum");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 41:
        if (vars.locationMarker1 == 25600)
        {   
            vars.DebugMessage("Split 40 - Cyrum completed, entering Cyrum Castle");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 42:
        if (vars.locationMarker1 == 26752)
        {   
            vars.DebugMessage("Split 41 - Cyrum Castle completed, entering Underground Plant");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 43:
        if (vars.locationMarker1 == 27648)
        {   
            vars.DebugMessage("Split 42 - Underground Plant completed, entering Underground Plant 2");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 44:
        if (vars.locationMarker1 == 27664)
        {   
            vars.DebugMessage("Split 43 - Underground Plant 2 completed, entering Underground Plant 3");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 45:
        if (vars.enemy1HP == 17000)
        {   
            vars.DebugMessage("Split 44 - Underground Plant 3 completed, entering Claw of Valmar fight");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 46:
        if (vars.enemy1HP == 0)
        {   
            vars.DebugMessage("Split 45 - Claw of Valmar fight completed, entering Melfice");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 47:
        if (vars.locationMarker1 == 28672)
        {   
            vars.DebugMessage("Split 46 - Melfice completed, entering Bakala");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 48:
        if (vars.locationMarker1 == 29696)
        {   
            vars.DebugMessage("Split 47 - Bakala completed, entering 5050");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 49:
        if (vars.locationMarker1 == 30720)
        {   
            vars.DebugMessage("Split 48 - Ceceile Reef completed, entering Ceceile Reef 1");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 50:
        if (vars.locationMarker1 == 30752)
        {   
            vars.DebugMessage("Split 49 - Ceceile Reef 1 completed, entering Ceceile Reef 2");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 51:
        if (vars.enemy1HP == 9800 && vars.enemy2HP == 9800)
        {   
            vars.DebugMessage("Split 50 - Ceceile Reef 2 completed, entering Crimson Tail fight");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 52:
        if (vars.enemy1HP == 0 && vars.enemy2HP == 0)
        {   
            vars.DebugMessage("Split 51 - Crimson Tail fight completed, entering Garlan Village");
            vars.splitCount++;
            return true;
            break;
        }   
        else {return false; break;}
        case 53:
        if (vars.locationMarker1 == 31744 || vars.locationMarker1 == 31760)
        {   
            vars.DebugMessage("Split 52 - Garlan Village completed, entering Grail Mountain Road");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 54:
        if (vars.locationMarker1 == 32768 || vars.locationMarker1 == -32768)
        {   
            vars.DebugMessage("Split 53 - Grail Mountain Road completed, entering Grail Mountain Road 1");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 55:
        if (vars.locationMarker1 == 32784 || vars.locationMarker1 == -32752)
        {   
            vars.DebugMessage("Split 54 - Grail Mountain Road 2 completed, entering Grail Mountain Road Shrine Square");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 56:
        if (vars.locationMarker1 == -32688)
        {   
            vars.DebugMessage("Split 55 - Grail Mountain Road Shrine Square completed, entering Plateau of Memories");
            vars.splitCount++;
            return true;
			break;
        }
        else {return false; break;}
        case 57:
        if (vars.enemy1HP == 19000 && vars.enemy2HP == 11000 && vars.enemy3HP == 13000) // this set of values only occurs in this fight so it will be a good check
        {   
            vars.DebugMessage("Split 56 - Plateau of Memories completed, entering Melfice fight");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 58:
        if (vars.enemy1HP == 0 && vars.enemy2HP == 0 && vars.enemy3HP == 0)
        {   
            vars.DebugMessage("Split 57 - Melfice fight completed, entering Garlan Bakala");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 59:
        if (vars.locationMarker1 == 29696)
        {   
            vars.DebugMessage("Split 58 - Garlan completed, entering 5050");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 60:
        // enterring Ghoss Forest West location marker must be the one for ghost forest west
        if (vars.locationMarker1 == -30704)
        {   
            vars.DebugMessage("Split 59 - 50/50 cutscene done enterring Ghoss Forest West");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 61:
        if (vars.locationMarker1 == -29696)
        {   
            vars.DebugMessage("Split 60 - Ghoss Forest West completed, entering Nanan Village");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 62:
        if (vars.locationMarker1 == -29536)
        {   
            vars.DebugMessage("Split 61 - Nanan Village completed, entering Ghoss Forest West");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 63:
        if (vars.locationMarker1 == -30704)
        {   
            vars.DebugMessage("Split 62 - Ghoss Forest West completed, entering Ghoss Forest East");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 64:
        if (vars.locationMarker1 == -30688)
        {   
            vars.DebugMessage("Split 63 - Ghoss Forest East completed, entering The Great Rift 1");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 65:
        if (vars.locationMarker1 == -28672)
        {   
            vars.DebugMessage("Split 64 - The Great Rift 1 completed, entering The Great Rift 2");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 66:
        if (vars.locationMarker1 == -28656)
        {   
            vars.DebugMessage("Split 65 - The Great Rift 2 completed, entering The Great Rift 3");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 67:
        if (vars.enemy1HP == 17000 && vars.enemy2HP == 4600 && vars.enemy3HP == 4600)
        {   
            vars.DebugMessage("Split 66 - The Great Rift 3 completed, entering Leck Guarder");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 68:
        if (vars.enemy1HP == 15000 && vars.enemy2HP == 15000)
        {   
            vars.DebugMessage("Split 68 - Naga Queens have spawned, Leck Guarder are done with");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 69:
        if (vars.enemy1HP == 25000)
        {   
            vars.DebugMessage("Split 69 - Tio Clone has spawned, therefore Naga Queens are done with");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}

        case 70:
        if(vars.enemy1HP == 0)
        {   
            vars.DebugMessage("Split 70 - Tio Clone defeated");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 71:
        if (vars.locationMarker1 == -28160)
        {   
            vars.DebugMessage("Split 70 - Demon's Law completed, entering Valmar's Body");
            vars.splitCount++;
            return true;
            break;
        }
        else {return false; break;}
        case 72:
        if (vars.locationMarker1 == -26624)
        {   
            vars.DebugMessage("Split 71 - Valmar's Body completed, entering Valmar's Core");
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
    else
    {
        vars.DebugMessage("Boss splits are enabled, using boss splits.");
        switch ((int)vars.splitCount)
        {
            case 0:
                if (vars.enemy1HP == 380 && vars.enemy2HP == 380)
                {
                    vars.DebugMessage("Split 1 - Gargoyles fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 1:
                if (vars.enemy1HP == 0 && vars.enemy2HP == 0)
                {
                    vars.DebugMessage("Split 2 - Gargoyles fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 2:
                if (vars.enemy1HP == 4200)
                {
                    vars.DebugMessage("Split 3 - Minotaur fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 3:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 4 - Minotaur fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 4:
                if (vars.enemy1HP == 4800)
                {
                    vars.DebugMessage("Split 5 - Beast-Man fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 5:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 6 - Beast-Man fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 6:
                if (vars.enemy1HP == 8000)
                {
                    vars.DebugMessage("Split 7 - Tongue of Valmar fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 7:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 8 - Tongue of Valmar fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 8:
                if (vars.enemy1HP == 3000)
                {
                    vars.DebugMessage("Split 9 - Eyeball Bat fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 9:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 10 - Eyeball Bat fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 10:
                if (vars.enemy1HP == 12000)
                {
                    vars.DebugMessage("Split 11 - Eye of Valmar fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 11:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 12 - Eye of Valmar fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 12:
                if (vars.enemy1HP == 14000)
                {
                    vars.DebugMessage("Split 13 - Claw of Valmar fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 13:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 14 - Claw of Valmar fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 14:
                if (vars.enemy1HP == 9800 && vars.enemy2HP == 9800)
                {
                    vars.DebugMessage("Split 15 - Crimson Tail fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 15:
                if (vars.enemy1HP == 0 && vars.enemy2HP == 0)
                {
                    vars.DebugMessage("Split 16 - Crimson Tail fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 16: // melfic
                if (vars.enemy1HP == 19000 && vars.enemy2HP == 11000 && vars.enemy3HP == 13000)
                {
                    vars.DebugMessage("Split 17 - Melfice fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 17:
                if (vars.enemy1HP == 0 && vars.enemy2HP == 0 && vars.enemy3HP == 0)
                {
                    vars.DebugMessage("Split 18 - Melfice fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 18:
                if (vars.enemy1HP == 17000)
                {
                    vars.DebugMessage("Split 19 - Leck Guarder fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 19:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 20 - Leck Guarder fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 20:
                if (vars.enemy1HP == 15000 && vars.enemy2HP == 15000)
                {
                    vars.DebugMessage("Split 21 - Naga Queens fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 21:
                if (vars.enemy1HP == 0 && vars.enemy2HP == 0)
                {
                    vars.DebugMessage("Split 22 - Naga Queens fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 22:
                if (vars.enemy1HP == 25000)
                {
                    vars.DebugMessage("Split 23 - Tio Clone fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 23:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 24 - Tio Clone fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 24:
                if (vars.enemy1HP == 24000)
                {
                    vars.DebugMessage("Split 25 - Valmar's Body fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 25:
                if (vars.enemy1HP == 22000 || vars.enemy1HP == 21000)
                {
                    vars.DebugMessage("Split 26 - Valmar Heart fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 26:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 27 - Valmar Heart fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 27:
                if (vars.enemy1HP == 28000)
                {
                    vars.DebugMessage("Split 28 - Egg Guardian fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 28:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 29 - Egg Guardian fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 29:
                if (vars.enemy1HP == 19000)
                {
                    vars.DebugMessage("Split 30 - Dual Fist fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 30:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 31 - Dual Fist fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 31:
                if (vars.enemy1HP == 17000)
                {
                    vars.DebugMessage("Split 32 - Guardian fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 32:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 33 - Guardian fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 33:
                if (vars.enemy1HP == 20000)
                {
                    vars.DebugMessage("Split 34 - Valmar Magna & Moths fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 34:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 35 - Valmar Magna & Moths fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 35:
                if (vars.enemy1HP == 20000 && vars.enemy2HP == 20000)
                {
                    vars.DebugMessage("Split 36 - Valmar Magna x2 fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 36:
                if (vars.enemy1HP == 0 && vars.enemy2HP == 0)
                {
                    vars.DebugMessage("Split 37 - Valmar Magna x2 fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 37:
                if (vars.enemy1HP == 48000)
                {
                    vars.DebugMessage("Split 38 - Core of Valmar fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 38:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 39 - Core of Valmar fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 39:
                if (vars.enemy1HP == 25000)
                {
                    vars.DebugMessage("Split 40 - Millenia #2 fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 40:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 41 - Millenia #2 fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 41:
                if (vars.enemy1HP == 30000)
                {
                    vars.DebugMessage("Split 42 - Tongue of Valmar #2 fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 42:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 43 - Tongue of Valmar #2 fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 43:
                if (vars.enemy1HP == 20000)
                {
                    vars.DebugMessage("Split 44 - Eye of Valmar fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 44:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 45 - Eye of Valmar fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 45:
                if (vars.enemy1HP == 25000)
                {
                    vars.DebugMessage("Split 46 - Heart of Valmar fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 46:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 47 - Heart of Valmar fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 47:
                if (vars.enemy1HP == 36000)
                {
                    vars.DebugMessage("Split 48 - Zera Valmar fight started");
                    vars.splitCount++;
                    return true;
                }
                break;
            case 48:
                if (vars.enemy1HP == 0)
                {
                    vars.DebugMessage("Split 49 - Zera Valmar fight completed");
                    vars.splitCount++;
                    return true;
                }
                break;
            default:
                vars.DebugMessage("No more boss splits available.");
                return false;
        }
    }



/*

Here are the splits if only bosses

-Gargoyles 380                   When gargoyle health == 0, split
-Minotaur 4200                   Minotaur Health == 0
-Beast-Man 4800                 Ends when mareg health == 0
-Tongue of Valmar (8000)        Ends when tongue killed
-Eyeball Bat 3000               Ends when fight over
-Eye of Valmar (12000)          Ends when Eye of Valmar HP (12000) = 0
-Claw of Valmar  14k               Ends when claw of valmar health == 0

-Crimson Tail 9800
-Melfice     Ends when Melfice fight starts (enemy 1hp = 19k, enemy 2 hp = 11k, enemy 3 hp = 13k)
-Leck Guarder (17,000 HP)
-Naga Queens (15,000 HP each)
-Tio Clone (25,000 HP)       
-Valmar's Body 24k
-Valmar Heart 22K or 21k
-Egg Guardian 28K
-Dual Fist (19,000)
-Guardian (17,000)
-Valmar Magna & Moths (20,000)
-Valmar Magna x2 (20,000)
-Core of Valmar (48,000)
-Millenia #2 (25,000)
-Tongue of Valmar #2 (30,000)
-Eye of Valmar (20,000)
-Heart of Valmar (25,000)
{New Valmar} Zera Valmar (36,000)
*/


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
-50/50 Cutscene                 Ends when the Ceceile Reef Point is enterred
{50/50} Ceceile Reef            Ends when the Ceceile Reef 1 is enterred
-Ceceile Reef                   Ends when the Ceceile Reef 2 is enterred
-Ceceile Reef 2                 Ends when the Tails battle starts (enemy 1 and 2 have hp = 9800)
-Crimson Tail                   Ends when both tails health is down from (both enemies hp = 0)
-Garlan Village                 Ends when you enter Grail Mountain Road 1
-Grail Mountain Road 1          Ends when you enter Grail Mountain Road 2
-Grail Mountain Road 2          Ends when you enter Grail Mountain Road Shrine Square
-Grail Mountain Shrine      Ends when you enter Plateau of Memories
-Plateau of Memories        Ends when Melfice fight starts (enemy 1hp = 19k, enemy 2 hp = 11k, enemy 3 hp = 13k)
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
-Tio Clone (25,000 HP)          Ends when Tio clone health == 0
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
-Recruit Roan
-Mausoleum
-Birthplace of the Gods
-Dual Fist (19,000)
-Guardian (17,000)
-Elmo
-Open Thought
{Birthplace of the Gods} Final Shopping
-New Valmar
-Valmar Magna & Moths (20,000)
-New Valmar
-Valmar Magna x2 (20,000)
-New Valmar
-Core of Valmar (48,000)
-New Valmar
-Millenia #2 (25,000)
-Room of Chaos
-Tongue of Valmar #2 (30,000)
-Room of Chaos
-Eye of Valmar (20,000)
-Room of Chaos
-Heart of Valmar (25,000)
{New Valmar} Zera Valmar (36,000)
*/

}

reset
{
    // Main Menu is vars.locationMarker == 65535, however for Phantom Skills Glitch where you need to go to the main menu, it's resetting where not needed
    // Plus press `numpad3` isn't the end of the world.
    return false;
}