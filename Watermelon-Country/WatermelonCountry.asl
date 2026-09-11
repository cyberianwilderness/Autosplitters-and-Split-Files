state("WatermelonCountry-Win64-Shipping") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
    vars.Uhara.EnableDebug();
}

init
{
    vars.Utils = vars.Uhara.CreateTool("UnrealEngine", "Utils");

    switch (modules.First().ModuleMemorySize)
    {
        case 58286080:
            version = "Steam";
            break;
    }

    vars.Resolver.Watch<uint>("WorldID", vars.Utils.GWorld, 0x18);
    vars.completedSplits = new HashSet<uint>();

    vars.Level1 = (uint)0x58773;
    vars.Level2 = (uint)0x587BF;
    vars.Level3 = (uint)0x5880B;
    vars.Level4 = (uint)0x58857;
    vars.Level5 = (uint)0x588A3;
    vars.Level6 = (uint)0x588BF;

    vars.LevelIds = new List<uint> { 
        (uint)vars.Level2, 
        (uint)vars.Level3, 
        (uint)vars.Level4, 
        (uint)vars.Level5, 
        (uint)vars.Level6 
    };
}

update
{
    if (vars.Utils.GWorld == IntPtr.Zero)
        return;
        
    vars.Uhara.Update();
    
    if (current.WorldID != old.WorldID)
    {
        print("WORLD CHANGED: 0x" + old.WorldID.ToString("X") + " -> 0x" + current.WorldID.ToString("X"));
    }
}

start
{
    // Start the very first time we enter Level 1
    return current.WorldID == vars.Level1 && old.WorldID != vars.Level1;
}

split
{
    // Split when ENTERING any of level 2-6, only once each
    if (current.WorldID != old.WorldID
        && vars.LevelIds.Contains(current.WorldID)
        && !vars.completedSplits.Contains(current.WorldID))
    {
        vars.completedSplits.Add(current.WorldID);
        return true;
    }
}

onStart
{
    vars.completedSplits.Clear();
}