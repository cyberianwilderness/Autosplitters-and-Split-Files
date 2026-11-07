// Light Fairytale Episode 1 — autosplitter
// Unity 2020.3.28f1, Mono x64, Beebyte-obfuscated (names below are stable only for the current Steam build).
//
// The game keeps every save variable as a string key/value pair in an ArrayList ("store A"):
//   XFramework.XMain.FBGHEPGPBEB (static MainScript) .CJBIINDGENG .JLAIHKJENBG .FMDMNLAKAHG
//   entries: JFEIILPGOHC { key @ECLPOIDPJMK, value @ENKOOHPGOCO }   event flags are "1"/"0"
//
// Battle:        MainScript.HJDAHBOIBLI (battle) .DELIMDNBBLP = ArrayList of enemy units (GDLHMLBFFDP : JAIPHLCHKOB)
//                unit.EIOHAOIIIME = current HP, unit.CJBIINDGENG -> enemy def { ECLPOIDPJMK id, AJAAMCPAFDK max HP }
//                ASL Var Viewer: current.BossName/BossHP/BossMaxHP/BossDamage/BossHPPercent, EnemyCount/EnemiesHP/EnemiesMaxHP/EnemiesDamage
//                "Boss" = the enemy with the highest max HP in the current fight.
// Start / reset: New Game creates a fresh, EMPTY store A. Loading a save creates one that's already full,
//                and quitting to the title keeps the old one, so neither triggers.
// Splits:        a flag becoming "1" in store A. Each split fires once per run, so reloads/backtracking are safe.
//                Flags present in a save you load are never split on.
// IGT:           MainScript keeps play time live: COEFDDAPNFF (int s, total at last save) + BKDBNBOGACE (int s since)
//                + LBBFFJAOIEG (float fraction of the current second). It counts while MainScript.CDPKAEKLBAF is true.
//                Reloading rolls it back to the save's value, so Game Time here only adds up positive deltas:
//                time lost to a wipe/reload stays on the timer, the same as RTA.

state("Light Fairytale Episode 1") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Light Fairytale Episode 1";

    // setting id, parent, default, label, flags that trigger it
    var defs = new List<Tuple<string, string, bool, string, string[]>>
    {
        Tuple.Create("area0", (string)null, true, "Lower City / Area 0", new string[0]),
        Tuple.Create("first_battle",   "area0", false, "First battle (spiders)",              new[] { "event_battlezone_cleared_env_12_1" }),
        Tuple.Create("spider_queen",   "area0", true,  "Spider Queen",                        new[] { "event_battlezone_cleared_env_12_1b" }),
        Tuple.Create("city",           "area0", false, "Reach the city (Back Alley)",         new[] { "event_env_13_city" }),
        Tuple.Create("id_card",        "area0", true,  "Get the ID card",                     new[] { "event_env_13_id_get" }),
        Tuple.Create("job",            "area0", false, "Get the job",                         new[] { "event_env_13_job" }),
        Tuple.Create("kid_game",       "area0", false, "Kid's game: find Kid the 3rd time",   new[] { "event_env_12_kid_game_found3" }),
        Tuple.Create("area0_battle",   "area0", false, "Area 0 battle",                       new[] { "event_battlezone_cleared_env_12_2a" }),
        Tuple.Create("warehouse",      "area0", true,  "Enter the warehouse",                 new[] { "location_level0_exit" }),

        Tuple.Create("wh1", (string)null, true, "Warehouse", new string[0]),
        Tuple.Create("floor2",         "wh1", false, "Floor 2",                               new[] { "location_level0_floor2" }),
        Tuple.Create("station",        "wh1", false, "Station",                               new[] { "location_level0_station" }),
        Tuple.Create("sewers",         "wh1", false, "Sewers",                                new[] { "location_level0_sewers" }),
        Tuple.Create("sewers_ext",     "wh1", false, "Sewers exterior",                       new[] { "location_level0_sewers_ext" }),
        Tuple.Create("giant_rat",      "wh1", true,  "Giant Rat",                             new[] { "event_battlezone_cleared_env_14_420" }),
        Tuple.Create("low_area",       "wh1", true,  "Reach the Low Area",                    new[] { "location_lowarea" }),

        Tuple.Create("la", (string)null, true, "Low Area", new string[0]),
        Tuple.Create("super_bomb",     "la", true,  "Get the super bomb",                     new[] { "event_env_15_got_super_bomb" }),

        Tuple.Create("wh2", (string)null, true, "Warehouse (return)", new string[0]),
        Tuple.Create("use_bomb",       "wh2", false, "Use the super bomb",                    new[] { "event_env_14_used_super_bomb" }),
        Tuple.Create("storage_boss",   "wh2", true,  "Storage boss",                          new[] { "event_battlezone_cleared_env_14_150" }),
        Tuple.Create("bomb_parts",     "wh2", false, "Get the bomb parts",                    new[] { "event_env_14_got_bomb_parts" }),
        Tuple.Create("parts_choice",   "wh2", false, "Give or keep the bomb parts",           new[] { "event_env_14_gave_bomb_parts", "event_env_14_kept_bomb_parts" }),
        Tuple.Create("sewers_gate",    "wh2", false, "Open the sewers gate",                  new[] { "event_env_14_sewers_gate_open" }),
        Tuple.Create("corridor",       "wh2", false, "Corridor minigame",                     new[] { "event_env_14_corridor_minigame_end" }),
        Tuple.Create("final_boss",     "wh2", true,  "Final boss (end of run)",               new[] { "event_battlezone_cleared_env_14_500" }),

        Tuple.Create("igt", (string)null, true, "Game Time = in-game play time (compare against Game Time to use it)", new string[0]),
        Tuple.Create("igt_debug", "igt", false, "Log the play-time counters every 5 seconds (DebugView)", new string[0]),
        Tuple.Create("flag_debug", (string)null, false, "Log every flag the game sets (DebugView)", new string[0]),
        Tuple.Create("any_battlezone", (string)null, false, "Split on every other battle zone cleared", new string[0]),
    };

    vars.FlagToSetting = new Dictionary<string, string>();
    foreach (var d in defs)
    {
        settings.Add(d.Item1, d.Item3, d.Item4, d.Item2);
        foreach (var f in d.Item5) vars.FlagToSetting[f] = d.Item1;
    }
    settings.SetToolTip("any_battlezone", "Any event_battlezone_cleared_* flag not already covered above. Most are optional fights.");

    vars.Completed = new HashSet<string>();
    vars.Pending   = new Queue<string>();
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var xmain = mono["MainScript", 1]; // FBGHEPGPBEB is declared on parent class XFramework.XMain
        var main  = mono["MainScript"];
        var state = mono["EOBEIIKOAEJ"];
        var store = mono["JPHMOOOAOMC"];
        var entry = mono["JFEIILPGOHC"];

        vars.Helper["storeA"] = xmain.Make<IntPtr>("FBGHEPGPBEB", main["CJBIINDGENG"], state["JLAIHKJENBG"], store["FMDMNLAKAHG"]);
        vars.Helper["ptTotal"]   = xmain.Make<int>("FBGHEPGPBEB", main["COEFDDAPNFF"]);
        vars.Helper["ptPending"] = xmain.Make<int>("FBGHEPGPBEB", main["BKDBNBOGACE"]);
        vars.Helper["ptFrac"]    = xmain.Make<float>("FBGHEPGPBEB", main["LBBFFJAOIEG"]);
        vars.Helper["ptOn"]      = xmain.Make<bool>("FBGHEPGPBEB", main["CDPKAEKLBAF"]);
        var battle = mono["BNOPDEFBMKH"];
        var unit   = mono["JAIPHLCHKOB"];
        var def    = mono["CGCAAGHMACF"];
        vars.Helper["enemies"] = xmain.Make<IntPtr>("FBGHEPGPBEB", main["HJDAHBOIBLI"], battle["DELIMDNBBLP"]);
        vars.UnitHp   = (int)unit["EIOHAOIIIME"];
        vars.UnitDef  = (int)unit["CJBIINDGENG"];
        vars.DefId    = (int)def["ECLPOIDPJMK"];
        vars.DefMaxHp = (int)def["AJAAMCPAFDK"];

        vars.EntryKey   = (int)entry["ECLPOIDPJMK"];
        vars.EntryValue = (int)entry["ENKOOHPGOCO"];
        return true;
    });

    vars.ReadMonoString = (Func<IntPtr, string>)(p =>
    {
        if (p == IntPtr.Zero) return null;
        int len = game.ReadValue<int>(p + 0x10);
        if (len == 0) return "";
        if (len < 0 || len > 512) return null;
        return game.ReadString(p + 0x14, ReadStringType.UTF16, len * 2);
    });

    // Per-store caches. Mono strings are immutable, so an entry's value only needs re-reading when its pointer changes.
    vars.KeyCache    = new Dictionary<long, string>();
    vars.ValPtrCache = new Dictionary<long, long>();
    vars.Values      = new Dictionary<string, string>();
    vars.NewFlags    = new List<string>();
    vars.Count       = -1;

    // ArrayList (Mono, refs first): _items @0x10, _size @0x20. object[] data @0x20.
    vars.Scan = (Func<IntPtr, int>)(list =>
    {
        var newly = (List<string>)vars.NewFlags;
        newly.Clear();
        if (list == IntPtr.Zero) return -1;

        IntPtr items = game.ReadPointer(list + 0x10);
        int size = game.ReadValue<int>(list + 0x20);
        if (items == IntPtr.Zero || size < 0 || size > 8192) return -1;
        if (size == 0) return 0;

        byte[] raw = game.ReadBytes(items + 0x20, size * 8);
        if (raw == null) return -1;

        var keys  = (Dictionary<long, string>)vars.KeyCache;
        var vptrs = (Dictionary<long, long>)vars.ValPtrCache;
        var vals  = (Dictionary<string, string>)vars.Values;
        int keyOff = (int)vars.EntryKey, valOff = (int)vars.EntryValue;

        for (int i = 0; i < size; i++)
        {
            long e = BitConverter.ToInt64(raw, i * 8);
            if (e == 0) continue;
            var ep = new IntPtr(e);

            string key;
            if (!keys.TryGetValue(e, out key))
            {
                key = vars.ReadMonoString(game.ReadPointer(ep + keyOff));
                if (key == null) continue;
                keys[e] = key;
            }

            long vp = game.ReadValue<long>(ep + valOff);
            long cachedVp;
            if (vptrs.TryGetValue(e, out cachedVp) && cachedVp == vp) continue;
            vptrs[e] = vp;

            string v = vars.ReadMonoString(new IntPtr(vp)) ?? "";
            string prevV;
            bool had = vals.TryGetValue(key, out prevV);
            vals[key] = v;
            if (v == "1" && (!had || prevV != "1")) newly.Add(key);
        }
        return size;
    });

    vars.NewGameArmed = false;
    current.BossName = ""; current.BossHP = 0; current.BossMaxHP = 0; current.BossDamage = 0; current.BossHPPercent = 0.0;
    current.EnemyCount = 0; current.EnemiesHP = 0; current.EnemiesMaxHP = 0; current.EnemiesDamage = 0;
    vars.Igt = 0.0;
    vars.LastLive = -1.0;
    vars.LastIgtLog = DateTime.MinValue;
    refreshRate = 30;
}

update
{
    // ---- battle / boss HP ----
    {
        string bossName = ""; int bossHp = 0, bossMax = 0, count = 0, totHp = 0, totMax = 0;
        IntPtr list = current.enemies;
        if (list != IntPtr.Zero)
        {
            IntPtr items = game.ReadPointer(list + 0x10);
            int n = game.ReadValue<int>(list + 0x20);
            if (items != IntPtr.Zero && n > 0 && n <= 16)
            {
                for (int i = 0; i < n; i++)
                {
                    IntPtr u = game.ReadPointer(items + 0x20 + i * 8);
                    if (u == IntPtr.Zero) continue;
                    IntPtr d = game.ReadPointer(u + (int)vars.UnitDef);
                    if (d == IntPtr.Zero) continue;
                    int hp  = Math.Max(0, game.ReadValue<int>(u + (int)vars.UnitHp));
                    int max = game.ReadValue<int>(d + (int)vars.DefMaxHp);
                    if (max <= 0 || max > 10000000) continue;
                    count++; totHp += hp; totMax += max;
                    if (max > bossMax)
                    {
                        bossMax = max; bossHp = hp;
                        bossName = vars.ReadMonoString(game.ReadPointer(d + (int)vars.DefId)) ?? "";
                    }
                }
            }
        }
        current.BossName      = bossName;
        current.BossHP        = bossHp;
        current.BossMaxHP     = bossMax;
        current.BossDamage    = bossMax - bossHp;
        current.BossHPPercent = bossMax > 0 ? Math.Round(100.0 * bossHp / bossMax, 1) : 0.0;
        current.EnemyCount    = count;
        current.EnemiesHP     = totHp;
        current.EnemiesMaxHP  = totMax;
        current.EnemiesDamage = totMax - totHp;
        if (current.BossName != old.BossName && current.BossName != "")
            print(string.Format("[LF1] battle: boss={0} {1}/{2} HP, {3} enemies", current.BossName, current.BossHP, current.BossMaxHP, count));
    }

    // in-game play time, accumulated as positive deltas only (reload rollbacks and save-load jumps are ignored)
    double live = current.ptTotal + current.ptPending + current.ptFrac;
    if (vars.LastLive >= 0)
    {
        double d = live - vars.LastLive;
        if (d > 0 && d < 5) vars.Igt += d;
    }
    vars.LastLive = live;
    if (settings["igt_debug"] && (DateTime.Now - vars.LastIgtLog).TotalSeconds >= 5)
    {
        vars.LastIgtLog = DateTime.Now;
        print(string.Format("[LF1] playtime total={0} pending={1} frac={2:0.00} counting={3} | timer IGT={4:0.00}",
            current.ptTotal, current.ptPending, current.ptFrac, current.ptOn, vars.Igt));
    }

    vars.StoreSwapped = current.storeA != old.storeA;
    if (vars.StoreSwapped)
    {
        // New Game or a save load: start over with a clean cache. The first scan only builds the baseline.
        vars.KeyCache.Clear();
        vars.ValPtrCache.Clear();
        vars.Values.Clear();
    }

    vars.Count = vars.Scan(current.storeA);

    if (vars.StoreSwapped)
    {
        vars.NewGameArmed = current.storeA != IntPtr.Zero && vars.Count == 0;
        print(string.Format("[LF1] store A swapped: 0x{0:X} ({1} entries){2}", ((IntPtr)current.storeA).ToInt64(), vars.Count, vars.NewGameArmed ? " -> New Game" : ""));
        return true;
    }
    if (vars.Count > 0) vars.NewGameArmed = false;

    var map = (Dictionary<string, string>)vars.FlagToSetting;
    foreach (string flag in vars.NewFlags)
    {
        if (settings["flag_debug"]) print("[LF1] flag: " + flag);
        string id;
        if (map.TryGetValue(flag, out id))
        {
            if (!settings[id]) continue;
        }
        else if (flag.StartsWith("event_battlezone_cleared_") && settings["any_battlezone"]) id = flag;
        else continue;

        if (vars.Completed.Add(id))
        {
            print("[LF1] split: " + id + " (" + flag + ")");
            vars.Pending.Enqueue(id);
        }
    }
}

start
{
    return vars.NewGameArmed && vars.Count == 0;
}

onStart
{
    vars.Igt = 0.0;
    vars.Completed.Clear();
    vars.Pending.Clear();
    vars.NewGameArmed = false;
}

split
{
    if (vars.Pending.Count > 0)
    {
        vars.Pending.Dequeue();
        return true;
    }
}

reset
{
    // a fresh empty store A only appears on New Game
    return vars.StoreSwapped && current.storeA != IntPtr.Zero && vars.Count == 0;
}

isLoading
{
    return settings["igt"];
}

gameTime
{
    if (settings["igt"]) return TimeSpan.FromSeconds(vars.Igt);
}
