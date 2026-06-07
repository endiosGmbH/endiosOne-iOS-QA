# Weather widget — `one_widget_weather` (Android)

Maestro flows for the Weather TestRail suite (project 5 / suite 468 / section 12897 — 11 cases) on the **Android** Claude Automation app.

## Files

| File | Cases | Notes |
| --- | --- | --- |
| `one_widget_weather.yaml` | happy path (110044, 110055, 110056, 110045, 110046, 110047, 110048, 110049, 110050) | single launch |
| `110052-only.yaml` | 110052 — location denied | launches with location permission denied → OS prompt → grant → feed |
| `110053-only.yaml` | 110053 — no-crash [OP-15887] | three cold-start launches |

## Run

```bash
maestro --device <emulator-serial> test maestro/android/widgets/one_widget_weather/one_widget_weather.yaml
```

- **`--device` is required** when more than one device/emulator is attached.
- App package: `de.endios.one.claudeautomation.demo.debug` (TEST, configId 1425).
- Cold start fetches config + tile images — the flow uses a 40s `extendedWaitUntil` on a known tile.

## Gotchas baked into the flow

- **Day-2 date regex needs updating each run.** `one_widget_weather.yaml` taps the day-2 card by a hardcoded date (e.g. `.*8\.06\..*` for "Montag, 8.06.") to prove future-day cards don't navigate. Today (Heute) = current date, day-2 = tomorrow — update the regex on re-run (the flow comment flags it).
- **Day Detail is today-only by design** (`GetTodayWeatherForecastDetailUseCase`). Future-day cards do NOT open a detail (tapping one stays on the Feed) and there is no day-switching control. So 110048's "tap a different day refreshes" and 110049's "day-switching" steps are iOS-style and N/A on Android.
- **ATT / permission dialogs:** the launch block pre-grants permissions and dismisses both apostrophe variants of "Don't allow".
- **Dark mode** (110047/110050/110055): captured post-run via `adb shell cmd uimode night yes` + a no-clearState capture pass, then `night no` to revert.

Last full run: 11/11 Pass (2026-06-07, emulator location "Mountain View").
