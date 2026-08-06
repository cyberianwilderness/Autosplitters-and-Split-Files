state("clown4-Win64-Shipping")
{
    int levelVar1: 0x8A42CC8; // 0 = main menu, 1 = in level
    int levelVar2: 0x8A42CD0; // 2 = main menu, 1 = in level
}

start
{
    // Game starts when enterring the first level from the Main Menu
    return (old.levelVar1 == 0 && old.levelVar2 == 2) &&
           (current.levelVar1 == 1 && current.levelVar2 == 1);
}

split
{
    // Split when returning to main menu
    return (old.levelVar1 == 1 && old.levelVar2 == 1) &&
           (current.levelVar1 == 0 && current.levelVar2 == 2);
}
