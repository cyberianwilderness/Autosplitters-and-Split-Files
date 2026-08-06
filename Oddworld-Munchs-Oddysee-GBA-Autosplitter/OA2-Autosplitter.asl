/*
Oddworld Adventures 2 (GBA) Autosplitter
Author: l1ndblum

Notes:
- Intended for mGBA
- Requires emu-help-v3.dll in LiveSplit Components folder
- This version is built around level ID + completion flags
*/

state("mGBA") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/emu-help-v3")).CreateInstance("GBC");

    // Core watchers
    vars.LevelID     = vars.Helper.Make<byte>(0x0000C59D);
    vars.LevelWide   = vars.Helper.Make<byte>(0x0000C59C); // may prove useful
    vars.SavedTotal  = vars.Helper.Make<byte>(0x0000C614);
    vars.KilledTotal = vars.Helper.Make<byte>(0x0000C615);

    // Completion flags
    vars.PV1 = vars.Helper.Make<byte>(0x0000C5E5);
    vars.PV2 = vars.Helper.Make<byte>(0x0000C5E6);
    vars.PV3 = vars.Helper.Make<byte>(0x0000C5E7);
    vars.PV4 = vars.Helper.Make<byte>(0x0000C5E8);

    vars.SV1 = vars.Helper.Make<byte>(0x0000C5EA);
    vars.SV2 = vars.Helper.Make<byte>(0x0000C5EB);
    vars.SV3 = vars.Helper.Make<byte>(0x0000C5EC);
    vars.SV4 = vars.Helper.Make<byte>(0x0000C5ED);

    vars.SB1 = vars.Helper.Make<byte>(0x0000C5F2);
    vars.SB2 = vars.Helper.Make<byte>(0x0000C5F3);
    vars.SB3 = vars.Helper.Make<byte>(0x0000C5F4);
    vars.SB4 = vars.Helper.Make<byte>(0x0000C5F5);

    vars.M11 = vars.Helper.Make<byte>(0x0000C5F7);
    vars.M12 = vars.Helper.Make<byte>(0x0000C5F8);
    vars.M13 = vars.Helper.Make<byte>(0x0000C5F9);

    vars.M21 = vars.Helper.Make<byte>(0x0000C5FB);
    vars.M22 = vars.Helper.Make<byte>(0x0000C5FC);
    vars.M23 = vars.Helper.Make<byte>(0x0000C5FD);

    // Split settings
    settings.Add("vaults", true, "Vaults");
    settings.Add("paramite", true, "Paramite Vaults", "vaults");
    settings.Add("pv1", true, "Paramite Vaults 1", "paramite");
    settings.Add("pv2", true, "Paramite Vaults 2", "paramite");
    settings.Add("pv3", true, "Paramite Vaults 3", "paramite");
    settings.Add("pv4", true, "Paramite Vaults 4", "paramite");

    settings.Add("scrab", true, "Scrab Vaults", "vaults");
    settings.Add("sv1", true, "Scrab Vaults 1", "scrab");
    settings.Add("sv2", true, "Scrab Vaults 2", "scrab");
    settings.Add("sv3", true, "Scrab Vaults 3", "scrab");
    settings.Add("sv4", true, "Scrab Vaults 4", "scrab");

    settings.Add("barracks", true, "Slig Barracks");
    settings.Add("sb1", true, "Slig Barracks 1", "barracks");
    settings.Add("sb2", true, "Slig Barracks 2", "barracks");
    settings.Add("sb3", true, "Slig Barracks 3", "barracks");
    settings.Add("sb4", true, "Slig Barracks 4", "barracks");

    settings.Add("meetings", true, "Meetings");
    settings.Add("m11", true, "Meeting 1.1", "meetings");
    settings.Add("m12", true, "Meeting 1.2", "meetings");
    settings.Add("m13", true, "Meeting 1.3", "meetings");
    settings.Add("m21", true, "Meeting 2.1", "meetings");
    settings.Add("m22", true, "Meeting 2.2", "meetings");
    settings.Add("m23", true, "Meeting 2.3", "meetings");

    settings.Add("finalsplit", true, "Final Split");
}

init
{
    vars.started = false;
    vars.finished = false;
    vars.firstPrint = true;

    // TODO: replace with real values once you confirm them
    vars.TitleLevel = (byte)0;
    vars.FirstGameplayLevel = (byte)1;
    vars.CreditsLevel = (byte)255;
}

update
{
    if (timer.CurrentPhase == TimerPhase.NotRunning)
    {
        vars.started = false;
        vars.finished = false;
    }

    if (vars.LevelID.Current != vars.LevelID.Old)
    {
        print("[OA2] LevelID: " + vars.LevelID.Old + " -> " + vars.LevelID.Current);
    }

    if (vars.LevelWide.Current != vars.LevelWide.Old)
    {
        print("[OA2] LevelWide: " + vars.LevelWide.Old + " -> " + vars.LevelWide.Current);
    }

    if (vars.SavedTotal.Current != vars.SavedTotal.Old)
    {
        print("[OA2] SavedTotal: " + vars.SavedTotal.Old + " -> " + vars.SavedTotal.Current);
    }

    if (vars.KilledTotal.Current != vars.KilledTotal.Old)
    {
        print("[OA2] KilledTotal: " + vars.KilledTotal.Old + " -> " + vars.KilledTotal.Current);
    }

    if (vars.PV1.Current != vars.PV1.Old) print("[OA2] PV1: " + vars.PV1.Old + " -> " + vars.PV1.Current);
    if (vars.PV2.Current != vars.PV2.Old) print("[OA2] PV2: " + vars.PV2.Old + " -> " + vars.PV2.Current);
    if (vars.PV3.Current != vars.PV3.Old) print("[OA2] PV3: " + vars.PV3.Old + " -> " + vars.PV3.Current);
    if (vars.PV4.Current != vars.PV4.Old) print("[OA2] PV4: " + vars.PV4.Old + " -> " + vars.PV4.Current);

    if (vars.SV1.Current != vars.SV1.Old) print("[OA2] SV1: " + vars.SV1.Old + " -> " + vars.SV1.Current);
    if (vars.SV2.Current != vars.SV2.Old) print("[OA2] SV2: " + vars.SV2.Old + " -> " + vars.SV2.Current);
    if (vars.SV3.Current != vars.SV3.Old) print("[OA2] SV3: " + vars.SV3.Old + " -> " + vars.SV3.Current);
    if (vars.SV4.Current != vars.SV4.Old) print("[OA2] SV4: " + vars.SV4.Old + " -> " + vars.SV4.Current);

    if (vars.SB1.Current != vars.SB1.Old) print("[OA2] SB1: " + vars.SB1.Old + " -> " + vars.SB1.Current);
    if (vars.SB2.Current != vars.SB2.Old) print("[OA2] SB2: " + vars.SB2.Old + " -> " + vars.SB2.Current);
    if (vars.SB3.Current != vars.SB3.Old) print("[OA2] SB3: " + vars.SB3.Old + " -> " + vars.SB3.Current);
    if (vars.SB4.Current != vars.SB4.Old) print("[OA2] SB4: " + vars.SB4.Old + " -> " + vars.SB4.Current);

    if (vars.M11.Current != vars.M11.Old) print("[OA2] M11: " + vars.M11.Old + " -> " + vars.M11.Current);
    if (vars.M12.Current != vars.M12.Old) print("[OA2] M12: " + vars.M12.Old + " -> " + vars.M12.Current);
    if (vars.M13.Current != vars.M13.Old) print("[OA2] M13: " + vars.M13.Old + " -> " + vars.M13.Current);
    if (vars.M21.Current != vars.M21.Old) print("[OA2] M21: " + vars.M21.Old + " -> " + vars.M21.Current);
    if (vars.M22.Current != vars.M22.Old) print("[OA2] M22: " + vars.M22.Old + " -> " + vars.M22.Current);
    if (vars.M23.Current != vars.M23.Old) print("[OA2] M23: " + vars.M23.Old + " -> " + vars.M23.Current);

    if (vars.firstPrint)
    {
        vars.firstPrint = false;
        print("[OA2] Autosplitter initialised.");
    }
}

start
{
    if (!vars.started && vars.LevelID.Old == vars.TitleLevel && vars.LevelID.Current == vars.FirstGameplayLevel)
    {
        vars.started = true;
        return true;
    }

    return false;
}

split
{
    if ((bool)settings["pv1"] && old.PV1 == 0 && current.PV1 != 0) return true;
    if ((bool)settings["pv2"] && old.PV2 == 0 && current.PV2 != 0) return true;
    if ((bool)settings["pv3"] && old.PV3 == 0 && current.PV3 != 0) return true;
    if ((bool)settings["pv4"] && old.PV4 == 0 && current.PV4 != 0) return true;

    if ((bool)settings["sv1"] && old.SV1 == 0 && current.SV1 != 0) return true;
    if ((bool)settings["sv2"] && old.SV2 == 0 && current.SV2 != 0) return true;
    if ((bool)settings["sv3"] && old.SV3 == 0 && current.SV3 != 0) return true;
    if ((bool)settings["sv4"] && old.SV4 == 0 && current.SV4 != 0) return true;

    if ((bool)settings["sb1"] && old.SB1 == 0 && current.SB1 != 0) return true;
    if ((bool)settings["sb2"] && old.SB2 == 0 && current.SB2 != 0) return true;
    if ((bool)settings["sb3"] && old.SB3 == 0 && current.SB3 != 0) return true;
    if ((bool)settings["sb4"] && old.SB4 == 0 && current.SB4 != 0) return true;

    if ((bool)settings["m11"] && old.M11 == 0 && current.M11 != 0) return true;
    if ((bool)settings["m12"] && old.M12 == 0 && current.M12 != 0) return true;
    if ((bool)settings["m13"] && old.M13 == 0 && current.M13 != 0) return true;
    if ((bool)settings["m21"] && old.M21 == 0 && current.M21 != 0) return true;
    if ((bool)settings["m22"] && old.M22 == 0 && current.M22 != 0) return true;
    if ((bool)settings["m23"] && old.M23 == 0 && current.M23 != 0) return true;

    // Placeholder final split until ending state is confirmed
    if ((bool)settings["finalsplit"] && !vars.finished)
    {
        if (current.LevelID == vars.CreditsLevel && old.LevelID != current.LevelID)
        {
            vars.finished = true;
            return true;
        }
    }

    return false;
}

reset
{
    if (timer.CurrentPhase == TimerPhase.Running)
    {
        // Placeholder reset until title value is confirmed
        if (current.LevelID == vars.TitleLevel && old.LevelID != current.LevelID)
            return true;
    }

    return false;
}
