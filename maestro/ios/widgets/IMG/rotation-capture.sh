#!/bin/zsh
# rotation-capture.sh — 110127 interval-precision companion for run-widget-img.yaml
# Proves the configured rotatingRhythm (3s code default / 4s on 18784) that the
# Maestro 10s watch cannot. Run AFTER the consolidated flow with the app sitting
# at the dashboard TOP (relaunch first if the panorama left it scrolled):
#   xcrun simctl terminate BD791DDE-CE86-4ADA-AE09-EDAF6A647CE8 de.endios.one
#   xcrun simctl launch BD791DDE-CE86-4ADA-AE09-EDAF6A647CE8 de.endios.one && sleep 8
#   ./rotation-capture.sh
# Reference result 2026-06-06: 18763 = 3.0s, 18742 = 3.0s, 18784 = 4.0s (exact).

UDID="${1:-BD791DDE-CE86-4ADA-AE09-EDAF6A647CE8}"
D="/tmp/verify-widget/run-widget-img/rotation-$(date +%Y%m%d)"
mkdir -p "$D"
rm -f "$D"/frame_*.png

python3 - "$UDID" "$D" <<'EOF'
import subprocess, time, sys
UDID, D = sys.argv[1], sys.argv[2]
start = time.time(); i = 0
while time.time() - start < 34:
    t = time.time() - start
    subprocess.run(["xcrun","simctl","io",UDID,"screenshot",f"{D}/frame_{i:03d}_{t:06.2f}.png"],
                   capture_output=True)
    i += 1
    d = start + i*0.8 - time.time()
    if d > 0: time.sleep(d)
print("frames:", i)

from PIL import Image, ImageChops, ImageStat
import glob, re
frames = sorted(glob.glob(f"{D}/frame_*.png"))
times = [float(re.search(r'_(\d+\.\d+)\.png', f).group(1)) for f in frames]
# crop boxes valid for iPhone 16 Pro 1206x2622 dashboard-top layout
boxes = {"18763 (rhythm ''->3s)": (500,280,740,500),
         "18742 (rhythm '0'->3s)": (880,350,1140,850),
         "18784 (rhythm '4'->4s)": (100,680,700,950)}
for name, box in boxes.items():
    crops = [Image.open(f).crop(box).convert("L").resize((60,60)) for f in frames]
    events = []
    for j in range(1, len(crops)):
        if ImageStat.Stat(ImageChops.difference(crops[j-1], crops[j])).mean[0] > 8:
            if not events or times[j] - events[-1] > 1.5:
                events.append(times[j])
    iv = [round(events[j]-events[j-1],1) for j in range(1,len(events))]
    print(f"{name}: intervals {iv}")
EOF
