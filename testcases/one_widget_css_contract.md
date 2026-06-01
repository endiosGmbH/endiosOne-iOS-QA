# CSS Contract [CT]

> **TestRail:** project `endiosOne` (5) · suite `Master` (468) · section `13651` — [CSS Contract [CT]](https://endios.testrail.io/index.php?/suites/view/468&group_id=13651)
> **Widget-key:** `one_widget_css_contract` · **Spec:** [S3/3318448129 — Contract V2.0](https://endios.atlassian.net/wiki/spaces/S3/pages/3318448129) · [Figma (CT-Contracts)](https://www.figma.com/design/feFT7GITFt6fWSNMKMI2Vu/CT-Contracts) (FLOW 2200-2693, iOS 2201-6361, Android 2253-4905, Nav-title 2901-4181)
>
> **App:** Claude Automation · CSS tab · TEST environment (no login required — mock data) · **Initiative refs:** OP-3394 (last), PMPO-4071 (next) · **Regression tier:** Full Regression
>
> Snapshot of TestRail testcases for the CSS Contract widget. 33 cases across 3 subsections. Customer Self-Service widget that lets users view conditions associated to their contracts (yearly price, price per unit, time/consumption slices, taxes/fees, end-of-term, cancellation, etc.). The COMBINED interface displays structured data + optional PDF list + optional webview button.
>
> **Configurable widget values referenced in tests:** `selectionNav`, `selectionHeadline`, `selectionDescription`, `overviewNav`, `showButton`, `buttonText`, `buttonUrl`, `changePaymentHeadline`, `changePaymentTextIndividual`, `showContextSwitch`, `labelContextSwitch`, `pdfNav`, `pdfHeadline`, `noContractNav`, `noContractHeadline`, `noContractDescription`, `noContractImage`.
>
> **Screen flow:** Contract Selection → Contract Overview (COMBINED interface) → Action button web view / Change-Payment modal → Budget Billing widget / Contract PDF → Share / Print → back navigation.

## Widget Tile & Configuration (13652)

### 116513 — Verify User-Configured Tile Image Displayed

**Preconditions:**
- Claude Automation app is installed and launched. CSS tab is visible in the bottom navigation. The Contracts widget tile has a user-configured image set in the dashboard.

**Steps:**
1. Launch Claude Automation app
2. Tap on the 'CSS' tab in the bottom navigation
3. Locate the Contracts widget tile

**Expected:**
- The Contracts widget tile displays the user-configured image as set in the dashboard.

---

### 116514 — Verify User-Configured Tile Title Displayed

**Preconditions:**
- Claude Automation app is on the CSS tab. The Contracts widget tile has a user-configured title set in the dashboard.

**Steps:**
1. Locate the Contracts widget tile on the CSS tab
2. Verify the tile title text

**Expected:**
- The Contracts widget tile displays the user-configured title as set in the dashboard.

---

### 116515 — Verify User-Configured Navigation Bar Title Displayed

**Preconditions:**
- The Contracts widget has a user-configured navigation bar title (selectionNav) set in the dashboard. Figma reference: node 2901-4181.

**Steps:**
1. Launch Claude Automation app
2. Tap the 'CSS' tab
3. Tap on the Contracts widget tile

**Expected:**
- The navigation bar at the top of the Contracts screen displays the configured selectionNav value (e.g., 'Verträge'), centered, in the brand interaction colour, matching Figma node 2901-4181.

---

## Main Flow (13653)

### 116516 — Open Contracts Widget from CSS Tab

**Preconditions:**
- App is installed and launched on Claude Automation. CSS tab is visible in the bottom navigation. The Contracts widget tile is configured.

**Steps:**
1. Launch Claude Automation app
2. Tap on the 'CSS' tab
3. Tap on the Contracts widget tile

**Expected:**
- The Contract Selection screen (Vertragsübersicht) opens with a 'Back' arrow in the top-left and the help (?) and options (⋯) icons in the top-right.

---

### 116517 — Verify Contract Selection Screen User-Configured Values Displayed

**Preconditions:**
- Contract Selection screen is displayed. Dashboard has selectionNav, selectionHeadline, and selectionDescription configured. Note these values down before starting.

**Steps:**
1. Verify the nav bar title text
2. Verify the centered headline below the nav bar
3. Verify the descriptive sub-text below the headline

**Expected:**
- Nav bar title matches selectionNav. Centered headline (e.g., 'Vertragsübersicht') matches selectionHeadline. Sub-text (e.g., 'Bitte wählen Sie einen Ihrer Verträge aus der Liste aus, um die detaillierten Konditionen anzuzeigen.') matches selectionDescription. Positioning matches Figma: headline above description, both centered above the Kundennummer row.

---

### 116518 — Verify Kundennummer (Context Switch) Row Displayed on Selection Screen

**Preconditions:**
- Contract Selection screen is displayed. Widget configuration has showContextSwitch=true and the integrator setting contextSwitchAvailable=true.

**Steps:**
1. Locate the pill-shaped row below the description text

**Expected:**
- A pill-shaped 'Kundennummer:' row (using the configured labelContextSwitch) is displayed with a dropdown chevron on the right. Note: tapping the Kundennummer row is NOT in scope (mock data, no actual context to switch to).

---

### 116519 — Verify Address Label Displayed Above Contract List

**Preconditions:**
- Contract Selection screen is displayed and finished loading.

**Steps:**
1. Locate the area between the Kundennummer row and the contract list

**Expected:**
- An address label (e.g., 'Steckelhoern 11, 20457 Hamburg') is displayed left-aligned above the contract list, matching Figma positioning.

---

### 116520 — Verify Contract List Rendering — Icons by Contract Type, Texts, Chevron, Colours

**Preconditions:**
- Contract Selection screen is displayed with multiple contract rows covering different contract types (e.g., Niederschlagswasser, Schmutzwasser, Gartenwasser, Wasser, Fernwärme).

**Steps:**
1. Inspect each row of the contract list
2. Verify the icon shown for each contract type against documentation
3. Verify colours of the icon, contract name, sub-type, and chevron against Figma

**Expected:**
- Each row's icon corresponds to its contract type per documentation (e.g., water-droplet variants for water services, flame icon for Fernwärme). Each row shows the contract name (bold), the contract sub-type below, and a chevron '>' on the right. Colours of icon, texts, and chevron match the user-configured interaction colour, verified end-to-end: dashboard value → Figma spec → code → device. Rows are separated by thin dividers. The list is scrollable when content exceeds the viewport.

---

### 116521 — Tap a Contract to Open Contract Overview Screen

**Preconditions:**
- Contract Selection screen is displayed.

**Steps:**
1. Tap any contract row (e.g., 'Test Regenwasser')

**Expected:**
- The Contract Overview screen (Vertragsdetails) opens. A back arrow labelled 'Back' is shown in the top-left of the screen.

---

### 116522 — Verify Contract Overview Screen User-Configured Values Displayed

**Preconditions:**
- Contract Overview screen is displayed. Dashboard has overviewNav configured.

**Steps:**
1. Verify the nav bar title
2. Verify the contract-name heading below the nav bar
3. Confirm presence of 'Price information', 'Contract information', and 'Documents' section headers with their content blocks

**Expected:**
- Nav bar title matches overviewNav (e.g., 'Vertragsdetails'). Contract name (e.g., 'Test Regenwasser') is the centered heading. Kundennummer row is shown below the heading. The three sections appear in order — Price information → Contract information → Documents — each rendered with the correct icons and labels per Figma.

---

### 116523 — Verify Price Information Section Content

**Preconditions:**
- Contract Overview screen is displayed. The contract has at least one price entry (e.g., Deduction = 48,00€).

**Steps:**
1. Locate the 'Price information' section

**Expected:**
- Each price row displays an icon on the left, the price value (e.g., '48,00€'), the price label (e.g., 'Deduction'), and an edit icon on the right. Layout matches Figma.

---

### 116524 — Verify Contract Information Section Content

**Preconditions:**
- Contract Overview screen is displayed. The contract has Rechnungsadresse, Startdatum, Laufzeit bis, Kündigungsfrist, Laufzeitverlängerung, and Preisgarantie bis values.

**Steps:**
1. Locate the 'Contract information' section

**Expected:**
- Each row shows a circular icon on the left (home, calendar, timer, stopwatch), a German label and corresponding value (e.g., 'Rechnungsadresse — Steckelhörn 11, 20457 Hamburg', 'Startdatum — 30.01.2022', 'Laufzeit bis — 31.12.2022', 'Kündigungsfrist — 3 Monate zu Vertragsende', 'Laufzeitverlängerung — 12 Monate', 'Preisgarantie bis — 31.12.2022'). Rows are separated by thin dividers. Layout matches Figma.

---

### 116525 — Verify Documents Section Content

**Preconditions:**
- Contract Overview screen is displayed. The contract has at least one PDF document attached.

**Steps:**
1. Locate the 'Documents' section

**Expected:**
- The Documents section displays a row with a PDF icon, a document label (e.g., 'Contract'), a sub-label (e.g., 'PDF document'), and a chevron '>' on the right. Layout matches Figma.

---

### 116526 — Verify Action Button Displayed When showButton Enabled

**Preconditions:**
- Contract Overview screen is displayed. Widget configuration has showButton=true and buttonText is set (e.g., 'WEITERE PRODUKTE').

**Steps:**
1. Scroll to the bottom of the Contract Overview screen

**Expected:**
- A full-width black action button is rendered at the bottom of the screen. The button label exactly matches the configured buttonText.

---

### 116527 — Tap Action Button to Open Web View at buttonUrl

**Preconditions:**
- Contract Overview screen with the action button is displayed. buttonUrl is configured with a valid URL.

**Steps:**
1. Tap the action button (e.g., 'WEITERE PRODUKTE')

**Expected:**
- A web view opens loading the URL configured as buttonUrl. A 'Done' button is visible in the top-left corner of the web view.

---

### 116528 — Tap Done on Web View to Return to Contract Overview

**Preconditions:**
- The web view opened from the action button is displayed.

**Steps:**
1. Tap the 'Done' button in the top-left corner of the web view

**Expected:**
- The web view closes. The user is returned to the Contract Overview screen with the same content rendered.

---

### 116529 — Open Change-Payment Modal via Price Row Edit Icon

**Preconditions:**
- Contract Overview screen is displayed. The contract has at least one price entry with an edit icon. Dashboard has changePaymentHeadline and changePaymentTextIndividual configured.

**Steps:**
1. Tap the edit icon next to a price entry (or tap anywhere on the price row)

**Expected:**
- A modal popup appears. The modal heading matches the configured changePaymentHeadline. The descriptive text matches the configured changePaymentTextIndividual. The modal has both 'OK' and 'Cancel' buttons.

---

### 116530 — Tap OK on Change-Payment Modal to Open Budget Billing Widget

**Preconditions:**
- Change-Payment modal is displayed on top of the Contract Overview screen.

**Steps:**
1. Tap the 'OK' button on the modal

**Expected:**
- The modal closes. The Budget Billing widget opens, rendered correctly. The first screen of the Budget Billing widget (the list view) is displayed.

---

### 116531 — Tap Back on Budget Billing Widget to Return to Contract Overview

**Preconditions:**
- Budget Billing widget's first screen is displayed (reached via the Change-Payment modal OK).

**Steps:**
1. Tap the back/close button in the top-right corner of the Budget Billing widget

**Expected:**
- The Budget Billing widget closes. The user is returned to the Contract Overview screen with the same content rendered.

---

### 116532 — Tap Cancel on Change-Payment Modal Closes Dialog

**Preconditions:**
- Contract Overview screen is displayed.

**Steps:**
1. Tap the edit icon next to a price entry to re-open the Change-Payment modal
2. On the modal, tap the 'Cancel' button

**Expected:**
- The modal closes. The user remains on the Contract Overview screen with no navigation change.

---

### 116533 — Open Contract PDF from Documents Section

**Preconditions:**
- Contract Overview screen is displayed. The contract has a PDF document in the Documents section.

**Steps:**
1. Tap the document row in the Documents section

**Expected:**
- The PDF viewer opens with the PDF content rendered. A close button is visible in the top-left corner and a share button is visible in the top-right corner.

---

### 116534 — Tap Share Button in PDF View to Open Bottom Sheet

**Preconditions:**
- PDF viewer (opened from the Documents section) is displayed.

**Steps:**
1. Tap the share button in the top-right corner of the PDF viewer

**Expected:**
- A bottom sheet pops up from the bottom of the screen containing share options including a 'Print' option.

---

### 116535 — Tap Print in Bottom Sheet to Open Print View

**Preconditions:**
- Share bottom sheet is displayed.

**Steps:**
1. Tap the 'Print' option in the bottom sheet

**Expected:**
- The print preview view opens, showing a preview of the PDF with print options.

---

### 116536 — Tap Cancel in Print View to Return to PDF View

**Preconditions:**
- Print preview view is displayed.

**Steps:**
1. Tap the 'Cancel' button in the top-left corner of the print view

**Expected:**
- The print view closes. The user returns to the PDF viewer with the same PDF document still rendered.

---

### 116537 — Close PDF Viewer and Return to Contract Overview

**Preconditions:**
- PDF viewer is displayed.

**Steps:**
1. Tap the close button in the top-left corner of the PDF viewer

**Expected:**
- The PDF viewer closes. The user is returned to the Contract Overview screen with the same content rendered.

---

### 116538 — Return from Contract Overview to Contract Selection

**Preconditions:**
- Contract Overview screen is displayed.

**Steps:**
1. Tap the back arrow in the top-left corner

**Expected:**
- The Contract Overview screen closes. The user returns to the Contract Selection screen with the contract list still rendered.

---

### 116539 — Return from Contract Selection to CSS Tab

**Preconditions:**
- Contract Selection screen is displayed.

**Steps:**
1. Tap the 'Back' arrow in the top-left of the screen header

**Expected:**
- The Contracts widget closes. The user returns to the CSS tab of Claude Automation with the Contracts widget tile visible.

---

## Alternative Flows & Negative Scenarios (13654)

### 116540 — Verify PDF Document Screen Displayed When Contract Has Only PDFs

**Preconditions:**
- Contract data only contains PDF document(s) and no structured data meeting minimum requirements. Dashboard has pdfNav and pdfHeadline configured.

**Steps:**
1. Open the Contracts widget from the CSS tab

**Expected:**
- The PDF Document screen is displayed (the Contract Selection and Contract Overview screens are skipped). The nav bar title matches the configured pdfNav. The screen heading matches the configured pdfHeadline. A list of PDF documents is displayed below the heading.

---

### 116541 — Tap PDF in PDF Document Screen to Open PDF Viewer

**Preconditions:**
- PDF Document screen is displayed with at least one PDF row.

**Steps:**
1. Tap a PDF row from the list

**Expected:**
- The PDF viewer opens with the selected PDF rendered. A close button is visible in the top-left corner.

---

### 116542 — Close PDF Viewer and Return to PDF Document Screen

**Preconditions:**
- PDF viewer opened from the PDF Document screen is displayed.

**Steps:**
1. Tap the close button in the top-left corner of the PDF viewer

**Expected:**
- The PDF viewer closes. The user returns to the PDF Document screen with the document list still rendered.

---

### 116543 — Verify No-Contract Screen Displayed When No Contracts Available

**Preconditions:**
- The user has no contracts associated (or the widget data returns an empty contract list). Dashboard has noContractNav, noContractHeadline, noContractDescription, and noContractImage configured.

**Steps:**
1. Open the Contracts widget from the CSS tab

**Expected:**
- The No-Contract screen is displayed. The nav bar title matches the configured noContractNav. The screen heading matches the configured noContractHeadline. The descriptive text matches the configured noContractDescription. The image displayed matches the URL configured in noContractImage. Layout matches Figma.

---

### 116544 — Verify Kundennummer Row Hidden When showContextSwitch Disabled

**Preconditions:**
- Widget configuration has showContextSwitch=false (or integrator contextSwitchAvailable=false).

**Steps:**
1. Open the Contracts widget
2. Tap any contract to reach the Contract Overview screen

**Expected:**
- No Kundennummer row is displayed on either the Contract Selection screen or the Contract Overview screen. Space is collapsed; no empty placeholder is shown. No crash.

---

### 116545 — Verify Action Button Hidden When showButton Disabled

**Preconditions:**
- Widget configuration has showButton=false.

**Steps:**
1. Open the Contracts widget
2. Tap any contract to open the Contract Overview screen
3. Scroll to the bottom of the screen

**Expected:**
- No action button is rendered at the bottom of the Contract Overview screen. buttonText and buttonUrl are not exposed in the UI. No crash.
