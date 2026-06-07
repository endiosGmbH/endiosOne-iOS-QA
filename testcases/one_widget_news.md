# News [NW]

> **TestRail:** project `endiosOne` (5) · suite `Master` (468) · section `12902` — [News [NW]](https://endios.testrail.io/index.php?/suites/view/468&group_id=12902)
> **Widget-key:** `one_widget_news` · **Spec:** [S3/580419716 — News widget concept](https://endios.atlassian.net/wiki/spaces/S3/pages/580419716) · [V1.1 features](https://endios.atlassian.net/wiki/spaces/S3/pages/593985543) · [ContentHub News-JSON](https://endios.atlassian.net/wiki/spaces/S3/pages/857014447)
>
> **Tile variants:** Carousel (12x12), Basic (4x4), Basic Image (4x4), Strip (12x4), Gallery (8x8 / 12x12)
>
> Snapshot of TestRail testcases for the News widget. 19 cases across 4 subsections.

## Widget Tile — Dashboard Configuration (12903)

### 110082 — News - Tile - Renders tile type, image, title, subtitle per variant

**Refs:** AGENCY-6416

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** Valid RSS feed URL (e.g. Tagesschau) or ContentHub manual news. Use TEST widget instances configured with `newsCount=5` per variant.

**Concept docs:** [S3/580419716 — News widget concept](https://endios.atlassian.net/wiki/spaces/S3/pages/580419716)

**Tile variants and per-variant element matrix:**

| Variant (`type`) | Size | image | title | subtitle | Editable styles |
| --- | --- | --- | --- | --- | --- |
| Carousel (`carousel`) | 12x12 | Yes (article image) | Yes | No (description excerpt instead) | fontColorTitle, fontColorSubtitle, backgroundColor |
| Basic (`basic`) | 4x4 | No (icon only, 36x36 dp) | Yes | No | fontColorTitle, backgroundColor |
| Basic Image (`basicImage`) | 4x4 | Yes (full-tile background) | Yes | No | fontColorTitle, backgroundColor |
| Strip (`strip`) | 12x4 | Yes | Yes | Yes | fontColorTitle, fontColorSubtitle, backgroundColor |
| Gallery (`gallery`) | 8x8 / 12x12 | Yes (per item) | Yes (per item) | Yes (description) | fontColorTitle, fontColorSubtitle, backgroundColor, glassColor |

Prepare one TEST widget instance per variant on the Product tab. Configure `defaultImageUrl` on each so the imageless-article fallback can be verified.

**User state:** User on the Product tab.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Product tab.
3. For each configured variant (Carousel, Basic, Basic Image, Strip, Gallery) repeat steps 4–9.
4. Locate the tile and confirm it matches the declared `type` and size from the precondition matrix.
5. Verify the **image** renders only if present for the variant (Carousel, Basic Image, Strip, Gallery); for Basic, verify the configured `icon` renders at 36x36 dp instead.
6. Verify the **title** renders with the configured value and the `fontColorTitle` is applied.
7. Verify the **subtitle** renders only on Strip and Gallery and the `fontColorSubtitle` is applied; confirm subtitle is NOT shown on Carousel, Basic, Basic Image.
8. For variants with article-image rendering (Carousel, Basic Image, Strip, Gallery), force an article without an image and verify the configured `defaultImageUrl` is used as fallback.
9. Verify the configured `backgroundColor` is applied (and `glassColor` on Gallery).

**Expected:**
- Each variant renders only the elements declared in the precondition matrix — no element appears on a variant where it does not apply.
- Subtitle is visible on Strip and Gallery; absent on Carousel, Basic, Basic Image.
- `fontColorTitle`, `fontColorSubtitle`, `backgroundColor`, and `glassColor` are applied per variant capability.
- `defaultImageUrl` fallback is used for imageless articles in image-bearing variants.
- NO crash, no blank tile, no spurious subtitle on variants without subtitle, no missing icon/image where applicable.

---

### 110083 — News - Tile - Tapping an article preview opens Article Detail directly (skips List View)

**Refs:** AGENCY-6416

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** Valid RSS feed URL or ContentHub manual news.

**Concept docs:** [S3/580419716 — News widget concept](https://endios.atlassian.net/wiki/spaces/S3/pages/580419716)

**Variants in scope:** Variants whose tile displays per-article previews directly — **Carousel** and **Gallery**. Skip variants without per-article tile previews (Basic, Basic Image, Strip — these route to List View instead and are covered by C110084).

**User state:** User on the Product tab. TEST widget instances configured for Carousel (12x12) and Gallery (8x8 or 12x12) with `newsCount` ≥ 2.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Product tab.
3. For each variant in scope (Carousel, Gallery) repeat steps 4–6.
4. Locate the tile rendering article previews directly.
5. Tap on any visible article preview on the tile.
6. Verify the app transitions directly to the Article Detail view of the tapped article (App-Store-style transition on Carousel) WITHOUT showing the List View as an intermediate screen.

**Expected:**
- For Carousel and Gallery, tapping an article preview opens the corresponding Article Detail directly.
- List View is NOT shown between the tile and the Article Detail (no flicker, no intermediate screen).
- The Article Detail shown matches the tapped preview (correct article).
- NO crash, no wrong-article opened, no broken transition.

---

### 110084 — News - Tile - Tapping moreButtonText navigates to List View

**Refs:** AGENCY-6416

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Concept docs:** [S3/580419716 — News widget concept](https://endios.atlassian.net/wiki/spaces/S3/pages/580419716)

**Field under test:** `moreButtonText` — dashboard-configurable label for the "view all" CTA that routes to the List View. The text is set per widget instance via the dashboard.

**Variants in scope:** Any tile variant where `moreButtonText` is configured on the TEST widget instance. Skip any variant where the field is not configured for that instance.

**User state:** User on the Product tab. TEST widget instances prepared with a non-empty `moreButtonText` value (e.g. "Alle Nachrichten ansehen") on every applicable variant.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Product tab.
3. For each variant where `moreButtonText` is configured, repeat steps 4–6.
4. Locate the tile and verify the configured `moreButtonText` string is rendered on the "view all" button.
5. Tap the button.
6. Verify the app navigates to the List View of the News widget.

**Expected:**
- The configured `moreButtonText` label is rendered exactly on every variant where the field is configured.
- Tapping the button opens the List View of the News widget.
- If `moreButtonText` is not configured for a variant, the button is not displayed on that tile.
- NO crash, no fallback / placeholder text, no navigation to a different screen.

---

### 110085 — News - Tile - Carousel rotation works for variants with horizontal swipe

**Refs:** AGENCY-6416

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Concept docs:** [S3/580419716 — News widget concept](https://endios.atlassian.net/wiki/spaces/S3/pages/580419716) (Variant 1: Carousel; Variant 4: Gallery)

**Variants in scope:** Tile variants that implement horizontal swipe rotation across articles — **Carousel** (12x12) and **Gallery** (8x8 / 12x12). Variants without carousel behavior (Basic, Basic Image, Strip) are out of scope.

**Config under test:** `newsCount` = 5 (range allowed: 1–8).

**User state:** User on the Product tab. TEST widget instances prepared for Carousel and Gallery with `newsCount=5`.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Product tab.
3. For each variant in scope (Carousel, Gallery) repeat steps 4–9.
4. Locate the tile.
5. Swipe horizontally **right-to-left** through the items on the tile from the first item to the last.
6. Verify exactly `newsCount` (5) items are reachable in the right-to-left direction.
7. Verify the page indicator (dots) animates in sync with the right-to-left swipe.
8. From the last item, swipe horizontally **left-to-right** back through the items to the first.
9. Verify all `newsCount` items are reachable in the left-to-right direction and the page indicator animates in sync, confirming the rotation works in both directions.

**Expected:**
- Carousel and Gallery support horizontal swipe in **both directions** (right-to-left and left-to-right) across exactly `newsCount` items.
- Page indicator animates in sync with swipe in either direction.
- Swiping past the last (or before the first) item behaves per spec (stops or loops — verify against current concept).
- NO crash, no skipped item in either direction, no stuck indicator, no rotation on out-of-scope variants (Basic, Basic Image, Strip).

---

## List View (12904)

Core article list view. Articles ordered newest-first, with image + title + truncated description per item. Uses `defaultImageUrl` from dashboard config when an article has no image.

### 110087 — News - List View - Manual news (ContentHub) displays for tiles with list-view access

**Refs:** AGENCY-6416

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** ContentHub manual news entries (≥3 articles) configured for the widget instance.

**Concept docs:** https://endios.atlassian.net/wiki/spaces/S3/pages/580419716 (Core / List View)

**Variants in scope (tiles with access to List View):**
- Whole-tile-tap → List View: Basic, Basic Image, Strip
- Any variant where `moreButtonText` is configured (e.g. Carousel, Gallery when the field is set) — entry via the `moreButtonText` CTA

Skip variants without List View access (Carousel / Gallery without `moreButtonText` configured).

**User state:** User on the Product tab. TEST widget instances prepared per applicable variant, all pointed at the same ContentHub manual-news source.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Product tab.
3. For each variant in scope, repeat steps 4–6.
4. Enter List View — for Basic / Basic Image / Strip tap the tile; for variants with `moreButtonText` configured, tap that button.
5. Verify all configured ContentHub manual news entries display in the list.
6. Verify the list is ordered by publish date with the newest article at the top.

**Expected:**
- List View opens via every entry path under test (whole-tile tap for Basic/Basic Image/Strip, `moreButtonText` tap for variants where the field is configured).
- Every configured ContentHub manual news entry appears in the list — no missing items.
- Articles are ordered by publish date, newest-first.
- NO crash, no blank list, no entries from a non-configured source.

---

### 110088 — News - List View - Tapping an RSS feed list item opens the configured URL in a webview and the close icon returns to the list

**Refs:** AGENCY-6416

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** Valid RSS feed URL configured on the widget instance (e.g. Tagesschau). Feed must contain ≥3 items, each with a configured web URL.

**Concept docs:** https://endios.atlassian.net/wiki/spaces/S3/pages/580419716 (Core / List View & Article Detail)

**Variants in scope (tiles with access to List View):**
- Whole-tile-tap → List View: Basic, Basic Image, Strip
- Any variant where `moreButtonText` is configured (e.g. Carousel, Gallery when the field is set)

**User state:** User on the Product tab. TEST widget instances prepared per applicable variant, all pointed at the same RSS feed.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Product tab.
3. Tap the News tile (or tap the configured `moreButtonText`) to open the List View.
4. Verify the RSS feed items returned by the configured feed display in the list.
5. Tap any RSS feed list item.
6. Verify the app opens a webview at the configured web URL of the tapped item; do NOT wait for the page to finish rendering fully.
7. Scroll through the webview for ~2 seconds.
8. Scroll back up to the top of the webpage so the webview chrome (top bar) becomes visible again.
9. Verify the close (X) icon is shown in the top-left corner of the webview chrome.
10. Tap the close (X) icon.
11. Verify the app returns to the News List View with the RSS feed items still displayed.

**Expected:**
- Tapping the tile (or `moreButtonText`) opens the List View with all RSS feed items shown.
- Tapping any RSS feed list item opens a webview at the article's configured web URL (no need to wait for full page render).
- Scrolling inside the webview is responsive; scrolling back to the top reveals the chrome with the close (X) icon visible in the top-left corner.
- Tapping the close (X) icon dismisses the webview and returns the user to the List View; the list state (items, scroll position) is preserved.
- The destination URL matches the URL configured for the tapped item — no wrong-article opened.
- NO crash, no broken link, no stuck webview, no missing close icon (user is never stranded).

---

### 110089 — News - List View - Layout (heading, subline, description, date) renders correctly; long description truncated with ellipsis

**Refs:** AGENCY-6416

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** ContentHub manual news AND RSS feed instances, each containing at least one article with a long description (clearly exceeding the preview area) and at least one article with no image (to verify `defaultImageUrl` fallback).

**Concept docs:** https://endios.atlassian.net/wiki/spaces/S3/pages/580419716 (Core / List View — layout, truncation rule, `defaultImageUrl` fallback)

**Required list-item layout:** heading, subline, description, date, image.

**Source coverage:** Verify on both a manual (ContentHub) news widget instance and an RSS feed widget instance.

**User state:** User on the Product tab; List View reachable for both source configurations.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Product tab.
3. For each source type (manual ContentHub, RSS feed) repeat steps 4–8.
4. Open the News widget List View.
5. For each visible list item, verify the layout displays heading, subline, description preview, date, and image — each rendered in its configured position with the configured value.
6. Locate an article whose description clearly exceeds the preview area; verify the description is truncated and terminated with three dots ("…").
7. Verify the rest of the item (image, heading, subline, date) for that long-description article remains intact and unaffected by the truncation.
8. Locate an article that has no image; verify the configured `defaultImageUrl` renders as fallback in the image slot.

**Expected:**
- Each list item renders heading, subline, description, date, and image — for both manual news and RSS source types.
- Over-long descriptions are truncated and terminated with "…"; the rest of the item (image, heading, subline, date) remains intact.
- Imageless articles render the configured `defaultImageUrl` as fallback; articles with their own image are unaffected.
- NO crash, no overflow text, no missing layout element, no broken/placeholder image.

---

### 110090 — News - List View - List is scrollable up and down

**Refs:** AGENCY-6416

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** RSS feed or ContentHub source returning enough articles to require scrolling beyond the initial viewport (≥10 items).

**Concept docs:** https://endios.atlassian.net/wiki/spaces/S3/pages/580419716 (Core / List View)

**User state:** User on the Product tab; List View is reachable from the configured tile.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Product tab.
3. Open the News widget List View.
4. Note the topmost visible article.
5. Swipe upward (scroll down) through the full list until the last item is reached.
6. Verify additional articles continuously load into view and the bottom of the list is reachable.
7. Swipe downward (scroll up) back to the start.
8. Verify the list returns smoothly to the topmost article noted in step 4.

**Expected:**
- List View scrolls smoothly in both directions — downward to the bottom of the list and upward back to the top.
- No items are skipped or rendered blank during scroll.
- Scrolling does not trigger unintended navigation (e.g. opening Article Detail).
- NO crash, no scroll lock, no jitter, no infinite loading state.

---

### 110101 — News - List View - Navigation bar heading shows configured value and Back button returns to previous screen

**Refs:** AGENCY-6416

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** Any valid News widget configuration (RSS feed or ContentHub).

**Dashboard widget config:** Widget instance with a non-empty configured `title` rendered in the List View navigation bar (AppBar). Use distinct, recognisable values (e.g. "Tagesschau News") so default fallbacks can be ruled out.

**Concept docs:** https://endios.atlassian.net/wiki/spaces/S3/pages/580419716 (Core / List View — AppBar)

**Variants in scope:** Any tile variant that opens List View (Basic, Basic Image, Strip; or any variant where `moreButtonText` is configured).

**User state:** User on the Product tab.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Product tab.
3. For each entry path under test (whole-tile tap on Basic / Basic Image / Strip; `moreButtonText` tap where configured), repeat steps 4–6.
4. Enter the News widget List View.
5. Verify the navigation bar (AppBar) displays the configured `title` exactly (matching case and characters; no truncation beyond design spec).
6. Tap the Back button in the navigation bar and verify the user returns to the Product tab with the originating tile visible.

**Expected:**
- Navigation bar heading shows the configured `title` exactly — no fallback, no placeholder, no truncation.
- Tapping the Back button returns the user to the previous screen (Product tab) with the originating tile visible and interactive.
- Behavior is consistent across every entry path (whole-tile tap and `moreButtonText` tap).
- NO crash, no stuck navigation, no unintended deep-back beyond the previous screen.

---

### 110107 — News - List View - Filter applied updates list and filter name shows configured value

**Refs:** AGENCY-6416

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** Multi-source widget configuration with ≥2 editable sources (source A and source B), each producing ≥1 identifiable article with distinct Publisher attribution. Both sources configured per V1.1 schema (`url`, `name`, `pos`, `editable=true`, `default=true`).

**Concept docs:**
- V1.0: https://endios.atlassian.net/wiki/spaces/S3/pages/580419716 (Core / List View)
- V1.1: https://endios.atlassian.net/wiki/spaces/S3/pages/593985543 (Settings — source activation/deactivation)

**Behaviour under test:**
- Deactivating a source removes its articles from List View immediately.
- Reactivating a source restores its articles.
- The filter chip / label shown in List View reflects the source's configured `name` value (not a hard-coded label).

**User state:** User on the Product tab; no personal source-setting overrides yet.

**Scope notes:** Persistence across app relaunch → C110105. Reset-to-default → C110106.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Product tab.
3. Open the News widget List View.
4. Verify articles from both source A and source B are present, ordered newest-first, with correct Publisher attribution.
5. Verify the filter chip / label in List View shows the configured source `name` values (not generic placeholders).
6. Open Source Settings; deactivate source A (leave source B active).
7. Return to List View and scroll the full list.
8. Verify the filter chip / label updates to reflect only the active source(s).
9. Open Source Settings; reactivate source A.
10. Return to List View and scroll the full list.

**Expected:**

**After step 7 (filter applied):**
- No article originally attributed to source A appears anywhere in List View.
- Every remaining article is attributed to source B (or other still-active sources).
- Filter chip / label updates to show only the configured `name` of active source(s) — never a hard-coded fallback.
- List remains ordered by publish date newest-first across surviving sources.
- NO empty state if any active source still returns articles; NO stale cache of deactivated-source articles.

**After step 10 (filter cleared):**
- Source A's articles re-appear and are interleaved by date alongside source B's articles.
- Filter chip / label updates to show all reactivated configured `name` values.
- NO duplicate articles after reactivation; NO crash at any point.

---

## Article Detail View (12905)

Article detail view. Renders native (for ContentHub manual news or tagged RSS) or as webview (for untagged RSS such as Tagesschau). Close via X button or pull-down-from-top gesture.

### 110091 — News - Article Detail - Main image, heading, subtitle, and content render only when configured

**Refs:** AGENCY-6416

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** ContentHub manual news entries with mixed configurations:
- Article A: all fields configured (`mainMedia`/main image, `name`/heading, `subTitle`, `description`/content).
- Article B: only heading + content configured (no `mainMedia`, no `subTitle`).
- Optional Article C: heading + content + subtitle but no `mainMedia`.

**Concept docs:** https://endios.atlassian.net/wiki/spaces/S3/pages/580419716 (Article view — field rendering rules)

**Field-display rule under test:** Each field is shown only if configured in the source data — non-configured fields are hidden, not shown as empty placeholders.

**User state:** User on the Product tab; List View reachable.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Product tab.
3. Open the News widget List View and tap Article A (all fields configured).
4. Verify the Detail View renders the configured main image, heading, subtitle, and content with their configured values.
5. Return to List View and tap Article B (only heading + content).
6. Verify the Detail View renders only heading and content; the main image area and subtitle area are NOT displayed at all (no empty slot, no placeholder).
7. (Optional) Open Article C and verify the corresponding subset (heading + subtitle + content, no main image) renders correctly.

**Expected:**
- Each configured field (main image, heading, subtitle, content) renders with its configured value.
- Fields that are not configured are hidden completely — no empty image slot, no empty subtitle line, no placeholder text.
- Layout adjusts correctly when fields are missing (no awkward whitespace).
- NO crash, no broken/placeholder image, no empty-string field showing.

---

### 110092 — News - Article Detail - Gallery section displays configured images

**Refs:** AGENCY-6416, OP-15729

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** ContentHub manual news entries with mixed gallery configurations:
- Article G+: ≥3 `additionalImages` configured (gallery should display).
- Article G−: no `additionalImages` (gallery should NOT display).

**Concept docs:**
- https://endios.atlassian.net/wiki/spaces/S3/pages/857014447 (News-JSON schema — `additionalImages`)
- https://endios.atlassian.net/wiki/spaces/S3/pages/580419716 (Article view — gallery section)

**User state:** User on the Product tab; List View reachable.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Product tab.
3. Open the News widget List View and tap Article G+ (gallery configured).
4. Scroll within the Detail View to locate the Gallery section.
5. Verify the Gallery section is displayed and renders every configured image from `additionalImages`.
6. Return to List View and tap Article G− (no `additionalImages`).
7. Verify the Gallery section is NOT displayed in this article's Detail View.

**Expected:**
- Gallery section is displayed only when `additionalImages` are configured.
- All configured images render in the gallery in the configured order.
- When `additionalImages` are not configured, the Gallery section is hidden completely (no empty container, no placeholder).
- NO crash, no broken thumbnails, no missing image, no extra/duplicate images.

---

### 110093 — News - Article Detail - Close (X icon) returns to List View / originating screen

**Refs:** AGENCY-6416

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** Any RSS feed or ContentHub article that opens in native Detail View.

**Concept docs:** https://endios.atlassian.net/wiki/spaces/S3/pages/580419716 (Article view — close affordance: X button stays visible while scrolling)

**User state:** User on the Product tab; List View reachable.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Product tab.
3. Open the News widget List View and tap any article to open Detail View.
4. Scroll the article to mid-content.
5. Verify the X (close) button remains visible at the top-right corner during scroll.
6. Tap the X button.
7. Verify the user returns to the originating screen (List View, or the Carousel/Gallery tile if that was the entry path).

**Expected:**
- X button is always visible at the top-right corner of the Detail View while scrolling content.
- Tapping the X button closes the Detail View and returns to the originating screen (List View, or Carousel/Gallery tile depending on entry path).
- NO crash, no stuck Detail View, no disappearing X button, no accidental re-scroll instead of close.

---

### 110094 — News - Article Detail - Gallery image swipe and full-view close icon

**Refs:** AGENCY-6416

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** ContentHub manual news article with ≥3 `additionalImages` configured (so swipe and full-view interactions are exercised).

**Concept docs:**
- https://endios.atlassian.net/wiki/spaces/S3/pages/857014447 (News-JSON schema — `additionalImages`)
- https://endios.atlassian.net/wiki/spaces/S3/pages/580419716 (Article view — gallery interaction)

**Scope notes:** Close icon under test here is the **gallery full-view close icon** at the top-right of the full-image viewer — distinct from the Detail View close (X) button covered by C110093.

**User state:** User on the Product tab; List View reachable.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Product tab.
3. Open the News widget List View and tap the article with ≥3 `additionalImages`.
4. Scroll to the Gallery section in the Detail View.
5. Swipe horizontally right-to-left through the gallery; verify all configured images become reachable.
6. Swipe horizontally left-to-right back through the gallery; verify all images are reachable in the reverse direction.
7. Tap any image in the gallery.
8. Verify the tapped image opens in a full-view image viewer.
9. Verify a close icon is shown at the top-right corner of the full-view viewer.
10. Tap the close icon.
11. Verify the user returns to the Detail View with the Gallery section preserved at the prior scroll position.

**Expected:**
- Gallery supports horizontal swipe in both directions; every configured image is reachable both right-to-left and left-to-right.
- Tapping an image opens that image in a full-view viewer.
- Full-view viewer shows the close icon at the top-right corner.
- Tapping the close icon dismisses the full view and returns to the Detail View with the prior Gallery scroll position preserved.
- NO crash, no stuck full view, no missing close icon, no skipped image during swipe.

---

### 110095 — News - Article Detail - Navigation from Carousel tile preview or from a manual news item in List View opens Detail View

**Refs:** AGENCY-6416

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** ContentHub manual news entries (≥1 article). Manual entries needed because RSS-untagged articles open as a webview and are covered by C110088.

**Concept docs:** https://endios.atlassian.net/wiki/spaces/S3/pages/580419716 (Article view — entry paths)

**Variants in scope:**
- Carousel-tile tap → Detail View directly: **Carousel only** (whole-tile tap on the currently visible article preview goes straight to Detail View). Carousel does **not** support `moreButtonText`.
- Whole-tile tap → List View → tap manual news item → Detail View: **Gallery, Basic, Basic Image, Strip**.
- Any of the above variants where `moreButtonText` is configured → List View → tap manual news item → Detail View.

**User state:** User on the Product tab. TEST widget instances prepared per applicable variant, all pointed at the same ContentHub manual-news source.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Product tab.
3. For the Carousel widget instance, tap the currently visible article preview on the tile (whole-tile tap).
4. Verify the app navigates directly to the Detail View of the selected article (skipping List View).
5. Return to the Product tab.
6. For Gallery / Basic / Basic Image / Strip widget instances (or any of these variants with `moreButtonText` configured), tap the tile to enter the List View.
7. Tap any manual news item in the List View.
8. Verify the app navigates to the Detail View of the tapped item.

**Expected:**
- Carousel only: whole-tile tap on the currently visible article preview opens Detail View directly — List View is NOT shown as an intermediate.
- Gallery, Basic, Basic Image, Strip (or `moreButtonText` entry on these variants): tapping a manual news item in List View opens its Detail View.
- Carousel does NOT expose `moreButtonText`; that affordance must not appear on Carousel instances.
- The Detail View shown matches the tapped item — no wrong-article opened.
- NO crash, no broken transition, no Detail View opened directly from Gallery / Basic / Basic Image / Strip tile tap (these must route through List View).

---

### 110257 — News - Article Detail - Social media buttons open URLs; overlay close returns

**Refs:** AGENCY-6416

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** ContentHub manual news article configured with a social media section containing ≥2 social media entries, each with a configured external URL (e.g. Facebook share, Twitter/X share, Instagram link).

**Concept docs:** https://endios.atlassian.net/wiki/spaces/S3/pages/580419716 (Article view — social media section)

**Scope notes:**
- Buttons under test are on a social-media overlay screen reached from the Detail View.
- Close icon under test is on the social-media overlay (top of the overlay) — distinct from the Detail View's X icon (covered by C110093) and the gallery full-view close (covered by C110094).
- "Opens external URL" means the configured URL is launched in the system browser or the corresponding native app handler.

**User state:** User on the Product tab; List View reachable; the test article (with social media configured) is visible in List View.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Product tab.
3. Open the News widget List View and tap the article with a configured social media section.
4. In the Detail View, locate the social media section / affordance and open the social media overlay.
5. Verify all configured social media buttons display on the overlay.
6. Tap one configured social media button.
7. Verify the configured external URL opens in the system browser (or the corresponding native app handler if installed).
8. Return to the Claude Automation app.
9. Verify the social media overlay is still in focus (or re-open it if dismissed by the URL handler).
10. Verify the close icon is shown on the social media overlay.
11. Tap the close icon on the overlay.
12. Verify the user returns to the Detail View with state preserved (scroll position, gallery, etc.).

**Expected:**
- Social media section / overlay displays only the buttons that are configured — no empty/placeholder buttons.
- Each configured button shows its configured icon/label.
- Tapping a button opens the configured external URL in the system browser or native app handler.
- The destination URL matches the URL configured for the tapped button — no wrong-URL navigation.
- Tapping the close icon on the social media overlay dismisses the overlay and returns the user to the Detail View; Detail View state (scroll position, gallery, etc.) is preserved.
- NO crash, no missing button, no broken/unresponsive close icon, no navigation to a wrong screen.

---

## Negative Scenarios (12909)

Error-handling scenarios: invalid / empty RSS feed URL, duplicate-article filtering (OP-15729), special characters in RSS image URLs (OP-15722), connector unavailable (OP-15995).

### 110097 — News - Negative - Empty RSS feed response handled gracefully

**Refs:** AGENCY-6416

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** News widget configured with a valid RSS URL that currently returns zero articles.

**Docs:** https://endios.atlassian.net/wiki/spaces/S3/pages/580419716

**User state:** User on the Auto tab.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Auto tab.
3. Open the News widget List View.
4. Wait for the empty feed to load.

**Expected:**
- List View renders a clean empty state (no list items, no spinner stuck indefinitely).
- Tile shows configured values (title/icon/image) but with no article previews where applicable.
- NO crash, NO false content, NO broken layout.

---

### 110098 — News - Negative - Duplicate RSS articles not shown twice in list

**Refs:** OP-15729

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** RSS feed known to occasionally repeat items when sorted by creation date (Tagesschau-style). Reference widgetId 55927.

**Bug context:** OP-15729 — Tagesschau feed showed duplicate articles due to sorting by creation date.

**Docs:** https://endios.atlassian.net/browse/OP-15729

**User state:** User on the Auto tab.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Auto tab.
3. Open the News widget List View pointed at the Tagesschau (or repro) feed.
4. Scroll through the full list.
5. Check for entries with identical title + publish date.

**Expected:**
- NO duplicate article appears in the feed (identical title + publish date + source is rendered at most once).
- Articles remain ordered newest-first.
- NO crash, NO missing articles due to deduplication going too far.

---

### 110100 — News - Negative - Connector unavailable shows error state without crash

**Refs:** OP-15995

**Preconditions:**

**Environment:** Claude Automation app (App-ID: 1020), Test environment, Android + iOS

**Widget key:** `one_widget_news`

**Backend data source:** Scenario where the NewsConnector is down or unreachable (simulate via feature toggle, invalid backend URL, or during known outage window).

**Bug context:** OP-15995 — NewsConnector cache failure / lack of auto-restart caused a P0 on 2026-03-31.

**Docs:** https://endios.atlassian.net/browse/OP-15995

**User state:** User on the Auto tab.

**Steps:**
1. Open the Claude Automation app on Android or iOS.
2. Navigate to the Auto tab with the NewsConnector unavailable.
3. Observe the News widget tile.
4. Tap the tile to attempt opening List View.
5. Wait for the request to time out / fail.
6. Restore connector availability.
7. Retry the interaction (pull-to-refresh or close/re-open).

**Expected:**
- While connector is down: tile still renders configured graphical elements (no blank tile), List View shows an error/empty state with a retry affordance.
- App does NOT crash, does NOT hang indefinitely.
- After connector is restored and user retries: List View loads articles normally.
- NO stale cached duplicate articles, NO inconsistent state.
