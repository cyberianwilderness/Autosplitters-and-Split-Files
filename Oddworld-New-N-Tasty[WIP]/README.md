# Oddworld: New 'n' Tasty
- An ASL (Auto Splitting Language) script for LiveSplit that auto-starts, auto-splits,
auto-resets, and tracks in-game time (IGT) for **Oddworld: New 'n'
Tasty** (Steam, Unity 4.3.4a0 / Mono / x86).

- This may work with GOG, it has not been tested

- Requires [asl-help](https://github.com/just-ero/LiveSplit.AslHelp) — the script loads
it automatically from `Components/asl-help` at startup, so make sure that component is
present in your LiveSplit `Components` folder.

---

## Features

- **Three splitting modes** (pick one in the LiveSplit settings panel):
  - **Main Game — Simple Splits**: one split per chapter.
  - **Main Game — Detailed Splits**: multiple sub-splits within each chapter
    (tutorials, trials, individual rooms, etc.).
  - **Individual Level (IL) Mode**: splits/times a single chosen chapter only.
- **Branch-aware routing**: New 'n' Tasty lets you do Paramonia or Scrabania first.
  The script detects which branch you took and reorders its split logic
  automatically — no manual toggle needed mid-run (a `scrabania_first` setting exists
  only to disambiguate ILs/simple-mode ordering, not to force a route).
- **Custom loadless IGT** — see below. This is the main technical centerpiece of the
  script and the reason for most of its complexity.
- **Auto start / auto split / auto reset**, all driven by reading the game's own Mono
  memory (level indices, app state, and the DLC-completion flag) — no manual
  intervention needed during a run.

---

## How the IGT works

This took a fair amount of reverse engineering (via dnSpy on `Assembly-CSharp.dll`) to
get right, so it's documented here for future reference / future-me.

### What doesn't work, and why

The game's save-slot screen displays a stat called `App.TotalTime`. This looked like an
obvious IGT candidate at first, but it is **not a live clock** — it's a property that
sums each chapter's **best-ever completion time** on the fly:

```csharp
public float TotalTime
{
    get
    {
        float num = 0f;
        if (this.m_fBestChapterTimeRuptureFarms < 3599999f)
            num += this.m_fBestChapterTimeRuptureFarms;
        // ...one such block per chapter...
        return num;
    }
}
```

- `3599999f` is the "chapter not yet completed" sentinel (~999 hours).
- Each `m_fBestChapterTimeX` field only updates if a chapter completion **beats the
  previous best** for that chapter, so it does not necessarily reflect the current
  attempt.
- It only changes in discrete jumps at chapter-complete, never ticks up live.
- It's also a C# **property**, not a real Mono field — `asl-help`'s `mono.Make<T>()`
  cannot resolve it at all (`TryLoad` fails outright if you try, breaking every other
  helper in the same batch).

Because of the above, an earlier version of this script that summed `m_fBestChapterTimeX`
fields directly was abandoned — it could stall or go backwards on any chapter that
wasn't a fresh personal best, and any stale value in the current save's best times would
pollute a "fresh" run's displayed IGT.

### What actually works

Each chapter has its own live `Timer` object
(`m_cChapterTimerRuptureFarms`, `m_cChapterTimerStockyardEscape`, …), and
`App.m_cCurrentChapterTimer` points at whichever one is active for the chapter you're
currently in. Confirmed via decompilation of `App`'s state machine (`Tick()`):

- Entering `Paused` state calls `m_cCurrentChapterTimer.Stop()`.
- Leaving `Paused` state calls `m_cCurrentChapterTimer.Start()`.
- Entering `Loading` state routes through `PauseGamePlay()`.

So `m_cCurrentChapterTimer.m_fCountdownDuration` (misleadingly named — in count-up mode
this field counts *up*, not down) is a genuinely loadless, pause-excluded, live elapsed
timer for the current chapter — exactly what a splitter wants.

**The catch:** this timer resets to `0` at the start of every chapter (it's a new
`Timer` instance each time). The script accounts for this itself, in `update`, by
watching for a large downward jump in the value and banking whatever it was just before
the drop into a running total (`vars.accumulatedTime`):

```csharp
update
{
    float chCur = vars.Helper["chapterTime"].Current;
    float chOld = vars.Helper["chapterTime"].Old;

    if (chCur < chOld - 1f)
        vars.accumulatedTime += (double)chOld;
}
```

`gameTime` then reports `accumulatedTime + current chapterTime`, minus a one-time
**baseline** captured at run start (see below).

### Why the baseline exists

The game's chapter `Timer` can already be mid-count by the moment the script's own
`start` condition fires (there's a small gap between the game internally starting the
timer and the script noticing `next == 0`). Without correction, a run could appear to
begin several seconds "ahead." `vars.chapterTimeBaseline` snapshots `chapterTime` at the
exact moment a run starts (or is reset) and is subtracted in `gameTime`, so IGT reliably
reads `0` at the true start of a run regardless of that gap.

Baseline is (re)captured in three places for redundancy: `start`, `onStart`, and
`onReset`. `onStart`/`onReset` are the ones guaranteed to fire on every run boundary
(manual or automatic) — `start`'s own copy is belt-and-braces only.


---

## Settings reference

| Setting | Purpose |
|---|---|
| `main_simple` / `main_detailed` / `il_mode` | Pick exactly one splitting mode. |
| `scrabania_first` | Disambiguates route order for simple-mode/IL targets that differ by branch (does not force the branch — the script auto-detects it from `newLevel`). |
| `s_*` | Per-chapter toggles for Simple mode. |
| `d_*` | Per-sub-split toggles for Detailed mode, grouped into ordered "phases." |
| `il_*` | Pick exactly one chapter for IL mode. |

---

## Credits / method

All memory offsets were derived from static analysis of `Assembly-CSharp.dll`
(via dnSpy) rather than blind memory scanning — this game's assemblies are
unobfuscated Mono IL with original class/field names intact, which made this far more
reliable than pattern-scanning in Cheat Engine. `asl-help`'s Mono field-walking
(`mono.Make<T>("ClassName", "instanceField", "fieldName", ...)`) is used throughout
instead of hand-computed pointer offsets.
