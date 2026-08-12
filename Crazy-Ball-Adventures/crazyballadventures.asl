/*       
___________________________________________________________________________
|                                                                          |
| LiveSplit Auto Splitter script for CrazyBallAdventures.exe               |
|                                                                          |
| Made by l1ndblum                                                         |
|__________________________________________________________________________|
*/

state("CrazyBallAdventures") {
    byte current_level : 0xA03430;
}

init {
    vars.last_level = 0;
}

update {
    print("Old Level: " + old.current_level.ToString());
    print("Current Level: " + current.current_level.ToString());
}

start {
    if (old.current_level == 0 && current.current_level == 1) {
        vars.last_level = 1;
        return true;
    }
    return false;
}

split {
    if (current.current_level == vars.last_level + 1) {
        vars.last_level = current.current_level;
        return true;
    }
    return false;
}

reset {
    if (current.current_level == 0) {
        vars.last_level = 0;
        return true;
    }
    return false;
}
