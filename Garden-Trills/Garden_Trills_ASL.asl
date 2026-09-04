state("Winged-Win64-Shipping")
{
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
    vars.Uhara.AlertLoadless();
    vars.Uhara.EnableDebug();
}

init
{
    vars.Utils = vars.Uhara.CreateTool("UnrealEngine", "Utils");

    vars.Resolver.Watch<uint>("GWorldName", vars.Utils.GWorld, 0x18);

    // GEngine -> GameViewport(0x9A0) -> GameInstance(0x80) -> LocalPlayers[0](0x38)
    // -> PlayerController(0x30) -> MyHUD(0x340) -> MasterMenu(0x3B0) -> CurrentMenu(0x2F0)
    vars.Resolver.Watch<uint>("CurrentMenuName", vars.Utils.GEngine,
        0x9A0, 0x80, 0x38, 0x0, 0x30, 0x340, 0x3B0, 0x2F0);

    // Same chain, extended past MasterMenu: -> UW_GameplayHUD(0x2B0) -> UW_QuestAnnoucements(0x308)
    // -> bRunning(0x2E0). Fires true whenever a quest announcement (new/updated/completed) pops up.
    vars.Resolver.Watch<bool>("QuestAnnouncementRunning", vars.Utils.GEngine,
        0x9A0, 0x80, 0x38, 0x0, 0x30, 0x340, 0x3B0, 0x2B0, 0x308, 0x2E0);

    current.World = "";
    current.CurrentMenu = "";
}

update
{
    vars.Uhara.Update();

    var world = vars.Utils.FNameToString(current.GWorldName);
    if (!string.IsNullOrEmpty(world) && world != "None") current.World = world;
    if (old.World != current.World)
        vars.Uhara.Log("World: " + old.World + " -> " + current.World);

    var menu = vars.Utils.FNameToString(current.CurrentMenuName);
    if (!string.IsNullOrEmpty(menu)) current.CurrentMenu = menu;
    if (old.CurrentMenu != current.CurrentMenu)
        vars.Uhara.Log("CurrentMenu: " + old.CurrentMenu + " -> " + current.CurrentMenu);

    if (old.QuestAnnouncementRunning != current.QuestAnnouncementRunning)
        vars.Uhara.Log("QuestAnnouncementRunning: " + old.QuestAnnouncementRunning + " -> " + current.QuestAnnouncementRunning);
}

start
{
    return old.CurrentMenu == "Menu.Loading" && current.CurrentMenu == "Menu.HUD";
}

isLoading
{
    return current.CurrentMenu == "Menu.Loading";
}
    
split
{
    return old.QuestCompletedVisibility != 0 && current.QuestCompletedVisibility == 0;
}

reset
{
    return old.CurrentMenu != "Menu.Home.Home" && current.CurrentMenu == "Menu.Home.Home";
}
