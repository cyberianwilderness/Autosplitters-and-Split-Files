# Oddworld-Munch-s-Oddysee-GBA-Autosplitter
Overview
This autosplitter is designed for Oddworld: Munch's Oddysee (Game Boy Advance) when played using the **mGBA emulator**.
It automatically:
- Starts the timer when a new run begins
- Splits at the end of each level
- Splits for the run completion and final rank screen
- Resets the timer when returning to the main menu after a run

The script reads game memory using the emu-help-v3 helper library.


Requirements

This is designed to work on the mGBA emulator only at present. Other emulators will not work.
Link is on the SRC page for this game
https://www.speedrun.com/omogba/resources

**emu-help-v3** (https://github.com/Jujstme/emu-help-v3/raw/refs/heads/main/lib/Livesplit/emu-help-v3)
**emu-help-v3** must be placed in the LiveSplit Components folder.

Typical path:
```
LiveSplit/Components/emu-help-v3.dll
```
*If the helper is missing, the autosplitter will fail to function.*

These timings aren't quite what the speedrun rules state, but are as close as I could get. 
This does mean you will have a consistent set of splits, with some minor time adjustments required post run.

These differences are due to
- Run starts when you hit new game, but the timer starts after the initial cutscene dialogue (which you press start to skip)
- Run ends when you possess Lulu, but the timer splits when your rank is visible.