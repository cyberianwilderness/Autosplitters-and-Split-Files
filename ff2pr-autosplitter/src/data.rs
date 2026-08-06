use asr::{
    game_engine::unity::il2cpp::{Image, Module, UnityPointer},
    Address, Address64, Process,
};
use bytemuck::{AnyBitPattern, CheckedBitPattern};
use core::{fmt, marker::PhantomData, mem::size_of};
use num_enum::{FromPrimitive, TryFromPrimitive};

// ── Battle result ────────────────────────────────────────────────────────────
// In FF2 PR, result=0 = Win (confirmed by probe data, opposite of FF1).

#[derive(Copy, Clone, Debug, PartialEq, Eq, FromPrimitive)]
#[repr(u32)]
pub enum BattleResult {
    Win     = 0,
    None    = 1,
    Lose    = 2,
    Escape  = 3,
    Forced  = 4,
    Restart = 5,
    #[num_enum(default)]
    Unknown = u32::MAX,
}

// ── BattleState enum (from BattleController.BattleState) ─────────────────────
// Read directly from stateMachine to detect win/loss more reliably.

#[derive(Copy, Clone, Debug, PartialEq, Eq, TryFromPrimitive)]
#[repr(u32)]
pub enum BattleState {
    None              = 0,
    Init              = 1,
    CreateObj         = 2,
    InBattle          = 3,
    PreeMptiveMes     = 4,
    Play              = 5,
    Event             = 6,
    WinWait           = 7,
    WinResult         = 8,
    LoseWait          = 9,
    LoseResult        = 10,
    Escape            = 11,
    WinFadeOut        = 12,
    LoseFadeOut       = 13,
    EscapeFadeOut     = 14,
    PrepareGameOver   = 15,
    GameOverFadeIn    = 16,
    GameOverPopup     = 17,
    GameOverEnd       = 18,
    End               = 19,
    RestartBattleWait = 20,
    RestartBattle     = 21,
}

impl BattleState {
    pub fn is_win(self) -> bool {
        matches!(self, BattleState::WinWait | BattleState::WinResult | BattleState::WinFadeOut | BattleState::End)
    }
    pub fn is_loss(self) -> bool {
        matches!(self, BattleState::LoseWait | BattleState::LoseResult | BattleState::LoseFadeOut
            | BattleState::PrepareGameOver | BattleState::GameOverFadeIn
            | BattleState::GameOverPopup | BattleState::GameOverEnd)
    }
    pub fn is_escape(self) -> bool {
        matches!(self, BattleState::Escape | BattleState::EscapeFadeOut)
    }
}

// ── Boss / encounter formation IDs ───────────────────────────────────────────
// slot[0] at offset 0x20 from the valueIntList object.
// Confirmed by probe through a full any% run.

#[derive(Copy, Clone, Debug, PartialEq, Eq, TryFromPrimitive)]
#[repr(u32)]
pub enum Monster {
    Chimera       = 463,
    Sergeant      = 471,
    Adamantoise   = 472,
    Borghen       = 473,
    RedSoul      = 474,
    Pirates       = 476,
    BigHorns      = 477,
    LamiaQueen    = 478,
    Behemoth      = 479,
    Gottos        = 480,
    Roundworm     = 481,
    FireGigas     = 482,
    IceGigas      = 483,
    ThunderGigas  = 484,
    EmperorFinal  = 488,
    EmperorCyclone = 1053,
}

// ── Map IDs ──────────────────────────────────────────────────────────────────
// Confirmed by walking every location during a full any% run.

#[derive(Copy, Clone, Debug, PartialEq, Eq, TryFromPrimitive)]
#[repr(u32)]
pub enum Location {
    WorldMap            = 1,

    // Altair (pre-bombing)
    Altair              = 14,
    AltairThrone        = 6,
    AltairRebel         = 3,
    AltairChurch        = 4,
    AltairMagic         = 5,
    AltairStartRoom     = 7,
    AltairKingsRoom     = 8,
    AltairQueensRoom    = 9,
    AltairInn           = 10,
    AltairArmor         = 11,
    AltairItems         = 12,
    AltairWeapons       = 13,

    // Altair (post-bombing)
    AltairPost          = 101,
    AltairInnPost       = 102,
    AltairArmorPost     = 103,
    AltairWeaponsPost   = 104,
    AltairItemsPost     = 105,
    AltairMagicPost     = 106,
    AltairRebelPost     = 325,
    AltairThronePost    = 326,
    AltairStartPost     = 327,
    AltairKingsPost     = 328,
    AltairQueensPost    = 329,
    AltairChurchPost    = 330,

    // Fynn
    Fynn                = 20,
    FynnCastle1F        = 31,
    FynnCastle2F        = 32,
    FynnCastleB1        = 33,
    FynnCastleB2        = 34,
    FynnCastleB5        = 37,
    FynnCastle2FAlt     = 39,
    FynnCastle3F        = 40,
    FynnCastle4F        = 43,
    FynnCastleSecret    = 44,
    FynnCastle3FAlt     = 45,
    // FynnCastleB4 = 46 conflicts with Paloom — Paloom is used for splitting
    FynnCastleWhiteMask = 75,

    // Paloom / Poft
    Paloom              = 46,
    PaloomItems         = 47,
    PaloomInn           = 48,
    PaloomWeapons       = 49,
    PaloomArmor         = 50,
    PaloomMagic         = 51,
    PaloomPost          = 112,
    Poft                = 52,
    PoftPub             = 53,
    PoftItems           = 54,
    PoftInn             = 55,
    PoftWeapons         = 56,
    PoftArmor           = 57,
    PoftMagic           = 58,
    PoftPost            = 115,
    PoftPubPost         = 116,
    PoftInnPost         = 117,
    ShipCutscene        = 100,

    // Bafsk
    Bafsk               = 67,
    BafskItems          = 68,
    BafskChurch         = 69,
    BafskInn            = 70,
    BafskMagic          = 71,
    BafskWeapons        = 72,
    BafskArmor          = 73,
    BafskCaveB1         = 136,
    BafskCave1F         = 137,
    BafskCaveTeleport   = 138,

    // Salamand
    Salamand            = 59,
    SalamandJosef       = 60,
    SalamandInn         = 61,
    SalamandWeapons     = 62,
    SalamandArmor       = 63,
    SalamandChurch      = 64,
    SalamandMagic       = 65,
    SalamandItems       = 66,

    // Semitt Falls
    SemittFalls1F       = 118,
    SemittFallsSnowcraft = 119,
    SemittFalls2F       = 128,
    SemittFallsB2       = 130,
    SemittFallsB3       = 131,
    SemittFallsB4       = 132,
    SemittFallsB5       = 134,

    // Snow Cave
    SnowCaveB1          = 139,
    SnowCaveB2          = 141,
    SnowCaveB3          = 143,
    SnowCaveB4          = 144,
    SnowCaveB5          = 145,
    SnowCaveBeaverRoom  = 146,
    SnowCaveB6          = 147,

    // Kashuan Keep
    KashuanKeep1F       = 149,
    KashuanKeepBoss     = 150,
    KashuanKeepGordon   = 156,
    KashuanKeep2F       = 158,
    KashuanKeep3F       = 159,
    KashuanKeep4F       = 160,
    KashuanKeep5F       = 162,

    // Chocobo / Dreadnought
    ChocobForest        = 99,
    Dreadnought1F       = 164,
    Dreadnought2F       = 168,
    Dreadnought3F       = 170,
    DreadnoughtStairs4F = 171,
    Dreadnought4F       = 172,
    DreadnoughtStairs5F = 173,
    // Dreadnought5F = 174 conflicts with RebelCamp — not needed for splitting
    DreadnoughtFinal    = 175,

    // Deist
    CastleDeist1F       = 176,
    CastleDeistTreasure = 178,
    CastleDeist2F       = 179,
    DeistCavernB1       = 183,
    DeistCavernB2       = 184,
    DeistCavernB3       = 185,
    DeistCavernB4       = 186,
    DeistCavernB5       = 187,

    // Black Mask Cave (Tropical Island)
    BlackMaskCaveB1     = 200,
    BlackMaskCaveB2     = 201,
    BlackMaskCaveB3     = 202,
    BlackMaskCaveB4     = 203,
    BlackMaskCaveB5     = 204,
    BlackMaskBossRoom   = 206,

    // Coliseum
    Coliseum1F          = 191,
    ColiseumB2          = 192,
    ColiseumB1          = 195,

    // Rebel Camp
    RebelCamp           = 174,

    // Mysidia
    Mysidia             = 90,
    MysidiaWeapons      = 91,
    MysidiaInn          = 92,
    MysidiaItems        = 93,
    MysidiaArmor        = 94,
    MysidiaMagic        = 95,
    MysidiaHouse        = 97,
    MysidiaUnderground  = 98,
    CaveOfMysidiaB1     = 207,
    CaveOfMysidiaStairsB2 = 218,
    CaveOfMysidiaB2     = 221,
    CaveOfMysidiaStairsB3 = 222,
    CaveOfMysidiaB3     = 223,
    CaveOfMysidiaStairsB4 = 224,
    CaveOfMysidiaB4     = 225,
    CaveOfMysidiaStairsB5 = 227,
    CaveOfMysidiaB5     = 208,

    // Leviathan
    Leviathan1F         = 228,
    Leviathan2F         = 229,
    Leviathan3F         = 230,

    // Mysidia Tower
    MysidiaTower1F      = 231,
    MysidiaTower2F      = 242,
    MysidiaTower3F      = 253,
    MysidiaTowerFireGigas   = 261,
    MysidiaTower4F      = 262,
    // MysidiaTower5F = 263 conflicts with CycloneFinalFloor — not needed for splitting
    MysidiaTowerIceGigas    = 264,
    MysidiaTower6F      = 232,
    MysidiaTowerTo7F    = 233,
    MysidiaTower7F      = 234,
    MysidiaTowerThunderGigas = 235,
    MysidiaTower8F      = 236,
    MysidiaTowerTo9F    = 237,
    MysidiaTower9F      = 238,
    MysidiaTower10F     = 240,
    MysidiaTowerUltima  = 241,

    // Cyclone
    Cyclone1F           = 265,
    Cyclone2F           = 268,
    Cyclone3F           = 269,
    Cyclone4F           = 270,
    Cyclone5F           = 271,
    Cyclone6F           = 272,
    CycloneFinalFloor   = 263,  // shares ID with MysidiaTower5F — same value

    // Castle Palamecia
    Palamecia1F         = 282,
    Palamecia2F         = 283,
    Palamecia3F         = 284,
    Palamecia4F         = 285,
    Palamecia5F         = 287,
    Palamecia6F         = 277,
    Palamecia7F         = 276,
    Palamecia8F         = 278,
    PalameciaTrapDoor   = 280,

    // Jade Passage
    JadePassageEntrance = 288,
    JadePassageB1       = 299,
    JadePassageStairsB2 = 307,
    JadePassageB2       = 308,
    JadePassageStairsB3 = 309,
    JadePassageB3       = 310,
    JadePassageStairsB4 = 311,
    JadePassageB4       = 312,
    JadePassageStairsB5 = 289,
    JadePassageB5       = 290,
    JadePassageStairsB6 = 291,
    JadePassageB6       = 292,

    // Pandaemonium
    Pandaemonium1F      = 314,
    Pandaemonium2F      = 317,
    Pandaemonium3F      = 318,
    Pandaemonium4F      = 319,
    Pandaemonium5F      = 322,
    Pandaemonium7F      = 323,
    Pandaemonium8F      = 324,
    Pandaemonium9F      = 315,
    Pandaemonium10F     = 316,

    // Ending
    // EndingCutscene = 43 conflicts with FynnCastle4F — not needed for splitting
}

impl Location {
    /// Human-readable name for ASL Var Viewer display.
    pub fn name(self) -> &'static str {
        match self {
            Location::WorldMap              => "World Map",
            Location::Altair                => "Altair",
            Location::AltairThrone          => "Altair - Throne Room",
            Location::AltairRebel           => "Altair - Rebel Hideout",
            Location::AltairChurch          => "Altair - Church",
            Location::AltairMagic           => "Altair - Magic Shop",
            Location::AltairStartRoom       => "Altair - Starting Room",
            Location::AltairKingsRoom       => "Altair - King's Room",
            Location::AltairQueensRoom      => "Altair - Queen's Room",
            Location::AltairInn             => "Altair - Inn",
            Location::AltairArmor           => "Altair - Armor Shop",
            Location::AltairItems           => "Altair - Item Shop",
            Location::AltairWeapons         => "Altair - Weapons Shop",
            Location::AltairPost            => "Altair (post-bombing)",
            Location::AltairInnPost         => "Altair - Inn (post-bombing)",
            Location::AltairArmorPost       => "Altair - Armor (post-bombing)",
            Location::AltairWeaponsPost     => "Altair - Weapons (post-bombing)",
            Location::AltairItemsPost       => "Altair - Items (post-bombing)",
            Location::AltairMagicPost       => "Altair - Magic (post-bombing)",
            Location::AltairRebelPost       => "Altair - Rebel Hideout (post-bombing)",
            Location::AltairThronePost      => "Altair - Throne Room (post-bombing)",
            Location::AltairStartPost       => "Altair - Starting Room (post-bombing)",
            Location::AltairKingsPost       => "Altair - King's Room (post-bombing)",
            Location::AltairQueensPost      => "Altair - Queen's Room (post-bombing)",
            Location::AltairChurchPost      => "Altair - Church (post-bombing)",
            Location::Fynn                  => "Fynn",
            Location::FynnCastle1F          => "Fynn Castle - 1F",
            Location::FynnCastle2F          => "Fynn Castle - 2F",
            Location::FynnCastleB1          => "Fynn Castle - B1",
            Location::FynnCastleB2          => "Fynn Castle - B2",
            Location::FynnCastleB5          => "Fynn Castle - B5",
            Location::FynnCastle2FAlt       => "Fynn Castle - 2F (alt)",
            Location::FynnCastle3F          => "Fynn Castle - 3F",
            Location::FynnCastle4F          => "Fynn Castle - 4F",
            Location::FynnCastleSecret      => "Fynn Castle - Secret Room",
            Location::FynnCastle3FAlt       => "Fynn Castle - 3F (alt)",
            Location::FynnCastleWhiteMask   => "Fynn Castle - White Mask Room",
            Location::Paloom                => "Paloom",
            Location::PaloomItems           => "Paloom - Items",
            Location::PaloomInn             => "Paloom - Inn",
            Location::PaloomWeapons         => "Paloom - Weapons",
            Location::PaloomArmor           => "Paloom - Armor",
            Location::PaloomMagic           => "Paloom - Magic",
            Location::PaloomPost            => "Paloom (post-bombing)",
            Location::Poft                  => "Poft",
            Location::PoftPub               => "Poft - Pub",
            Location::PoftItems             => "Poft - Items",
            Location::PoftInn               => "Poft - Inn",
            Location::PoftWeapons           => "Poft - Weapons",
            Location::PoftArmor             => "Poft - Armor",
            Location::PoftMagic             => "Poft - Magic",
            Location::PoftPost              => "Poft (post-bombing)",
            Location::PoftPubPost           => "Poft - Pub (post-bombing)",
            Location::PoftInnPost           => "Poft - Inn (post-bombing)",
            Location::ShipCutscene          => "Ship (Leila cutscene)",
            Location::Bafsk                 => "Bafsk",
            Location::BafskItems            => "Bafsk - Items",
            Location::BafskChurch           => "Bafsk - Church",
            Location::BafskInn              => "Bafsk - Inn",
            Location::BafskMagic            => "Bafsk - Magic",
            Location::BafskWeapons          => "Bafsk - Weapons",
            Location::BafskArmor            => "Bafsk - Armor",
            Location::BafskCaveB1           => "Bafsk Cave - B1",
            Location::BafskCave1F           => "Bafsk Cave - 1F",
            Location::BafskCaveTeleport     => "Bafsk Cave - Teleport Room",
            Location::Salamand              => "Salamand",
            Location::SalamandJosef         => "Salamand - Josef's House",
            Location::SalamandInn           => "Salamand - Inn",
            Location::SalamandWeapons       => "Salamand - Weapons",
            Location::SalamandArmor         => "Salamand - Armor",
            Location::SalamandChurch        => "Salamand - Church",
            Location::SalamandMagic         => "Salamand - Magic",
            Location::SalamandItems         => "Salamand - Items",
            Location::SemittFalls1F         => "Semitt Falls - 1F",
            Location::SemittFallsSnowcraft  => "Semitt Falls - Snowcraft Room",
            Location::SemittFalls2F         => "Semitt Falls - 2F",
            Location::SemittFallsB2         => "Semitt Falls - B2",
            Location::SemittFallsB3         => "Semitt Falls - B3",
            Location::SemittFallsB4         => "Semitt Falls - B4",
            Location::SemittFallsB5         => "Semitt Falls - B5",
            Location::SnowCaveB1            => "Snow Cave - B1",
            Location::SnowCaveB2            => "Snow Cave - B2",
            Location::SnowCaveB3            => "Snow Cave - B3",
            Location::SnowCaveB4            => "Snow Cave - B4",
            Location::SnowCaveB5            => "Snow Cave - B5",
            Location::SnowCaveBeaverRoom    => "Snow Cave - Beaver Room",
            Location::SnowCaveB6            => "Snow Cave - B6",
            Location::KashuanKeep1F         => "Kashuan Keep - 1F",
            Location::KashuanKeepBoss       => "Kashuan Keep - Boss Floor",
            Location::KashuanKeepGordon     => "Kashuan Keep - Gordon Floor",
            Location::KashuanKeep2F         => "Kashuan Keep - 2F",
            Location::KashuanKeep3F         => "Kashuan Keep - 3F",
            Location::KashuanKeep4F         => "Kashuan Keep - 4F",
            Location::KashuanKeep5F         => "Kashuan Keep - 5F",
            Location::ChocobForest          => "Chocobo Forest",
            Location::Dreadnought1F         => "Dreadnought - 1F",
            Location::Dreadnought2F         => "Dreadnought - 2F",
            Location::Dreadnought3F         => "Dreadnought - 3F",
            Location::DreadnoughtStairs4F   => "Dreadnought - Stairs to 4F",
            Location::Dreadnought4F         => "Dreadnought - 4F",
            Location::DreadnoughtStairs5F   => "Dreadnought - Stairs to 5F",
            Location::DreadnoughtFinal      => "Dreadnought - Final Room",
            Location::CastleDeist1F         => "Castle Deist - 1F",
            Location::CastleDeistTreasure   => "Castle Deist - Treasure Room",
            Location::CastleDeist2F         => "Castle Deist - 2F",
            Location::DeistCavernB1         => "Deist Cavern - B1",
            Location::DeistCavernB2         => "Deist Cavern - B2",
            Location::DeistCavernB3         => "Deist Cavern - B3",
            Location::DeistCavernB4         => "Deist Cavern - B4",
            Location::DeistCavernB5         => "Deist Cavern - B5",
            Location::BlackMaskCaveB1       => "Black Mask Cave - B1",
            Location::BlackMaskCaveB2       => "Black Mask Cave - B2",
            Location::BlackMaskCaveB3       => "Black Mask Cave - B3",
            Location::BlackMaskCaveB4       => "Black Mask Cave - B4",
            Location::BlackMaskCaveB5       => "Black Mask Cave - B5",
            Location::BlackMaskBossRoom     => "Black Mask Cave - Boss Room",
            Location::Coliseum1F            => "Coliseum - 1F",
            Location::ColiseumB2            => "Coliseum - B2",
            Location::ColiseumB1            => "Coliseum - B1",
            Location::RebelCamp             => "Rebel Camp",
            Location::Mysidia               => "Mysidia",
            Location::MysidiaWeapons        => "Mysidia - Weapons",
            Location::MysidiaInn            => "Mysidia - Inn",
            Location::MysidiaItems          => "Mysidia - Items",
            Location::MysidiaArmor          => "Mysidia - Armor",
            Location::MysidiaMagic          => "Mysidia - Magic",
            Location::MysidiaHouse          => "Mysidia - House",
            Location::MysidiaUnderground    => "Mysidia - Underground",
            Location::CaveOfMysidiaB1       => "Cave of Mysidia - B1",
            Location::CaveOfMysidiaStairsB2 => "Cave of Mysidia - Stairs to B2",
            Location::CaveOfMysidiaB2       => "Cave of Mysidia - B2",
            Location::CaveOfMysidiaStairsB3 => "Cave of Mysidia - Stairs to B3",
            Location::CaveOfMysidiaB3       => "Cave of Mysidia - B3",
            Location::CaveOfMysidiaStairsB4 => "Cave of Mysidia - Stairs to B4",
            Location::CaveOfMysidiaB4       => "Cave of Mysidia - B4",
            Location::CaveOfMysidiaStairsB5 => "Cave of Mysidia - Stairs to B5",
            Location::CaveOfMysidiaB5       => "Cave of Mysidia - B5",
            Location::Leviathan1F           => "Leviathan - 1F",
            Location::Leviathan2F           => "Leviathan - 2F",
            Location::Leviathan3F           => "Leviathan - 3F",
            Location::MysidiaTower1F        => "Mysidia Tower - 1F",
            Location::MysidiaTower2F        => "Mysidia Tower - 2F",
            Location::MysidiaTower3F        => "Mysidia Tower - 3F",
            Location::MysidiaTowerFireGigas => "Mysidia Tower - Fire Gigas Room",
            Location::MysidiaTower4F        => "Mysidia Tower - 4F",
            Location::MysidiaTowerIceGigas  => "Mysidia Tower - Ice Gigas Floor",
            Location::MysidiaTower6F        => "Mysidia Tower - 6F",
            Location::MysidiaTowerTo7F      => "Mysidia Tower - Room to 7F",
            Location::MysidiaTower7F        => "Mysidia Tower - 7F",
            Location::MysidiaTowerThunderGigas => "Mysidia Tower - Thunder Gigas Room",
            Location::MysidiaTower8F        => "Mysidia Tower - 8F",
            Location::MysidiaTowerTo9F      => "Mysidia Tower - Room to 9F",
            Location::MysidiaTower9F        => "Mysidia Tower - 9F",
            Location::MysidiaTower10F       => "Mysidia Tower - 10F",
            Location::MysidiaTowerUltima    => "Mysidia Tower - Ultima Room",
            Location::Cyclone1F             => "Cyclone - 1F",
            Location::Cyclone2F             => "Cyclone - 2F",
            Location::Cyclone3F             => "Cyclone - 3F",
            Location::Cyclone4F             => "Cyclone - 4F",
            Location::Cyclone5F             => "Cyclone - 5F",
            Location::Cyclone6F             => "Cyclone - 6F",
            Location::CycloneFinalFloor     => "Cyclone - Final Floor",
            Location::Palamecia1F           => "Castle Palamecia - 1F",
            Location::Palamecia2F           => "Castle Palamecia - 2F",
            Location::Palamecia3F           => "Castle Palamecia - 3F",
            Location::Palamecia4F           => "Castle Palamecia - 4F",
            Location::Palamecia5F           => "Castle Palamecia - 5F",
            Location::Palamecia6F           => "Castle Palamecia - 6F",
            Location::Palamecia7F           => "Castle Palamecia - 7F",
            Location::Palamecia8F           => "Castle Palamecia - 8F",
            Location::PalameciaTrapDoor     => "Castle Palamecia - Trap Door Room",
            Location::JadePassageEntrance   => "Jade Passage - Entrance",
            Location::JadePassageB1         => "Jade Passage - B1",
            Location::JadePassageStairsB2   => "Jade Passage - Stairs to B2",
            Location::JadePassageB2         => "Jade Passage - B2",
            Location::JadePassageStairsB3   => "Jade Passage - Stairs to B3",
            Location::JadePassageB3         => "Jade Passage - B3",
            Location::JadePassageStairsB4   => "Jade Passage - Stairs to B4",
            Location::JadePassageB4         => "Jade Passage - B4",
            Location::JadePassageStairsB5   => "Jade Passage - Stairs to B5",
            Location::JadePassageB5         => "Jade Passage - B5",
            Location::JadePassageStairsB6   => "Jade Passage - Stairs to B6",
            Location::JadePassageB6         => "Jade Passage - B6",
            Location::Pandaemonium1F        => "Pandaemonium - 1F",
            Location::Pandaemonium2F        => "Pandaemonium - 2F",
            Location::Pandaemonium3F        => "Pandaemonium - 3F",
            Location::Pandaemonium4F        => "Pandaemonium - 4F",
            Location::Pandaemonium5F        => "Pandaemonium - 5F",
            Location::Pandaemonium7F        => "Pandaemonium - 7F",
            Location::Pandaemonium8F        => "Pandaemonium - 8F",
            Location::Pandaemonium9F        => "Pandaemonium - 9F",
            Location::Pandaemonium10F       => "Pandaemonium - 10F",
            // EndingCutscene removed (conflicted with FynnCastle4F = 43)
        }
    }
}

// ── Key item IDs ──────────────────────────────────────────────────────────────
// Stored in importantOwendItems as (item_id + 1) keys.

#[derive(Copy, Clone, Debug, PartialEq, Eq, TryFromPrimitive)]
#[repr(u32)]
pub enum Item {
    Ring        = 1,
    Canoe       = 2,
    Pass        = 3,
    Mythril     = 4,
    Snowcraft   = 5,
    GoddessBell = 6,
    EgilsTorch  = 7,
    Sunfire     = 8,
    Pendant     = 9,
    WyvernEgg   = 10,
    WhiteMask   = 11,
    BlackMask   = 12,
    CrystalRod  = 13,
    Wyvern      = 14,
}

impl super::EnumSetMember for Item {
    fn ordinal(&self) -> Option<u8> {
        Some(*self as u8)
    }
}

// ── Data container ────────────────────────────────────────────────────────────

pub struct Data<'a> {
    battles:  BattleData,
    items:    ItemsData,
    user:     UserData,
    new_game: NewGame,
    process:  &'a Process,
    module:   &'a Module,
    image:    &'a Image,
}

impl<'a> Data<'a> {
    pub async fn new(process: &'a Process, module: &'a Module, image: &'a Image) -> Self {
        Self {
            battles:  BattleData::new(),
            items:    ItemsData::new(),
            user:     UserData::new(),
            new_game: NewGame::new(),
            process,
            module,
            image,
        }
    }
}

impl Data<'_> {
    pub fn battle_active(&self) -> bool {
        self.battles.active
            .deref(self.process, self.module, self.image)
            .unwrap_or_default()
    }

    pub fn encounter(&self) -> Option<Monster> {
        let obj_ptr: Pointer<RawSlotObj> = self.battles.monster_slots
            .deref(self.process, self.module, self.image)
            .ok()?;
        let obj = obj_ptr.read(self.process)?;
        Monster::try_from_primitive(obj.slot0).ok()
    }

    pub fn battle_result(&self) -> BattleResult {
        self.battles.end_result
            .deref::<u32>(self.process, self.module, self.image)
            .map_or(BattleResult::Unknown, BattleResult::from)
    }

    pub fn battle_state(&self) -> Option<BattleState> {
        self.battles.battle_state
            .deref::<u32>(self.process, self.module, self.image)
            .ok()
            .and_then(|s| BattleState::try_from_primitive(s).ok())
    }

    pub fn battle_time(&self) -> f32 {
        self.battles.elapsed_time
            .deref(self.process, self.module, self.image)
            .unwrap_or_default()
    }

    pub fn key_item_ids(&self) -> impl Iterator<Item = Item> + '_ {
        self.items.key_items
            .deref::<Pointer<Map<u32, Pointer<()>>>>(self.process, self.module, self.image)
            .into_iter()
            .filter_map(|key_items| key_items.iter(self.process))
            .flatten()
            .map(|(item_id_plus_1, _)| item_id_plus_1.saturating_sub(1))
            .filter_map(|item_id| Item::try_from_primitive(item_id).ok())
    }

    pub fn location(&self) -> Option<Location> {
        self.user.map_id
            .deref(self.process, self.module, self.image)
            .ok()
            .and_then(|id| Location::try_from_primitive(id).ok())
    }

    pub fn raw_map_id(&self) -> u32 {
        self.user.map_id
            .deref(self.process, self.module, self.image)
            .unwrap_or(0)
    }

    pub fn has_fade_out(&self) -> bool {
        self.new_game
            .has_fade_out(self.process, self.module, self.image)
            .unwrap_or(false)
    }
}

// ── Raw slot object layout ────────────────────────────────────────────────────
// Confirmed from probe raw dumps: slot0 (formation ID) at offset 0x20.

#[derive(Copy, Clone, AnyBitPattern)]
#[repr(C)]
struct RawSlotObj {
    _type_id:  u64,  // 0x00
    _header:   u64,  // 0x08
    _header2:  u64,  // 0x10
    _capacity: u32,  // 0x18  always 51
    _pad:      u32,  // 0x1C
    pub slot0: u32,  // 0x20  ← formation/encounter ID
}

// ── Pointer paths ─────────────────────────────────────────────────────────────

fn ptr_path<const N: usize>(cls: &'static str, path: [&'static str; N]) -> UnityPointer<N> {
    UnityPointer::new(cls, 0, &path)
}

struct NewGame {
    fade_out_finish: UnityPointer<2>,
}

impl NewGame {
    fn new() -> Self {
        Self {
            fade_out_finish: UnityPointer::new(
                "FadeManager", 1,
                &["instance", "fadeOutFinishedCallback"],
            ),
        }
    }

    fn has_fade_out(&self, process: &Process, module: &Module, image: &Image) -> Option<bool> {
        let ptr = self.fade_out_finish
            .deref::<Address64>(process, module, image)
            .ok()?;
        Some(!ptr.is_null())
    }
}

struct BattleData {
    active:        UnityPointer<2>,
    monster_slots: UnityPointer<5>,
    end_result:    UnityPointer<3>,
    elapsed_time:  UnityPointer<2>,
    battle_state:  UnityPointer<4>,
}

impl BattleData {
    fn new() -> Self {
        Self {
            active: ptr_path("BattlePlugManager", ["instance", "isBattle"]),
            monster_slots: UnityPointer::new(
                "BattlePlugManager", 0,
                &[
                    "instance",
                    "<InstantiateManager>k__BackingField",
                    "<battleEnemyInstanceData>k__BackingField",
                    "<monsterParty>k__BackingField",
                    "valueIntList",
                ],
            ),
            end_result: ptr_path(
                "BattlePlugManager",
                ["instance", "<BattleEndJugment>k__BackingField", "resultType"],
            ),
            battle_state: UnityPointer::new(
                "BattlePlugManager", 0,
                &[
                    "instance",
                    "<BattleController>k__BackingField",
                    "stateMachine",
                    "<currentState>k__BackingField",
                ],
            ),
            elapsed_time: ptr_path("BattlePlugManager", ["instance", "elapsedTime"]),
        }
    }
}

struct ItemsData {
    key_items: UnityPointer<2>,
}

impl ItemsData {
    fn new() -> Self {
        Self {
            key_items: ptr_path(
                "UserDataManager",
                ["instance", "importantOwendItems"],
            ),
        }
    }
}

struct UserData {
    map_id: UnityPointer<2>,
}

impl UserData {
    fn new() -> Self {
        Self {
            map_id: ptr_path(
                "UserDataManager",
                ["instance", "<CurrentMapId>k__BackingField"],
            ),
        }
    }
}

// ── Il2CPP memory helpers ─────────────────────────────────────────────────────

#[repr(C)]
struct Pointer<T> {
    address: Address64,
    _t: PhantomData<T>,
}

impl<T> Pointer<T> {
    const fn address(self) -> Address64 { self.address }
    fn addr(self) -> Address { self.address.into() }
    fn is_null(self) -> bool { self.address.is_null() }
}

impl<T: CheckedBitPattern> Pointer<T> {
    fn read(self, process: &Process) -> Option<T> {
        if self.is_null() { return None; }
        process.read(self.address).ok()
    }
}

impl<T> fmt::Debug for Pointer<T> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("Pointer")
            .field("address", &self.address)
            .field("type", &core::any::type_name::<T>())
            .finish()
    }
}

impl<T> Copy for Pointer<T> {}
impl<T> Clone for Pointer<T> { fn clone(&self) -> Self { *self } }
unsafe impl<T: 'static> AnyBitPattern for Pointer<T> {}
unsafe impl<T: 'static> bytemuck::Zeroable for Pointer<T> {}

#[repr(C)]
struct Array<T> {
    _type_id: u64,
    _header:  u64,
    _header2: u64,
    size: u32,
    _t: PhantomData<T>,
}

impl<T> Array<T> {
    const DATA: u64 = 0x20;
}

impl<T: CheckedBitPattern + 'static> Pointer<Array<T>> {
    fn iter<'a>(self, process: &'a Process) -> Option<impl Iterator<Item = T> + 'a> {
        let array = self.read(process)?;
        let start = self.address() + Array::<T>::DATA;
        let count = array.size as usize;
        Some((0..count).filter_map(move |i| {
            process.read(start + (i * size_of::<T>()) as u64).ok()
        }))
    }
}

impl<T> Copy for Array<T> {}
impl<T> Clone for Array<T> { fn clone(&self) -> Self { *self } }
unsafe impl<T: 'static> AnyBitPattern for Array<T> {}
unsafe impl<T: 'static> bytemuck::Zeroable for Array<T> {}

#[repr(C)]
struct Map<K, V> {
    _type_id:  u64,
    _header:   u64,
    _header_2: u64,
    entries:   Pointer<Array<Entry<K, V>>>,
    size: u32,
}

#[derive(Copy, Clone, AnyBitPattern)]
#[repr(C)]
struct Entry<K, V> {
    _hash: u32,
    _next: u32,
    key:   K,
    value: V,
}

impl<K: AnyBitPattern + 'static, V: AnyBitPattern + 'static> Pointer<Map<K, V>> {
    fn iter(self, process: &Process) -> Option<impl Iterator<Item = (K, V)> + '_> {
        let map = self.read(process)?;
        Some(
            map.entries
                .iter(process)?
                .filter(|o| o._hash != 0 || o._next != 0)
                .take(map.size as _)
                .map(|o| (o.key, o.value)),
        )
    }
}

impl<K, V> Copy for Map<K, V> {}
impl<K, V> Clone for Map<K, V> { fn clone(&self) -> Self { *self } }
unsafe impl<K: 'static, V: 'static> AnyBitPattern for Map<K, V> {}
unsafe impl<K: 'static, V: 'static> bytemuck::Zeroable for Map<K, V> {}