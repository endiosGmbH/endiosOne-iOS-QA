#!/bin/bash
# tap_button.sh — AXButton tap helper for iPhone 17 Pro
# Substring-matches AXButton description, clicks center via cliclick, screenshots.
#
# Usage:
#   tap_button.sh <pattern> [<screenshot_name>] [<device>]
#
#   <pattern>          — substring of AXButton description (case-sensitive)
#   <screenshot_name>  — base name for screenshot file (optional)
#   <device>           — "17 Pro" (default) or "16 Pro"
#
# Hard-coded UDID for iPhone 17 Pro defaults; override via DEVICE env or arg 3.
#
# Substring-match danger: "Ok" matches "Dokument" — use exact text where possible.

PATTERN="$1"
SHOT="$2"
DEVICE="${3:-17 Pro}"

if [ "$DEVICE" = "17 Pro" ]; then
  UDID=6DA2CF14-7FAE-40CB-BC7A-0059950D85E0
elif [ "$DEVICE" = "16 Pro" ]; then
  UDID=4B385F1D-C21D-42C7-921C-6205F8E02A57
else
  echo "Unknown device: $DEVICE (expected '17 Pro' or '16 Pro')"
  exit 2
fi

POS=$(osascript 2>/dev/null <<OSA
tell application "System Events"
  tell process "Simulator"
    set targetWin to missing value
    repeat with w in windows
      if name of w contains "$DEVICE" then
        set targetWin to w
        exit repeat
      end if
    end repeat
    if targetWin is missing value then return ""
    set elems to (entire contents of targetWin)
    set foundPos to ""
    repeat with i from 1 to (count of elems)
      set e to item i of elems
      try
        if (role of e) as string is "AXButton" then
          set dsc to (description of e) as string
          if dsc contains "$PATTERN" then
            set bp to position of e
            set bs to size of e
            set cx to (item 1 of bp) + ((item 1 of bs) div 2)
            set cy to (item 2 of bp) + ((item 2 of bs) div 2)
            set foundPos to (cx as string) & "," & (cy as string)
            exit repeat
          end if
        end if
      end try
    end repeat
    return foundPos
  end tell
end tell
OSA
)

if [ -z "$POS" ]; then
  echo "BUTTON NOT FOUND: $PATTERN"
  exit 1
fi

echo "Tap '$PATTERN' at $POS"

# Bring the target window to front so the click lands on the right simulator
osascript >/dev/null 2>&1 <<OSA
tell application "Simulator" to activate
delay 0.2
tell application "System Events"
  tell process "Simulator"
    set frontmost to true
    repeat with w in windows
      if name of w contains "$DEVICE" then
        perform action "AXRaise" of w
        exit repeat
      end if
    end repeat
  end tell
end tell
OSA

cliclick c:$POS
sleep 3

if [ -n "$SHOT" ]; then
  xcrun simctl io $UDID screenshot /tmp/verify-widget/run-widget-ct/$SHOT.png >/dev/null 2>&1
  mkdir -p /tmp/verify-widget/run-widget-ct/r2
  sips --resampleHeight 1200 /tmp/verify-widget/run-widget-ct/$SHOT.png \
       --out /tmp/verify-widget/run-widget-ct/r2/$SHOT.png >/dev/null 2>&1
  echo "Shot: $SHOT"
fi
