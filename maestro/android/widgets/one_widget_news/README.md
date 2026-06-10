# News widget — `one_widget_news` (Android)

Maestro flows for the News TestRail suite (project 5 / suite 468 / section **12902 — News [NW]**, 19 cases) on the **Android** Claude Automation app.

## Files

| File | Cases | Notes |
| --- | --- | --- |
| `one_widget_news.yaml` | 18 of 19 (all except 110100) | **single launch** — one `launchApp`, each News tile opened once |
| `110100-connector-only.yaml` | 110100 — connector/network unavailable | needs airplane-mode toggling around the run (Maestro can't toggle it inline) |

## Run

```bash
maestro --device <emulator-serial> test maestro/android/widgets/one_widget_news/one_widget_news.yaml
```

- `--device` is required when more than one device/emulator is attached.
- App package: `de.endios.one.claudeautomation.demo.debug` (TEST, configId 1425).
- **Build:** verified on develop `oneWidgetNews 4.1.32` / Foundation 5.5.12.

### 110100 (connector down) — run with airplane orchestration
```bash
# 1) launch + go to Auto tab (network ON, config loads), then:
adb shell cmd connectivity airplane-mode enable
maestro --device <serial> test maestro/android/widgets/one_widget_news/110100-connector-only.yaml
adb shell cmd connectivity airplane-mode disable
```
Expected: "Keine Internetverbindung" dialog, no crash.

## Tile → case mapping (each News tile opened at most once)

| Tile | Cases |
| --- | --- |
| dashboard (no open) | 110082 (variants + Strip subtitle "Qualiy"), 110085 (gallery/carousel rotation) |
| Gallery 18766 **chevron → List** | 110084 (moreButton chevron), 110107 (Kategorien filter), 110087, 110089, 110090, 110101, + open article → 110091, 110093, 110095 |
| Carousel/Gallery **preview → Detail direct** | 110083 (+ this article has a Galerie → 110092, 110094) |
| Testing QA 18744 → List → "World news" | 110257 (social), 110087 (manual ContentHub) |
| RSS Feed 18773 (Auto tab) | 110088 (webview close-X), 110098 (dedup), 110089 (RSS layout) |
| No feed 18772 (Auto tab) | 110097 (empty state) |

## Why single-launch works despite the re-open crash (BUG-B)

The News widget crashes if the **same** tile is opened a **second** time in one process
(`NoSuchMethodError`/`NoDefinitionFoundException` `NewsAnalytics` Koin qualifier @
`NewsTileViewHolderProvider.kt:211`). Opening **different** tiles once each is safe, so the
flow opens each News tile at most once. Article ↔ list navigation **within** one session does
NOT re-open the tile, so it's fine. **Never add a relaunch** — recover with hardware `Back`.

## Gotchas baked into the flow

- **Tolerant scrolls.** `scrollUntilVisible` uses `visibilityPercentage: 20, optional: true`.
  `centerElement` with the default 100% visibility fails intermittently and would abort the
  whole single flow.
- **Gallery/carousel have NO text selector** → coordinate taps. They are anchored with
  `scrollUntilVisible "News 2" centerElement` (pins the gallery row to ~50% y) then tapped:
  chevron ≈ `94%, 45%`, preview ≈ `66%, 52%`. Each is wrapped in a `runFlow when visible`
  guard (`Nachrichten` / `Beschreibung` / `Galerie`) so a missed coordinate tap never bails
  the flow. **If a gallery case isn't captured on a given device/density, nudge those
  percentages** — do not treat a missed coordinate tap as a Fail.
- **Hard `assertVisible` only on reliable text tiles** (World news / Soziale Medien /
  tagesschau / "keine Nachrichten").
- **Chrome first-run must be completed once** on the emulator (Chrome → "Use without an
  account"), else the RSS webview Custom Tab is intercepted (110088).
- **110094 multi-image swipe** is N/A when test data has only single-image galleries.

## Known product issues (filed)

- **iOS** "more" button should be a chevron like Android — **AGENCY-7645**.
- **iOS** filter is a "Kategorien" bar below the nav bar vs Android's top-right funnel icon — **AGENCY-7649**.
- **BUG-B** (News tile re-open crash) — the reason each tile is opened only once.

Last full run: 18/19 captured in a single clean launch (EXIT 0, no crash); 110100 via the connector-only flow.
