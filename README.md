# endiosOne Mobile QA

Maestro UI test automation **and** TestRail-mirrored test cases for the **endios One** mobile app (iOS & Android).

Each widget is verified by running a consolidated Maestro flow against a booted simulator/emulator, screenshotting one tile per TestRail case, and checking the rendered UI against the case's expected result. TestRail is read **read-only** — runs never write results back.

## Repository Structure

```
endiosOne-mobile-QA/
├── maestro/
│   ├── ios/
│   │   └── widgets/
│   │       └── <WIDGET>/        ← per-widget iOS flows
│   │           ├── run-widget-<code>.yaml   ← consolidated suite flow (one launch, one tile per case)
│   │           ├── case-<id>.yaml           ← focused single-case flows
│   │           ├── <id>-only.yaml           ← targeted re-run / debug flows
│   │           └── README.md                ← per-widget runbook (device + tile + tap recipe)
│   └── android/
│       └── widgets/
│           └── <WIDGET>/        ← per-widget Android flows
└── testcases/
    └── <CODE>.md               ← TestRail snapshot per widget (cases, steps, expected results)
```

## Widget Coverage

| Code | Widget | `widget-key` | TestRail section | iOS | Android |
|------|--------|--------------|------------------|-----|---------|
| `IMG` | Image | `one_widget_image` | [12911](https://endios.testrail.io/index.php?/suites/view/468&group_id=12911) | ✅ | 🚧 |
| `NW`  | News | `one_widget_news` | [12902](https://endios.testrail.io/index.php?/suites/view/468&group_id=12902) | ✅ | — |
| `OF`  | Offers | `one_widget_offers` | [12923](https://endios.testrail.io/index.php?/suites/view/468&group_id=12923) | ✅ | — |
| `INV` | CSS Invoice | `one_widget_css_invoice` | [12945](https://endios.testrail.io/index.php?/suites/view/468&group_id=12945) | ✅ | — |
| `CT`  | CSS Contract | `one_widget_css_contract` | [13651](https://endios.testrail.io/index.php?/suites/view/468&group_id=13651) | ✅ | — |
| `MSG` | CSS Message | `one_widget_css_messages` | [12953](https://endios.testrail.io/index.php?/suites/view/468&group_id=12953) | ✅ | — |

All widgets live under TestRail project `endiosOne` (5) · suite `Master` (468).

## Prerequisites

1. **Maestro CLI** (`$HOME/.maestro/bin/maestro`, v2.4.0+):
   ```bash
   curl -Ls "https://get.maestro.mobile.dev" | bash
   ```

2. **iOS:** a booted simulator with the app `de.endios.one` ("endios one Debug" / "Claude Automation") installed.
   - Canonical sim: `iPhone 16 Pro iOS18` — UDID `4B385F1D-C21D-42C7-921C-6205F8E02A57`.
   - `appData.json` → `configId: 1425` (Claude Automation tenant).
   - Some widgets need `iPhone 17 Pro` (`6DA2CF14-7FAE-40CB-BC7A-0059950D85E0`) for iOS 26 / modal / webview cases — see the per-widget runbook.

3. **Android:** a running emulator/device with the debug APK installed.

4. **TestRail (read-only):** the `testrail` MCP server supplies case data. Project `5`, suite `468`. **Never** call `testrail_add_result*`.

## The QA Flow

This repo is driven by the QA skills rather than run by hand:

- **`/verify-widget <WIDGET>`** — verifies a widget's TestRail cases against the iOS codebase and Maestro runs.
- **`/run-widget <WIDGET>`** — runs a widget's entire TestRail suite in a **single consolidated Maestro flow**: one app launch, a different tile per case, and a table report at the end.
- **`/run-refresh-testrail-and-simulator`** — hard-refresh TestRail + the iOS simulator before any verify / run.

The pattern for every widget:

1. Pull the latest TestRail cases → snapshot into `testcases/<CODE>.md`.
2. Build/maintain the consolidated `run-widget-<code>.yaml` (one dashboard tile per case).
3. Run it against the canonical sim, capturing one screenshot per case.
4. Compare each screenshot against the case's expected result; record Pass/Fail in the per-widget `README.md` runbook.

## Running Tests

```bash
M=$HOME/.maestro/bin/maestro
U16=4B385F1D-C21D-42C7-921C-6205F8E02A57   # iPhone 16 Pro (canonical)

# Boot the sim
xcrun simctl boot $U16 2>/dev/null; open -a Simulator

# Run a widget's full consolidated suite (iOS)
$M --udid $U16 test maestro/ios/widgets/NW/run-widget-nw.yaml

# Run a single focused case
$M --udid $U16 test maestro/ios/widgets/OF/case-110169.yaml

# Run an Android flow
$M test maestro/android/widgets/IMG/run-widget-img.yaml
```

Screenshots and JUnit reports are written to `/tmp/verify-widget/<run>/` (git-ignored — never committed).

## File Naming Conventions

| Pattern | Purpose | Example |
|---------|---------|---------|
| `run-widget-<code>.yaml` | Consolidated full-suite flow | `run-widget-nw.yaml` |
| `case-<id>.yaml` | Focused single TestRail case | `case-110082.yaml` |
| `<id>-only.yaml` | Targeted re-run / debug of one case | `116519-only.yaml` |
| `<CODE>.md` (in `testcases/`) | TestRail snapshot for the widget | `NW.md` |
| `README.md` (in a widget dir) | Per-widget runbook (device + tile + tap recipe + verdict) | `one_widget_css_contract/README.md` |

## Per-Widget Runbooks

Each widget folder may carry its own `README.md` documenting the exact device, tile-to-coordinate mapping, tap recipe, known sim quirks, and the last full-suite Pass/Fail verdict — so the next `/run-widget` run reproduces it without rediscovery. See [`maestro/ios/widgets/one_widget_css_contract/README.md`](maestro/ios/widgets/one_widget_css_contract/README.md) for the reference example.

## Hard Rules

- **Read-only TestRail** — never `testrail_add_result*`. This repo verifies; it does not report results back.
- **Never commit** anything under `/tmp/verify-widget/` (screenshots, reports, resolved configs).
- **Preserve prior flows** — timestamp-copy an existing `run-widget-*.yaml` before regenerating it.

## Adding New Tests

### Via terminal:
```bash
git checkout main
git add maestro/ios/widgets/<WIDGET>/new_flow.yaml
git commit -m "Add <WIDGET> flow for <case/feature>"
git push origin main
```

### Via browser (1–2 files):
1. Open the widget folder on GitHub → **Add file → Upload files**.
2. Drag the `.yaml`, write a commit message, **Commit changes**.

## Maintainer

**Sangeerthana Edavalath** — QA, endios GmbH
