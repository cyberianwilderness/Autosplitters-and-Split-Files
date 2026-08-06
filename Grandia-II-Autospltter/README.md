# Grandia-II-Autospltter
Autsplitter for Grandia II HD (Anniversary Edition) 

# General Info
There are 2 ways to use this splitter
- Split by boss fights [recommended]
- Split by boss fights and locations [development in progress]

Due to the Phantom Skills glitch, players may need to save the game and reset. This makes a reset function difficult to do as it would not work in this circumstance. Therefore there is no resetting within this autosplitter - however all you need to do is press `numpad3`, so it isn't the end of the world!
# Setup Guidance
For this script to work you will need
- [LiveSplit](https://github.com/LiveSplit/LiveSplit)
- [ASL Var Viewer](https://github.com/hawkerm/LiveSplit.ASLVarViewer)
- A copy of the game on Steam!


## Adding the auto splitter
> [!TIP]
> Right click on Livesplit  
> Click on Edit Layout  
> Add Button > `Control` > `Scriptable Auto Splitter` 

![Adding the splits](adding-scriptable-auto-splitter.png)

---

> [!TIP]
> Select the `GrandiaII-ASL.asl` file wherever you have saved it using the browse button.  


---

> [!TIP]
> On the same menu where you added the autosplitter before  
> Right click on Livesplit  
> Click on Edit Layout  
> Add Button > `Information` > `ASL Var Viewer` (pictured)  

![Adding ASL Var Viewer]

> [!CAUTION]
> If you don't see this option, you need to make sure the ASL Var Viewer is inside your Livesplit components folder.  

---

> [!TIP]
> To find in-game variables through Livesplit, you need to double click on the ASL Var Viewer you added in the above step.  
> To select variables and add them to your Livesplit file, the game must start so the Autosplitter script can read the game's variables. Once this is done once, the variables you add will remain for next time.
> These in-game variables include
> - Each characters total EXP
> - Enemy and Boss Health
> - Location information
> - Gold Coin amount
> Should more useful information be discovered, it will be added as VAR variable so you can monitor it throughout gameplay.

![Accessing ASL Var Variables](/Images/edit-layout-interface.png)

---

>[!WARNING]
> The game must be running for you to get the option click the drop down menu, otherwise it is greyed out.  
> It is highly recommended you use the splits provided at (link ro be added later)