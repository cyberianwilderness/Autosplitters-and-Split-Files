state("LiveSplit") {}
startup
{
    Assembly.Load(File.ReadAllBytes("Components/emu-help-v3")).CreateInstance("GBC");

    vars.LevelID = vars.Helper.Make<byte>(0xc59d); // "Level ID 8bit"

    vars.FrameCount = 0; // must exist before update reads it — ExpandoObject
                         // throws on reading a never-set property, it doesn't
                         // just return null like a normal dictionary lookup
}
update
{
    if (vars.LevelID.Current != vars.LevelID.Old)
        print("LevelID: " + vars.LevelID.Old + " -> " + vars.LevelID.Current);
}

start
{
    return vars.LevelID.Current == 0 && vars.LevelID.Old == 30;
}
split
{
    return vars.LevelID.Current == 32 && vars.LevelID.Old != 32;
}
reset
{
    return vars.LevelID.Current == 30 && vars.LevelID.Old != 30;
}
