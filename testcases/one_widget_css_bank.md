# CSS Bankdaten [BNK]

> **TestRail:** project `endiosOne` (5) · suite `Master` (468) · section `13655` — [CSS Bankdaten [BNK]](https://endios.testrail.io/index.php?/suites/view/468&group_id=13655)
> **Widget-key:** `one_widget_css_bank` · **Concept:** [S3/3306192897 — Banking Widget v2.0](https://endios.atlassian.net/wiki/spaces/S3/pages/3306192897) · **Backend v2.1.1:** [S3/3794960385 — bank endpoint](https://endios.atlassian.net/wiki/spaces/S3/pages/3794960385) · **Analytics (all screen states):** [S3/4803985416](https://endios.atlassian.net/wiki/spaces/S3/pages/4803985416) · **Data modelling:** [S3/3306455045](https://endios.atlassian.net/wiki/spaces/S3/pages/3306455045)
>
> **App:** Claude Automation (App-ID 1020) · CSS tab · TEST environment (no login required — mock data via configured backend)
>
> Snapshot of TestRail testcases for the CSS Bankdaten widget. 20 cases across 3 sections. Customer Self-Service widget that lets users view and manage their banking details (SEPA Debit / Credit accounts) tied to their contract groups. Banking widget is data-driven via mock data (mirrors CSS Invoice / News / Image pattern). Testcases verify UI display + navigation; actual PATCH persistence to ERP is out of scope without a real backend.
>
> **Backend endpoint:** `GET/PATCH /v2/connect?to=erpConnector&process=bank&version=2`
>
> **Screen flow:** Contract Group Selection (`Auswahl: Vertragsgruppen`, BA-01) → Contract Group Details (`Übersicht: Vertragsgruppen`) → Add/Edit Banking Details (`Bankdaten anlegen`) → SEPA-Mandat → Success (`Erfolgreich angepasst`) / Error.

## Widget Tile & Dashboard Configuration (13656)

### 116546 — CSS Bankdaten - Tile - Title, image, icon flow from dashboard config

**Preconditions:**
- The CSS Bankdaten widget instance is configured on the CSS tab of the Claude Automation app. The dashboard configuration has values set for `tileTitle`, `image`, and `icon`. Note these configured values down before starting.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Observe the CSS Bankdaten widget tile

**Expected:**
- The tile renders on the CSS tab without crash
- The tile title displays the value configured in the dashboard as `tileTitle`
- The tile image displays the value configured in the dashboard as `image`
- The tile icon displays the value configured in the dashboard as `icon`
- Tile layout matches the rest of the CSS tab tiles (visually consistent with CSS Invoice / CSS Message tiles)
- No crash

---

### 116547 — CSS Bankdaten - Tile - Tap tile opens widget

**Preconditions:**
- The CSS Bankdaten widget tile is rendered on the CSS tab.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Wait for the widget to finish loading

**Expected:**
- Tapping the tile is registered (visual feedback / ripple)
- The widget opens and navigates the user away from the CSS tab into the CSS Bankdaten widget
- The first widget screen renders (either Contract Group Selection or — if single group — Contract Group Details, depending on mock data)
- No crash

---

## Main Flow (13657)

### 116548 — CSS Bankdaten - Contract Selection - Multiple groups list renders

**Preconditions:**
- The bank endpoint mock data returns **more than one** item in `groups[]`. Each group has `label` populated and at least one entry in `contracts[]`. `addressLabel` may be populated.
- Analytics screen: `Auswahl: Vertragsgruppen`. Concept §See Contracts.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Wait for the widget to finish loading
5. Observe the Contract Group Selection screen (`Auswahl: Vertragsgruppen`)

**Expected:**
- The Contract Group Selection screen renders
- One row is shown per item in the response `groups[]`
- Each row displays the group `label`
- If `addressLabel` is populated for a group, it is displayed on the row alongside the label
- The number of rows matches the number of groups in the mock response
- No crash

---

### 116549 — CSS Bankdaten - Contract Selection - Scroll the group list

**Preconditions:**
- The bank endpoint mock data returns enough items in `groups[]` to exceed the viewport (typically 6+ groups).

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. On the Contract Group Selection screen, swipe up to scroll the list
5. Swipe down to scroll back to the top

**Expected:**
- The list is scrollable when content exceeds the viewport
- All group rows can be reached by scrolling (no clipping or stuck rows)
- Scroll position returns to the top after step 5
- No crash

---

### 116550 — CSS Bankdaten - Contract Selection - Single group skips selector

**Preconditions:**
- The bank endpoint mock data returns **exactly one** item in `groups[]`, with `paymentBankData.available: true` and populated `contracts[]`.
- Concept §See Contracts.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Wait for the widget to finish loading

**Expected:**
- The Contract Group Selection screen (`Auswahl: Vertragsgruppen`) is **SKIPPED**
- The user lands directly on the Contract Group Details screen (`Übersicht: Vertragsgruppen`) of the only available group
- The screen shows the contracts and the banking details of that single group
- No crash

---

### 116551 — CSS Bankdaten - Contract Selection - Tap group opens details

**Preconditions:**
- The mock returns more than one group, and the user is on the Contract Group Selection screen.
- Analytics screen: `Übersicht: Vertragsgruppen`.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. On the Contract Group Selection screen, tap one of the contract group rows

**Expected:**
- Tapping a row is registered (visual feedback / ripple)
- The user navigates to the Contract Group Details screen (`Übersicht: Vertragsgruppen`) for the selected group
- The details screen renders with the selected group's contracts and banking details
- A back navigation control is visible to return to the selector
- No crash

---

### 116552 — CSS Bankdaten - Details - Contracts list with tariff and type renders

**Preconditions:**
- The selected contract group has multiple items in `contracts[]` covering at least two distinct `type` values (e.g. one ELECTRICITY, one GAS, one WATER). Each contract has `tariff.name` populated and a `label`.
- Concept §See Contract & Banking Details.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Select a contract group (skip this step if only one group is configured)
5. On the Contract Group Details screen, locate the Contracts section

**Expected:**
- The Contracts section renders on the Contract Group Details screen
- One row is shown per contract in the response `contracts[]`
- Each row displays the `tariff.name` (e.g. "Prinzengas", "Königsstrom")
- Each row displays the contract type label (Strom for ELECTRICITY, Gas for GAS, Wasser for WATER, Fernwärme for DISTRICT_HEATING)
- The number of rows matches the number of contracts in the response
- No crash

---

### 116553 — CSS Bankdaten - Details - Debit Banking details render (Zahlungskonto)

**Preconditions:**
- The selected contract group has `paymentBankData.available: true` with `iban`, `bankName`, `bic`, and `accountHolder.accountHolderFields[]` populated.
- Concept §See Contract & Banking Details.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Select a contract group (skip if only one is configured)
5. On the Contract Group Details screen, locate the Debit Banking section (Zahlungskonto)

**Expected:**
- The Debit Banking section (Zahlungskonto) renders on the Contract Group Details screen
- The IBAN from `paymentBankData.iban` is displayed
- The bank name from `paymentBankData.bankName` is displayed
- The BIC from `paymentBankData.bic` is displayed
- If `accountHolder.visible: true`, the account holder name is displayed
- No crash

---

### 116554 — CSS Bankdaten - Details - Credit Banking details render (Gutschriftkonto)

**Preconditions:**
- The selected contract group has `paybackBankData.available: true` with `iban`, `bankName`, `bic` populated. (Some Service Providers do not offer Credit accounts — pick a mock that has it.)
- Concept §See Contract & Banking Details.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Select a contract group (skip if only one is configured)
5. On the Contract Group Details screen, locate the Credit Banking section (Gutschriftkonto)

**Expected:**
- The Credit Banking section (Gutschriftkonto) renders on the Contract Group Details screen
- The IBAN from `paybackBankData.iban` is displayed
- The bank name from `paybackBankData.bankName` is displayed
- The BIC from `paybackBankData.bic` is displayed
- The Credit section is visually distinct from the Debit section
- No crash

---

### 116555 — CSS Bankdaten - Details - Tap Edit on Debit opens edit form

**Preconditions:**
- The selected contract group has `paymentBankData.available: true` and `paymentBankData.readOnly: false`. The user is on the Contract Group Details screen.
- Concept §Add / Edit Banking Details. Analytics screen: `Bankdaten anlegen`.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Select a contract group (skip if only one is configured)
5. On the Contract Group Details screen, tap the Edit action on the Debit Banking section

**Expected:**
- Tapping Edit is registered (visual feedback / ripple)
- The user navigates to the Add/Edit Banking Details screen (`Bankdaten anlegen`)
- The IBAN input field is pre-filled with the current `paymentBankData.iban`
- The account holder field (if `accountHolder.visible: true`) is pre-filled with the current value
- A confirm action (e.g. "Weiter" / "Bestätigen") is visible
- A back navigation control is visible to return to the details screen
- No crash

---

### 116556 — CSS Bankdaten - Edit Form - IBAN input accepts valid IBAN

**Preconditions:**
- The user is on the Add/Edit Banking Details screen for Debit. A valid German test IBAN is available (e.g. `DE89370400440532013000`).
- Backend endpoint v2.1.1: PATCH /v2/connect?to=erpConnector&process=bank&version=2.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Select a contract group (skip if only one is configured)
5. Tap Edit on the Debit Banking section
6. Tap the IBAN input field
7. Clear the existing value
8. Type a valid German IBAN (e.g. DE89370400440532013000)

**Expected:**
- The IBAN field is editable when tapped (cursor + keyboard appear)
- The existing value is cleared on step 7
- The typed IBAN is accepted character-by-character
- No validation error is shown for a syntactically valid IBAN
- The confirm action becomes enabled (if it was disabled with empty IBAN)
- No crash

---

### 116557 — CSS Bankdaten - Edit Form - Account holder fields editable when visible

**Preconditions:**
- The selected contract group has `paymentBankData.accountHolder.visible: true` and `accountHolder.readOnly: false`. At least one item in `accountHolderFields[]` has `readOnly: false` (typically a TEXT_BOX such as Kontoinhaber). The user is on the Add/Edit Banking Details screen.
- Concept §Add / Edit Banking Details.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Select a contract group (skip if only one is configured)
5. Tap Edit on the Debit Banking section
6. Locate the account holder field (e.g. "Kontoinhaber")
7. Tap the field
8. Change the displayed value to a new test value (e.g. "Max Mustermann")

**Expected:**
- The account holder field is visible on the form (because `accountHolder.visible: true`)
- The field is editable on tap (cursor + keyboard appear) because `readOnly: false`
- The new value replaces the previous value
- The field label matches the `label` from `accountHolderFields[]` (e.g. "Kontoinhaber")
- No crash

---

### 116558 — CSS Bankdaten - Edit Form - Update both switch shown when Credit editable

**Preconditions:**
- The selected contract group has BOTH `paymentBankData` (Debit) AND `paybackBankData` (Credit) `available: true` and `readOnly: false`. The user is editing the Debit account.
- Concept §Add / Edit Banking Details.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Select a contract group (skip if only one is configured)
5. Tap Edit on the Debit Banking section
6. Scroll to the bottom of the Add/Edit Banking Details screen
7. Toggle the "Update both" switch on
8. Toggle the "Update both" switch off

**Expected:**
- The "Update both accounts with the same information" switch is rendered at the bottom of the screen
- The switch is OFF by default
- The switch responds to taps and visually toggles ON
- The switch responds to a second tap and visually toggles OFF
- No crash

---

### 116560 — CSS Bankdaten - SEPA Mandate - Screen renders on Debit submit

**Preconditions:**
- The user is on the Add/Edit Banking Details screen for the **Debit** account. A valid IBAN has been entered and the form is otherwise valid.
- Concept §Add / Edit Banking Details. Analytics screen: `SEPA-Mandat Info`.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Select a contract group (skip if only one is configured)
5. Tap Edit on the Debit Banking section
6. Enter a valid IBAN
7. Tap the confirm action ("Weiter" / "Bestätigen")

**Expected:**
- The SEPA-Mandate screen (`SEPA-Mandat Info`) is shown after the user confirms the form
- The screen displays the SEPA mandate information text
- An action to view the full SEPA mandate (e.g. link to webview) is visible
- An "Accept" / "Confirm" action is visible
- A back navigation control is visible
- No crash

---

### 116562 — CSS Bankdaten - SEPA Mandate - Accept opens Success screen

**Preconditions:**
- The PATCH endpoint mock returns a success response. The user is on the SEPA-Mandate screen.
- Concept §Add / Edit Banking Details. Analytics screen: `Erfolgreich angepasst`.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Select a contract group (skip if only one is configured)
5. Tap Edit on the Debit Banking section
6. Enter a valid IBAN and tap confirm
7. On the SEPA-Mandate screen, tap Accept

**Expected:**
- Tapping Accept is registered
- The PATCH call is fired to the bank endpoint
- After the call returns success, the Success screen (`Erfolgreich angepasst`) is shown
- A success message / icon is displayed on the screen
- A "Back" / "Continue" action is visible to return to the previous screen
- No crash

---

### 116563 — CSS Bankdaten - Success - Back navigation returns to details

**Preconditions:**
- The user has just submitted a Debit account edit and is on the Success screen.
- Concept §Add / Edit Banking Details.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Select a contract group (skip if only one is configured)
5. Tap Edit on the Debit Banking section
6. Enter a valid IBAN, tap confirm, then accept SEPA mandate
7. On the Success screen, tap the back / continue action

**Expected:**
- The widget returns to the widget selector — **Meine Verträge** screen.

---

### 116564 — CSS Bankdaten - Context Switch - UI displayed when configured

**Preconditions:**
- **IMPORTANT — limited test scope:** Context switching is NOT functionally testable in this app because mockcase data is used. This testcase verifies only that the context switch UI is **displayed** correctly when configured — actual context-switching is out of scope.
- The widget instance is configured with: `showContextSwitch` = true; `labelContextSwitch` = a recognizable test value (e.g. "Kundennummer"); Integrator-side `contextSwitchAvailable` = true.
- The test user has at least two contexts available. Backend returns more than one item in `groups[]` so both Contract Selection and Contract Group Details screens are reachable.
- Concept §Changing the active context.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Wait for the widget to finish loading
5. On the Contract Group Selection screen, inspect the top section of the screen for the customer-number row + switch icon
6. Tap a contract group row to navigate to the Contract Group Details screen
7. On the Contract Group Details screen, inspect the top section of the screen for the customer-number row + switch icon

**Expected:**
- Step 5 (Contract Group Selection): the active customer number is displayed together with the `labelContextSwitch` value, and a context-switch icon is rendered next to it
- Step 7 (Contract Group Details): the active customer number is displayed together with the `labelContextSwitch` value, and a context-switch icon is rendered next to it
- Visual layout / placement matches concept where applicable
- No crash
- **Note:** Tapping the context-switch icon is NOT in scope (context switching is not fully functional with mockcase data). Only the display is verified.

---

## Negative Scenarios (13658)

### 116566 — CSS Bankdaten - Empty - No Bankdata Available view with CTA

**Preconditions:**
- The bank endpoint mock returns a contract group with `paymentBankData.available: false` (no Debit account). Per concept, the user is jumped past the Contract Group Details to the No Bankdata Available view.
- Concept §See Contracts — skip-to-step-3 rule. Analytics screens: `Noch keine Daten` + `Neues Konto anlegen`.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Select the contract group with no Debit data (skip if only one is configured)
5. Observe the resulting screen
6. Tap the "Neues Konto anlegen" CTA

**Expected:**
- The No Bankdata Available view (`Noch keine Daten`) is shown
- The view explains that no banking data is yet available for this group
- A "Neues Konto anlegen" CTA is visible
- Step 6: tapping the CTA opens the Add/Edit Banking Details screen (`Bankdaten anlegen`) with an empty IBAN field
- A back navigation control is visible
- No crash

---

### 116567 — CSS Bankdaten - Read-only - Keine Anpassungen erlaubt view renders

**Preconditions:**
- The bank endpoint mock returns a contract group with `paymentBankData.available: true` and `paymentBankData.readOnly: true` (the ERP does not allow write operations for this account).
- Concept §See Contract & Banking Details. Analytics screen: `Keine Anpassungen erlaubt`.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Select the contract group whose banking is read-only (skip if only one is configured)
5. On the Contract Group Details screen, observe whether an Edit action is present
6. If a read-only entry-point exists, tap it to confirm the No Adjustments view

**Expected:**
- The Debit Banking section renders with the IBAN / bank / BIC values
- No Edit action is rendered on the Debit Banking section (because `readOnly: true`)
- If the No Adjustments screen (`Keine Anpassungen erlaubt`) is reachable from this state, it renders with an explanatory message
- The user can navigate back to the Contract Group Details screen
- No crash

---

### 116568 — CSS Bankdaten - Edit Form - Invalid IBAN shows validation error

**Preconditions:**
- The user is on the Add/Edit Banking Details screen for the Debit account.
- Concept §Add / Edit Banking Details — "we will validate" the IBAN.

**Steps:**
1. Open the Claude Automation app
2. Go to CSS tab
3. Tap the CSS Bankdaten widget tile
4. Select a contract group (skip if only one is configured)
5. Tap Edit on the Debit Banking section
6. Clear the IBAN field
7. Type an invalid IBAN (e.g. "DE00000000000000000000" or "NOTAVALIDIBAN")
8. Tap the confirm action

**Expected:**
- The IBAN field accepts the typed input character-by-character (no input blocking)
- A validation error is surfaced after the user attempts to confirm (or on blur, depending on implementation): error styling on the IBAN field and / or an inline error message
- The user is NOT navigated forward to the SEPA-Mandate screen
- The PATCH call is NOT fired
- The user can correct the IBAN and re-attempt
- No crash
