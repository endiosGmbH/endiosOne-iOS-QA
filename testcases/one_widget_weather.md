# Weather [WE]

> **TestRail:** project `endiosOne` (5) · suite `Master` (468) · section `12897` — [Weather](https://endios.testrail.io/index.php?/suites/view/468&group_id=12897)
> **Widget-key:** `one_widget_weather` · **Backend:** localWeather via weatherConnector — [Weather-Calls (S3/2324135937)](https://endios.atlassian.net/wiki/spaces/S3/pages/2324135937/Weather-Calls) · [Figma (WE-Weather)](https://www.figma.com/design/MxtDUNZO8PdggxIxAXsoQ5/WE-Weather?node-id=517-3545)
>
> **App:** Claude Automation (App-ID 1020) · TEST environment · **Refactor:** AGENCY-7050 / AGENCY-7051 / AGENCY-7052 (Android Compose + Nav3) · **Regression tier:** Full Regression
>
> Snapshot of TestRail testcases for the Weather widget. 11 cases across 4 subsections. Live-connector widget (accuweather). **No mockcase infrastructure** — testcases are written against live data and verify structure/format rather than exact values.
>
> **Screen flow:** Widget tile (QA tab) → Feed / List View (Listenansicht, up to 5 daily cards + station block) → Day Detail View (Detailansicht Tag, up to 12 hourly cards).
>
> _Note: section 12901 previously held 110051 (network error / retry); it was removed from TestRail (as of 2026-06-02), leaving 110052 + 110053._

## Widget Tile and Entry (12898)

### 110044 — Widget Tile and Entry tab - Tile title, Dashboard tile image, and connector-driven preview

`refs: AGENCY-7050` (regression of AGENCY-6630 black tile / OP-14441 no data)

**Preconditions:**
- Location permission granted; Weather widget configured on QA tab via Dashboard; current-day forecast available from the connector.
- Dashboard-side config: `tileTitle` (optional override of default label), optional tile image asset(s) with size variants matching the configured tile size (1x1 / 2x1 / 2x2).
- When no Dashboard tile image is configured (NOT an image tile), the preview image is driven by `forecast[0].tileImageURL`, which should map to `forecast[0].statusText` (e.g. `weather_tile_cloudy.jpg` for "Wolkig", `weather_tile_rain.jpg` for "Schauer", `weather_tile_sunny.jpg` for "Überwiegend sonnig"; night variants after sunset).
- `station.name` (connector-driven) is the location name shown in the station block on tile sizes that support it (e.g. "Landesbergen").

**Steps:**
1. In Dashboard, open the Weather widget instance and configure: (a) `tileTitle` to a recognizable value (e.g. "QA Wetter Test"); (b) tile image asset(s) for the tile size(s) used on the QA tab (1x1, 2x1, 2x2). Save.
2. Open the Claude Automation app on TEST and navigate to the QA tab.
3. Observe the Weather tile's title, preview image, and — only on tile sizes that support it — the location name in the station block.
4. Change the tile size in Dashboard (1x1 → 2x1 → 2x2), reopen and verify the image renders the correct size variant.
5. Clear the tile image so the instance is NOT an image tile — keep `tileTitle`. Save and reopen.
6. Open the Weather widget once to note the current `forecast[0].statusText` (e.g. "Wolkig", "Schauer", "Überwiegend sonnig").
7. Return to the QA tab and observe the Weather tile preview image.
8. Repeat at a different time of day / forecast to validate day / night image variants.
9. Clear the `tileTitle` field and reopen — verify the tile falls back to the default label per Figma.

**Expected:**
- Weather content tile visible on the QA tab at its expected position (per Figma).
- **Tile title:** configured → shows the Dashboard value (e.g. "QA Wetter Test"), NOT the default; cleared → falls back to the default label per Figma (e.g. "Wetter").
- **Tile image — Dashboard-configured:** shows the configured image in the correct size variant (1x1 / 2x1 / 2x2); no crop, stretch, or distortion.
- **Tile image — connector-driven (not an image tile):** preview image visually matches the current condition — cloudy → cloudy tile, rain/shower → rain tile, clear/mostly sunny → sunny tile, after sunset → night variant. Never mismatches the reported `statusText`.
- **Station block (supported sizes only):** shows the location name from `station.name` exactly (e.g. "Landesbergen"); on unsupported sizes no station block renders (no placeholder, no "null"/"undefined").
- In all cases the image is loaded — NOT blank, black, or a broken-image placeholder (regression of AGENCY-6630 / OP-14441).
- No crash, ANR, or rendering glitch.

---

### 110055 — Widget Tile and Entry tab - Icons and text displayed per Figma

`refs: AGENCY-7050, AGENCY-7052`

**Preconditions:**
- Location permission granted; Weather widget visible on the QA tab; device set to Light mode initially (Dark mode toggled during the test). Live accuweather response.

**Steps:**
1. Open the app on TEST and navigate to the QA tab.
2. Locate the Weather content tile.
3. Compare against the Figma design: (a) icon — asset, size, position; (b) tile title text — font family, weight, size, color; (c) supporting labels (temperature, status text) — typography and color; (d) padding / spacing; (e) background, corner radius, border / shadow.
4. Switch the device theme to Dark mode and re-observe.
5. Verify rendering at all tile sizes used on the QA tab (1x1, 2x1, 2x2) — text and icons scale / wrap appropriately.

**Expected:**
- Icon rendering matches Figma — correct asset, size, position.
- Tile title uses Figma typography (font family, weight, size, color); supporting labels match Figma styling.
- Padding, spacing, background color, corner radius (and border / shadow if specified) match the design.
- Dark mode: icons and text remain readable with sufficient contrast; correct dark-theme assets used.
- At all tile sizes (1x1 / 2x1 / 2x2): no clipping, overlap, or truncation.
- No missing icon, no fallback / placeholder asset, no broken text rendering.

---

### 110056 — Widget Tile - Home - Tap Opens Weather Widget Feed View

`refs: AGENCY-7050, AGENCY-7052`

**Preconditions:**
- Location permission granted; on the QA tab with the Weather tile visible; widget has loaded at least once to cache data. Live accuweather response.

**Steps:**
1. Open the app on TEST.
2. Navigate to the QA tab.
3. Locate the Weather content tile.
4. Tap the Weather tile.
5. Observe the Weather widget Feed View opens and the transition from home.
6. Tap back to home, then tap the tile again to verify repeated entry is stable.

**Expected:**
- Tapping the tile opens the Weather widget Feed / List View (Listenansicht) — NOT a different widget, NOT the error view, NOT a blank screen.
- Transition is smooth (per Nav3 refactor), completing within ≈2s on TEST.
- Repeated tap-enter cycles open the Feed View consistently — no crash, stuck state, or wrong route.
- No crash / ANR at tap, during transition, or on Feed View load.

---

## Feed / List View (12899)

### 110045 — Feed View - Daily Forecast - List and Card Content Render

`refs: AGENCY-7050, AGENCY-7051`

**Preconditions:**
- Location permission granted; on the QA tab; Weather widget configured. Live accuweather response — contract provides up to a 5-day daily forecast and a station block (name, coords, key).

**Steps:**
1. Open the app on TEST.
2. Navigate to the QA tab.
3. Tap the Weather tile to open the Feed / List View (Listenansicht).
4. Scroll through the daily forecast list top to bottom.
5. Inspect each daily card and the station block.

**Expected:**
- Feed View renders up to 5 daily entries (from `forecast[]`), consistent with the contract limit.
- Each daily card displays: prepared date text (e.g. "Heute, 22.01."), weather icon (`iconURL`), status text (e.g. "Wolkig"), `temperatureMin` and `temperatureMax` in °C.
- Station block shows the location name (e.g. "Landesbergen" — from `station.name`).
- All fields populated — NO empty placeholders, NO null values, NO raw JSON.
- No crash, flicker, or layout glitch on scroll.

---

### 110046 — Feed View - Navigation - Tap Day Detail and Back

`refs: AGENCY-7052`

**Preconditions:**
- On the Feed / List View of the Weather widget. Live accuweather response.

**Steps:**
1. Open the Weather widget from the QA tab — Feed View is shown.
2. Tap the first day entry in the daily forecast list.
3. Verify the Day Detail View (Detailansicht Tag) opens with the selected day's content.
4. Tap the device / system back button.
5. Verify return to the Feed View.
6. From the Feed View, tap the system back or widget back control.
7. Verify return to the QA tab home.

**Expected:**
- Tapping a day card navigates to the Day Detail View for that specific day (hourly forecast for that day, not a different day).
- Back from Day Detail returns to the Feed View — NOT directly to home.
- Back from the Feed View returns to the QA tab home.
- Navigation is smooth — no flicker, no crash, no wrong route (Nav3 regression).

---

### 110047 — Feed View - UI Compliance - Figma Layout and Images

`refs: AGENCY-7052`

**Preconditions:**
- Device set to Light mode initially; toggled to Dark mode during the test. `backgroundImageURL` and `iconURL` are driven by the daily `statusText` (e.g. `weather_bg_cloudy.jpg` when statusText = "Wolkig").

**Steps:**
1. Open the Weather widget Feed View.
2. Compare layout (spacing, typography, alignment, card sizing) against Figma.
3. Verify the background image matches the daily status text (cloudy-bg for "Wolkig", rain-bg for "Schauer", clear-bg for "Überwiegend sonnig").
4. Verify the icon on each daily card matches that day's status.
5. Switch device theme to Dark mode.
6. Return to the Feed View and observe rendering and contrast.

**Expected:**
- Feed View layout matches Figma: padding, font sizes, icon sizes, card spacing.
- Background image visually corresponds to the weather status (cloudy / rain / clear / night variants render correctly).
- Weather icon on each daily card matches that day's `statusText`.
- Dark mode: all text, icons, and station name remain readable with sufficient contrast.
- No UI element clipped, overlapping, or missing in either theme.

---

## Day Detail View (12900)

### 110048 — Day Detail - Hourly Forecast - List and Card Content Render

`refs: AGENCY-7050, AGENCY-7051`

**Preconditions:**
- On the Feed / List View of the Weather widget. Live accuweather response — hourly data is in `forecast[n].content[]` (contract: up to 12 hours per day).

**Steps:**
1. From the Feed View, tap the first day (typically "Heute") to open the Day Detail View.
2. Scroll through the hourly forecast list top to bottom.
3. Inspect each hourly card's fields: time, icon, status text, temperature, precipitation chance, precipitation amount, wind speed, wind direction.
4. Return to the Feed View and tap a different day (Day 2 / Day 3) to verify the Day Detail refreshes with that day's data.

**Expected:**
- Hourly list renders up to 12 entries for the selected day (from `forecast[n].content[]`).
- Each hourly card shows: prepared time (e.g. "12:00"), weather icon, status text (e.g. "Wolkig"), temperature in °C, precipitation chance as a percent (0–100), precipitation amount in mm, wind speed in km/h, and wind direction as a cardinal abbreviation (e.g. WSW, N, SE).
- Wind direction uses only cardinal abbreviations (N, S, E, W and combinations) — NOT raw degrees.
- Precipitation chance clearly labelled as % and amount as mm.
- Tapping a different day refreshes the hourly content to that day's data.
- No empty placeholders, no null values, no crash on scroll.

---

### 110049 — Day Detail - Navigation - Back and Day Switching

`refs: AGENCY-7052`

**Preconditions:**
- On the Feed / List View of the Weather widget. Live accuweather response.

**Steps:**
1. Tap Day 1 (Heute) from the Feed View — the Day Detail View opens.
2. If a day-switching control is present (swipe, tabs, or next/prev arrows per Figma), switch to Day 2.
3. Observe that the hourly content updates to Day 2.
4. Switch back to Day 1.
5. Tap back and verify return to the Feed View.
6. Note scroll position / state on the Feed View after return.

**Expected:**
- The day-switching control (if present per Figma) transitions between days without returning to the Feed View.
- Hourly content updates correctly on each day switch — no stale data.
- Back navigation returns to the Feed View — NOT directly to home.
- Feed View state (e.g. scroll position) preserved on return.
- No crash or stuck state during switching or navigation.

---

### 110050 — Day Detail - UI Compliance - Figma Layout

`refs: AGENCY-7052`

**Preconditions:**
- On the Day Detail View; device in Light mode initially. `backgroundImageURL` / `iconURL` are driven by the selected day's `statusText`.

**Steps:**
1. Open the Day Detail View from the Feed View.
2. Compare the overall layout (header, hourly row rendering, wind / precipitation labels, typography) against Figma.
3. Verify the background image matches the selected day's `statusText`.
4. Toggle device theme to Dark mode and re-observe.

**Expected:**
- Day Detail layout (header area, hourly rows, column labels for wind / precipitation) matches Figma.
- Icons, typography, and spacing consistent with the Feed View and the design system.
- Background image visually corresponds to the selected day's `statusText`.
- Dark mode renders correctly with adequate contrast for all text and icons.
- No clipping, overlap, or missing asset in either theme.

---

## Negative Scenarios (12901)

### 110052 — Negative - Location - Missing GPS Permission Handled

`refs: AGENCY-7050`

**Preconditions:**
- Location permission explicitly DENIED for the Claude Automation app in OS Settings. The endpoint requires GPS coordinates as params — without location permission the widget cannot request forecast data.

**Steps:**
1. In device Settings → Privacy → Location → Claude Automation app → set to Never / Denied.
2. Force-close and reopen the app.
3. Navigate to the QA tab and tap the Weather tile.
4. Observe the view rendered and any prompts displayed.
5. If a "Grant permission" CTA is present, tap it and grant permission via the OS prompt / app settings.
6. Return to the Weather widget.

**Expected:**
- The Weather widget does NOT crash when location permission is missing.
- A clear error state, empty state, or permission-request prompt is shown (per design) — NOT a blank screen.
- If a CTA to grant permission is shown, tapping it opens the OS permission prompt or app settings.
- After permission is granted and the widget is reopened, the Feed View loads the live forecast successfully.

---

### 110053 — Negative - Launch - No Crash on Widget Open [OP-15887]

`refs: OP-15887` — [Android][Weather] App crashes after launching the widget (Critical). Regression must validate the AGENCY-7050/7051/7052 refactor does not reintroduce the crash.

**Preconditions:**
- Fresh app install OR cold start; TEST build includes the latest Weather refactor.

**Steps:**
1. Install the latest TEST build.
2. Cold-start the app.
3. Navigate to the QA tab.
4. Tap the Weather tile to open the widget.
5. Repeat steps 2–4 three times with a cold-start between attempts.
6. Then, within a single session: open widget → navigate to Day Detail → back to Feed → back to home → reopen widget.
7. Repeat the same flow on iOS if build parity applies.

**Expected:**
- The app does NOT crash at any point during widget open, navigation, or back.
- The Feed / List View loads without ANR, freeze, or black screen.
- Repeated cold-start openings behave identically across all attempts.
- No crash / ANR recorded in device logs (regression of OP-15887).
- Behaviour consistent across Android and iOS if a parity build is tested.
