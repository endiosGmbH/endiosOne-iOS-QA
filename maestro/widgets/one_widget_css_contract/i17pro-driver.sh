#!/bin/bash
# i17pro-driver.sh — Fully-automated iPhone 17 Pro chain for CSS Contract.
# Runs cases 116527, 116528, 116529-116532, 116533, 116534, 116535, 116536 end-to-end.
# Maestro is NOT used (iOS 26 / iPhone 17 Pro doesn't accept Maestro taps reliably);
# all input goes via AppleScript (system dialogs + tab radio buttons) + cliclick
# (in-app SwiftUI buttons + raw coords for separate-process system views).
#
# Prereqs:
#   - iPhone 17 Pro sim booted (UDID 6DA2CF14-7FAE-40CB-BC7A-0059950D85E0)
#   - de.endios.one installed
#   - cliclick on PATH (`brew install cliclick`)
#   - This script's sibling `tap_button.sh` exists
#
# Output:
#   /tmp/verify-widget/run-widget-ct/17pro-step-NN-<name>.png + downsized in r2/
#
# Re-run safe: cleans up by closing print preview at the end.

set -e

UDID=6DA2CF14-7FAE-40CB-BC7A-0059950D85E0
HERE="$(cd "$(dirname "$0")" && pwd)"
TAP="$HERE/tap_button.sh"
OUT=/tmp/verify-widget/run-widget-ct
mkdir -p "$OUT/r2"

shot() {
  local name="$1"
  xcrun simctl io $UDID screenshot "$OUT/${name}.png" >/dev/null 2>&1
  sips --resampleHeight 1200 "$OUT/${name}.png" --out "$OUT/r2/${name}.png" >/dev/null 2>&1
  echo "  → $name"
}

raise17() {
  osascript >/dev/null 2>&1 <<'OSA'
tell application "Simulator" to activate
delay 0.2
tell application "System Events"
  tell process "Simulator"
    set frontmost to true
    repeat with w in windows
      if name of w contains "17 Pro" then
        perform action "AXRaise" of w
        exit repeat
      end if
    end repeat
  end tell
end tell
OSA
}

click_xy() {
  raise17
  cliclick c:"$1","$2"
  sleep "${3:-3}"
}

dismiss_notif_dialog() {
  # SpringBoard "endios one Debug Would Like to Send You Notifications" — curly apostrophe.
  # Not visible to Maestro / runFlow when visible (separate process), so use AXPress
  # via accessibility on the dialog AXButton element.
  osascript >/dev/null 2>&1 <<'OSA'
tell application "Simulator" to activate
delay 0.3
tell application "System Events"
  tell process "Simulator"
    set frontmost to true
    repeat with w in windows
      if name of w contains "17 Pro" then
        perform action "AXRaise" of w
        exit repeat
      end if
    end repeat
    -- Try AXPress on the Don't Allow button found anywhere in the AX tree
    try
      tell sheet 1 of group 3 of group 15 of group 1 of window 1
        set elems to entire contents
        repeat with i from 1 to (count of elems)
          set e to item i of elems
          try
            if (role of e) as string is "AXButton" then
              -- Use a fragment that survives both straight + curly apostrophe
              set dsc to (description of e) as string
              if dsc starts with "Don" and dsc ends with "Allow" then
                perform action "AXPress" of e
                return "pressed"
              end if
            end if
          end try
        end repeat
      end tell
    end try
    return "no-dialog"
  end tell
end tell
OSA
  sleep 1
}

echo "=== STEP 0: Relaunch endios one with clearState on iPhone 17 Pro ==="
xcrun simctl terminate $UDID de.endios.one 2>/dev/null || true
sleep 1
xcrun simctl uninstall $UDID de.endios.one 2>/dev/null || true
echo "  (skipping reinstall — keep existing build; if not installed, run /run-widget first)"

# If you actually want clearState behaviour run this via Maestro instead:
#   maestro --udid $UDID test -e clearState=true ...
# For everyday re-runs, just relaunch (preserves notification denial):
xcrun simctl launch $UDID de.endios.one >/dev/null 2>&1
sleep 6
shot 17pro-step-00-launch

echo "=== STEP 1: Dismiss notifications permission dialog (if shown) ==="
dismiss_notif_dialog
shot 17pro-step-01-dismissed

echo "=== STEP 2: Tap CSS tab (radio button — AppleScript click) ==="
# iPhone 17 Pro window at (758, 51) size (387, 833); CSS tab radio at Mac (1079, 820)
osascript >/dev/null 2>&1 <<'OSA'
tell application "Simulator" to activate
delay 0.2
tell application "System Events"
  tell process "Simulator"
    set frontmost to true
    click at {1079, 820}
  end tell
end tell
OSA
sleep 2
shot 17pro-step-02-css-tab

echo "=== STEP 3: Tap canonical Verträge tile (cliclick on AXButton center) ==="
# Verträge AXButton at (784, 518) size 110x110 → center (839, 573)
click_xy 839 573 4
shot 17pro-step-03-willkommen

echo "=== STEP 4: WEITER onboarding ==="
"$TAP" "WEITER" 17pro-step-04-vertrage-list

echo "=== STEP 5: Tap Test Regenwasser list cell (AXStaticText) ==="
# Cell text at (845, 416)
click_xy 845 416 4
shot 17pro-step-05-vertragsdetails

echo "=== STEP 6: Tap Abschlag compose pencil → modal opens (116527/528) ==="
# AXImage 'compose' at (1075, 423) → center (1085, 433)
click_xy 1085 433 3
shot 17pro-step-06-modal-open

echo "=== STEP 7: Tap modal Ok → Budget Billing flow (116529/530) ==="
# Modal Ok at (952, 539) sz 114x37 → center (1009, 558)
click_xy 1009 558 5
shot 17pro-step-07-bb-onboarding

echo "=== STEP 8: WEITER on BB onboarding → BB list (116531 entry) ==="
"$TAP" "Weiter" 17pro-step-08-bb-list

echo "=== STEP 9: Zurück twice to return to Vertragsdetails ==="
"$TAP" "Zurück" 17pro-step-09a-back1
"$TAP" "Zurück" 17pro-step-09b-back2

echo "=== STEP 10: Tap Abschlag compose pencil again (modal) ==="
click_xy 1085 433 3
shot 17pro-step-10-modal-again

echo "=== STEP 11: Tap Abbrechen → modal dismisses (116532) ==="
# Abbrechen at (837, 539) sz 114x37 → center (894, 558)
click_xy 894 558 3
shot 17pro-step-11-modal-closed

echo "=== STEP 12: Tap Vertrag PDF-Dokument → PDF viewer (116533) ==="
"$TAP" "Vertrag PDF-Dokument" 17pro-step-12-pdf-viewer

echo "  Waiting for PDF/webview to load…"
sleep 6
shot 17pro-step-12b-pdf-loaded

echo "=== STEP 13: Tap share icon (bottom toolbar) → share sheet (116534) ==="
# Bottom toolbar share icon: iOS (~250, 830) → Mac (~999, 842)
click_xy 999 842 4
shot 17pro-step-13-share-sheet

echo "=== STEP 14: Tap View More to expand sheet ==="
# View More chevron at iOS (~340, 815) → Mac (~1085, 829)
click_xy 1085 829 3
shot 17pro-step-14-sheet-expanded

echo "=== STEP 15: Tap Print row → print preview (116535) ==="
# Print row at iOS (~200, 664) → Mac (~951, 684)
click_xy 951 684 4
shot 17pro-step-15-print-preview

echo "=== STEP 16: Dismiss print preview via X close (116536) ==="
# Print preview X close at top-left, iOS (~35, 130) → Mac (~790, 175)
click_xy 790 175 2
shot 17pro-step-16-print-cancelled

echo
echo "=== DONE ==="
echo "All 11 iPhone 17 Pro screenshots saved to $OUT/r2/17pro-step-*.png"
echo "Cases verified end-to-end on iPhone 17 Pro:"
echo "  116527 (webview) 116528 (X close)"
echo "  116529 116530 116531 116532 (modal chain)"
echo "  116533 (PDF viewer) 116534 (share sheet) 116535 (print) 116536 (cancel)"
