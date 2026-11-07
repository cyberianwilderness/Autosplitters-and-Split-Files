#![no_std]

use asr::{
    future::next_tick,
    game_engine::unity::il2cpp::{Module, UnityPointer},
    watcher::Watcher,
    Address64, Process,
};

asr::async_main!(stable);
asr::panic_handler!();

#[macro_export]
macro_rules! log {
    ($($arg:tt)*) => {{
        let mut buf = ::asr::arrayvec::ArrayString::<8192>::new();
        let _ = ::core::fmt::Write::write_fmt(&mut buf, ::core::format_args!($($arg)*));
        ::asr::print_message(&buf);
    }};
}

struct Pointers {
    play_time: UnityPointer<3>,
    map_id:    UnityPointer<3>,
    is_exit:   UnityPointer<2>,
    exit_mode: UnityPointer<2>,
    has_boss:  UnityPointer<2>,
    encount:   UnityPointer<2>,
}

impl Pointers {
    fn new() -> Self {
        Self {
            play_time: UnityPointer::new(
                "GameManager", 1,
                &["_instance", "<GameSystemInfo>k__BackingField", "_playTimeSec"],
            ),
            map_id: UnityPointer::new(
                "GameManager", 1,
                &["_instance", "<GameSystemInfo>k__BackingField", "_mapId"],
            ),
            is_exit: UnityPointer::new(
                "BattleDirector", 1,
                &["_instance", "<IsExit>k__BackingField"],
            ),
            exit_mode: UnityPointer::new(
                "BattleDirector", 1,
                &["_instance", "<ExitMode>k__BackingField"],
            ),
            has_boss: UnityPointer::new(
                "BattleDirector", 1,
                &["_instance", "<HasBossUnit>k__BackingField"],
            ),
            encount: UnityPointer::new(
                "BattleDirector", 1,
                &["_instance", "<EncountType>k__BackingField"],
            ),
        }
    }
}

async fn main() {
    asr::set_tick_rate(60.0);
    loop {
        let process = Process::wait_attach("FantasianND.exe").await;
        log!("[Fantasian] attached");
        process.until_closes(game_loop(&process)).await;
        log!("[Fantasian] closed");
    }
}

async fn game_loop(process: &Process) {
    let module = Module::wait_attach_auto_detect(process).await;
    log!("[Fantasian] IL2CPP attached");
    let image = module.wait_get_default_image(process).await;
    log!("[Fantasian] image found — diagnostic running");

    let ptrs = Pointers::new();
    let mut map_watcher:  Watcher<MapId> = Watcher::new();
    let mut exit_watcher: Watcher<bool>  = Watcher::new();
    let mut boss_watcher: Watcher<bool>  = Watcher::new();
    let mut tick: u32 = 0;

    loop {
        tick = tick.wrapping_add(1);
        let debug = tick % 300 == 0;

        let play_time: f64 = ptrs.play_time
            .deref(process, &module, &image)
            .unwrap_or(0.0);

        // Read map_id string directly and log it every 5s
        let map_str = ptrs.map_id
            .deref::<Address64>(process, &module, &image)
            .ok()
            .and_then(|p| if p.is_null() { None } else {
                read_string(process, p.into())
            });

        if debug {
            log!("[DBG] play_time={:.1}s map={:?}", play_time, map_str.as_deref().unwrap_or("None"));
        }

        // Map change detection
        let map_id = map_str.as_ref().map(|s| str_to_map_id(s.as_str()));
        if let Some(pair) = map_watcher.update(map_id) {
            if pair.changed() {
                log!("[MAP] {:?} -> {:?} @ {:.1}s", pair.old, pair.current, play_time);
            }
        }

        // Battle state
        let is_exit = ptrs.is_exit
            .deref::<u8>(process, &module, &image)
            .map(|v| v != 0).unwrap_or(false);
        let exit_mode: i32 = ptrs.exit_mode
            .deref(process, &module, &image).unwrap_or(0);
        let has_boss = ptrs.has_boss
            .deref::<u8>(process, &module, &image)
            .map(|v| v != 0).unwrap_or(false);
        let encount: i32 = ptrs.encount
            .deref(process, &module, &image).unwrap_or(0);

        let exit_pair = exit_watcher.update_infallible(is_exit);
        if exit_pair.changed_to(&true) {
            let result = match exit_mode {
                0=>"None", 1=>"Escape", 2=>"GameClear", 3=>"GameOver", _=>"Unknown"
            };
            log!("[BATTLE END] result={} has_boss={} encount={} @ {:.1}s",
                result, has_boss, encount, play_time);
            if exit_mode == 2 && has_boss {
                log!("[BOSS KILL] *** @ {:.1}s ***", play_time);
            }
        }
        if exit_pair.changed_to(&false) {
            log!("[BATTLE START] has_boss={} encount={} @ {:.1}s",
                has_boss, encount, play_time);
        }
        let boss_pair = boss_watcher.update_infallible(has_boss);
        if boss_pair.changed_to(&true) {
            log!("[BOSS DETECTED] @ {:.1}s", play_time);
        }

        next_tick().await;
    }
}

fn read_string(process: &Process, addr: asr::Address)
    -> Option<asr::arrayvec::ArrayString<64>>
{
    let len: u32 = process.read(addr + 0x10u64).ok()?;
    if len == 0 || len > 32 { return None; }
    let mut utf16 = [0u16; 32];
    process.read_into_slice(addr + 0x14u64, &mut utf16[..len as usize]).ok()?;
    let mut out = asr::arrayvec::ArrayString::<64>::new();
    for c in char::decode_utf16(utf16[..len as usize].iter().copied()).flatten() {
        let _ = out.try_push(c);
    }
    Some(out)
}

#[derive(Copy, Clone, PartialEq, Eq)]
struct MapId([u8; 64], usize);

impl core::fmt::Debug for MapId {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        let s = core::str::from_utf8(&self.0[..self.1]).unwrap_or("?");
        f.write_str(s)
    }
}

fn str_to_map_id(s: &str) -> MapId {
    let mut buf = [0u8; 64];
    let bytes = s.as_bytes();
    let len = bytes.len().min(64);
    buf[..len].copy_from_slice(&bytes[..len]);
    MapId(buf, len)
}
