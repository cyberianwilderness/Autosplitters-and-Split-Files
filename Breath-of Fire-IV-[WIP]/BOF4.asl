state("BOF4")
{
    /* General Info*/
    int Zenny: 0x755C34;                // Zenny || BOF4.exe+755C34
    int EXPGainedFromFIght: 0x7AB5D8;   // EXPGainedFromFIght || BOF4.exe+7AB5D8
    // The below value is not tested
    // int ZennyGainedFromFight: 0x7AB5DC;      // ZennyGainedFromFight || BOF4.exe+7AB5DC

    /* Ryu Stats */
    int RyuCurrentHP: 0x7BB440;         // RyuCurrentHP || BOF4.exe+7BB4E0
    int RyuMaxHP: 0x75585C;             // RyuMaxHP || BOF4.exe+75585C
    int RyuTotalEXP: 0x75580C;          // RyuTotalEXP || BOF4.exe+75580C
    int RyuCurrentAP: 0x7BB5F8;         // RyuCurrentAP || BOF4.exe+7BB5F8
    int RyuCurrentAP2: 0x7BB6A4;        // RyuCurrentAP2 || BOF4.exe+7BB6A4
    int RyuMaxAP: 0x75583C;             // RyuMaxAP || BOF4.exe+75583C
    int RyuMaxAP2: 0x755860;            // RyuMaxAP2 || BOF4.exe+755860

        // int RyuCurrentHP: 0x755814;        // RyuCurrentHP || BOF4.exe+755814   /* TEST */
    // int RyuMaxAPBOF4.exe+
    // int RyuCurrentAP

    /* Nina Stats */
    int NinaTotalEXP: 0x7558A4;         // NinaTotalEXP || BOF4.exe+7558A4
    int NinaTotalHP: 0x7558F4;          // NinaTotalHP  || BOF4.exe+7558F4
    int NinaTotalHP2: 0x7558D0;         // NinaTotalHP2 || BOF4.exe+7558D0
    int NinaCurrentAP: 0x7558B0;        // NinaCurrentAP|| BOF4.exe+7558B0
    int NinaMaxAP: 0x7558F8;            // NinaMaxAP    || BOF4.exe+7558F8
    int NinaMaxAP2: 0x7558D4;           // NinaMaxAP2   || BOF4.exe+7558D4
    
    
    /** Ershin Stats **/
    int ErshinMaxHP: 0x755B54; //BOF4.exe+755B54
    int ErshinMaxHP2: 0x755B30; //BOF4.exe+755B30
    int ErshinMaxHP3: 0x755B0C; //BOF4.exe+755B0C


    int ErshinCurrentHP: 0x7BB440; //BOF4.exe+7BB440
    int ErshinCurrentHP2: 0x7BB4E0; //BOF4.exe+7BB4E0
    int ErshinTotalEXP: 0x755B04; //BOF4.exe+755B04


    /** Cray Stats **/  
    int CrayCurrentHP: 0x7BB848; // Cray Current HP || BOF4.exe+7BB848
    int CrayCurrentHP2: 0x7BB7A8; // Cray Current HP2 || BOF4.exe+7BB7A8
    int CrayTotalEXP: 0x75593C; // Cray Total EXP || BOF4.exe+75593C
    int CrayTotalHP: 0x75593C; // Cray Total HP || BOF4.exe+75593C
        // Cray Total HP tests 
 

    /** Location Variables**/
    int LocationVar1: 0x2F6000;
    int LocationVar2: 0x2E6000;
    int LocationVar3: 0x2E6018;
    int LocationVar4: 0x2E601C;
    int LocationVar5: 0x57DB40;
    int LocationVar6: 0x57538C;
    int LocationVar7: 0x575B8C;
    int LocationVar8: 0x574B6C;
    int LocationVar9: 0x574B34;
    int LocationVar10: 0x576B40;
    int LocationVar11: 0x2E651C;

    // Cray Total HP tests 
    int CrayTotalHP1: 0x6F95CC;   // NOT CORRECT - IS FOR SOMETHING ELSE
    // BOF4.exe+6F95CC
    int CrayTotalHP2: 0x6F95F0;
    // BOF4.exe+6F95F0
    int CrayTotalHP3: 0x6F9614;
    // BOF4.exe+6F9614
    int CrayTotalHP4: 0x755968;
    // BOF4.exe+755968
    int CrayTotalHP5: 0x755984;
    // BOF4.exe+755984



    /*Enemy Scanning*/

    int Enemy1HP: 0x7BBFA4;
    int Enemy2HP: 0x7BC17C;
    int Enemy3HP: 0x7BC354;
    int Enemy4HP: 0x7BC468;             // Enemy4HP     || BOF4.exe+7BC468
    int Enemy5HP: 0x7BC704;              // Enemy5HP     || BOF4.exe+7BC704
    int Enemy6HP: 0x7BC818;              // Enemy6HP     || BOF4.exe+7BC818

    
    /* Original Enemy Scanning Values
    int EnemyAHP: 0x7BBFA4;             // EnemyAHP     || BOF4.exe+7BBFA4
    int EnemyAHP2: 0x7BBEE0;            // EnemyAHP2    || BOF4.exe+7BBEE0

    int EnemyBHP: 0x7BBFA4;             // EnemyBHP     || BOF4.exe+7BBFA4
    int EnemyBHP2: 0x7BC17C;            // EnemyBHP2    || BOF4.exe+7BC17C
    int EnemyCHP: 0x7BBFA4;             // EnemyCHP     || BOF4.exe+7BBFA4
    int EnemyCHP2: 0x7BC354;            // EnemyCHP2    || BOF4.exe+7BC354


    int enemy2HP: 0x7BC0B8;             // Enemy2HP     || BOF4.exe+7BC0B8
    int enemy2MaxHP: 0x7BC17C;          // Enemy2MaxHP  || BOF4.exe+7BC17C

    int SkulfishHP: 0x7BBFA4;           // SkulfishHP   || BOF4.exe+7BBFA4
    int SkulfishHP2: 0x7BBEE0;          // SkulfishHP2  || BOF4.exe+7BBEE0

    int Enemy4HP: 0x7BC468;             // Enemy4HP     || BOF4.exe+7BC468
    int Enemy4HP2: 0x7BC52C;            // Enemy4HP2    || BOF4.exe+7BC52C
    int Enemy5HP: 0x7BC704;              // Enemy5HP     || BOF4.exe+7BC704
    int Enemy5HP2: 0x7BC468;             // Enemy5HP2    || BOF4.exe+7BC468

    int Enemy6HP: 0x7BC818;              // Enemy6HP     || BOF4.exe+7BC818

    int Enemy6HP2: 0x7BC8DC;             // Enemy6HP2    || BOF4.exe+7BC8DC
    */

    byte ItemSlot1Quantity: 0x755C4D; // BOF4.exe+755C4D
    byte ItemSlot2Quantity: 0x755C4F; // BOF4.exe+755C4F
    byte ItemSlot3Quantity: 0x755C51; // BOF4.exe+755C51
    byte ItemSlot4Quantity: 0x755C53; // BOF4.exe+755C53
    byte ItemSlot5Quantity: 0x755C55; // BOF4.exe+755C55
    byte ItemSlot6Quantity: 0x755C57; // BOF4.exe+755C57
    byte ItemSlot7Quantity: 0x755C59; // BOF4.exe+755C59
    byte ItemSlot8Quantity: 0x755C5B; // BOF4.exe+755C5B
    byte ItemSlot9Quantity: 0x755C5D; // BOF4.exe+755C5D
    byte ItemSlot10Quantity: 0x755C5F; // BOF4.exe+755C5F
    byte ItemSlot11Quantity: 0x755C61; // BOF4.exe+755C61
    byte ItemSlot12Quantity: 0x755C63; // BOF4.exe+755C63
    byte ItemSlot13Quantity: 0x755C65; // BOF4.exe+755C65
    byte ItemSlot14Quantity: 0x755C67; // BOF4.exe+755C67
    byte ItemSlot15Quantity: 0x755C69; // BOF4.exe+755C69
    byte ItemSlot16Quantity: 0x755C6B; // BOF4.exe+755C6B
    byte ItemSlot17Quantity: 0x755C6D; // BOF4.exe+755C6D
    byte ItemSlot18Quantity: 0x755C6F; // BOF4.exe+755C6F
    byte ItemSlot19Quantity: 0x755C71; // BOF4.exe+755C71
    /* These are to save space selecting ASL Var Variables 
    byte ItemSlot20Quantity: 0x755C73; // BOF4.exe+755C73
    byte ItemSlot21Quantity: 0x755C75; // BOF4.exe+755C75
    byte ItemSlot22Quantity: 0x755C77; // BOF4.exe+755C77
    byte ItemSlot23Quantity: 0x755C79; // BOF4.exe+755C79
    byte ItemSlot24Quantity: 0x755C7B; // BOF4.exe+755C7B
    byte ItemSlot25Quantity: 0x755C7D; // BOF4.exe+755C7D
    byte ItemSlot26Quantity: 0x755C7F; // BOF4.exe+755C7F
    byte ItemSlot27Quantity: 0x755C81; // BOF4.exe+755C81
    byte ItemSlot28Quantity: 0x755C83; // BOF4.exe+755C83
    byte ItemSlot29Quantity: 0x755C85; // BOF4.exe+755C85
    byte ItemSlot30Quantity: 0x755C87; // BOF4.exe+755C87
    byte ItemSlot31Quantity: 0x755C89; // BOF4.exe+755C89
    byte ItemSlot32Quantity: 0x755C8B; // BOF4.exe+755C8B
    byte ItemSlot33Quantity: 0x755C8D; // BOF4.exe+755C8D
    byte ItemSlot34Quantity: 0x755C8F; // BOF4.exe+755C8F
    byte ItemSlot35Quantity: 0x755C91; // BOF4.exe+755C91
    byte ItemSlot36Quantity: 0x755C93; // BOF4.exe+755C93
    byte ItemSlot37Quantity: 0x755C95; // BOF4.exe+755C95
    byte ItemSlot38Quantity: 0x755C97; // BOF4.exe+755C97
    byte ItemSlot39Quantity: 0x755C99; // BOF4.exe+755C99
    byte ItemSlot40Quantity: 0x755C9B; // BOF4.exe+755C9B
    byte ItemSlot41Quantity: 0x755C9D; // BOF4.exe+755C9D
    byte ItemSlot42Quantity: 0x755C9F; // BOF4.exe+755C9F
    byte ItemSlot43Quantity: 0x755CA1; // BOF4.exe+755CA1
    byte ItemSlot44Quantity: 0x755CA3; // BOF4.exe+755CA3
    byte ItemSlot45Quantity: 0x755CA5; // BOF4.exe+755CA5
    byte ItemSlot46Quantity: 0x755CA7; // BOF4.exe+755CA7
    byte ItemSlot47Quantity: 0x755CA9; // BOF4.exe+755CA9
    byte ItemSlot48Quantity: 0x755CAB; // BOF4.exe+755CAB
    byte ItemSlot49Quantity: 0x755CAD; // BOF4.exe+755CAD
    byte ItemSlot50Quantity: 0x755CAF; // BOF4.exe+755CAF
    byte ItemSlot51Quantity: 0x755CB1; // BOF4.exe+755CB1
    byte ItemSlot52Quantity: 0x755CB3; // BOF4.exe+755CB3
    byte ItemSlot53Quantity: 0x755CB5; // BOF4.exe+755CB5
    byte ItemSlot54Quantity: 0x755CB7; // BOF4.exe+755CB7
    byte ItemSlot55Quantity: 0x755CB9; // BOF4.exe+755CB9
    byte ItemSlot56Quantity: 0x755CBB; // BOF4.exe+755CBB
    byte ItemSlot57Quantity: 0x755CBD; // BOF4.exe+755CBD
    byte ItemSlot58Quantity: 0x755CBF; // BOF4.exe+755CBF
    byte ItemSlot59Quantity: 0x755CC1; // BOF4.exe+755CC1
    byte ItemSlot60Quantity: 0x755CC3; // BOF4.exe+755CC3
    byte ItemSlot61Quantity: 0x755CC5; // BOF4.exe+755CC5
    byte ItemSlot62Quantity: 0x755CC7; // BOF4.exe+755CC7
    byte ItemSlot63Quantity: 0x755CC9; // BOF4.exe+755CC9
    byte ItemSlot64Quantity: 0x755CCB; // BOF4.exe+755CCB
    byte ItemSlot65Quantity: 0x755CCD; // BOF4.exe+755CCD
    byte ItemSlot66Quantity: 0x755CCF; // BOF4.exe+755CCF
    byte ItemSlot67Quantity: 0x755CD1; // BOF4.exe+755CD1
    byte ItemSlot68Quantity: 0x755CD3; // BOF4.exe+755CD3
    byte ItemSlot69Quantity: 0x755CD5; // BOF4.exe+755CD5
    byte ItemSlot70Quantity: 0x755CD7; // BOF4.exe+755CD7
    byte ItemSlot71Quantity: 0x755CD9; // BOF4.exe+755CD9
    byte ItemSlot72Quantity: 0x755CDB; // BOF4.exe+755CDB
    byte ItemSlot73Quantity: 0x755CDD; // BOF4.exe+755CDD
    byte ItemSlot74Quantity: 0x755CDF; // BOF4.exe+755CDF
    byte ItemSlot75Quantity: 0x755CE1; // BOF4.exe+755CE1
    byte ItemSlot76Quantity: 0x755CE3; // BOF4.exe+755CE3
    byte ItemSlot77Quantity: 0x755CE5; // BOF4.exe+755CE5
    byte ItemSlot78Quantity: 0x755CE7; // BOF4.exe+755CE7
    byte ItemSlot79Quantity: 0x755CE9; // BOF4.exe+755CE9
    byte ItemSlot80Quantity: 0x755CEB; // BOF4.exe+755CEB
    byte ItemSlot81Quantity: 0x755CED; // BOF4.exe+755CED
    byte ItemSlot82Quantity: 0x755CEF; // BOF4.exe+755CEF
    byte ItemSlot83Quantity: 0x755CF1; // BOF4.exe+755CF1
    byte ItemSlot84Quantity: 0x755CF3; // BOF4.exe+755CF3
    byte ItemSlot85Quantity: 0x755CF5; // BOF4.exe+755CF5
    byte ItemSlot86Quantity: 0x755CF7; // BOF4.exe+755CF7
    byte ItemSlot87Quantity: 0x755CF9; // BOF4.exe+755CF9
    byte ItemSlot88Quantity: 0x755CFB; // BOF4.exe+755CFB
    byte ItemSlot89Quantity: 0x755CFD; // BOF4.exe+755CFD
    byte ItemSlot90Quantity: 0x755CFF; // BOF4.exe+755CFF
    byte ItemSlot91Quantity: 0x755D01; // BOF4.exe+755D01
    byte ItemSlot92Quantity: 0x755D03; // BOF4.exe+755D03
    byte ItemSlot93Quantity: 0x755D05; // BOF4.exe+755D05
    byte ItemSlot94Quantity: 0x755D07; // BOF4.exe+755D07
    byte ItemSlot95Quantity: 0x755D09; // BOF4.exe+755D09
    byte ItemSlot96Quantity: 0x755D0B; // BOF4.exe+755D0B
    byte ItemSlot97Quantity: 0x755D0D; // BOF4.exe+755D0D
    byte ItemSlot98Quantity: 0x755D0F; // BOF4.exe+755D0F
    byte ItemSlot99Quantity: 0x755D11; // BOF4.exe+755D11
    byte ItemSlot100Quantity: 0x755D13; // BOF4.exe+755D13
    byte ItemSlot101Quantity: 0x755D15; // BOF4.exe+755D15
    byte ItemSlot102Quantity: 0x755D17; // BOF4.exe+755D17
    byte ItemSlot103Quantity: 0x755D19; // BOF4.exe+755D19
    byte ItemSlot104Quantity: 0x755D1B; // BOF4.exe+755D1B
    byte ItemSlot105Quantity: 0x755D1D; // BOF4.exe+755D1D
    byte ItemSlot106Quantity: 0x755D1F; // BOF4.exe+755D1F
    byte ItemSlot107Quantity: 0x755D21; // BOF4.exe+755D21
    byte ItemSlot108Quantity: 0x755D23; // BOF4.exe+755D23
    byte ItemSlot109Quantity: 0x755D25; // BOF4.exe+755D25
    byte ItemSlot110Quantity: 0x755D27; // BOF4.exe+755D27
    byte ItemSlot111Quantity: 0x755D29; // BOF4.exe+755D29
    byte ItemSlot112Quantity: 0x755D2B; // BOF4.exe+755D2B
    byte ItemSlot113Quantity: 0x755D2D; // BOF4.exe+755D2D
    byte ItemSlot114Quantity: 0x755D2F; // BOF4.exe+755D2F
    byte ItemSlot115Quantity: 0x755D31; // BOF4.exe+755D31
    byte ItemSlot116Quantity: 0x755D33; // BOF4.exe+755D33
    byte ItemSlot117Quantity: 0x755D35; // BOF4.exe+755D35
    byte ItemSlot118Quantity: 0x755D37; // BOF4.exe+755D37
    byte ItemSlot119Quantity: 0x755D39; // BOF4.exe+755D39
    byte ItemSlot120Quantity: 0x755D3B; // BOF4.exe+755D3B
    byte ItemSlot121Quantity: 0x755D3D; // BOF4.exe+755D3D
    byte ItemSlot122Quantity: 0x755D3F; // BOF4.exe+755D3F
    byte ItemSlot123Quantity: 0x755D41; // BOF4.exe+755D41
    byte ItemSlot124Quantity: 0x755D43; // BOF4.exe+755D43
    byte ItemSlot125Quantity: 0x755D45; // BOF4.exe+755D45
    byte ItemSlot126Quantity: 0x755D47; // BOF4.exe+755D47
    byte ItemSlot127Quantity: 0x755D49; // BOF4.exe+755D49
    byte ItemSlot128Quantity: 0x755D4B; // BOF4.exe+755D4B
    */
}
state("Breath Of Fire IV")
{
    //   ryuhp// BOF4.exe+755814
    /* General Info*/
    int Zenny: 0x755C34;                // Zenny        || BOF4.exe+755C34
    int EXPGainedFromFIght: 0x7AB5D8;   // EXPGainedFromFIght || BOF4.exe+7AB5D8

    /* Ryu Stats */
    int RyuCurrentHP: 0x7BB440;         // RyuCurrentHP || BOF4.exe+7BB4E0
    int RyuMaxHP: 0x75585C;             // RyuMaxHP || BOF4.exe+75585C
    int RyuTotalEXP: 0x75580C;          // RyuTotalEXP || BOF4.exe+75580C
    // int RyuMaxAP
    // int RyuCurrentAP

    /* Nina Stats */
    int NinaTotalEXP: 0x7558A4;         // NinaTotalEXP || BOF4.exe+7558A4
    int NinaTotalHP: 0x7558F4;          // NinaTotalHP || BOF4.exe+7558F4
    int NinaTotalHP2: 0x7558D0;         // NinaTotalHP2 || BOF4.exe+7558D0
    int NinaCurrentAP: 0x7558B0;        // NinaCurrentAP || BOF4.exe+7558B0
    int NinaMaxAP: 0x7558F8;            // NinaMaxAP || BOF4.exe+7558F8
    int NinaMaxAP2: 0x7558D4;           // NinaMaxAP2 || BOF4.exe+7558D4


    /*Enemy Scanning*/
    int EnemyAHP: 0x7BBFA4;             // EnemyAHP || BOF4.exe+7BBFA4
    int EnemyAHP2: 0x7BBEE0;            // EnemyAHP2 || BOF4.exe+7BBEE0
    int EnemyBHP: 0x7BBFA4;             // EnemyBHP || BOF4.exe+7BBFA4
    int EnemyBHP2: 0x7BC17C;            // EnemyBHP2 || BOF4.exe+7BC17C
    int EnemyCHP: 0x7BBFA4;             // EnemyCHP || BOF4.exe+7BBFA4
    int EnemyCHP2: 0x7BC354;            // EnemyCHP2 || BOF4.exe+7BC354


}
startup
{
  
}

init
{
  
}

update
{

    return false;
}

start
{
    return false;
}

split
{
    return false;
}

reset
{
    return false;
}