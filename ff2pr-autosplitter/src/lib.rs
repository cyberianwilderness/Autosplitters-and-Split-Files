#![no_std]

use asr::{
    future::next_tick,
    game_engine::unity::il2cpp::Module,
    settings::{gui::Title as Heading, Gui},
    timer::{self, TimerState},
    watcher::{Pair, Watcher},
    Process,
};
use core::{marker::PhantomData, ops::ControlFlow};

use crate::data::{BattleResult, BattleState, Data, Item, Location, Monster};

mod data;

asr::async_main!(stable);
asr::panic_handler!();

#[macro_export]
macro_rules! log {
    ($($arg:tt)*) => {{
        let mut buf = ::asr::arrayvec::ArrayString::<8192>::new();
        let _ = ::core::fmt::Write::write_fmt(
            &mut buf,
            ::core::format_args!($($arg)*),
        );
        ::asr::print_message(&buf);
    }};
}

// ── Settings ──────────────────────────────────────────────────────────────────

#[derive(Gui)]
pub struct Settings {
    /// General Settings
    _general: Heading,

    /// Start the timer on new game
    #[default = true]
    start: bool,

    /// Split when defeating the final Emperor (Pandaemonium)
    #[default = true]
    emperor_final: bool,

/// --- Splits (enable only what matches your layout) ---
    _splits_heading: Heading,

    /// Split when obtaining the Ring (Fynn pub - Scott)
    #[default = false]
    ring: bool,

    /// Split when obtaining the Canoe
    #[default = false]
    canoe: bool,

    /// Split when obtaining Mythril
    #[default = false]
    mythril: bool,

    /// Split when defeating the Sergeant (Semitt Falls)
    #[default = false]
    sergeant: bool,

    /// Split when obtaining the Pass (Bafsk sewers)
    #[default = false]
    pass: bool,

    /// Split when obtaining the Snowcraft (Semitt Falls)
    #[default = false]
    snowcraft: bool,

    /// Split when defeating Adamantoise (Snow Cave)
    #[default = false]
    adamantoise: bool,

    /// Split when obtaining the Goddess' Bell (Snow Cave)
    #[default = false]
    goddess_bell: bool,

    /// Split when defeating Borghen (Snow Cave escape)
    #[default = false]
    borghen: bool,

    /// Split when obtaining Egil's Torch (Kashuan Keep)
    #[default = false]
    egils_torch: bool,

    /// Split when defeating the Red Soul (Kashuan Keep)
    #[default = false]
    red_soul: bool,

    /// Split when obtaining Sunfire (Kashuan Keep)
    #[default = false]
    sunfire: bool,

    /// Split when defeating the Pirates / Leila fight
    #[default = false]
    pirates: bool,

    /// Split when obtaining the Pendant (Deist Cave)
    #[default = false]
    pendant: bool,

    /// Split when obtaining the Wyvern Egg (Castle Deist)
    #[default = false]
    wyvern_egg: bool,

    /// Split when defeating the Chimera x4 (Deist Cave)
    #[default = false]
    chimera: bool,

    /// Split when defeating the Big Horns x4 (Black Mask Cave)
    #[default = false]
    big_horns: bool,

    /// Split when obtaining the Black Mask
    #[default = false]
    black_mask: bool,

    /// Split when defeating the Lamia Queen (Altair ambush)
    #[default = false]
    lamia_queen: bool,

    /// Split when defeating Behemoth (Coliseum)
    #[default = false]
    behemoth: bool,

    /// Split when defeating Gottos (Fynn Castle)
    #[default = false]
    gottos: bool,

    /// Split when obtaining the White Mask (Fynn Sewers)
    #[default = false]
    white_mask: bool,

    /// Split when obtaining the Crystal Rod (Cave of Mysidia)
    #[default = false]
    crystal_rod: bool,

    /// Split when defeating the Roundworm (Leviathan)
    #[default = false]
    roundworm: bool,

    /// Split when entering Mysidia Tower (World Map -> Tower 1F)
    #[default = false]
    enter_mysidia_tower: bool,

    /// Split when defeating the Fire Gigas (Mysidia Tower)
    #[default = false]
    fire_gigas: bool,

    /// Split when defeating the Ice Gigas (Mysidia Tower)
    #[default = false]
    ice_gigas: bool,

    /// Split when defeating the Thunder Gigas (Mysidia Tower)
    #[default = false]
    thunder_gigas: bool,

    /// Split when the Wyvern hatches (after Mysidia Tower)
    #[default = false]
    wyvern: bool,

    /// Split when defeating the Emperor (Cyclone)
    #[default = false]
    emperor_cyclone: bool,

    /// Split when entering Jade Passage (World Map -> Jade Passage Entrance)
    #[default = false]
    palamecia: bool,

    /// Split when entering Pandaemonium (Jade Passage B6 -> Pandaemonium 1F)
    #[default = false]
    jade_passage: bool,

    /// Split when the final Emperor fight starts (Pandaemonium)
    #[default = false]
    pandaemonium: bool,
}

// ── Main ──────────────────────────────────────────────────────────────────────

async fn main() {
    asr::set_tick_rate(60.0);

    let mut settings = {
        let mut s = Settings::register();
        s.update();
        s
    };

    loop {
        let process = Process::wait_attach("FINAL FANTASY II.exe").await;
        log!("Attached to FINAL FANTASY II.exe");
        process
            .until_closes(game_loop(&process, &mut settings))
            .await;
    }
}

enum State {
    NotRunning(Title),
    Running(Splits),
}

async fn game_loop(process: &Process, settings: &mut Settings) {
    let module = Module::wait_attach_auto_detect(process).await;
    let image  = module.wait_get_default_image(process).await;
    log!("il2cpp ready");

    let data = Data::new(process, &module, &image).await;
    log!("Game data loaded — autosplitter running");

    // ── LiveSplit variables (visible in Layout Editor -> Timer -> Variables) ──
    timer::set_variable("location", "Unknown");
    timer::set_variable("encounter_count", "0");

    let mut state = State::NotRunning(Title::new());
    let mut encounter_count: u32 = 0;
    let mut last_in_battle = false;
    let mut location_cache: Option<Location> = None;

    'outer: loop {
        settings.update();

        // ── ASL Var: location name ────────────────────────────────────────────
        if let Some(loc) = data.location() {
            if Some(loc) != location_cache {
                location_cache = Some(loc);
                let mut vars = asr::settings::Map::load();
                timer::set_variable("location", loc.name());
            }
        }

        // ── ASL Var: encounter counter ────────────────────────────────────────
        let in_battle = data.battle_active();
        if in_battle && !last_in_battle {
            encounter_count = encounter_count.saturating_add(1);
            let mut buf = asr::arrayvec::ArrayString::<32>::new();
            let _ = core::fmt::Write::write_fmt(&mut buf, format_args!("{}", encounter_count));
            timer::set_variable("encounter_count", &buf);
        }
        last_in_battle = in_battle;

        // ── Debug: log isBattle raw value every 5 seconds ───────────────────
        {
            static mut TICK: u32 = 0;
            unsafe {
                TICK = TICK.wrapping_add(1);
                if TICK % 300 == 0 {
                    let raw = data.battle_active();
                    log!("[DEBUG] isBattle={raw}");
                }
            }
        }

        // ── Timer logic ───────────────────────────────────────────────────────
        match main_loop(&data, &mut state) {
            ControlFlow::Continue(()) => continue 'outer,
            ControlFlow::Break(Action::Start) if settings.start => {
                log!("Starting timer — timer::start() called");
                encounter_count = 0;
                timer::start();
                log!("After timer::start(), state={:?}", timer::state());
            }
            ControlFlow::Break(Action::Split(split)) if settings.filter(split) => {
                log!("Splitting: {split:?}");
                timer::split();
            }
            ControlFlow::Break(Action::Start) => {
                log!("Ignoring: Start");
            }
            ControlFlow::Break(Action::Split(split)) => {
                log!("Ignoring: {split:?}");
            }
            ControlFlow::Break(Action::None) => {}
        }

        next_tick().await;
    }
}

fn main_loop(
    data: &Data<'_>,
    state: &mut State,
) -> ControlFlow<Action> {
    match state {
        State::NotRunning(title) => match timer::state() {
            TimerState::Running => {
                log!("[state] NotRunning -> Running detected, creating fresh Splits");
                *state = State::Running(Splits::new());
                return ControlFlow::Continue(());
            }
            TimerState::NotRunning => {
                if title.new_game(data) {
                    *state = State::Running(Splits::new());
                    return ControlFlow::Break(Action::Start);
                }
            }
            _ => {}
        },
        State::Running(splits) => match timer::state() {
            TimerState::NotRunning => {
                *state = State::NotRunning(Title::new());
                return ControlFlow::Continue(());
            }
            TimerState::Running => {
                if let Some(split) = splits.check(data) {
                    return ControlFlow::Break(Action::Split(split));
                }
            }
            _ => {}
        },
    }
    ControlFlow::Break(Action::None)
}

// ── Actions ───────────────────────────────────────────────────────────────────

#[derive(Copy, Clone, Debug, PartialEq, Eq)]
enum Action {
    None,
    Start,
    Split(SplitOn),
}

// Split order matches the any% route order for clarity.
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
enum SplitOn {
    Ring,
    Canoe,
    Mythril,
    Sergeant,
    Pass,
    Snowcraft,
    Adamantoise,
    GoddessBell,
    Borghen,
    EgilsTorch,
    RedSoul,
    Sunfire,
    Pirates,
    Pendant,
    WyvernEgg,
    Chimera,
    BigHorns,
    BlackMask,
    LamiaQueen,
    Behemoth,
    Gottos,
    WhiteMask,
    CrystalRod,
    Roundworm,
    EnterMysidiaTower,
    FireGigas,
    IceGigas,
    ThunderGigas,
    Wyvern,
    EmperorCyclone,
    Palamecia,
    JadePassage,
    Pandaemonium,
    EmperorFinal,
}

impl EnumSetMember for SplitOn {
    fn ordinal(&self) -> Option<u8> {
        Some(*self as u8)
    }
}

impl Settings {
    fn filter(&self, split: SplitOn) -> bool {
        match split {
            SplitOn::Ring              => self.ring,
            SplitOn::Canoe             => self.canoe,
            SplitOn::Mythril           => self.mythril,
            SplitOn::Sergeant          => self.sergeant,
            SplitOn::Pass              => self.pass,
            SplitOn::Snowcraft         => self.snowcraft,
            SplitOn::Adamantoise       => self.adamantoise,
            SplitOn::GoddessBell       => self.goddess_bell,
            SplitOn::Borghen           => self.borghen,
            SplitOn::EgilsTorch        => self.egils_torch,
            SplitOn::RedSoul           => self.red_soul,
            SplitOn::Sunfire           => self.sunfire,
            SplitOn::Pirates           => self.pirates,
            SplitOn::Pendant           => self.pendant,
            SplitOn::WyvernEgg         => self.wyvern_egg,
            SplitOn::Chimera           => self.chimera,
            SplitOn::BigHorns          => self.big_horns,
            SplitOn::BlackMask         => self.black_mask,
            SplitOn::LamiaQueen        => self.lamia_queen,
            SplitOn::Behemoth          => self.behemoth,
            SplitOn::Gottos            => self.gottos,
            SplitOn::WhiteMask         => self.white_mask,
            SplitOn::CrystalRod        => self.crystal_rod,
            SplitOn::Roundworm         => self.roundworm,
            SplitOn::EnterMysidiaTower => self.enter_mysidia_tower,
            SplitOn::FireGigas         => self.fire_gigas,
            SplitOn::IceGigas          => self.ice_gigas,
            SplitOn::ThunderGigas      => self.thunder_gigas,
            SplitOn::Wyvern            => self.wyvern,
            SplitOn::EmperorCyclone    => self.emperor_cyclone,
            SplitOn::Palamecia         => self.palamecia,
            SplitOn::JadePassage       => self.jade_passage,
            SplitOn::Pandaemonium      => self.pandaemonium,
            SplitOn::EmperorFinal      => self.emperor_final,
        }
    }
}

// ── Map transition splits ─────────────────────────────────────────────────────

impl SplitOn {
    fn from_location(watcher: &Pair<Location>) -> Option<Self> {
        match (watcher.old, watcher.current) {
            // Enter Mysidia Tower from World Map
            (Location::WorldMap, Location::MysidiaTower1F) =>
                Some(SplitOn::EnterMysidiaTower),
            // Palamecia split: fires when entering Jade Passage from World Map
            (Location::WorldMap, Location::JadePassageEntrance) =>
                Some(SplitOn::Palamecia),
            // Jade Passage split: fires when entering Pandaemonium 1F from Jade Passage B6
            (Location::JadePassageB6, Location::Pandaemonium1F) =>
                Some(SplitOn::JadePassage),
            _ => None,
        }
    }
}

// ── Title screen ──────────────────────────────────────────────────────────────

struct Title {
    fade_out: Watcher<bool>,
}

impl Title {
    fn new() -> Self {
        Self { fade_out: Watcher::new() }
    }

    fn new_game(&mut self, data: &Data) -> bool {
        let fade_out = self.fade_out.update_infallible(data.has_fade_out());
        if fade_out.changed_to(&true) {
            log!("Fade out detected — new game starting");
            return true;
        }
        false
    }
}

// ── Split state ───────────────────────────────────────────────────────────────

#[derive(Copy, Clone, Debug)]
struct NoBattle;

struct Splits {
    in_battle:     Watcher<bool>,
    battle_result: Watcher<BattleResult>,
    location:      Watcher<Location>,
    items:         EnumSet<Item>,
    seen:          EnumSet<SplitOn>,
    emperor_end:   f32,
    last_monster:  Option<Monster>,  // cached when battle starts
}

impl Splits {
    fn new() -> Self {
        Self {
            in_battle:     Watcher::new(),
            battle_result: Watcher::new(),
            location:      Watcher::new(),
            items:         EnumSet::empty(),
            seen:          EnumSet::empty(),
            emperor_end:   f32::MAX,
            last_monster:  None,
        }
    }

    fn check(&mut self, data: &Data) -> Option<SplitOn> {
        let split = self.split_check(data)?;
        let is_new = self.seen.insert(&split);
        log!("[check] split={split:?} is_new={is_new}");
        is_new.then_some(split)
    }

    fn split_check(&mut self, data: &Data) -> Option<SplitOn> {
        // Pandaemonium split: fires when final Emperor battle starts
        {
            let in_battle = data.battle_active();
            if in_battle && self.last_monster.is_none() {
                if let Some(Monster::EmperorFinal) = data.encounter() {
                    log!("Pandaemonium — final Emperor fight started");
                    return Some(SplitOn::Pandaemonium);
                }
            }
        }

        // Battle splits — None means mid-battle, fall through to other checks
        match self.battle_check(data) {
            None => {} // mid-battle, still check items/map below
            Some(Ok(monster)) => return Some(match monster {
                Monster::Sergeant      => SplitOn::Sergeant,
                Monster::Adamantoise   => SplitOn::Adamantoise,
                Monster::Borghen       => SplitOn::Borghen,
                Monster::RedSoul       => SplitOn::RedSoul,
                Monster::Pirates       => SplitOn::Pirates,
                Monster::Chimera       => SplitOn::Chimera,
                Monster::BigHorns      => SplitOn::BigHorns,
                Monster::LamiaQueen    => SplitOn::LamiaQueen,
                Monster::Behemoth      => SplitOn::Behemoth,
                Monster::Gottos        => SplitOn::Gottos,
                Monster::Roundworm     => SplitOn::Roundworm,
                Monster::FireGigas     => SplitOn::FireGigas,
                Monster::IceGigas      => SplitOn::IceGigas,
                Monster::ThunderGigas  => SplitOn::ThunderGigas,
                Monster::EmperorCyclone => SplitOn::EmperorCyclone,
                Monster::EmperorFinal  => SplitOn::EmperorFinal,
            }),
            Some(Err(_)) => {} // no battle or battle in progress with no result
        }

        // Map transition splits
        if let Some(loc) = data.location() {
            let pair = self.location.update_infallible(loc);
            if pair.changed() {
                log!("[MAP] {:?} -> {:?}", pair.old, pair.current);
            }
            if let Some(split) = SplitOn::from_location(pair) {
                log!("Map transition split: {split:?} ({:?} -> {:?})", pair.old, pair.current);
                return Some(split);
            }
        }

        // Key item splits
        if let Some(item) = data.key_item_ids().find(|item| self.items.insert(item)) {
            log!("Picked up: {item:?}");
            return Some(match item {
                Item::Ring        => SplitOn::Ring,
                Item::Canoe       => SplitOn::Canoe,
                Item::Pass        => SplitOn::Pass,
                Item::Mythril     => SplitOn::Mythril,
                Item::Snowcraft   => SplitOn::Snowcraft,
                Item::GoddessBell => SplitOn::GoddessBell,
                Item::EgilsTorch  => SplitOn::EgilsTorch,
                Item::Sunfire     => SplitOn::Sunfire,
                Item::Pendant     => SplitOn::Pendant,
                Item::WyvernEgg   => SplitOn::WyvernEgg,
                Item::WhiteMask   => SplitOn::WhiteMask,
                Item::BlackMask   => SplitOn::BlackMask,
                Item::CrystalRod  => SplitOn::CrystalRod,
                Item::Wyvern      => SplitOn::Wyvern,
            });
        }

        None
    }

    fn battle_check(
        &mut self,
        data: &Data,
    ) -> Option<Result<Monster, NoBattle>> {
        let in_battle = self.in_battle.update_infallible(data.battle_active());
        if !in_battle.current && in_battle.unchanged() {
            return Some(Err(NoBattle));
        }

        let result = self.battle_result.update_infallible(data.battle_result());

        if in_battle.changed_to(&true) {
            // Cache the monster ID now while isBattle is true
            self.last_monster = data.encounter();
            log!("Encounter: {:?} -- Started", self.last_monster);
            return None;
        }

        // Update cache while still in battle in case it wasn't set on start
        if in_battle.current {
            if let Some(m) = data.encounter() {
                self.last_monster = Some(m);
            }
        }

        // Battle just ended — use cached monster ID
        if in_battle.changed_to(&false) {
            let monster = match self.last_monster {
                Some(m) => m,
                None => {
                    log!("Encounter ended but no monster cached — skipping");
                    return None;
                }
            };

            log!("Encounter: {monster:?} -- Ended, result={:?} (prev={:?})", result.current, result.old);

            // Check for explicit loss/escape — otherwise assume win.
            // We cannot rely on changed_from(&Win) because battle result
            // memory starts at 0 (Win) before any battle has occurred.
            let is_loss = matches!(result.current,
                BattleResult::Lose | BattleResult::Escape | BattleResult::Restart
            );

            if !is_loss {
                // Also verify we're still in a valid map (not reset to title)
                let raw_map = data.raw_map_id();
                let still_in_game = raw_map != 0 && raw_map != 355;
                if still_in_game {
                    log!("Encounter: {monster:?} -- Win confirmed");
                    if monster != Monster::EmperorFinal {
                        return Some(Ok(monster));
                    }
                } else {
                    log!("Encounter: {monster:?} -- battle ended but no valid map, ignoring (likely reset)");
                }
            } else {
                log!("Encounter: {monster:?} -- Loss/escape, not splitting");
            }
            return None;
        }

        // Final Emperor: split on death animation (2 second delay)
        if let Some(monster) = self.last_monster {
            if monster == Monster::EmperorFinal {
                if result.changed_to(&BattleResult::Win) {
                    log!("Final Emperor defeated — waiting for death animation");
                    self.emperor_end = data.battle_time() + (120.0 / 60.0);
                }
                if result.unchanged() && result.current == BattleResult::Win {
                    if data.battle_time() > self.emperor_end {
                        self.emperor_end = f32::MAX;
                        return Some(Ok(monster));
                    }
                }
            }
        }

        None
    }
}

// ── EnumSet ───────────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Copy)]
struct EnumSet<T>(u64, PhantomData<T>);

trait EnumSetMember {
    fn ordinal(&self) -> Option<u8>;
}

impl<T: EnumSetMember> EnumSet<T> {
    const fn empty() -> Self {
        Self(0, PhantomData)
    }

    fn insert(&mut self, item: &T) -> bool {
        let Some(ord) = item.ordinal() else { return false; };
        if ord >= 64 { return false; }
        let mask = 1_u64 << ord;
        let previous = self.0 & mask;
        self.0 |= mask;
        previous == 0
    }
}