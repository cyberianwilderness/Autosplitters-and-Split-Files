state("Pongo") {
    int current_level : 0xA00428;         // Memory address for current level - Main Menu is 1 and every level is the level number + 1
    int reset_condition : 0xBEDEBC;       // Extra variable to detect game reset
}

init {
    vars.in_level = false;
    vars.last_level = 0;
}

update {
}

start {
    if (old.current_level == 1 && current.current_level == 2) {
        vars.last_level = current.current_level;
        vars.in_level = true;
        return true;
    }
    return false;
}

split {
    if (vars.in_level && current.current_level == vars.last_level + 1) {
        print("Split Triggered: Level " + current.current_level.ToString());
        vars.last_level = current.current_level;  // Update last_level to the new current_level
        return true;
    }
    return false;
}

reset {
    if (current.reset_condition == 40 || current.current_level == 1) {
        vars.last_level = 0;
        vars.in_level = false;
        print("Game Reset Detected.");
        return true;
    }
    return false;
}