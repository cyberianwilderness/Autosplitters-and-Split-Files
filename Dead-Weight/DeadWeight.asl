state("Dead_weight")
{
}

startup
{
    vars.Log = (Action<object>)((output) => print("[DW Test] " + output));

    vars.ReadStringName = (Func<IntPtr, string>) ((ptr) => {
        var stringPtr = game.ReadValue<IntPtr>(ptr + 0x10);
        var output = vars.ReadUtf32String(stringPtr);
        if (String.IsNullOrEmpty(output))
        {
            stringPtr = game.ReadValue<IntPtr>(ptr + 0x8);
            output = game.ReadString(stringPtr, 255);
        }
        return output;
    });

    vars.ReadUtf32String = (Func<IntPtr, string>)((ptr) =>
    {
        var sb = new StringBuilder();
        int utf32char;
        while ((utf32char = game.ReadValue<int>(ptr)) != 0)
        {
            sb.Append(char.ConvertFromUtf32(utf32char));
            ptr += 4;
        }
        return sb.ToString();
    });

    vars.NODE_CHILDREN_OFFSET             = 0x1C8;
    vars.NODE_NAME_OFFSET                 = 0x228;
    vars.SCENETREE_ROOT_WINDOW_OFFSET     = 0x3A8;
    vars.OBJECT_SCRIPT_INSTANCE_OFFSET    = 0x068;
    vars.SCRIPTINSTANCE_SCRIPT_REF_OFFSET = 0x018;
    vars.SCRIPTINSTANCE_MEMBERS_OFFSET    = 0x028;
    vars.GDSCRIPT_MEMBER_MAP_OFFSET       = 0x258;
}

init
{
    var scn = new SignatureScanner(game, game.MainModule.BaseAddress, game.MainModule.ModuleMemorySize);

    // Try pattern 1 (Bloodthief)
    var trg1 = new SigScanTarget(3, "4C 8B 35 ?? ?? ?? ?? 4D 85 F6 74 7E")
        { OnFound = (p, s, ptr) => ptr + 0x4 + game.ReadValue<int>(ptr) };
    var sceneTreePtr = scn.Scan(trg1);

    if (sceneTreePtr == IntPtr.Zero)
    {
        vars.Log("Pattern 1 failed, trying pattern 2 (Lucid Blocks)...");
        var trg2 = new SigScanTarget(3, "48 8B 0D ?? ?? ?? ?? 48 85 C9 74 ?? E8 ?? ?? ?? ?? 84 C0 74 ?? 40 B6")
            { OnFound = (p, s, ptr) => ptr + 0x4 + game.ReadValue<int>(ptr) };
        sceneTreePtr = scn.Scan(trg2);
    }

    if (sceneTreePtr == IntPtr.Zero)
    {
        vars.Log("BOTH signatures failed — need a fresh scan for Dead Weight specifically.");
        return;
    }

    vars.Log("SceneTree found at static ptr location: 0x" + sceneTreePtr.ToString("X"));

    var sceneTree     = game.ReadValue<IntPtr>((IntPtr)sceneTreePtr);
    var rootWindow    = game.ReadValue<IntPtr>((IntPtr)(sceneTree + vars.SCENETREE_ROOT_WINDOW_OFFSET));
    var childCount    = game.ReadValue<int>   ((IntPtr)(rootWindow + vars.NODE_CHILDREN_OFFSET));
    var childArrayPtr = game.ReadValue<IntPtr>((IntPtr)(rootWindow + vars.NODE_CHILDREN_OFFSET + 0x8));

    vars.Log("Root has " + childCount + " children:");

    var saveSystem = IntPtr.Zero;
    var party      = IntPtr.Zero;

    for (int i = 0; i < childCount; i++)
    {
        var child = game.ReadValue<IntPtr>(childArrayPtr + (0x8 * i));
        var nameFieldPtr = game.ReadValue<IntPtr>((IntPtr)(child + vars.NODE_NAME_OFFSET));
        var childName = vars.ReadStringName(nameFieldPtr);
        vars.Log(i + ": " + childName + " (0x" + child.ToString("X") + ")");

        if (childName == "SaveSystem") saveSystem = child;
        if (childName == "Party") party = child;
    }

    if (saveSystem == IntPtr.Zero)
    {
        vars.Log("SaveSystem NOT found among root children — check autoload name/order, or SceneTree resolve is wrong.");
        return;
    }

    vars.Log("SaveSystem found at 0x" + saveSystem.ToString("X"));

    // Dump SaveSystem's own GDScript member offsets (so we can find active_save's offset)
    var siPtr = game.ReadValue<IntPtr>((IntPtr)(saveSystem + vars.OBJECT_SCRIPT_INSTANCE_OFFSET));
    if (siPtr == IntPtr.Zero)
    {
        vars.Log("SaveSystem has no script_instance — unexpected.");
        return;
    }

    var scriptPtr = game.ReadValue<IntPtr>((IntPtr)(siPtr + vars.SCRIPTINSTANCE_SCRIPT_REF_OFFSET));
    var memberPtr     = game.ReadValue<IntPtr>((IntPtr)(scriptPtr + vars.GDSCRIPT_MEMBER_MAP_OFFSET));
    var lastMemberPtr = game.ReadValue<IntPtr>((IntPtr)(scriptPtr + vars.GDSCRIPT_MEMBER_MAP_OFFSET + 0x8));
    int memberSize = 0x18;

    vars.Log("SaveSystem members:");
    while (memberPtr != IntPtr.Zero)
    {
        var namePtr = game.ReadValue<IntPtr>(memberPtr + 0x10);
        string memberName = vars.ReadStringName(namePtr);
        var index = game.ReadValue<int>(memberPtr + 0x18);
        int offset = index * memberSize + 0x8;
        vars.Log("  " + memberName + " -> offset 0x" + offset.ToString("X"));

        if (memberPtr == lastMemberPtr) break;
        memberPtr = game.ReadValue<IntPtr>(memberPtr);
    }
}

update {}