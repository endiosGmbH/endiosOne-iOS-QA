# Weather widget — `one_widget_weather` (iOS)

Single all-in-one Maestro flow covering the **entire Weather TestRail suite** (project 5 / suite 468 / section 12897 — 11 cases as of 2026-06-02) in one run.

## Run

```bash
maestro --device <ios-udid> test maestro/ios/widgets/one_widget_weather/run-widget-we.yaml
```

- **`--device` is required** — Maestro otherwise grabs a running Android emulator and fails with "Package … not installed".
- Run on **iPhone 16 Pro / iOS 18.4**. The current sim build is x86_64/Rosetta with min-iOS 16 and will **not** drive under Maestro on iOS 26.x.
- Self-contained: no external `simctl` setup needed (location handled in-flow).

## Structure (one file, three sections, run in order)

| Section | Cases | Notes |
| --- | --- | --- |
| A — happy path | 110044, 110055, 110056, 110045, 110046, 110047, 110048, 110049, 110050 | one launch + one baseline pull-to-refresh |
| B — 110053 no-crash [OP-15887] | 110053 | three cold-start launches + in-session nav cycle |
| C — 110052 location denied | 110052 | launches with `permissions: location: unset`, dismisses the prompt ("Don't Allow") → denied state; runs last |

## Gotchas baked into the flow

- **App Tracking Transparency prompt** — `clearKeychain` re-triggers it on an unpredictable delay and it blocks Maestro's view of the dashboard. Every launch polls and dismisses "Ask App Not to Track" before asserting the dashboard.
- **Day Detail back button is the live location name** (San Francisco / Hamburg / …), so detail→feed back taps the chevron by coordinate (`6%, 7%`), not a hardcoded label.
- `location: deny` is invalid in Maestro — `unset` + an in-flow "Don't Allow" tap gives the denied state.

Last full validation: `[Passed]` end-to-end, all 11 cases (~13.5 min; the ATT poll is the main cost).
