/*
  Postal 2 Demo Autosplitter
  Janky in places, but it works.
  Created by: l1ndblum
  Timer starts at -10.333 as this how long it takes between the first frame of the game 
  and the first frame "Press SPACE to continue" appears where gameplay starts 
*/

state("Postal2", "Engine.dll")
{   
  byte isLoading1: "Engine.dll", 0x4AB2BA; // 24 when loading
  byte isLoading2: "Engine.dll", 0x4AB2B8; // 24 when loading
  byte isLoading3: "Engine.dll", 0x4AB2B0; // 16 when loading
  byte isLoading4: "Engine.dll", 0x4AB2A4; // 8 when loading
  int endingVariable: "Core.dll", 0x190018; // 78 at end of game
}
init
{
  vars.isLoading1 = 0;
  vars.isLoading2 = 0;
  vars.isLoading3 = 0;
  vars.isLoading4 = 0;
  vars.endingVariable = 0;
  print("Initialization complete");
}

update
{
  vars.isLoading1 = current.isLoading1;
  vars.isLoading2 = current.isLoading2;
  vars.isLoading3 = current.isLoading3;
  vars.isLoading4 = current.isLoading4;
  vars.endingVariable = current.endingVariable;
}

start
{
  if (vars.isLoading1 == 24 && vars.isLoading2 == 24 && vars.isLoading3 == 16 && vars.isLoading4 == 8) {
      print("Game Loaded");
      return true;
  }
  return false;
}

split
{
  if (vars.endingVariable == 78) {
    return true;
  }
}
reset
{
  if (vars.isLoading3 == 255 && vars.isLoading2 == 255 && vars.isLoading4 == 255) {
      return true;
    }
    return false;
}
