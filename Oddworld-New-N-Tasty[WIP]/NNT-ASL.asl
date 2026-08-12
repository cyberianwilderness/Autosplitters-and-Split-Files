state("NNT") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    print("[NNT] startup complete");

    // --------------------
    // MODES
    // --------------------
    settings.Add("modes", true, "Modes");
    settings.Add("main_simple", false, "Main Game - Simple Splits", "modes");
    settings.Add("main_detailed", true, "Main Game - Detailed Splits", "modes");
    settings.Add("il_mode", false, "Individual Level Mode", "modes");

    // For simple mode + ambiguous IL endings.
    settings.Add("route_order", true, "Simple/IL Route Order");
    settings.Add("scrabania_first", false, "Scrabania First (unticked = Paramonia First)", "route_order");

    // --------------------
    // SIMPLE SPLITS
    // --------------------
    settings.Add("simple_group", true, "Simple Splits");
    settings.Add("s_rf", true, "Rupture Farms", "simple_group");
    settings.Add("s_stock", true, "Stockyards", "simple_group");
    settings.Add("s_mon", true, "Monsaic Lines", "simple_group");
    settings.Add("s_para", true, "Paramonia", "simple_group");
    settings.Add("s_para_temple", true, "Paramonian Temple", "simple_group");
    settings.Add("s_para_nests", true, "Paramonian Nests", "simple_group");
    settings.Add("s_scrab", true, "Scrabania", "simple_group");
    settings.Add("s_scrab_temple", true, "Scrabanian Temple", "simple_group");
    settings.Add("s_scrab_nests", true, "Scrabanian Nests", "simple_group");
    settings.Add("s_ffz", true, "Free-Fire Zone", "simple_group");
    settings.Add("s_z1", true, "Zulag 1", "simple_group");
    settings.Add("s_z2", true, "Zulag 2", "simple_group");
    settings.Add("s_z3", true, "Zulag 3", "simple_group");
    settings.Add("s_z4", true, "Zulag 4", "simple_group");
    settings.Add("s_boardroom_final", true, "The Boardroom (final movie split)", "simple_group");

    // --------------------
    // DETAILED SPLITS
    // --------------------
    settings.Add("detailed_group", true, "Detailed Splits");

    // Early game
    settings.Add("d_rf1", true, "Rupture Farms - Tutorials", "detailed_group");
    settings.Add("d_rf2", true, "Rupture Farms - Meat Grinders", "detailed_group");
    settings.Add("d_rf3", true, "Rupture Farms - Exit", "detailed_group");
    settings.Add("d_stock1", true, "Stockyards", "detailed_group");
    settings.Add("d_stock2", true, "Free Fire Zone", "detailed_group");
    settings.Add("d_mon1", true, "Monsaic Lines - Natives", "detailed_group");
    settings.Add("d_mon2", true, "Monsaic 2", "detailed_group");
    settings.Add("d_mon3", true, "Monsaic 3", "detailed_group");

    // Paramonia branch
    settings.Add("d_para1", true, "Paramonia - Get Elum", "detailed_group");
    settings.Add("d_para2", true, "Paramonia - Honey and Sligs", "detailed_group");
    settings.Add("d_para3", true, "Paramonia - Platforms and Bees", "detailed_group");
    settings.Add("d_para4", true, "Paramonia 4 - Passwords and Bees", "detailed_group");
    settings.Add("d_paraTempleEntry", true, "Paramonia Temple Entry", "detailed_group");
    settings.Add("d_paraT1", true, "Paramonia Trial 1", "detailed_group");
    settings.Add("d_paraT2", true, "Paramonia Trial 2", "detailed_group");
    settings.Add("d_paraT3", true, "Paramonia Trial 3", "detailed_group");
    settings.Add("d_paraT4", true, "Paramonia Trial 4", "detailed_group");
    settings.Add("d_paraT5", true, "Paramonia Trial 5", "detailed_group");
    settings.Add("d_paraT6", true, "Paramonia Trial 6", "detailed_group");
    settings.Add("d_paraN1", true, "Paramonia Nests 1", "detailed_group");
    settings.Add("d_paraN2", true, "Paramonia Nests 2", "detailed_group");
    settings.Add("d_monReturn1", true, "Monsaic Return 1", "detailed_group");

    // Scrabania branch
    settings.Add("d_scrab1", true, "Scrabania - Get Elum", "detailed_group");
    settings.Add("d_scrab2", true, "Scrabania 2", "detailed_group");
    settings.Add("d_scrab3", true, "Scrabania 3", "detailed_group");
    settings.Add("d_scrab4", true, "Scrabania 4", "detailed_group");
    settings.Add("d_scrabTempleEntry", true, "Scrabania Temple Entry", "detailed_group");
    settings.Add("d_scrabT1", true, "Scrabania Trial 1", "detailed_group");
    settings.Add("d_scrabT2", true, "Scrabania Trial 2", "detailed_group");
    settings.Add("d_scrabT3", true, "Scrabania Trial 3", "detailed_group");
    settings.Add("d_scrabT4", true, "Scrabania Trial 4", "detailed_group");
    settings.Add("d_scrabT5", true, "Scrabania Trial 5", "detailed_group");
    settings.Add("d_scrabT6", true, "Scrabania Trial 6", "detailed_group");
    settings.Add("d_scrabT7", true, "Scrabania Trial 7", "detailed_group");
    settings.Add("d_scrabT8", true, "Scrabania Trial 8", "detailed_group");
    settings.Add("d_scrabN1", true, "Scrabania Nests", "detailed_group");
    settings.Add("d_scrabN2", true, "Scrabania Exit", "detailed_group");

    // Late game
    settings.Add("d_ffz_return", true, "Free Fire Zone", "detailed_group");
    settings.Add("d_z1_1", true, "Zulag 1 Entrance", "detailed_group");
    settings.Add("d_z1_2", true, "Zulag 1", "detailed_group");
    settings.Add("d_z2_entry", true, "Zulag 2 Entry", "detailed_group");
    settings.Add("d_z2_a", true, "Zulag 2 Room 1", "detailed_group");
    settings.Add("d_z2_b", true, "Zulag 2 Room 2", "detailed_group");
    settings.Add("d_z2_c", true, "Zulag 2 Room 3", "detailed_group");
    settings.Add("d_z3_entry", true, "Zulag 3 Entry", "detailed_group");
    settings.Add("d_z3_a", true, "Zulag 3 Room 1", "detailed_group");
    settings.Add("d_z3_b", true, "Zulag 3 Room 2", "detailed_group");
    settings.Add("d_z3_c", true, "Zulag 3 Room 3", "detailed_group");
    settings.Add("d_z4_1", true, "Zulag 4 Entrance", "detailed_group");
    settings.Add("d_z4_2", true, "Zulag 4 Slig Area", "detailed_group");
    settings.Add("d_kennels", true, "Zulag 4 - Enter Slog Kennels", "detailed_group");
    settings.Add("d_z4_back1", true, "Zulag 4 - Leave Slog Kennels", "detailed_group");
    settings.Add("d_z4_back2", true, "Zulag 4 - Enter Second Part", "detailed_group");
    settings.Add("d_z4_end", true, "Zulag 4 - Sligs and Slogs", "detailed_group");
    settings.Add("d_boardroom_final", true, "Boardroom", "detailed_group");

    // --------------------
    // IL SETTINGS
    // --------------------
    settings.Add("il_group", true, "Individual Levels (tick one only)");
    settings.Add("il_alf", false, "Alf Escape", "il_group");
    settings.Add("il_rf", false, "Rupture Farms", "il_group");
    settings.Add("il_stock", false, "Stockyards Escape", "il_group");
    settings.Add("il_mon", false, "Monsaic Lines", "il_group");
    settings.Add("il_para", false, "Paramonia", "il_group");
    settings.Add("il_para_temple", false, "Paramonian Temple", "il_group");
    settings.Add("il_para_nests", false, "Paramonian Nests", "il_group");
    settings.Add("il_scrab", false, "Scrabania", "il_group");
    settings.Add("il_scrab_temple", false, "Scrabanian Temple", "il_group");
    settings.Add("il_scrab_nests", false, "Scrabanian Nests", "il_group");
    settings.Add("il_ffz", false, "Free Fire Zone", "il_group");
    settings.Add("il_z1", false, "Zulag 1", "il_group");
    settings.Add("il_z2", false, "Zulag 2", "il_group");
    settings.Add("il_z3", false, "Zulag 3", "il_group");
    settings.Add("il_z4", false, "Zulag 4", "il_group");
    settings.Add("il_boardroom", false, "The Boardroom", "il_group");

    vars.Names = new Dictionary<string, string>()
    {
        // simple
        { "s_rf", "Rupture Farms" },
        { "s_stock", "Stockyards" },
        { "s_mon", "Monsaic Lines" },
        { "s_para", "Paramonia" },
        { "s_para_temple", "Paramonian Temple" },
        { "s_para_nests", "Paramonian Nests" },
        { "s_scrab", "Scrabania" },
        { "s_scrab_temple", "Scrabanian Temple" },
        { "s_scrab_nests", "Scrabanian Nests" },
        { "s_ffz", "Free-Fire Zone" },
        { "s_z1", "Zulag 1" },
        { "s_z2", "Zulag 2" },
        { "s_z3", "Zulag 3" },
        { "s_z4", "Zulag 4" },
        { "s_boardroom_final", "The Boardroom" },

        // detailed
        { "d_rf1", "Rupture Farms - 1" },
        { "d_rf2", "Rupture Farms - 2" },
        { "d_rf3", "Rupture Farms - 3" },
        { "d_stock1", "Stockyards" },
        { "d_stock2", "Free Fire Zone (first pass)" },
        { "d_mon1", "Monsaic 1" },
        { "d_mon2", "Monsaic 2" },
        { "d_mon3", "Monsaic 3" },

        { "d_para1", "Paramonia 1" },
        { "d_para2", "Paramonia 2" },
        { "d_para3", "Paramonia 3" },
        { "d_para4", "Paramonia 4" },
        { "d_paraTempleEntry", "Paramonia Temple Entry" },
        { "d_paraT1", "Paramonia Trial 1" },
        { "d_paraT2", "Paramonia Trial 2" },
        { "d_paraT3", "Paramonia Trial 3" },
        { "d_paraT4", "Paramonia Trial 4" },
        { "d_paraT5", "Paramonia Trial 5" },
        { "d_paraT6", "Paramonia Trial 6" },
        { "d_paraN1", "Paramonia Nests" },
        { "d_paraN2", "Paramonia Exit" },
        { "d_monReturn1", "Monsaic Return #1" },

        { "d_scrab1", "Scrabania 1" },
        { "d_scrab2", "Scrabania 2" },
        { "d_scrab3", "Scrabania 3" },
        { "d_scrab4", "Scrabania 4" },
        { "d_scrabTempleEntry", "Scrab Temple Entry" },
        { "d_scrabT1", "Scrabania Trial 1" },
        { "d_scrabT2", "Scrabania Trial 2" },
        { "d_scrabT3", "Scrabania Trial 3" },
        { "d_scrabT4", "Scrabania Trial 4" },
        { "d_scrabT5", "Scrabania Trial 5" },
        { "d_scrabT6", "Scrabania Trial 6" },
        { "d_scrabT7", "Scrabania Trial 7" },
        { "d_scrabT8", "Scrabania Trial 8" },
        { "d_scrabN1", "Scrabania Nests" },
        { "d_scrabN2", "Scrabania Exit" },

        { "d_ffz_return", "Free Fire Zone" },
        { "d_z1_1", "Zulag 1 Return 1" },
        { "d_z1_2", "Zulag 1 Return 2" },
        { "d_z2_entry", "Zulag 2 Entry" },
        { "d_z2_a", "Zulag 2 Room 1" },
        { "d_z2_b", "Zulag 2 Room 2" },
        { "d_z2_c", "Zulag 2 Room 3" },
        { "d_z3_entry", "Zulag 3 Entry" },
        { "d_z3_a", "Zulag 3 Room 1" },
        { "d_z3_b", "Zulag 3 Room 2" },
        { "d_z3_c", "Zulag 3 Room 3" },
        { "d_z4_1", "Zulag 4 - 1" },
        { "d_z4_2", "Zulag 4 - 2" },
        { "d_kennels", "Slog Kennels" },
        { "d_z4_back1", "Zulag 4 Backtrack 1" },
        { "d_z4_back2", "Zulag 4 Backtrack 2" },
        { "d_z4_end", "Zulag 4 End / Boardroom Entry" },
        { "d_boardroom_final", "The Boardroom" },

        // IL
        { "il_alf",          "Alf Escape" },
        { "il_rf",           "Rupture Farms" },
        { "il_stock",        "Stockyards Escape" },
        { "il_mon",          "Monsaic Lines" },
        { "il_para",         "Paramonia" },
        { "il_para_temple",  "Paramonian Temple" },
        { "il_para_nests",   "Paramonian Nests" },
        { "il_scrab",        "Scrabania" },
        { "il_scrab_temple", "Scrabanian Temple" },
        { "il_scrab_nests",  "Scrabanian Nests" },
        { "il_ffz",          "Free Fire Zone" },
        { "il_z1",           "Zulag 1" },
        { "il_z2",           "Zulag 2" },
        { "il_z3",           "Zulag 3" },
        { "il_z4",           "Zulag 4" },
        { "il_boardroom",    "The Boardroom" }
    };

    vars.Values = new Dictionary<string, int>()
    {
        // simple
        { "s_rf", 4 },
        { "s_stock", 6 },
        { "s_mon_param", 9 },
        { "s_mon_scrab", 23 },
        { "s_para", 15 },
        { "s_para_temple", 21 },
        { "s_para_nests_first", 8 },
        { "s_para_nests_second", 5 },
        { "s_scrab", 27 },
        { "s_scrab_temple", 37 },
        { "s_scrab_nests_first", 8 },
        { "s_scrab_nests_second", 5 },
        { "s_ffz", 3 },
        { "s_z1", 39 },
        { "s_z2", 43 },
        { "s_z3", 47 },
        { "s_z4", 52 },

        // detailed
        { "d_rf1", 1 },
        { "d_rf2", 2 },
        { "d_rf3", 3 },
        { "d_stock1", 4 },
        { "d_stock2", 5 },
        { "d_mon1", 6 },
        { "d_mon2", 7 },
        { "d_mon3", 8 },

        { "d_para1", 9 },
        { "d_para2", 10 },
        { "d_para3", 11 },
        { "d_para4", 12 },
        { "d_paraTempleEntry", 13 },
        { "d_paraT1", 15 },
        { "d_paraT2", 16 },
        { "d_paraT3", 17 },
        { "d_paraT4", 18 },
        { "d_paraT5", 19 },
        { "d_paraT6", 20 },
        { "d_paraN1", 21 },
        { "d_paraN2", 22 },
        { "d_monReturn1", 8 },

        { "d_scrab1", 23 },
        { "d_scrab2", 24 },
        { "d_scrab3", 25 },
        { "d_scrab4", 26 },
        { "d_scrabTempleEntry", 27 },
        { "d_scrabT1", 29 },
        { "d_scrabT2", 30 },
        { "d_scrabT3", 31 },
        { "d_scrabT4", 32 },
        { "d_scrabT5", 33 },
        { "d_scrabT6", 34 },
        { "d_scrabT7", 35 },
        { "d_scrabT8", 36 },
        { "d_scrabN1", 37 },
        { "d_scrabN2", 38 },

        { "d_ffz_return", 5 },
        { "d_z1_1", 3 },
        { "d_z1_2", 2 },
        { "d_z2_entry", 39 },
        { "d_z2_a", 40 },
        { "d_z2_b", 41 },
        { "d_z2_c", 42 },
        { "d_z3_entry", 43 },
        { "d_z3_a", 44 },
        { "d_z3_b", 45 },
        { "d_z3_c", 46 },
        { "d_z4_1", 47 },
        { "d_z4_2", 48 },
        { "d_kennels", 49 },
        { "d_z4_back1", 48 },
        { "d_z4_back2", 47 },
        { "d_z4_end", 52 },

        // IL starts
        { "il_alf_start", 91 },
        { "il_rf_start", 0 },
        { "il_stock_start", 4 },
        { "il_mon_start", 6 },
        { "il_para_start", 9 },
        { "il_para_temple_start", 13 },
        { "il_para_nests_start", 21 },
        { "il_scrab_start", 23 },
        { "il_scrab_temple_start", 27 },
        { "il_scrab_nests_start", 37 },
        { "il_ffz_start", 5 },
        { "il_z1_start", 3 },
        { "il_z2_start", 39 },
        { "il_z3_start", 43 },
        { "il_z4_start", 47 },
        { "il_boardroom_start", 52 },

        // IL ends
        { "il_rf_end", 4 },
        { "il_stock_end", 6 },
        { "il_mon_end_param", 9 },
        { "il_mon_end_scrab", 23 },
        { "il_para_end", 15 },
        { "il_para_temple_end", 21 },
        { "il_para_nests_end_first", 8 },
        { "il_para_nests_end_second", 5 },
        { "il_scrab_end", 27 },
        { "il_scrab_temple_end", 37 },
        { "il_scrab_nests_end_first", 8 },
        { "il_scrab_nests_end_second", 5 },
        { "il_ffz_end", 3 },
        { "il_z1_end", 39 },
        { "il_z2_end", 43 },
        { "il_z3_end", 47 },
        { "il_z4_end", 52 }
    };

    vars.SimpleParamRoute = new List<string>()
    {
        "s_rf",
        "s_stock",
        "s_mon",
        "s_para",
        "s_para_temple",
        "s_para_nests",
        "s_scrab",
        "s_scrab_temple",
        "s_scrab_nests",
        "s_ffz",
        "s_z1",
        "s_z2",
        "s_z3",
        "s_z4"
    };

    vars.SimpleScrabRoute = new List<string>()
    {
        "s_rf",
        "s_stock",
        "s_mon",
        "s_scrab",
        "s_scrab_temple",
        "s_scrab_nests",
        "s_para",
        "s_para_temple",
        "s_para_nests",
        "s_ffz",
        "s_z1",
        "s_z2",
        "s_z3",
        "s_z4"
    };

    vars.PreBranchPhases = new List<List<string>>()
    {
        new List<string>() { "d_rf1" },
        new List<string>() { "d_rf2" },
        new List<string>() { "d_rf3" },
        new List<string>() { "d_stock1" },
        new List<string>() { "d_stock2" },
        new List<string>() { "d_mon1" },
        new List<string>() { "d_mon2" },
        new List<string>() { "d_mon3" }
    };

    vars.PostParamPhases = new List<List<string>>()
    {
        new List<string>() { "d_para1" },
        new List<string>() { "d_para2" },
        new List<string>() { "d_para3" },
        new List<string>() { "d_para4" },
        new List<string>() { "d_paraTempleEntry" },
        new List<string>() { "d_paraT1", "d_paraT2", "d_paraT3", "d_paraT4", "d_paraT5", "d_paraT6" },
        new List<string>() { "d_paraN1" },
        new List<string>() { "d_paraN2" },
        new List<string>() { "d_monReturn1" },

        new List<string>() { "d_scrab1" },
        new List<string>() { "d_scrab2" },
        new List<string>() { "d_scrab3" },
        new List<string>() { "d_scrab4" },
        new List<string>() { "d_scrabTempleEntry" },
        new List<string>() { "d_scrabT1", "d_scrabT2", "d_scrabT3", "d_scrabT4", "d_scrabT5", "d_scrabT6", "d_scrabT7", "d_scrabT8" },
        new List<string>() { "d_scrabN1" },
        new List<string>() { "d_scrabN2" },

        new List<string>() { "d_ffz_return" },
        new List<string>() { "d_z1_1" },
        new List<string>() { "d_z1_2" },
        new List<string>() { "d_z2_entry" },
        new List<string>() { "d_z2_a", "d_z2_b", "d_z2_c" },
        new List<string>() { "d_z3_entry" },
        new List<string>() { "d_z3_a", "d_z3_b", "d_z3_c" },
        new List<string>() { "d_z4_1" },
        new List<string>() { "d_z4_2" },
        new List<string>() { "d_kennels" },
        new List<string>() { "d_z4_back1" },
        new List<string>() { "d_z4_back2" },
        new List<string>() { "d_z4_end" }
    };

    vars.PostScrabPhases = new List<List<string>>()
    {
        new List<string>() { "d_scrab1" },
        new List<string>() { "d_scrab2" },
        new List<string>() { "d_scrab3" },
        new List<string>() { "d_scrab4" },
        new List<string>() { "d_scrabTempleEntry" },
        new List<string>() { "d_scrabT1", "d_scrabT2", "d_scrabT3", "d_scrabT4", "d_scrabT5", "d_scrabT6", "d_scrabT7", "d_scrabT8" },
        new List<string>() { "d_scrabN1" },
        new List<string>() { "d_scrabN2" },
        new List<string>() { "d_monReturn1" },

        new List<string>() { "d_para1" },
        new List<string>() { "d_para2" },
        new List<string>() { "d_para3" },
        new List<string>() { "d_para4" },
        new List<string>() { "d_paraTempleEntry" },
        new List<string>() { "d_paraT1", "d_paraT2", "d_paraT3", "d_paraT4", "d_paraT5", "d_paraT6" },
        new List<string>() { "d_paraN1" },
        new List<string>() { "d_paraN2" },

        new List<string>() { "d_ffz_return" },
        new List<string>() { "d_z1_1" },
        new List<string>() { "d_z1_2" },
        new List<string>() { "d_z2_entry" },
        new List<string>() { "d_z2_a", "d_z2_b", "d_z2_c" },
        new List<string>() { "d_z3_entry" },
        new List<string>() { "d_z3_a", "d_z3_b", "d_z3_c" },
        new List<string>() { "d_z4_1" },
        new List<string>() { "d_z4_2" },
        new List<string>() { "d_kennels" },
        new List<string>() { "d_z4_back1" },
        new List<string>() { "d_z4_back2" },
        new List<string>() { "d_z4_end" }
    };

    vars.IsPhaseComplete = (Func<List<string>, dynamic, bool>)((phase, s) =>
    {
        foreach (string key in phase)
        {
            if (s[key] && !vars.CompletedDetailed.Contains(key))
                return false;
        }
        return true;
    });

    vars.TryPhaseSplit = (Func<List<string>, int, int, dynamic, bool>)((phase, oldNext, curNext, s) =>
    {
        if (curNext == oldNext)
            return false;

        foreach (string key in phase)
        {
            if (!settings[key])
                continue;

            if (vars.CompletedDetailed.Contains(key))
                continue;

            if (curNext == (int)vars.Values[key])
            {
                vars.CompletedDetailed.Add(key);
                print("[NNT] SPLIT - " + vars.Names[key] + " (" + oldNext + " -> " + curNext + ")");
                return true;
            }
        }

        return false;
    });
}

init
{
vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
{
    vars.Helper["lt"] = mono.Make<int>("App", "m_instance", "LevelTransition");
    vars.Helper["cur"] = mono.Make<int>("App", "m_instance", "curLevel");
    vars.Helper["next"] = mono.Make<int>("App", "m_instance", "newLevel");
    vars.Helper["appState"] = mono.Make<int>("App", "m_instance", "mState", "mState");
    vars.Helper["alfDone"] = mono.Make<bool>("App", "m_instance", "m_bAlfDLCCompleted");

    // current chapter's live elapsed time
    vars.Helper["chapterTime"] = mono.Make<float>("App", "m_instance", "m_cCurrentChapterTimer", "m_fCountdownDuration");

    // individual best chapter times (real fields, not the computed property)
    vars.Helper["bestRF"]         = mono.Make<float>("App", "m_instance", "m_fBestChapterTimeRuptureFarms");
    vars.Helper["bestStock"]      = mono.Make<float>("App", "m_instance", "m_fBestChapterTimeStockyardEscape");
    vars.Helper["bestMon"]        = mono.Make<float>("App", "m_instance", "m_fBestChapterTimeMonsaicLines");
    vars.Helper["bestPara"]       = mono.Make<float>("App", "m_instance", "m_fBestChapterTimeParamonia");
    vars.Helper["bestParaTemple"] = mono.Make<float>("App", "m_instance", "m_fBestChapterTimeParamonianTemple");
    vars.Helper["bestParaNests"]  = mono.Make<float>("App", "m_instance", "m_fBestChapterTimeParamonianNests");
    vars.Helper["bestScrab"]      = mono.Make<float>("App", "m_instance", "m_fBestChapterTimeScrabania");
    vars.Helper["bestScrabTemple"]= mono.Make<float>("App", "m_instance", "m_fBestChapterTimeScrabanianTemple");
    vars.Helper["bestScrabNests"] = mono.Make<float>("App", "m_instance", "m_fBestChapterTimeScabanianNests");
    vars.Helper["bestFFZ"]        = mono.Make<float>("App", "m_instance", "m_fBestChapterTimeFreeFireZone");
    vars.Helper["bestZ1"]         = mono.Make<float>("App", "m_instance", "m_fBestChapterTimeRescueZulag1");
    vars.Helper["bestZ2"]         = mono.Make<float>("App", "m_instance", "m_fBestChapterTimeRescueZulag2");
    vars.Helper["bestZ3"]         = mono.Make<float>("App", "m_instance", "m_fBestChapterTimeRescueZulag3");
    vars.Helper["bestZ4"]         = mono.Make<float>("App", "m_instance", "m_fBestChapterTimeRescueZulag4");
    vars.Helper["bestBoardroom"]  = mono.Make<float>("App", "m_instance", "m_fBestChapterTimeTheBoardroom");

    return true;
    });


    vars.GetSelectedIL = (Func<string>)(() =>
    {
        if ((bool)settings["il_alf"]) return "il_alf";
        if ((bool)settings["il_rf"]) return "il_rf";
        if ((bool)settings["il_stock"]) return "il_stock";
        if ((bool)settings["il_mon"]) return "il_mon";
        if ((bool)settings["il_para"]) return "il_para";
        if ((bool)settings["il_para_temple"]) return "il_para_temple";
        if ((bool)settings["il_para_nests"]) return "il_para_nests";
        if ((bool)settings["il_scrab"]) return "il_scrab";
        if ((bool)settings["il_scrab_temple"]) return "il_scrab_temple";
        if ((bool)settings["il_scrab_nests"]) return "il_scrab_nests";
        if ((bool)settings["il_ffz"]) return "il_ffz";
        if ((bool)settings["il_z1"]) return "il_z1";
        if ((bool)settings["il_z2"]) return "il_z2";
        if ((bool)settings["il_z3"]) return "il_z3";
        if ((bool)settings["il_z4"]) return "il_z4";
        if ((bool)settings["il_boardroom"]) return "il_boardroom";
        return "";
    });

    vars.simpleIndex = 0;
    vars.branchOrder = "";
    vars.phaseIndex = 0;
    vars.ActivePostPhases = null;
    vars.CompletedDetailed = new HashSet<string>();
    vars.selectedIL = "";  // FIX: initialise here to avoid RuntimeBinderException
}

onStart
{
    vars.simpleIndex = 0;
    vars.branchOrder = "";
    vars.phaseIndex = 0;
    vars.ActivePostPhases = null;
    vars.CompletedDetailed.Clear();
    vars.selectedIL = vars.GetSelectedIL();
}

onReset
{
    vars.simpleIndex = 0;
    vars.branchOrder = "";
    vars.phaseIndex = 0;
    vars.ActivePostPhases = null;
    vars.CompletedDetailed.Clear();
    vars.selectedIL = "";
}

start
{
    // IL mode
    if (settings["il_mode"])
    {
        vars.selectedIL = vars.GetSelectedIL();
        if (vars.selectedIL == "")
            return false;

        int curNext = vars.Helper["next"].Current;
        int oldNext = vars.Helper["next"].Old;

        if (vars.selectedIL == "il_alf")
        {
            if (curNext == (int)vars.Values["il_alf_start"] && oldNext != curNext)
            {
                print("[NNT] START - " + vars.Names["il_alf"]);
                return true;
            }
        }
        else
        {
            string startKey = vars.selectedIL + "_start";
            if (vars.Values.ContainsKey(startKey) && curNext == (int)vars.Values[startKey] && oldNext != curNext)
            {
                print("[NNT] START - " + vars.Names[vars.selectedIL]);
                return true;
            }
        }

        return false;
    }

    // Main game start
    if (vars.Helper["next"].Current == 0 && vars.Helper["next"].Old != 0)
    {
        print("[NNT] START");
        vars.simpleIndex = 0;
        vars.branchOrder = "";
        vars.phaseIndex = 0;
        vars.ActivePostPhases = null;
        vars.CompletedDetailed.Clear();
        return true;
    }

    return false;
}

split
{
    int oldNext = vars.Helper["next"].Old;
    int curNext = vars.Helper["next"].Current;

    // --------------------
    // IL MODE
    // --------------------

    if (settings["il_mode"])
    {
        if (vars.selectedIL == "")
            vars.selectedIL = vars.GetSelectedIL();

        if (vars.selectedIL == "")
            return false;

        if (vars.selectedIL == "il_alf")
        {
            if (vars.Helper["alfDone"].Current && !vars.Helper["alfDone"].Old)
            {
                print("[NNT] FINAL SPLIT - Alf Escape");
                return true;
            }
            return false;
        }

        if (vars.selectedIL == "il_boardroom")
        {
            if (vars.Helper["next"].Old == 52 &&
                vars.Helper["appState"].Current == 11 &&
                vars.Helper["appState"].Old == 7)
            {
                print("[NNT] FINAL SPLIT - The Boardroom");
                return true;
            }
            return false;
        }

        if (curNext == oldNext)
            return false;

        if (vars.selectedIL == "il_mon")
        {
            int target = settings["scrabania_first"] ? (int)vars.Values["il_mon_end_scrab"] : (int)vars.Values["il_mon_end_param"];
            if (curNext == target)
            {
                print("[NNT] SPLIT - Monsaic Lines");
                return true;
            }
            return false;
        }

        if (vars.selectedIL == "il_para_nests")
        {
            int target = settings["scrabania_first"] ? (int)vars.Values["il_para_nests_end_second"] : (int)vars.Values["il_para_nests_end_first"];
            if (curNext == target)
            {
                print("[NNT] SPLIT - Paramonian Nests");
                return true;
            }
            return false;
        }

        if (vars.selectedIL == "il_scrab_nests")
        {
            int target = settings["scrabania_first"] ? (int)vars.Values["il_scrab_nests_end_first"] : (int)vars.Values["il_scrab_nests_end_second"];
            if (curNext == target)
            {
                print("[NNT] SPLIT - Scrabanian Nests");
                return true;
            }
            return false;
        }

        string endKey = vars.selectedIL + "_end";
        if (vars.Values.ContainsKey(endKey) && curNext == (int)vars.Values[endKey])
        {
            print("[NNT] SPLIT - " + vars.Names[vars.selectedIL]);
            return true;
        }

        return false;
    }

    // --------------------
    // MAIN SIMPLE MODE
    // --------------------
    if (settings["main_simple"])
    {
        List<string> route = settings["scrabania_first"] ? (List<string>)vars.SimpleScrabRoute : (List<string>)vars.SimpleParamRoute;

        // final boardroom split
        if (settings["s_boardroom_final"] &&
            vars.Helper["next"].Old == 52 &&
            vars.Helper["appState"].Current == 11 &&
            vars.Helper["appState"].Old == 7)
        {
            print("[NNT] FINAL SPLIT - The Boardroom");
            return true;
        }

        if (curNext == oldNext)
            return false;

        while (vars.simpleIndex < route.Count && !settings[route[vars.simpleIndex]])
            vars.simpleIndex++;

        if (vars.simpleIndex >= route.Count)
            return false;

        string key = route[vars.simpleIndex];
        int target = -1;

        if (key == "s_mon")
            target = settings["scrabania_first"] ? (int)vars.Values["s_mon_scrab"] : (int)vars.Values["s_mon_param"];
        else if (key == "s_para_nests")
            target = settings["scrabania_first"] ? (int)vars.Values["s_para_nests_second"] : (int)vars.Values["s_para_nests_first"];
        else if (key == "s_scrab_nests")
            target = settings["scrabania_first"] ? (int)vars.Values["s_scrab_nests_first"] : (int)vars.Values["s_scrab_nests_second"];
        else
            target = (int)vars.Values[key];

        if (curNext == target)
        {
            print("[NNT] SPLIT - " + vars.Names[key]);
            vars.simpleIndex++;
            return true;
        }

        return false;
    }

    // --------------------
    // MAIN DETAILED MODE
    // --------------------
    if (settings["main_detailed"])
    {
        // final boardroom split
        if (settings["d_boardroom_final"] &&
            vars.Helper["next"].Old == 52 &&
            vars.Helper["appState"].Current == 11 &&
            vars.Helper["appState"].Old == 7)
        {
            print("[NNT] FINAL SPLIT - The Boardroom");
            return true;
        }

        if (curNext == oldNext)
            return false;

        // Pre-branch phases
        while (vars.phaseIndex < vars.PreBranchPhases.Count &&
            vars.IsPhaseComplete(vars.PreBranchPhases[vars.phaseIndex], settings))
        {
            vars.phaseIndex++;
        }

        if (vars.phaseIndex < vars.PreBranchPhases.Count)
        {
            if (vars.TryPhaseSplit(vars.PreBranchPhases[vars.phaseIndex], oldNext, curNext, settings))
            {
                if (vars.IsPhaseComplete(vars.PreBranchPhases[vars.phaseIndex], settings))
                    vars.phaseIndex++;
                return true;
            }

            return false;
        }

        // Determine branch dynamically
        if (vars.branchOrder == "")
        {
            if (curNext == 9)
            {
                vars.branchOrder = "ParamoniaFirst";
                vars.ActivePostPhases = vars.PostParamPhases;
            }
            else if (curNext == 23)
            {
                vars.branchOrder = "ScrabaniaFirst";
                vars.ActivePostPhases = vars.PostScrabPhases;
            }
            else
            {
                return false;
            }
        }

        int postIndex = vars.phaseIndex - vars.PreBranchPhases.Count;
        List<List<string>> activePost = (List<List<string>>)vars.ActivePostPhases;

        while (postIndex < activePost.Count &&
            vars.IsPhaseComplete(activePost[postIndex], settings))
        {
            vars.phaseIndex++;
            postIndex = vars.phaseIndex - vars.PreBranchPhases.Count;
        }

        if (postIndex >= activePost.Count)
            return false;

        if (vars.TryPhaseSplit(activePost[postIndex], oldNext, curNext, settings))
        {
            if (vars.IsPhaseComplete(activePost[postIndex], settings))
                vars.phaseIndex++;
            return true;
        }

        return false;
    }
}

isLoading
{
    return vars.Helper["lt"].Current != 0 ||
        (vars.Helper["appState"].Current != 7 && vars.Helper["appState"].Current != 5);
}

reset
{
    if (vars.Helper["lt"].Old != 0 &&
        vars.Helper["lt"].Current == 0 &&
        vars.Helper["cur"].Current == 84)
    {
        print("[NNT] RESET");
        vars.simpleIndex = 0;
        vars.branchOrder = "";
        vars.phaseIndex = 0;
        vars.ActivePostPhases = null;
        vars.CompletedDetailed.Clear();
        vars.selectedIL = "";
        return true;
    }

    return false;
}
update
{
    if (vars.Helper["chapterTime"] != null)
        print("[NNT] chapterTime = " + vars.Helper["chapterTime"].Current);
}
gameTime
{
    if (vars.Helper["chapterTime"] == null) return null;

    float[] bests = new float[]
    {
        vars.Helper["bestRF"].Current,
        vars.Helper["bestStock"].Current,
        vars.Helper["bestMon"].Current,
        vars.Helper["bestPara"].Current,
        vars.Helper["bestParaTemple"].Current,
        vars.Helper["bestParaNests"].Current,
        vars.Helper["bestScrab"].Current,
        vars.Helper["bestScrabTemple"].Current,
        vars.Helper["bestScrabNests"].Current,
        vars.Helper["bestFFZ"].Current,
        vars.Helper["bestZ1"].Current,
        vars.Helper["bestZ2"].Current,
        vars.Helper["bestZ3"].Current,
        vars.Helper["bestZ4"].Current,
        vars.Helper["bestBoardroom"].Current
    };

    double sum = 0;
    foreach (float b in bests)
        if (b < 3599999f) sum += b;

    sum += (double)vars.Helper["chapterTime"].Current;

    return TimeSpan.FromSeconds(sum);
}
exit { }
