state("mGBA")
{
    // EWRAM memory region — each int below reads 4 bytes from that offset
    int var01 : 0x0000;
    int var02 : 0x0100;
    int var03 : 0x0200;
    int var04 : 0x0300;
    int var05 : 0x0400;
    int var06 : 0x0500;
    int var07 : 0x0600;
    int var08 : 0x0700;
    int var09 : 0x0800;
    int var10 : 0x0900;
    int var11 : 0x1000;
    int var12 : 0x2000;
    int var13 : 0x3000;
    int var14 : 0x4000;
    int var15 : 0x5000;
    int var16 : 0x6000;
    int var17 : 0x7000;
    int var18 : 0x8000;
    int var19 : 0x9000;
    int var20 : 0xA000;
}

startup
{
    // nothing fancy needed
    vars.ready = true;
}

init
{
    print("[ASLVarViewer] Munch’s Oddysee GBA memory explorer active.");
}

update
{
    // These are automatically populated into ASLVarViewer via 'current'
    vars.var01 = current.var01;
    vars.var02 = current.var02;
    vars.var03 = current.var03;
    vars.var04 = current.var04;
    vars.var05 = current.var05;
    vars.var06 = current.var06;
    vars.var07 = current.var07;
    vars.var08 = current.var08;
    vars.var09 = current.var09;
    vars.var10 = current.var10;
    vars.var11 = current.var11;
    vars.var12 = current.var12;
    vars.var13 = current.var13;
    vars.var14 = current.var14;
    vars.var15 = current.var15;
    vars.var16 = current.var16;
    vars.var17 = current.var17;
    vars.var18 = current.var18;
    vars.var19 = current.var19;
    vars.var20 = current.var20;
}

start { return false; }
split { return false; }
reset { return false; }
isLoading { return false; }
