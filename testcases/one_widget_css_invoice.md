# CSS Invoice [INV]

> **TestRail:** project `endiosOne` (5) · suite `Master` (468) · section `12945` — [CSS Invoice [INV]](https://endios.testrail.io/index.php?/suites/view/468&group_id=12945)
> **Widget-key:** `one_widget_css_invoice` · **Spec:** [S3/1335918649 — Invoice V2.1](https://endios.atlassian.net/wiki/spaces/S3/pages/1335918649) · [Backend v2.3](https://endios.atlassian.net/wiki/spaces/S3/pages/5606998033) · [Figma (iOS)](https://www.figma.com/design/puJPzr1lsiLaguHMEGyZc0/INV-Invoices?node-id=2519-2111)
>
> **App:** Claude Automation (1020) · CSS tab · TEST environment · **Widget instance:** 3731 / widget 18809 · [Dashboard config](https://dashboard-test.endios.one/konfigurieren/widgets/edit-widget/1020/3731/18809) · **Regression tier:** Full Regression · **Initiative refs:** PMPO-1574 (last), PMPO-3033 (next)
>
> Snapshot of TestRail testcases for the CSS Invoice widget. 10 cases across 3 subsections. Invoice is data-driven via app config (mirrors News/Weather/Offers pattern) — testcases run against the configured Invoice instance in Claude Automation rather than fixed mockcase IDs.

## Widget Tile & Dashboard Configuration (12946)

### 110361 — Widget Tile - Title and image match dashboard config

**Refs:** PMPO-3033

**Preconditions:**
- **Environment:** Claude Automation app (App-ID 1020), CSS tab, TEST environment
- **Widget-key:** `one_widget_css_invoice`
- **Widget instance:** 3731 / widget 18809
- **Dashboard config:** https://dashboard-test.endios.one/konfigurieren/widgets/edit-widget/1020/3731/18809
- **Concept:** [CSS] [INV] Invoice V2.1 — https://endios.atlassian.net/wiki/spaces/S3/pages/1335918649
- **Figma (iOS — tile variants):** https://www.figma.com/design/puJPzr1lsiLaguHMEGyZc0/INV-Invoices?node-id=2519-2136 (Basic Default 4x4) and node-id=2519-2141 (Basic Image 4x4)
- The Invoice widget instance has been configured in the dashboard with a custom tile title and a background image URL. User is logged into the Claude Automation app.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Locate the Invoice widget tile
4. Open the dashboard config URL in a browser and note the configured `tileTitle` and image URL values
5. Compare the rendered tile against the configured values

**Expected:**
- The tile title text matches the value configured in the dashboard
- The tile background image matches the image URL configured in the dashboard
- The `ic_bills` icon is rendered on the tile
- For the Image variant: darkening layer is applied so the title remains legible
- No crash; the tile is tappable

---

## Main Flow (12952)

### 110372 — Contract Selection - Multiple groups - selector and invoices

**Refs:** PMPO-3033

**Preconditions:**
- **Environment:** Claude Automation app (App-ID 1020), CSS tab, TEST environment
- **Widget-key:** `one_widget_css_invoice` (instance 3731 / widget 18809)
- **Dashboard config:** https://dashboard-test.endios.one/konfigurieren/widgets/edit-widget/1020/3731/18809
- **Backend endpoint v2.3:** GET /v2/connect?to=erpConnector&process=invoice&version=2 — https://endios.atlassian.net/wiki/spaces/S3/pages/5606998033
- **Concept:** [CSS] [INV] Invoice V2.1 — https://endios.atlassian.net/wiki/spaces/S3/pages/1335918649
- **Figma (BA-01 Contract Lists):** https://www.figma.com/design/puJPzr1lsiLaguHMEGyZc0/INV-Invoices?node-id=2519-2149
- User account is set up so that the v2.3 endpoint returns more than one item in `groups[]`. Each group has a `label` and `addressLabel` populated. The widget instance has the following dashboard-configured values: `contractsTitle`, `contractsHeadline`, `contractsSubline`. Note these values down before starting.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the Invoice widget tile
4. Wait for the widget to finish loading
5. Observe the Contract Lists screen (BA-01) — Nav title, Headline, Subline, and the list area
6. Scroll the contract group list (if more groups exist than fit on screen)
7. Tap one of the contract group rows
8. Observe the Invoice Selection screen — verify the full list of invoices for the selected group is shown with correct type labels
9. Tap each invoice in the list (covering at least one FINAL and one INTERIM type) and verify the PDF document opens in the viewer
10. Tap the close (X) button after each PDF to return to the Invoice Selection screen

**Expected:**
- Nav bar title displays the value configured in the dashboard as `contractsTitle`
- Headline displays the value configured in the dashboard as `contractsHeadline`
- Subline (Customer ID area) displays the value configured in the dashboard as `contractsSubline`
- One row per contract group is shown using the One List Small component; layout matches Figma node 2519:2149
- Each row displays the group `label` and `addressLabel`
- The list is scrollable when content exceeds the viewport (no clipping or stuck rows)
- Each contract group row is tappable
- Step 7: tapping a row navigates to that group's Invoice Selection screen, which shows the selected group's headline and client ID
- Step 8: the Invoice Selection screen lists every invoice in the selected contract group with the correct type label (FINAL → "Abschlussrechnung", INTERIM → "Zwischenrechnung", OTHER → "Rechnung")
- Step 9: each invoice opens its own distinct PDF when tapped — at least one FINAL and one INTERIM type are confirmed openable, with content matching the tapped invoice
- Step 10: tapping the close (X) button returns the user to the Invoice Selection screen with the same invoice list still rendered
- No crash across all invoices

---

### 110373 — Contract Selection - Single group navigates directly to PDF

**Refs:** PMPO-3033

**Preconditions:**
- **Environment:** Claude Automation app (App-ID 1020), CSS tab, TEST environment
- **Widget-key:** `one_widget_css_invoice` (instance 3731 / widget 18809)
- **Backend endpoint v2.3:** GET /v2/connect?to=erpConnector&process=invoice&version=2 — https://endios.atlassian.net/wiki/spaces/S3/pages/5606998033
- **Concept:** [CSS] [INV] Invoice V2.1 — https://endios.atlassian.net/wiki/spaces/S3/pages/1335918649
- User account is set up so that the v2.3 endpoint returns exactly **one** item in `groups[]`, and that group contains exactly **one** invoice with a valid `invoiceFile` (mimeType = application/pdf, content or downloadLink populated).

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the Invoice widget tile
4. Wait for the widget to finish loading
5. Observe the Contract Lists screen (BA-01)
6. Tap the single contract group row

**Expected:**
- Step 5: Contract Lists screen displays a single row for the only available contract group
- Step 6: Tapping the single contract group row navigates the user **directly to the PDF viewer** — the Invoice Selection screen is SKIPPED
- The PDF document of the single invoice is rendered in the viewer
- Close button (X) is visible in the top-left corner
- No crash

---

### 110374 — Invoice Selection - Headline, subline, and invoice list render

**Refs:** PMPO-3033

**Preconditions:**
- **Environment:** Claude Automation app (App-ID 1020), CSS tab, TEST environment
- **Widget-key:** `one_widget_css_invoice` (instance 3731 / widget 18809)
- **Dashboard config:** https://dashboard-test.endios.one/konfigurieren/widgets/edit-widget/1020/3731/18809
- **Backend endpoint v2.3:** GET /v2/connect?to=erpConnector&process=invoice&version=2 — https://endios.atlassian.net/wiki/spaces/S3/pages/5606998033
- **Concept:** [CSS] [INV] Invoice V2.1 — https://endios.atlassian.net/wiki/spaces/S3/pages/1335918649
- **Figma (INVOICES OVERVIEW):** https://www.figma.com/design/puJPzr1lsiLaguHMEGyZc0/INV-Invoices?node-id=2519-2162
- The selected contract group has at least three invoices, all with a populated `invoiceFile`. Each invoice has `invoiceName` and `invoiceDate` set. The widget instance has the following dashboard-configured values: `invoicesTitle`, `invoicesSubline`. Note these values down before starting.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the Invoice widget tile
4. Select a contract group (skip this step if only one group is configured)
5. Observe the Invoice Selection screen — Nav title, Subline, and the invoice list/box

**Expected:**
- Nav bar title displays the value configured in the dashboard as `invoicesTitle`
- Subline (Client ID area) displays the value configured in the dashboard as `invoicesSubline`
- The invoice box layout matches Figma node 2519:2162: System List header → divider → invoice rows
- One System List row is shown per invoice with `invoiceFile` populated
- Each row shows the invoice name and the invoice date
- The number of rows matches the number of file-attached invoices in the response
- No crash

---

### 110376 — PDF View - Open and close multiple invoices

**Refs:** PMPO-3033, AGENCY-5509

**Preconditions:**
- **Environment:** Claude Automation app (App-ID 1020), CSS tab, TEST environment
- **Widget-key:** `one_widget_css_invoice` (instance 3731 / widget 18809)
- **Backend endpoint v2.3:** GET /v2/connect?to=erpConnector&process=invoice&version=2 — https://endios.atlassian.net/wiki/spaces/S3/pages/5606998033
- **Concept:** [CSS] [INV] Invoice V2.1 — https://endios.atlassian.net/wiki/spaces/S3/pages/1335918649
- **Figma (SYSTEM VIEWER):** https://www.figma.com/design/puJPzr1lsiLaguHMEGyZc0/INV-Invoices?node-id=2519-2122
- The selected contract group has at least 2-3 invoices, each with a valid `invoiceFile` (mimeType = application/pdf, content or downloadLink populated). The PDF content of the invoices is distinguishable (e.g. different invoice numbers or amounts).

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the Invoice widget tile
4. Select a contract group (skip if only one is configured)
5. Tap the first invoice row in the Invoice Selection screen
6. Wait for the PDF to load and verify the document content
7. Tap the close button (X) in the top-left corner of the PDF viewer
8. Tap a second invoice row
9. Wait for the PDF to load and verify the document content
10. Tap the close button (X)
11. Repeat steps 8-10 for a third invoice (if available)

**Expected:**
- For each invoice: PDF viewer (SYSTEM VIEWER) opens and the correct document is rendered (content matches the tapped invoice — verify by invoice number / amount / date)
- Document is scrollable; multiple pages are navigable when applicable
- Close button (X) is visible in the top-left corner of the navigation bar in every case
- Tapping X closes the PDF viewer and returns the user to the Invoice Selection screen with the same invoice list still rendered (selection state preserved)
- Each invoice opens its own distinct PDF — there is no cross-talk or stale content between invoices
- No crash across all 2-3 iterations

---

### 110377 — Loading - Indicator displayed across all loading scenarios

**Refs:** PMPO-3033, AGENCY-5526

**Preconditions:**
- **Environment:** Claude Automation app (App-ID 1020), CSS tab, TEST environment
- **Widget-key:** `one_widget_css_invoice` (instance 3731 / widget 18809)
- **Concept:** [CSS] [INV] Invoice V2.1 — https://endios.atlassian.net/wiki/spaces/S3/pages/1335918649
- **Figma (LOADING):** https://www.figma.com/design/puJPzr1lsiLaguHMEGyZc0/INV-Invoices?node-id=2519-2118
- **Figma (MR-01 - Loading, PDF):** https://www.figma.com/design/puJPzr1lsiLaguHMEGyZc0/INV-Invoices?node-id=2519-2112
- User has more than one contract group configured (so a group switch is observable). At least one invoice has a valid `invoiceFile`. Network may be throttled to make the loading indicator easier to observe.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the Invoice widget tile and observe the screen until widget data finishes loading (initial widget load)
4. From the Contract Lists screen, tap a contract group and observe the screen until the Invoice Selection screen renders (group switch — skip this step if only one contract group is configured)
5. From the Invoice Selection screen, tap an invoice row and observe the screen until the PDF viewer opens (PDF load)

**Expected:**
- Step 3 (initial widget load): Progress indicator (Figma 2519:2118 LOADING) is shown centered on screen until widget data is ready
- Step 4 (group switch): Progress indicator is shown until the new group's invoice list renders
- Step 5 (PDF open): Progress indicator (Figma 2519:2112 MR-01 - Loading) is shown until the PDF viewer opens
- In all three scenarios the indicator disappears as soon as content is ready
- User input is not blocked indefinitely; no crash

---

### 110378 — Context Switch - Displayed when showContextSwitch enabled

**Refs:** PMPO-3033

**Preconditions:**
- **Environment:** Claude Automation app (App-ID 1020), CSS tab, TEST environment
- **Widget-key:** `one_widget_css_invoice` (instance 3731 / widget 18809)
- **Dashboard config:** https://dashboard-test.endios.one/konfigurieren/widgets/edit-widget/1020/3731/18809
- **Concept:** [CSS] [INV] Invoice V2.1 — https://endios.atlassian.net/wiki/spaces/S3/pages/1335918649 (§Changing the active context)
- **IMPORTANT — limited test scope:** Context switching is NOT functionally testable in this app because mockcase data is used. This testcase verifies only that the context switch UI is **displayed** correctly when configured — actual context-switching is out of scope.
- The widget instance is configured with:
  - `showContextSwitch` = true
  - `labelContextSwitch` = a recognizable test value (e.g. "Kundennummer")
  - The Integrator-side `contextSwitchAvailable` = true
- The test user has at least two contexts available. Backend v2.3 returns more than one item in `groups[]` so both Contract Selection and Invoice Selection screens are reachable.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the Invoice widget tile
4. Wait for the widget to finish loading
5. On the Contract Selection screen (BA-01), inspect the top section of the screen for the customer-number row + switch icon
6. Tap a contract group row to navigate to the Invoice Selection screen
7. On the Invoice Selection screen, inspect the top section of the screen for the customer-number row + switch icon

**Expected:**
- Step 5 (Contract Selection screen): the active customer number is displayed together with the `labelContextSwitch` value, and a context-switch icon is rendered next to it
- Step 7 (Invoice Selection screen): the active customer number is displayed together with the `labelContextSwitch` value, and a context-switch icon is rendered next to it
- Visual layout / placement matches Figma where applicable
- No crash
- **Note:** Tapping the context-switch icon is NOT in scope (context switching is not fully functional with mockcase data). Only the display is verified.

---

### 110379 — PDF View - Share to print and cancel

**Refs:** PMPO-3033

**Preconditions:**
- **Environment:** Claude Automation app (App-ID 1020), CSS tab, TEST environment
- **Widget-key:** `one_widget_css_invoice` (instance 3731 / widget 18809)
- **Concept:** [CSS] [INV] Invoice V2.1 — https://endios.atlassian.net/wiki/spaces/S3/pages/1335918649
- **Figma (SYSTEM VIEWER):** https://www.figma.com/design/puJPzr1lsiLaguHMEGyZc0/INV-Invoices?node-id=2519-2122
- The selected contract group has at least one invoice with a valid `invoiceFile` (mimeType = application/pdf). The PDF viewer (SYSTEM VIEWER) is reachable.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the Invoice widget tile
4. Select a contract group (skip if only one is configured)
5. Tap an invoice row in the Invoice Selection screen
6. Wait for the PDF viewer to open
7. Tap the share button on the top-right of the navigation bar
8. In the bottom sheet that slides up, tap the Print option
9. On the print preview screen, tap Cancel
10. Tap the close button (X) on the top-left of the navigation bar

**Expected:**
- Step 7: tapping the share button reveals a bottom sheet (modal box that slides up from the bottom of the screen) containing share options including a Print button
- Step 8: tapping the Print option in the bottom sheet opens the print preview screen with a preview of the invoice PDF
- Step 9: tapping Cancel closes the print preview; the user returns to the PDF viewer with the same document still rendered
- Step 10: the PDF viewer closes; the user is returned to the Invoice Selection screen with the invoice list still rendered
- No crash at any step

---

## Negative Scenarios (12951)

### 110368 — Negative - Empty state when no invoices

**Refs:** PMPO-3033

**Preconditions:**
- **Environment:** Claude Automation app (App-ID 1020), CSS tab, TEST environment
- **Widget-key:** `one_widget_css_invoice` (instance 3731 / widget 18809)
- **Dashboard config:** https://dashboard-test.endios.one/konfigurieren/widgets/edit-widget/1020/3731/18809
- **Concept:** [CSS] [INV] Invoice V2.1 — https://endios.atlassian.net/wiki/spaces/S3/pages/1335918649 (§Empty State View)
- **Figma (Empty State):** https://www.figma.com/design/puJPzr1lsiLaguHMEGyZc0/INV-Invoices?node-id=2519-2178
- A contract group is configured that has no invoices (empty `invoices[]`) OR all received invoices are file-less. Empty-state content (headline, body, optional button) is configured in the dashboard.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the Invoice widget tile
4. Select the contract group with no invoices (skip if only one group is configured)
5. Observe the resulting screen
6. Tap the zurück (back) button on the bottom of the screen

**Expected:**
- Empty State view is displayed (Figma 2519:2178)
- Headline 2, body text, and Document image are rendered using the values configured in the dashboard
- Optional action button is rendered when configured
- NO invoice rows are shown
- Step 6: tapping the zurück button on the bottom of the screen navigates the user back to the CSS tab main screen of the Claude Automation app
- No crash

---

### 110369 — Negative - PDF download error displays dialog

**Refs:** PMPO-3033

**Preconditions:**
- **Environment:** Claude Automation app (App-ID 1020), CSS tab, TEST environment
- **Widget-key:** `one_widget_css_invoice` (instance 3731 / widget 18809)
- **Concept:** [CSS] [INV] Invoice V2.1 — https://endios.atlassian.net/wiki/spaces/S3/pages/1335918649
- **Figma (Scrim + Native Dialog):** https://www.figma.com/design/puJPzr1lsiLaguHMEGyZc0/INV-Invoices?node-id=2519-2117
- Test data is configured so that tapping a specific invoice triggers a PDF download failure (e.g. unreachable `downloadLink`, corrupted `content`, or 404 on the file). Selected contract group has at least one such failing invoice.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the Invoice widget tile
4. Select the contract group containing the failing invoice (skip if only one group)
5. Tap the failing invoice row
6. Wait for the download attempt to fail
7. Tap the dismiss option in the dialog

**Expected:**
- After step 6: an error dialog (Figma 2519:2117 — Native iOS dialog with a single dismiss option) is displayed over a scrim
- Dialog informs the user that the PDF could not be opened
- After step 7: the dialog closes and the user remains on the Invoice Selection screen
- The PDF viewer is NOT opened
- No crash
