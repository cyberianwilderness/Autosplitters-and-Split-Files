state("clownpuzzle-Win64-Shipping")
{
    byte varA: 0x44442B5;
    long varB: 0x453C00C;
}
start
{
    if (current.varA != 0)
    {
        return true;
    }
    return false;
}
split
{
    if (current.varB == 8589934610 && current.varA == 1)
    {
        return true;
    }
    return false;
}
reset
{
    if (current.varA == 0)
    {
        return true;
    }
    return false;
}
