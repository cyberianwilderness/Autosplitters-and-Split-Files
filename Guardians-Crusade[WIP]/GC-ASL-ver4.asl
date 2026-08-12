state("retroarch") { }

startup
{
    // Load PS1 helper (works with PCSX ReARMed on RetroArch)
    Assembly.Load(File.ReadAllBytes("Components/emu-help-v3")).CreateInstance("PS1");

    // ---- Watchers (use Make<> so Old/Current work automatically) ----
    vars.HP      = vars.Helper.Make<short>(0x801CD79C);
    vars.PP      = vars.Helper.Make<short>(0x801CD79E);
    vars.MaxHP   = vars.Helper.Make<short>(0x801CD7A0);
    vars.MaxPP   = vars.Helper.Make<short>(0x801CD7A2);

    vars.Level   = vars.Helper.Make<short>(0x801CD7A4);
    vars.Agi     = vars.Helper.Make<short>(0x801CD7A6);
    vars.Str     = vars.Helper.Make<short>(0x801CD7A8);
    vars.Power   = vars.Helper.Make<short>(0x801CD7AA);
    vars.Luck    = vars.Helper.Make<short>(0x801CD7AE);

    vars.Exp     = vars.Helper.Make<int>(0x801CD7B4);

    vars.LoadMap = vars.Helper.Make<short>(0x801CE852);
    vars.MapId   = vars.Helper.Make<short>(0x801CE854);

    vars.PauseCursor   = vars.Helper.Make<byte>(0x801C6BBF);

    vars.BattleStatus  = vars.Helper.Make<byte>(0x801CD1D0);
    vars.ItemDropped   = vars.Helper.Make<short>(0x801CD4A0);

    vars.EnemyFormation = vars.Helper.Make<int>(0x801CE9E0);
    vars.EnemyCount     = vars.Helper.Make<byte>(0x801CE9E8);

    vars.Enemy1HP       = vars.Helper.Make<short>(0x801CEA0A);
    vars.Enemy2HP       = vars.Helper.Make<short>(0x801CEA36);

    vars.Rubies         = vars.Helper.Make<int>(0x801B5518);
    vars.SaveTime       = vars.Helper.Make<int>(0x801CD874);

    // Baby
    vars.BabyHP   = vars.Helper.Make<short>(0x801CD7C4);
    vars.BabyLvl  = vars.Helper.Make<short>(0x801CD7CC);
    vars.BabyLuck = vars.Helper.Make<short>(0x801CD7D6);
    vars.BabyExp  = vars.Helper.Make<uint>(0x801CD7DC);

    // Inventory slots 1–20 (0x801B53F0 + 2*(slot-1))
    vars.Inv01 = vars.Helper.Make<short>(0x801B53F0);
    vars.Inv02 = vars.Helper.Make<short>(0x801B53F2);
    vars.Inv03 = vars.Helper.Make<short>(0x801B53F4);
    vars.Inv04 = vars.Helper.Make<short>(0x801B53F6);
    vars.Inv05 = vars.Helper.Make<short>(0x801B53F8);
    vars.Inv06 = vars.Helper.Make<short>(0x801B53FA);
    vars.Inv07 = vars.Helper.Make<short>(0x801B53FC);
    vars.Inv08 = vars.Helper.Make<short>(0x801B53FE);
    vars.Inv09 = vars.Helper.Make<short>(0x801B5400);
    vars.Inv10 = vars.Helper.Make<short>(0x801B5402);
    vars.Inv11 = vars.Helper.Make<short>(0x801B5404);
    vars.Inv12 = vars.Helper.Make<short>(0x801B5406);
    vars.Inv13 = vars.Helper.Make<short>(0x801B5408);
    vars.Inv14 = vars.Helper.Make<short>(0x801B540A);
    vars.Inv15 = vars.Helper.Make<short>(0x801B540C);
    vars.Inv16 = vars.Helper.Make<short>(0x801B540E);
    vars.Inv17 = vars.Helper.Make<short>(0x801B5410);
    vars.Inv18 = vars.Helper.Make<short>(0x801B5412);
    vars.Inv19 = vars.Helper.Make<short>(0x801B5414);
    vars.Inv20 = vars.Helper.Make<short>(0x801B5416);

    // Junk slots 1–20 (0x801B5418 + 2*(slot-1))
    vars.Junk01 = vars.Helper.Make<short>(0x801B5418);
    vars.Junk02 = vars.Helper.Make<short>(0x801B541A);
    vars.Junk03 = vars.Helper.Make<short>(0x801B541C);
    vars.Junk04 = vars.Helper.Make<short>(0x801B541E);
    vars.Junk05 = vars.Helper.Make<short>(0x801B5420);
    vars.Junk06 = vars.Helper.Make<short>(0x801B5422);
    vars.Junk07 = vars.Helper.Make<short>(0x801B5424);
    vars.Junk08 = vars.Helper.Make<short>(0x801B5426);
    vars.Junk09 = vars.Helper.Make<short>(0x801B5428);
    vars.Junk10 = vars.Helper.Make<short>(0x801B542A);
    vars.Junk11 = vars.Helper.Make<short>(0x801B542C);
    vars.Junk12 = vars.Helper.Make<short>(0x801B542E);
    vars.Junk13 = vars.Helper.Make<short>(0x801B5430);
    vars.Junk14 = vars.Helper.Make<short>(0x801B5432);
    vars.Junk15 = vars.Helper.Make<short>(0x801B5434);
    vars.Junk16 = vars.Helper.Make<short>(0x801B5436);
    vars.Junk17 = vars.Helper.Make<short>(0x801B5438);
    vars.Junk18 = vars.Helper.Make<short>(0x801B543A);
    vars.Junk19 = vars.Helper.Make<short>(0x801B543C);
    vars.Junk20 = vars.Helper.Make<short>(0x801B543E);
}

update
{
    // Never crash the script; if it crashes, VarViewer greys out.
    try
    {
        if (!vars.Helper.Update())
            return false;
    }
    catch
    {
        return false;
    }

    // Expose values to ASLVarViewer via CURRENT STATE
    current.HP     = vars.HP.Current;
    current.PP     = vars.PP.Current;
    current.MaxHP  = vars.MaxHP.Current;
    current.MaxPP  = vars.MaxPP.Current;

    current.Level  = vars.Level.Current;
    current.Agi    = vars.Agi.Current;
    current.Str    = vars.Str.Current;
    current.Power  = vars.Power.Current;
    current.Luck   = vars.Luck.Current;

    current.Exp    = vars.Exp.Current;

    current.LoadMapId = vars.LoadMap.Current;
    current.MapId     = vars.MapId.Current;

    current.PauseCursor  = vars.PauseCursor.Current;

    current.BattleStatus = vars.BattleStatus.Current;
    current.ItemDropped  = vars.ItemDropped.Current;

    current.EnemyFormation = vars.EnemyFormation.Current;
    current.EnemyCount     = vars.EnemyCount.Current;
    current.Enemy1HP       = vars.Enemy1HP.Current;
    current.Enemy2HP       = vars.Enemy2HP.Current;

    current.Rubies   = vars.Rubies.Current;
    current.SaveTime = vars.SaveTime.Current;

    current.BabyHP   = vars.BabyHP.Current;
    current.BabyLvl  = vars.BabyLvl.Current;
    current.BabyLuck = vars.BabyLuck.Current;
    current.BabyExp  = vars.BabyExp.Current;

    // Inventory/Junk raw 16-bit values
    current.Inv01 = vars.Inv01.Current;  current.Inv02 = vars.Inv02.Current;
    current.Inv03 = vars.Inv03.Current;  current.Inv04 = vars.Inv04.Current;
    current.Inv05 = vars.Inv05.Current;  current.Inv06 = vars.Inv06.Current;
    current.Inv07 = vars.Inv07.Current;  current.Inv08 = vars.Inv08.Current;
    current.Inv09 = vars.Inv09.Current;  current.Inv10 = vars.Inv10.Current;
    current.Inv11 = vars.Inv11.Current;  current.Inv12 = vars.Inv12.Current;
    current.Inv13 = vars.Inv13.Current;  current.Inv14 = vars.Inv14.Current;
    current.Inv15 = vars.Inv15.Current;  current.Inv16 = vars.Inv16.Current;
    current.Inv17 = vars.Inv17.Current;  current.Inv18 = vars.Inv18.Current;
    current.Inv19 = vars.Inv19.Current;  current.Inv20 = vars.Inv20.Current;

    current.Junk01 = vars.Junk01.Current;  current.Junk02 = vars.Junk02.Current;
    current.Junk03 = vars.Junk03.Current;  current.Junk04 = vars.Junk04.Current;
    current.Junk05 = vars.Junk05.Current;  current.Junk06 = vars.Junk06.Current;
    current.Junk07 = vars.Junk07.Current;  current.Junk08 = vars.Junk08.Current;
    current.Junk09 = vars.Junk09.Current;  current.Junk10 = vars.Junk10.Current;
    current.Junk11 = vars.Junk11.Current;  current.Junk12 = vars.Junk12.Current;
    current.Junk13 = vars.Junk13.Current;  current.Junk14 = vars.Junk14.Current;
    current.Junk15 = vars.Junk15.Current;  current.Junk16 = vars.Junk16.Current;
    current.Junk17 = vars.Junk17.Current;  current.Junk18 = vars.Junk18.Current;
    current.Junk19 = vars.Junk19.Current;  current.Junk20 = vars.Junk20.Current;

    return true;
}

start { return false; }
split { return false; }
reset { return false; }