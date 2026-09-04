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

    // World/level name -- not used in split logic yet, kept for future area-based splits and general diagnosis.
    vars.Resolver.Watch<uint>("GWorldName", vars.Utils.GWorld, 0x18);

    // GEngine -> GameViewport(0x9A0) -> GameInstance(0x80) -> LocalPlayers[0](0x38)
    // -> PlayerController(0x30) -> MyHUD(0x340) -> MasterMenu(0x3B0) -> CurrentMenu(0x2F0)
    // CurrentMenu is an FGameplayTag (e.g. "Menu.Home.Save", "Menu.Loading", "Menu.HUD").
    vars.Resolver.Watch<uint>("CurrentMenuName", vars.Utils.GEngine,
        0x9A0, 0x80, 0x38, 0x0, 0x30, 0x340, 0x3B0, 0x2F0);

    // Same chain past MasterMenu -> UW_GameplayHUD(0x2B0) -> UW_QuestAnnoucements(0x308)-> QuestCompleted(0x2A8) -> Visibility(0xE4). Visibility == 0 means shown.
    vars.Resolver.Watch<byte>("QuestCompletedVisibility", vars.Utils.GEngine,
        0x9A0, 0x80, 0x38, 0x0, 0x30, 0x340, 0x3B0, 0x2B0, 0x308, 0x2A8, 0xE4);

    // Same chain to MasterMenu -> FadePanel(0x298) -> RenderOpacity(0xE8).
    // Starts moving the instant the screen-fade begins, well before CurrentMenu itself flips to Menu.Loading once the fade finishes.
    vars.Resolver.Watch<float>("FadePanelOpacity", vars.Utils.GEngine,
        0x9A0, 0x80, 0x38, 0x0, 0x30, 0x340, 0x3B0, 0x298, 0xE8);

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

    if (old.QuestCompletedVisibility != current.QuestCompletedVisibility)
        vars.Uhara.Log("QuestCompletedVisibility: " + old.QuestCompletedVisibility + " -> " + current.QuestCompletedVisibility);

    if (old.FadePanelOpacity != current.FadePanelOpacity)
        vars.Uhara.Log("FadePanelOpacity: " + old.FadePanelOpacity + " -> " + current.FadePanelOpacity);
}

start
{
    return old.CurrentMenu == "Menu.Home.Save" && old.FadePanelOpacity != current.FadePanelOpacity;
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
