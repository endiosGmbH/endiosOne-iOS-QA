# CSS Message [MSG]

> **TestRail:** project `endiosOne` (5) · suite `Master` (468) · section `12953` — [CSS Message [MSG]](https://endios.testrail.io/index.php?/suites/view/468&group_id=12953)
> **Widget-key:** `one_widget_css_messages` · **Spec:** [S3/1332740240 — Message V2.0](https://endios.atlassian.net/wiki/spaces/S3/pages/1332740240) · [Data model](https://endios.atlassian.net/wiki/spaces/S3/pages/3285909505) · [Figma (iOS)](https://www.figma.com/design/GuGQl0YlugL15ErovxOx9P/ME-Messages?node-id=1336-2732)
>
> **App:** Claude Automation · CSS tab · TEST environment (no login required — mock data) · **Initiative refs:** PMPO-3033
>
> Snapshot of TestRail testcases for the CSS Message widget. 26 cases across 4 subsections. Customer Self-Service widget that displays provider messages (SINGLE_FILE or COMBINED type) in a unified inbox grouped by recency.
>
> **Message types:**
> - SINGLE_FILE: 1 file without headline/body — opens the file natively
> - COMBINED: headline with optional image, body text, and 1-n files — opens Combined Message View
>
> **List sections** (titles configurable via widget keys):
> - `newMessagesTitle`: most recent message (singular)
> - `otherMessagesTitle`: messages from current calendar year, descending by date
> - `oldMessagesTitle`: messages from former calendar years, descending by date

## Widget Tile & Configuration (12954)

### 110543 — Verify User-Configured Tile Image Displayed

**Preconditions:**
- Claude Automation app is installed and launched. CSS tab is visible in the bottom navigation. The Messages widget tile has a user-configured image set in the dashboard.

**Steps:**
1. Launch Claude Automation app
2. Tap on the 'CSS' tab in the bottom navigation
3. Locate the Messages widget tile

**Expected:**
- The Messages widget tile displays the user-configured image as set in the dashboard.

---

### 110544 — Verify User-Configured Tile Title Displayed

**Preconditions:**
- Claude Automation app is on the CSS tab. The Messages widget tile has a user-configured title set in the dashboard.

**Steps:**
1. Locate the Messages widget tile on the CSS tab
2. Verify the tile title text

**Expected:**
- The Messages widget tile displays the user-configured title as set in the dashboard.

---

### 110545 — Verify User-Configured Navigation Bar Title Displayed

**Preconditions:**
- The Messages widget has a user-configured navigation bar title set in the dashboard.

**Steps:**
1. Launch Claude Automation app
2. Tap the 'CSS' tab
3. Tap on the Messages widget tile

**Expected:**
- The navigation bar at the top of the Messages screen displays the user-configured title (e.g., 'Mitteilungen').

---

## Main Flow (12955)

### 110546 — Open Messages Widget from CSS Tab

**Preconditions:**
- App is installed and launched on Claude Automation. CSS tab is visible in the bottom navigation.

**Steps:**
1. Launch Claude Automation app
2. Tap on the 'CSS' tab
3. Tap on the 'Messages' widget tile

**Expected:**
- Messages widget opens. A loading spinner is briefly displayed, then the Messages list screen appears with a 'Zurück' back arrow in the top-left and a three-dot menu icon in the top-right.

---

### 110547 — Verify Messages List Overview Loads

**Preconditions:**
- Messages widget is open. Loading spinner has finished.

**Steps:**
1. Verify the message list is displayed
2. Scroll through the list to see the section groups

**Expected:**
- List is rendered grouped into sections configured via widget keys (`newMessagesTitle`, `otherMessagesTitle`, `oldMessagesTitle`). Each message row shows a title, a date label (e.g., 'vom 23.09.2025'), and a thumbnail image on the right.

---

### 110548 — Verify Latest Message Appears Under newMessagesTitle Section

**Preconditions:**
- Messages list overview is displayed.

**Steps:**
1. Locate the topmost section header on the list
2. Verify the message(s) shown under it

**Expected:**
- The topmost section uses the `newMessagesTitle` widget key (e.g., 'Neuste Mitteilung'). Only the single most-recent message by date appears in this section.

---

### 110549 — Verify Current-Year Messages Appear Under otherMessagesTitle Section

**Preconditions:**
- Messages list overview is displayed. Test data includes at least one message from the current calendar year other than the most-recent one.

**Steps:**
1. Scroll down past the `newMessagesTitle` section
2. Verify the `otherMessagesTitle` section header and its contents

**Expected:**
- The `otherMessagesTitle` section is shown listing all messages from the current calendar year other than the most-recent one, sorted by date in descending order.

---

### 110550 — Verify Older-Year Messages Appear Under oldMessagesTitle Section

**Preconditions:**
- Messages list overview is displayed.

**Steps:**
1. Scroll down past the `newMessagesTitle` and `otherMessagesTitle` sections
2. Verify the `oldMessagesTitle` section header and its contents

**Expected:**
- The `oldMessagesTitle` section (e.g., 'Alte Mitteilungen') is shown listing all messages from previous calendar years, sorted by date in descending order.

---

### 110551 — Verify Kundennummer (Context Switch) Row Displayed

**Preconditions:**
- Messages list overview is displayed. The widget configuration has `showContextSwitch=true` and the integrator setting `contextSwitchAvailable=true`.

**Steps:**
1. Scroll to the top of the screen
2. Verify the 'Kundennummer:' row below the header

**Expected:**
- A 'Kundennummer:' row (using the configured `labelContextSwitch`) is displayed below the screen header. A context-switch icon is shown on the right side if the user has at least two contexts available.

---

### 110552 — Open Latest Message from newMessagesTitle Section

**Preconditions:**
- Messages list overview is displayed. The `newMessagesTitle` section is visible.

**Steps:**
1. Tap on the message under the `newMessagesTitle` section (e.g., 'CASE 7: test Latest')
2. Verify the view that opens corresponds to the message's type
3. Tap the 'Zurück' back arrow (or close the native viewer) to return to the list

**Expected:**
- Tapping the latest message opens the view based on the message type: if SINGLE_FILE, the file is opened natively in the system viewer; if COMBINED, the Combined Message View detail screen opens. After tapping back, the user returns to the Messages list overview.

---

### 110553 — Open COMBINED Message - Just Text (no attachments)

**Preconditions:**
- Messages list overview is displayed. A COMBINED message with body text only is visible (e.g., 'CASE 4: Just Text').

**Steps:**
1. Tap on the 'Just Text' message

**Expected:**
- Combined Message View opens. Header shows 'Mitteilungen' with a 'Zurück' arrow and three-dot menu. The screen displays the date, title, and body text only. No preview image and no 'Anhänge' section are shown.

---

### 110554 — Open COMBINED Message - Just Text + Preview Image (Base64)

**Preconditions:**
- Messages list overview is displayed. A COMBINED message with body and a Base64-encoded preview image is visible (e.g., 'CASE 2').

**Steps:**
1. Tap the 'Zurück' arrow if currently in a detail view to return to the list
2. Tap on the 'Just Text + Preview Image (Base64)' message

**Expected:**
- Combined Message View opens displaying the preview image (decoded from Base64) at the top, then the date, title, and body text (e.g., 'Lorem ipsum dolor sit amet'). No 'Anhänge' section is shown because there are no attachments.

---

### 110555 — Open COMBINED Message - Text & Single File + Preview Image (URL)

**Preconditions:**
- Messages list overview is displayed. A COMBINED message with body, URL-loaded preview image, and a single attached file is visible (e.g., 'CASE 3').

**Steps:**
1. Tap the 'Zurück' arrow if currently in a detail view to return to the list
2. Tap on the 'Text & Single File + Preview Image (URL)' message

**Expected:**
- Combined Message View opens displaying the preview image (loaded from URL), date, title, body text, and an 'Anhänge' section listing a single attached file (e.g., 'Datei1.pdf') with a file icon and chevron.

---

### 110556 — Open COMBINED Message - Multiple Files (Base64 & URLs)

**Preconditions:**
- Messages list overview is displayed. A COMBINED message with multiple attached files (no body text, no preview image) is visible (e.g., 'CASE 5: Multiple Files (Base64 & URLs)').

**Steps:**
1. Tap the 'Zurück' arrow if currently in a detail view to return to the list
2. Tap on the 'Multiple Files' message

**Expected:**
- Combined Message View opens displaying the date, title, and an 'Anhänge' section listing all attached files in a single grouped container (e.g., 'Datei1.docx', 'Datei2.jpg', 'Datei3.mp3', 'Datei4.zip'). Each row shows a file icon, filename, and a chevron on the right. No preview image and no body text are shown.

---

### 110557 — Open SINGLE_FILE Message Opens File Natively

**Preconditions:**
- Messages list overview is displayed. A SINGLE_FILE message (one file only, no headline/body) is visible (e.g., 'CASE 1: Just file').

**Steps:**
1. Tap the 'Zurück' arrow if currently in a detail view to return to the list
2. Tap on the SINGLE_FILE message

**Expected:**
- Per the documentation, no detail screen is shown. The file opens natively in the appropriate system viewer (e.g., iOS Quick Look). After closing the viewer, the user returns to the Messages list overview.

---

### 110558 — Return to CSS Tab from Messages List

**Preconditions:**
- Messages list overview is displayed.

**Steps:**
1. Tap the 'Zurück' arrow in the top-left of the list header

**Expected:**
- Messages widget closes. The user returns to the CSS tab of Claude Automation with the Messages widget tile visible.

---

## File Attachment Types (12956)

### 110559 — Open PDF Attachment (.pdf)

**Preconditions:**
- A Combined Message View with an attached .pdf file is open (e.g., 'CASE 3' with 'Datei1.pdf' in the Anhänge section).

**Steps:**
1. Tap on the '.pdf' file row in the 'Anhänge' section
2. Wait for the viewer to load
3. Swipe up/down to scroll through the pages
4. Tap the 'Fertig' button in the top-right corner

**Expected:**
- Steps 1-2: The in-app PDF viewer opens with the filename in the header, 'Zurück' on the left, and 'Fertig' on the right.
- Step 3: Multi-page PDF scrolls smoothly.
- Step 4: PDF viewer closes and returns to the Combined Message View.

---

### 110560 — Open Word Document Attachment (.docx)

**Preconditions:**
- A Combined Message View with an attached .docx file is open (e.g., 'CASE 5' with 'Datei1.docx').

**Steps:**
1. Tap on the '.docx' file row in the 'Anhänge' section
2. Wait for the system handler to launch
3. Close the viewer/handler and return to the app

**Expected:**
- The .docx file is handed off to the system file viewer (Quick Look) or compatible app. The user can preview the file and return to the Combined Message View without the app crashing.

---

### 110561 — Open Image Attachment (.jpg)

**Preconditions:**
- A Combined Message View with an attached .jpg file is open (e.g., 'CASE 5' with 'Datei2.jpg').

**Steps:**
1. Tap on the '.jpg' file row in the 'Anhänge' section
2. Wait for the image viewer to load
3. Close the viewer and return to the app

**Expected:**
- The .jpg file opens in the iOS Quick Look image viewer showing the image content. The user can return to the Combined Message View without the app crashing.

---

### 110562 — Open Audio Attachment (.mp3)

**Preconditions:**
- A Combined Message View with an attached .mp3 file is open (e.g., 'CASE 5' with 'Datei3.mp3').

**Steps:**
1. Tap on the '.mp3' file row in the 'Anhänge' section
2. Wait for the audio handler to load
3. Close/dismiss the handler and return to the app

**Expected:**
- The .mp3 file is handed off to the system audio player or Quick Look. The user can play/preview the audio file and return to the Combined Message View without the app crashing.

---

### 110563 — Open Archive Attachment (.zip)

**Preconditions:**
- A Combined Message View with an attached .zip file is open (e.g., 'CASE 5' with 'Datei4.zip').

**Steps:**
1. Tap on the '.zip' file row in the 'Anhänge' section
2. Wait for the system handler to launch
3. Close/dismiss the handler and return to the app

**Expected:**
- The .zip file is handed off to the system Files app / share sheet. The user can save or open the archive and return to the Combined Message View without the app crashing.

---

### 116430 — Open PDF Attachment - Share to print and cancel

**Refs:** PMPO-3033

**Preconditions:**
- **Environment:** Claude Automation app, CSS tab, TEST environment
- **Widget-key:** `one_widget_css_messages`
- **Concept:** [CSS] [MSG] Message V2.0 — https://endios.atlassian.net/wiki/spaces/S3/pages/1332740240
- **Figma (iOS):** https://www.figma.com/design/GuGQl0YlugL15ErovxOx9P/ME-Messages?node-id=1336-2732
- A COMBINED message with an attached `.pdf` file is available in the mock data (e.g., 'CASE 3' with 'Datei1.pdf' in the Anhänge section).

**Steps:**
1. Launch the Claude Automation app
2. Tap the 'CSS' tab
3. Tap the Messages widget tile
4. Tap a COMBINED message that has a PDF attachment (e.g., 'CASE 3')
5. Tap the '.pdf' file row in the 'Anhänge' section
6. Wait for the in-app PDF viewer to open
7. Tap the share button on the top-right of the navigation bar
8. In the bottom sheet that slides up, tap the Print option
9. On the print preview screen, tap Cancel
10. Tap the 'Zurück' button on the top-left of the navigation bar

**Expected:**
- Step 7: tapping the share button reveals a bottom sheet (modal that slides up from the bottom of the screen) containing share options including a Print button
- Step 8: tapping the Print option opens the print preview screen with a preview of the PDF attachment
- Step 9: tapping Cancel closes the print preview; the user returns to the PDF viewer with the same document still rendered
- Step 10: the PDF viewer closes; the user is returned to the Combined Message View with the Anhänge section still rendered
- No crash at any step

---

### 116431 — Open Word Document Attachment - Share to print and cancel

**Refs:** PMPO-3033

**Preconditions:**
- **Environment:** Claude Automation app, CSS tab, TEST environment
- **Widget-key:** `one_widget_css_messages`
- **Concept:** [CSS] [MSG] Message V2.0 — https://endios.atlassian.net/wiki/spaces/S3/pages/1332740240
- **Figma (iOS):** https://www.figma.com/design/GuGQl0YlugL15ErovxOx9P/ME-Messages?node-id=1336-2732
- A COMBINED message with an attached `.docx` file is available in the mock data (e.g., 'CASE 5' with 'Datei1.docx' in the Anhänge section).

**Steps:**
1. Launch the Claude Automation app
2. Tap the 'CSS' tab
3. Tap the Messages widget tile
4. Tap a COMBINED message that has a .docx attachment (e.g., 'CASE 5')
5. Tap the '.docx' file row in the 'Anhänge' section
6. Wait for the system file viewer to open
7. Tap the share button on the top-right of the navigation bar
8. In the bottom sheet that slides up, tap the Print option
9. On the print preview screen, tap Cancel
10. Tap the close button on the navigation bar to dismiss the viewer

**Expected:**
- Step 7: tapping the share button reveals a bottom sheet (modal that slides up from the bottom of the screen) containing share options including a Print button
- Step 8: tapping the Print option opens the print preview screen with a preview of the .docx document
- Step 9: tapping Cancel closes the print preview; the user returns to the file viewer with the same document still rendered
- Step 10: the file viewer closes; the user is returned to the Combined Message View with the Anhänge section still rendered
- No crash at any step

---

## Negative Scenarios (12957)

### 110564 — Empty State - No Messages Available

**Preconditions:**
- A customer/configuration with no available messages is configured (mock empty data).

**Steps:**
1. Launch Claude Automation app
2. Tap on the 'CSS' tab
3. Tap on the 'Messages' widget tile

**Expected:**
- Loading spinner appears, then the Standard Empty State View is displayed with the user-configured empty-state message (e.g., 'Hallo! Es liegen keine aktuellen Meldungen für Sie vor.') and a retry icon. No message list is shown.

---

### 110565 — Initial Loading Spinner Displayed

**Preconditions:**
- App is launched and the CSS tab is open. The Messages widget tile is visible.

**Steps:**
1. Tap on the 'Messages' widget tile
2. Observe the screen immediately after tapping

**Expected:**
- Before the list is rendered, a loading spinner is displayed in the centre of the screen. Spinner disappears once the list data is loaded.

---

### 110567 — Anhänge Section Header Not Displayed When No Attachments

**Preconditions:**
- Messages list overview is displayed. A COMBINED message with body text and/or preview image but NO attached files is visible (e.g., 'CASE 2: Just Text + Preview Image (Base64)').

**Steps:**
1. Tap on the message with no attachments
2. Inspect the detail screen for the 'Anhänge' section

**Expected:**
- The 'Anhänge' section header is NOT displayed since there are no files to list. Only the preview image (if any), date, title, and body text are shown.
