state("junkTest-Win64-Shipping")
{

}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Helper.GameName = "Junkster";
}

init
{
    vars.GWorld = vars.Helper.ScanRel(8, "0F 2E ?? 74 ?? 48 8B 1D ?? ?? ?? ?? 48 85 DB 74");
    vars.Log("GWorld: 0x" + vars.GWorld.ToString("X"));

    vars.FNamePool = vars.Helper.ScanRel(13, "89 5C 24 ?? 89 44 24 ?? 74 ?? 48 8D 15");
    vars.Log("FNamePool: 0x" + vars.FNamePool.ToString("X"));

    // cached once we've discovered ComicFrontend's raw FName value - avoids repeated string decoding
    vars.ComicFrontendFName = null;

    var cachedFNames = new Dictionary<long, string>();
    vars.ReadFName = (Func<long, string>)(fname =>
    {
        string name;
        if (cachedFNames.TryGetValue(fname, out name))
            return name;

        int name_offset  = (int) fname & 0xFFFF;
        int chunk_offset = (int) (fname >> 0x10) & 0xFFFF;

        var base_ptr = new DeepPointer((IntPtr) vars.FNamePool + chunk_offset * 0x8 + 0x10, name_offset * 0x2);
        byte[] name_metadata = base_ptr.DerefBytes(game, 2);
        if (name_metadata == null) return null;

        int size = name_metadata[1] << 2 | (name_metadata[0] & 0xC0) >> 6;

        IntPtr name_addr;
        base_ptr.DerefOffsets(game, out name_addr);
        name = game.ReadString(name_addr + 0x2, size);

        cachedFNames[fname] = name;
        return name;
    });
}

update
{
    if (vars.GWorld == IntPtr.Zero || vars.FNamePool == IntPtr.Zero) return;

    try
    {
        IntPtr world = vars.Helper.Read<IntPtr>((IntPtr) vars.GWorld);
        if (world == IntPtr.Zero) return;

        // Levels TArray<ULevel*>: data ptr at +0x138, count at +0x140
        IntPtr levelsData = vars.Helper.Read<IntPtr>(world + 0x138);
        int levelsCount = vars.Helper.Read<int>(world + 0x140);

        bool foundComicFrontend = false;

        if (levelsData != IntPtr.Zero && levelsCount > 0 && levelsCount < 64) // sanity clamp against a bad read
        {
            for (int i = 0; i < levelsCount; i++)
            {
                IntPtr level = vars.Helper.Read<IntPtr>(levelsData + i * 0x8);
                if (level == IntPtr.Zero) continue;

                IntPtr outer = vars.Helper.Read<IntPtr>(level + 0x20); // UOBJECT_OUTER
                if (outer == IntPtr.Zero) continue;

                long outerFName = vars.Helper.Read<long>(outer + 0x18);

                if (vars.ComicFrontendFName != null)
                {
                    // fast path: cheap integer compare, no string decode
                    if (outerFName == (long) vars.ComicFrontendFName)
                    {
                        foundComicFrontend = true;
                        break;
                    }
                }
                else
                {
                    // slow path: only runs until we've discovered and cached the target FName once
                    string name = vars.ReadFName(outerFName);
                    if (name == "ComicFrontend")
                    {
                        vars.ComicFrontendFName = outerFName;
                        foundComicFrontend = true;
                        break;
                    }
                }
            }
        }

        current.puzzleEnding = foundComicFrontend;

        if (!((IDictionary<string, object>) old).ContainsKey("puzzleEnding"))
        {
            vars.Log("puzzleEnding (initial): " + current.puzzleEnding);
            return;
        }

        if (old.puzzleEnding != current.puzzleEnding)
            vars.Log("puzzleEnding: " + old.puzzleEnding + " -> " + current.puzzleEnding);
    }
    catch (Exception)
    {
        return;
    }
}

start
{
    var oldDict = (IDictionary<string, object>) old;
    if (!oldDict.ContainsKey("puzzleEnding")) return false;

    return old.puzzleEnding && !current.puzzleEnding;
}

split
{
    var oldDict = (IDictionary<string, object>) old;
    if (!oldDict.ContainsKey("puzzleEnding")) return false;

    return !old.puzzleEnding && current.puzzleEnding;
}