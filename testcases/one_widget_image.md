# Image [IMG]

> **TestRail:** project `endiosOne` (5) · suite `Master` (468) · section `12911` — [Image [IMG]](https://endios.testrail.io/index.php?/suites/view/468&group_id=12911)
> **Widget-key:** `one_widget_image` · **Spec:** [S3/586645520 — Image](https://endios.atlassian.net/wiki/spaces/S3/pages/586645520/Image)
>
> **Tile variants:** `plain`, `textBottom`, `textTop` · **Regression tier:** Full Regression
>
> Snapshot of TestRail testcases for the Image widget. 7 cases across 2 subsections.

## Tile & Core View (12912)

### 110108 — Tile rendering — configured variants

**Refs:** —

**Preconditions:**
- **Environment:** Claude Automation app (App-ID: 1020), Test environment
- **Widget-key:** `one_widget_image`
- **Spec:** [Image widget — S3/586645520](https://endios.atlassian.net/wiki/spaces/S3/pages/586645520/Image)
- **Setup:** One or more `one_widget_image` instances configured on the Product tab, in any combination of variants (`plain`, `textBottom`, `textTop`) and any supported size. Each tile has a reachable `url` / `url1` set; for text variants, `title` is set.

**Steps:**
1. Open the Claude Automation app and log in.
2. Navigate to the Product tab.
3. For each configured Image tile, observe its rendering.

**Expected:**
- Each configured tile displays the configured image filling the tile area.
- For `textBottom` tiles, the title renders at the bottom; for `textTop` tiles, at the top; `plain` tiles show no title.
- No broken-image icons, no layout breakage, no crash.

---

### 110127 — Image rotation follows configured rotatingRhythm

**Refs:** —

**Preconditions:**
- **Environment:** Claude Automation app (App-ID: 1020), Test environment
- **Widget-key:** `one_widget_image`
- **Spec:** [Image widget — S3/586645520](https://endios.atlassian.net/wiki/spaces/S3/pages/586645520/Image)
- **Setup:** At least one Plain Image tile configured with multiple URLs (`url1` + `url2`, optionally `url3`) and a `rotatingRhythm` value — default or any user-configured value (seconds up to hours).

**Steps:**
1. Open the Product tab.
2. Locate the rotating Image tile.
3. Observe the tile for at least `2 × rotatingRhythm`.

**Expected:**
- Tile cycles `url1 → url2 → (url3) → url1` at the configured rhythm.
- The observed interval matches the configured `rotatingRhythm`.
- No blank or stale frames between transitions; no crash.

---

### 110114 — Tap opens image viewer when notClickable=false

**Refs:** —

**Preconditions:**
- **Environment:** Claude Automation app (App-ID: 1020), Test environment
- **Widget-key:** `one_widget_image`
- **Spec:** [Image widget — S3/586645520](https://endios.atlassian.net/wiki/spaces/S3/pages/586645520/Image) (Core section — clickable core view)
- **Setup:** At least one Image tile configured with `notClickable = false` (or unset) and a reachable image URL.

**Steps:**
1. Open the Product tab.
2. Tap the tile.

**Expected:**
- A dedicated image viewer (core view) opens as a full-screen view.
- The configured image is displayed at full resolution.
- A close affordance (close button / back gesture) is present; no crash.

---

### 110295 — Swipe in image viewer cycles through configured images in order

**Refs:** —

**Preconditions:**
- **Environment:** Claude Automation app (App-ID: 1020), Test environment
- **Widget-key:** `one_widget_image`
- **Spec:** [Image widget — S3/586645520](https://endios.atlassian.net/wiki/spaces/S3/pages/586645520/Image) (Core section — viewer navigation)
- **Setup:** At least one Plain Image tile configured with `notClickable = false` (or unset) and multiple URLs (`url1` + `url2`, optionally `url3`). The image viewer was opened by `[IMG] Tap opens image viewer when notClickable=false`.

**Steps:**
1. From the open image viewer (showing `url1`), swipe left.
2. Swipe left again if a third image (`url3`) is configured.
3. Swipe right to navigate back.

**Expected:**
- Swiping left advances to the next configured image in `url1 → url2 → url3` order.
- Swiping right returns to the previous configured image.
- The order matches the dashboard configuration order.
- No crash; no blank frames.

---

### 110115 — Close image viewer returns to Home

**Refs:** —

**Preconditions:**
- **Environment:** Claude Automation app (App-ID: 1020), Test environment
- **Widget-key:** `one_widget_image`
- **Spec:** [Image widget — S3/586645520](https://endios.atlassian.net/wiki/spaces/S3/pages/586645520/Image) (Core section — dismiss core view)
- **Setup:** `[IMG] Tap opens image viewer when notClickable=false` just executed; the image viewer is open.

**Steps:**
1. From the open image viewer, tap the close button or use the back gesture.

**Expected:**
- The viewer dismisses.
- The Product tab is restored to its prior scroll position and layout.
- The tile remains tappable (re-opens the viewer if tapped again); no crash.

---

### 110116 — Tap is blocked when notClickable=true

**Refs:** —

**Preconditions:**
- **Environment:** Claude Automation app (App-ID: 1020), Test environment
- **Widget-key:** `one_widget_image`
- **Spec:** [Image widget — S3/586645520](https://endios.atlassian.net/wiki/spaces/S3/pages/586645520/Image) (Core section — `notClickable` flag)
- **Setup:** At least one Image tile configured with `notClickable = true`.

**Steps:**
1. Open the Product tab.
2. Tap the tile.

**Expected:**
- No image viewer / core view opens.
- No navigation occurs; the Product tab remains active.
- Tile remains visible and unchanged; no crash.

---

## Negative Scenarios (12915)

### 110117 — Negative - Invalid or Unreachable Image URL Does Not Crash

**Refs:** —

**Preconditions:**
- **Environment:** Claude Automation app (App-ID: 1020), Test environment
- **Widget-key:** `one_widget_image`
- **Spec:** [Image widget — S3/586645520](https://endios.atlassian.net/wiki/spaces/S3/pages/586645520/Image)
- **Jira:** none (legacy widget)
- **Dashboard variables** (full reference for `one_widget_image`):
  - `type`: `plain` | `textBottom` | `textTop`
  - `url` / `url1` / `url2` / `url3`: image source URL(s)
  - `title`: text shown on textBottom / textTop variants (no subtitle field)
  - `decorativeImage`: boolean — marks image as decorative (hidden from screen readers)
  - `isCenterCropped`: boolean — center-crop fill vs. fit
  - `isBorderShown`: boolean — show widget border
  - `shadowColor`: hex
  - `notClickable`: boolean
  - `rotatingRhythm`: number (seconds) — rotation interval for `url1`/`url2`/`url3`
  - `fontColorTitle`: hex — defaults to MCL style `Dark/Text/Headline 4` when unset
  - `image1ScreenReaderText` / `image2ScreenReaderText` / `image3ScreenReaderText`: accessibility labels
- **Setup:** One Plain Image widget at size 8x8 on the Product tab configured with:
  - `type = "plain"`
  - `url1 =` a malformed OR unreachable URL (e.g. `https://invalid.endios.test/missing.jpg` returning HTTP 404)
  - `url2`, `url3` left empty
  - `notClickable = false`

> Note: expected UI for an invalid URL is not explicitly documented in S3/586645520. This testcase asserts robustness (no crash) only. Richer expected behaviour would require a dedicated error-state mockcase or documented fallback UI.

**Steps:**
1. Open the Claude Automation app and log in.
2. Navigate to the Product tab.
3. Locate the configured Image widget.
4. Observe the tile for at least 15 seconds.
5. Scroll the tile off-screen, then back onto screen once.

**Expected:**
- The app does NOT crash when attempting to load the invalid / unreachable URL.
- The tile remains in the dashboard layout at its configured 8x8 size.
- NO broken-image icon or error artefact leaks outside the tile bounds.
- NO visible retry storm that flickers the tile repeatedly.
- Other widgets on the Product tab remain fully interactive and unaffected.
- After scrolling off and back, the tile still does not crash the app.
