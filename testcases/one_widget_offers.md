# Offers Widget [OF]

> **TestRail:** project `endiosOne` (5) · suite `Master` (468) · section `12923` — [Offers Widget [OF]](https://endios.testrail.io/index.php?/suites/view/468&group_id=12923)
> **Widget-key:** `one_widget_offers` · **Spec:** [S3/586809384 — Offers Widget](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384/Offers+Widget+OF) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905/Offers+GraphQL) · [JSON](https://endios.atlassian.net/wiki/spaces/S3/pages/852328527/Offers-JSON)
>
> **Regression tier:** Full Regression
>
> Snapshot of TestRail testcases for the Offers widget. 20 cases across 4 subsections.

## Widget Tile & Dashboard Configuration (12924)

### 110164 — [OF] Widget Tile - All Tile Types Render Image, Title, Highlight Badge, Validity, Subtitle

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · ContentHub live data

**Test data:** Offers widget covering every supported tile type, each with: `title`, valid image (or rely on `defaultImageUrl` fallback), `featuredText` + `featuredColor`, populated `validityPeriod` end date, subtitle on tile types that support one.

**Doc gap:** concept currently documents a single tile; if multiple tile types ship, update preconditions and re-confirm subtitle support per type.

**Steps:**
1. Open the homepage and locate every configured Offers tile.
2. For each tile type observe: image, title, highlight badge (text + colour), validity end date, subtitle if supported, and the spatial relationship between text elements.
3. If multiple sizes exist for the same tile type, observe each.

**Expected:**
- Image renders (`mainMedia` or `defaultImageUrl` fallback) — no broken image.
- Title matches `title` exactly.
- Highlight badge: `featuredText` + `featuredColor`.
- Validity end date renders.
- Subtitle renders only on tile types that support one.
- Text elements (title, subtitle, validity, badge text) do not overlap each other or other tile elements (image, badge, icons) on any of the configured tiles or sizes.
- All configured sizes render without truncation. No crash.

---

### 110165 — [OF] Widget Tile - moreButtonText Tap Navigates to List View

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · ContentHub live data

**Test data:** Offers widget on a tile type that exposes `moreButtonText`, with a populated `moreButtonText` value visible on the tile.

**Doc gap:** `moreButtonText` is not in the Offers concept or GraphQL; concept must specify which tile types render it before this case enters regression.

**Steps:**
1. Open the homepage and locate the Offers tile that displays `moreButtonText`.
2. Tap the `moreButtonText` element.

**Expected:**
- Tap navigates to Offers List View (Listenansicht); OS default transition.
- Destination is List View — not Detail View, not another screen.
- No crash.

---

### 110296 — [OF] Widget Tile - Article Preview Tap Opens Detail View Directly Skipping List

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · ContentHub live data

**Test data:** Offers widget on a tile type that supports direct-to-Detail routing (article preview rendered on tile; tap opens Detail View, bypassing List View). Tile must show ≥ 1 offer preview.

**Doc gap:** direct-to-Detail routing not in concept; concept should enumerate which tile types skip List View on tap.

**Steps:**
1. Open the homepage and locate the Offers tile that renders an article preview.
2. Tap the article preview on the tile.

**Expected:**
- Tap routes directly to Detail View (Angebotsdetails) for the previewed offer.
- List View is NOT shown — no flicker, no intermediate screen.
- Detail View matches the previewed offer (title, image, validity).
- No crash.

---

### 110297 — [OF] Widget Tile - Carousel Tile Type Left Right Swipe

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · ContentHub live data

**Test data:** Offers widget configured as a carousel tile with widget-key `offersCount` set to a known value (e.g. 5) and ContentHub providing ≥ `offersCount` active offers.

**Doc gap:** carousel tile type and `offersCount` widget-key not in concept.

**Steps:**
1. Open the homepage and locate the carousel Offers tile.
2. Count the rendered offer cards.
3. Swipe right-to-left to the end of the carousel.
4. Swipe left-to-right back to the start.

**Expected:**
1. Number of offers in the carousel equals the configured `offersCount` value.
2. Right-to-left swipe advances; left-to-right returns to previous.
3. Smooth transitions; no flicker, no jump, no skipped/duplicate offers.
4. Edge behaviour at first/last item is consistent (bounce or wrap).
5. No crash.

---

## Feed View & Map View (12925)

Default list view of active offers. Every item shows image (with `defaultImageUrl` fallback), title, "bis + end date", saving value, and address. Sorted by redemption date (closest first). Business rule: only future/today offers shown. Featured offers render a top-right badge with `featuredColor` + `featuredText`.

### 110166 — [OF] Feed View - List Item Renders Image Title Highlight Badge And Validity

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · [JSON](https://endios.atlassian.net/wiki/spaces/S3/pages/852328527) · ContentHub live data

**Test data:** Offers widget with: ≥ 1 offer with `mainMedia`, ≥ 1 without (for `defaultImageUrl` fallback), ≥ 1 with `featured: true` + `featuredText` + distinctive `featuredColor`, ≥ 1 with `featured: false`, all offers have `validityPeriod` populated.

**Doc gap:** concept says validity is `"bis" + end date` but implementation renders the full date range with day names. Expected matches implementation.

**Steps:**
1. Open the Feed View from the homepage.
2. In one pass, inspect items with vs. without `mainMedia` and featured vs. non-featured: image, title, badge, validity row.

**Expected:**
- Image renders (`mainMedia` or `defaultImageUrl` fallback) — no broken image.
- Title matches `name` exactly.
- Featured offers show top-right badge with `featuredColor` + `featuredText`; non-featured show no badge.
- Validity row shows full configured `validityPeriod` (start–end with day names).
- No "null"/"undefined"; no crash; no broken layout.

---

### 110167 — [OF] Feed View - List Scrollable Up Down And Only Non Expired Offers Displayed

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · ContentHub live data

**Test data:** Offers widget with: ≥ 1 offer with `validityPeriod.endTime` in the PAST, ≥ 1 valid TODAY, ≥ 10 future offers (enough to require scrolling).

**Doc gap:** sort order ("closest validity end date at top") was previously asserted by this case and is no longer covered. Add via `/testcases-create` if regression on ordering is required.

**Steps:**
1. Open the Feed View from the homepage.
2. Scroll the list top-to-bottom; compare the visible items against the configured offer set.

**Expected:**
- Smooth scroll; no jank, flicker, or crash.
- Every offer with `validityPeriod.endTime` ≥ today is reachable.
- Past-date offers are NOT shown.
- No duplicates; no empty rows; no "null"/"undefined".

---

### 110300 — [OF] Feed View - Filter Category Toggle Filters Feed And Renders Category Icon

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · [Analytics](https://endios.atlassian.net/wiki/spaces/S3/pages/5166661686) · ContentHub live data

**Test data:** Offers widget with offers spanning ≥ 2 distinct categories; each category has a non-null `icon` URL configured.

**Note:** consolidated from C110173 (deprecated) so all Feed View coverage lives in one section.

**Steps:**
1. Open the Feed View from the homepage.
2. Tap the filter icon in the nav bar to open Filtereinstellungen.
3. Disable one category and confirm; observe the Feed View.
4. Re-open Filtereinstellungen, re-enable the same category, and confirm; observe the Feed View.

**Expected:**
- Filter icon opens Filtereinstellungen.
- Each category row renders: configured `category.icon`, `name`, and a toggle.
- Toggle change enabled → disabled: that category's offers are removed from the Feed View; the list reflects the offers fetched per the filters applied.
- Toggle change disabled → enabled: that category's offers are restored in the Feed View; the list reflects the offers fetched per the filters applied.
- Rows with missing/invalid `icon` show no broken-image icon (fallback or nothing).
- No crash.

---

### 110301 — [OF] Feed View - Date Picker Gültigkeit Confirmed Date Filters Feed By validityPeriod

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · [Analytics](https://endios.atlassian.net/wiki/spaces/S3/pages/5166661686) · ContentHub live data

**Test data:** Offers widget with: ≥ 1 offer valid only in the current week; ≥ 1 offer valid only in a later week (no overlap).

**UI reference:** per supplied iOS screenshots. Colour rendering is NOT in scope of this case.

**Note:** consolidated from C110174 (deprecated).

**Steps:**
1. Open the Feed View; tap the filter icon to open **Filter & Sortierung**.
2. Under GÜLTIGKEIT, pick a date covered only by the LATER offer from the date picker; tap **Übernehmen**; verify the "Ab" pill shows the selected date and the Feed View updates.
3. Re-open the screen; pick a date covered only by the CURRENT-week offer; tap **Übernehmen**; verify the "Ab" pill matches and the list updates.
4. Re-open the screen; change the date and tap **Abbrechen**; verify the filter is unchanged.
5. Tap the **X** close icon on the "Ab" pill; verify the date clears back to the default state (`Beliebig` / current date).

**Expected:**
- Filter & Sortierung opens with GÜLTIGKEIT (Ab pill + date picker) and KATEGORIEN (toggles).
- Übernehmen applies the selected date: the "Ab" pill displays it (format per UI reference) and the Feed View shows only offers whose `validityPeriod` covers it.
- Each new confirmed date updates the list.
- Abbrechen does NOT change the filter.
- Tapping the X close icon on the "Ab" pill clears the selected date back to the default state (`Beliebig` / current date).
- No crash.

---

### 110169 — [OF] Map View - Toggle, Pins, Current Location, And Map View Type Selector

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · [Analytics](https://endios.atlassian.net/wiki/spaces/S3/pages/5166661686) · ContentHub live data

**Test data:** Offers widget with ≥ 2 active offers, each having valid `place.coordinate` (latitude + longitude) values. Offers spanning ≥ 2 distinct categories (mirrors C110300 setup) so the filter category toggle on Map View can be exercised. ≥ 1 offer valid only in the current week and ≥ 1 offer valid only in a later week (no overlap) so the Gültigkeit date filter can be exercised.

**Permissions:** location permission granted to the app for the current-location icon. If not yet granted, the OS permission flow may appear on first tap — grant to proceed.

**UI reference:** per supplied iOS screenshots (shared with C110301). Colour rendering is NOT in scope of this case.

**Doc gap:** Map View (including current-location icon, map view type selector with 3 options + close button, filter behaviour, overview control) is documented only in the analytics page (not in the 2018 concept).

**Steps:**
1. Open the Feed View; toggle to Map View via the view-switcher control.
2. Tap a pin (or its offer card popup); observe the destination.
3. Close the Detail View; verify Map View is restored.
4. Tap the filter icon to open **Filter & Sortierung**; under KATEGORIEN, inspect each category row (icon, name, toggle); disable one category; observe the Map View. Re-open the screen, re-enable the same category; observe.
5. Re-open the screen. Under GÜLTIGKEIT, pick a date covered only by the LATER offer from the date picker; tap **Übernehmen**; verify the "Ab" pill shows the selected date and the Map View updates.
6. Re-open the screen; pick a date covered only by the CURRENT-week offer; tap **Übernehmen**; verify the "Ab" pill matches and the Map View updates.
7. Re-open the screen; change the date and tap **Abbrechen**; verify the filter is unchanged.
8. Tap the X close icon on the "Ab" pill; verify the date clears back to the default state (`Beliebig` / current date).
9. Tap the map view type icon (positioned below the current location icon); verify the popup opens listing all 3 view types: **Map**, **Satellite**, **Hybrid**.
10. Select **Map**; verify the map renders the standard map view.
11. Re-open the popup; select **Satellite**; verify the map renders satellite imagery.
12. Re-open the popup; select **Hybrid**; verify the map renders satellite imagery with road / label overlay.
13. Re-open the popup; tap the close (X) button; verify the popup dismisses without changing the active view.
14. Tap the current location icon; verify the map navigates to the user's current (precise) location.
15. Tap the overview control via the view-switcher control; verify navigation to the List View (Listenansicht).

**Expected:**
- View switcher cleanly switches between Listenansicht and Kartenansicht.
- Pins render at positions consistent with each offer's `place.coordinate.latitude` / `longitude`.
- Tapping a pin opens the same Detail View as tapping the offer from the list.
- Closing Detail View returns to Map View (not Feed View).
- Filter & Sortierung opens with GÜLTIGKEIT (Ab pill + date picker) and KATEGORIEN (toggles).
- Each KATEGORIEN row renders: configured `category.icon`, `name`, and a toggle.
- Rows with missing/invalid `icon` show no broken-image icon (fallback or nothing).
- Filter category toggle (Map View): toggling a KATEGORIEN row applies immediately (no Übernehmen needed); disabling a category removes that category's pins from the map and re-enabling restores them. The Map View reflects the offers fetched per the filters applied.
- Übernehmen is used ONLY to confirm a new date selected in the GÜLTIGKEIT date picker; it does NOT gate KATEGORIEN toggles.
- Übernehmen applies the selected date: the "Ab" pill displays it (format per UI reference) and the Map View shows only offers whose `validityPeriod` covers it.
- Each new confirmed date updates the Map View.
- Abbrechen does NOT change the filter.
- Tapping the X close icon on the "Ab" pill clears the selected date back to the default state (`Beliebig` / current date).
- Map view type icon (below current location) opens a popup listing exactly 3 view types — **Map**, **Satellite**, **Hybrid** — with the active one indicated.
- Selecting **Map** renders the standard map view (roads + labels, no satellite imagery).
- Selecting **Satellite** renders satellite imagery only (no road / label overlay).
- Selecting **Hybrid** renders satellite imagery with road / label overlay.
- The selected view type persists when the popup closes; pins remain rendered correctly across all three view types.
- Close (X) button on the popup dismisses it without changing the active view type.
- Current location icon navigates the map to the user's current (precise) location (location permission flow handled per OS — grant if prompted).
- Tapping the overview control via the view-switcher navigates from Map View to the List View (Listenansicht); OS default transition. No state loss.
- No crash.

---

### 110168 — [OF] Feed View - Tap List Item Opens Detail View

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · ContentHub live data

**Test data:** Offers widget with ≥ 2 active offers, each with distinct titles and images so the destination Detail View can be matched.

**Note:** this case previously covered the Featured Badge; that coverage is now in C110166.

**Steps:**
1. Open the Feed View from the homepage.
2. Tap one specific list item; observe the destination.
3. Return to the Feed View and tap a different list item; observe the destination.

**Expected:**
- Tap navigates to the Detail View (Angebotsdetails) for the tapped offer.
- OS default transition.
- Detail View renders the same offer (title and image match).
- Tapping a different item routes to that offer's Detail View, not a stale one.
- No crash.

---

### 110298 — [OF] Feed View - Navigation Bar Renders Title Back Filters And Map

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · ContentHub live data

**Test data:** Offers widget with ≥ 1 active offer so the Feed View renders normally.

**Doc gap:** Feed View nav bar layout (Title / Back / Filters / Map) is not in the concept. Reference layout per supplied iOS screenshot.

**Steps:**
1. Open the Feed View from the homepage.
2. Inspect the navigation bar — note elements on the left, centre, and right.

**Expected:**
- Centre: title (e.g. "Angebote") matches the configured widget title.
- Left: Back button.
- Right: Filters icon, then Map toggle (rightmost).
- All elements visible; no truncation, no overlap.
- Tappable elements look interactive (no greyed-out unless intentional).
- No crash; no missing element; no "null"/"undefined".

---

### 110299 — [OF] Feed View - Navigation Bar Back Button Returns To Homepage

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · ContentHub live data

**Test data:** Offers widget reachable from the homepage; Feed View renders with ≥ 1 active offer and shows the Back button.

**Doc gap:** Back button behaviour from the Feed View not documented; concept should specify the destination on Back tap (Homepage in current implementation).

**Steps:**
1. Open the Offers widget so the Feed View is shown.
2. Tap the Back button in the navigation bar.

**Expected:**
- Tap returns the user to the Homepage.
- OS default transition.
- Homepage renders in its expected state — not a blank screen, not a different widget.
- No crash.

---

## Detail View (Angebotsdetails) (12927)

Full detail view for a single offer. Covers field rendering (title, subtitle, main/additional media, validity period, location, rich-text description), dashboard-configured social media actions (`socialMediaType`/`Url`/`title`), and close interactions (sticky X button + pull-down-from-top gesture).

### 110170 — [OF] Detail View - All Sections Render In Order With Configured Fields

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · [JSON](https://endios.atlassian.net/wiki/spaces/S3/pages/852328527) · ContentHub live data

**Test data:** Fully populated offer — `name`, `subTitle`, `mainMedia`, ≥ 2 `additionalMedia`, full `validityPeriod`, `saving.savingValue`, `featured: true` + `featuredText` + `featuredColor`, full `place.address`, rich-text `description`, all 3 contact fields, ≥ 2 social media entries.

**Doc gap:** concept lacks: saving + badge in detail, directions affordance, section headers, Contact box structure, Social Media section, section order. Implementation reality (per supplied screenshot) captured below.

**Steps:**
1. Open the test offer's Detail View from the homepage.
2. Scroll the entire Detail View top-to-bottom in one pass; verify each section in order.

**Expected:**
- Header (image), Title, Subtitle render as configured.
- Saving + Validity card: `saving.savingValue` next to euro icon; full date range with day names; badge top-right with `featuredText` + `featuredColor`.
- Location card: `place.name` + directions arrow on right.
- Description card: `Beschreibung` header; rich-text rendered (no literal `\n`).
- Contact box: `Kontakt` header; WEB / Phone / Mail rows render only when populated, with chevron.
- Gallery: `Galerie` header; `additionalMedia` items in 2-per-row grid; positioned **after** Contact.
- Social Media: section header; one row per `socialMediaType` with `socialMediaTitle` label.
- Section order: Header → Title/Subtitle → Saving+Validity → Location → Description → Contact → Gallery → Social Media.
- Hide-if-unavailable per row/field; no crash; no broken layout.

---

### 110303 — [OF] Detail View - Location Tap Opens Map Picker And Navigates To Map App

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · ContentHub live data

**Test data:** Offer with populated `place.address`. Both Google Maps and Apple Maps installed on the device.

**Doc gap:** map-picker behaviour and the Google Maps / Apple Maps choice are not in the concept; concept should specify the map apps surfaced and the dismissal contract.

**Steps:**
1. Open an offer Detail View; tap the location card; verify both Abbrechen and tap-outside dismiss the popup.
2. Tap the location card; select Google Maps; observe.
3. Return to the app; tap the location card; select Apple Maps; observe.

**Expected:**
- Popup lists both Google Maps and Apple Maps.
- Abbrechen and tap-outside dismiss the popup; no app launches.
- Google Maps option opens Google Maps navigated to the offer location.
- Apple Maps option opens Apple Maps navigated to the offer location.
- Returning preserves Detail View scroll position. No crash.

---

### 110304 — [OF] Detail View - Contact Section Rows Are Functional

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · ContentHub live data

**Test data:** Offer with all 3 contact fields populated (`website`, `phone`, `email`). Browser, dialer, and mail client installed.

**Doc gap:** tap handlers for WEB / Phone / Mail not documented; concept should specify the system handlers and prefill contract.

**Steps:**
1. Open an offer Detail View from the homepage; scroll to Kontakt.
2. Tap **WEB**; return to the app.
3. Tap **Phone**; return to the app.
4. Tap **Mail**; return to the app.

**Expected:**
- WEB opens system browser at `website`.
- Phone opens dialer prefilled with `phone`.
- Mail opens mail composer prefilled with `email` (To:).
- Returning preserves Detail View scroll position. No crash.

---

### 110305 — [OF] Detail View - Gallery Renders Images With Swipe And Full Viewer

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · ContentHub live data

**Test data:** Offer with ≥ 3 distinct `additionalMedia` images.

**Doc gap:** full-image viewer + in-viewer swipe + close-and-restore-scroll-position not in concept.

**Steps:**
1. Open Detail View; scroll to Galerie. Verify every configured `additionalMedia` image is listed.
2. Tap an image; in the full-image viewer swipe right-to-left then left-to-right.
3. Tap close on the viewer.

**Expected:**
- Galerie lists all configured `additionalMedia` images — no missing items, no broken images.
- Tap opens the full-image viewer for the tapped image.
- Right-to-left advances; left-to-right returns to previous.
- Close returns to Detail View at the same scroll position. No crash.

---

### 110306 — [OF] Detail View - Social Media Rows Functional With Expand Collapse

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · ContentHub live data

**Test data (three instances):**
- A: ≤ 3 social media entries with distinct `socialMediaType`, valid `socialMediaUrl`, non-empty `socialMediaTitle`.
- B: ≥ 5 social media entries — for expand/collapse.
- C: offer with NO `socialMedia` entries — for negative check.

**Doc gap:** > 3 expand/collapse with dropdown / dropup chevron not in concept. Also: `Social Media aufgerufen` analytics event from deprecated C110171 is NOT covered here.

**Steps:**
1. Open Detail View on Instance A; verify each row's icon (`socialMediaType`) and label (`socialMediaTitle`); tap each row in turn and return to the app.
2. Open Detail View on Instance B; scroll to Social Media; verify only first 3 rows + dropdown chevron.
3. Tap the chevron; verify all rows render and chevron flips to dropup. Tap again; verify collapse back to 3.
4. Open Detail View on Instance C; scroll to where the Social Media section would render.

**Expected:**
- Instance A: each row has `socialMediaType` icon + `socialMediaTitle` label; tap opens `socialMediaUrl` via OS default handler (social app if installed, else browser). Returning preserves scroll.
- Instance B: initial state = first 3 rows + dropdown chevron. Expand → all rows + dropup chevron. Collapse → 3 rows + dropdown chevron. Rows tappable in either state.
- Instance C: NO Social Media section — no header, no rows, no container, no placeholder.
- No crash.

---

### 110307 — [OF] Detail View - Close Icon Returns To Previous Page

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · ContentHub live data

**Test data (two entry-point scenarios):**
- (a) Detail View entered via Feed View tap (companion to C110168).
- (b) Detail View entered via direct-tile article-preview routing (companion to C110296). Requires a tile type with direct-to-Detail support.

**Doc gap:** dual-source close-routing not in concept. Pull-down-from-top close gesture (mentioned in concept) is intentionally NOT covered here — raise via `/testcases-create` if needed.

**Steps:**
1. From the homepage, open the Offers tile to enter the Feed View.
2. Tap a list item to open the Detail View.
3. Tap the close (X) icon. Observe the destination.
4. From the homepage, locate an Offers tile with direct-to-Detail support.
5. Tap the article preview to open the Detail View directly.
6. Tap the close (X) icon. Observe the destination.

**Expected:**
- (a) Feed View entry: close returns to the Feed View at the same scroll position; OS default transition.
- (b) Direct-tile entry: close returns to the homepage with the originating Offers tile visible.
- Each scenario routes to its correct entry point — no stale or unrelated screen.
- No crash; no stranded blank screen.

---

## Negative Scenarios (12929)

Error-handling and robustness checks: empty offer list (zero active offers returned by GraphQL) and offers missing optional fields (no `subTitle`, no `logo`, no `phone`, no `email`, no `description`). Expected behaviour: no crash; affected UI elements hidden rather than showing placeholders.

### 110175 — [OF] Negative - Empty List And Missing Optional Fields - No Crash No Placeholders

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · [JSON](https://endios.atlassian.net/wiki/spaces/S3/pages/852328527) · ContentHub live data

**Test data (two scenarios):**
- (a) Empty bucket — Offers widget pointed at an empty/inactive ContentHub bucket so GraphQL returns zero offers.
- (b) Partial fields — offer missing each of: `subTitle`, `logo`, `phone`, `email`, `description`, `additionalMedia`.

**Steps:**
1. Open Scenario (a) Offers widget from the homepage; observe the Feed View; verify filter and Gültigkeit controls remain accessible.
2. Open Scenario (b) Offers widget from the homepage; tap into the partial-field offer and scroll the entire Detail View.

**Expected:**
- (a) Feed View renders an empty state (friendly message if configured); filter and Gültigkeit remain responsive. No crash.
- (b) Each missing optional field is hidden, not placeholdered: no `subTitle` line, no `logo` area, no Phone row, no Mail row, no Beschreibung card, no Galerie section.
- No crash; no literal "null"/"undefined"/empty-string.

---

### 110302 — [OF] Negative - Airplane Mode - Widget Shows Error And Recovers When Network Restored

**Refs:** —

**Preconditions:**

**App:** Claude Automation (1020) · **Widget:** `one_widget_offers`
**Sources:** [Concept](https://endios.atlassian.net/wiki/spaces/S3/pages/586809384) · [GraphQL](https://endios.atlassian.net/wiki/spaces/S3/pages/5122555905) · ContentHub live data

**Test data:** Offers widget with ≥ 1 active offer that renders normally online. Tester has device-level Airplane Mode access.

**Doc gap:** airplane mode / network-recovery behaviour not in concept; case asserts no-crash + auto-recovery as observed.

**Steps:**
1. From the homepage, enable Airplane Mode and refresh; observe the Offers tile.
2. Tap the tile; observe the Feed View.
3. Disable Airplane Mode; wait for the network to restore.
4. From the homepage, tap the Offers tile; observe the Feed View.

**Expected:**
- Airplane Mode (steps 1–2): tile and Feed View render an error/empty state — no broken images, no "null"/"undefined", no infinite spinner. App does not crash; homepage and other widgets stay interactive.
- Network restored (step 4): widget recovers without app restart; offers render as before. No stale error state, no duplicates.
