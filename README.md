# LangSwitch Enhanced

[简体中文](README.zh-Hans.md) · [Releases](https://github.com/beaumelon/LangSwitch-Enhanced/releases)

An enhanced macOS menu bar utility, based on [Nikeev/LangSwitch](https://github.com/Nikeev/LangSwitch). Press the Globe key (🌐 / Fn) for instant input-source switching — no popup, no waiting.

> **Unofficial fork** · Maintained by [@beaumelon](https://github.com/beaumelon) · Thanks to [@Nikeev](https://github.com/Nikeev) for the original project ([MIT License](LICENSE))

---

## Improvements over the original

| Area | Description |
|------|-------------|
| **Stability** | Reconnects Globe key listeners and retains event references for more consistent switching over time |
| **Settings** | Dedicated settings window: debounce, launch at login, menu bar icon, HUD, localized UI, and more |
| **Statistics** | Today/total switch counts, 7-day and monthly trends, per-input-source breakdown |
| **Localization** | English, 简体中文, Français, 日本語, 한국어, Deutsch, Español |
| **Globe key guide** | Detects whether the Globe key is set to “Do Nothing”; shows a prominent banner in Settings with a one-click link to Keyboard settings |
| **Input HUD** | Optional post-switch overlay (off by default — macOS already shows the current input source at the cursor) |
| **Requirements** | Deployment target raised to **macOS 14.0+** |

---

## Requirements

- macOS 14.0 (Sonoma) or later
- A keyboard with a Globe (🌐 / Fn) key

---

## Installation

### Option 1: Download a release (recommended)

1. Download the latest `.zip` from [Releases](https://github.com/beaumelon/LangSwitch-Enhanced/releases)
2. Unzip the archive and move `LangSwitch.app` into your Applications folder
3. If macOS blocks the first launch, allow it under **System Settings → Privacy & Security**

### Option 2: Build from source

```bash
git clone https://github.com/beaumelon/LangSwitch-Enhanced.git
cd LangSwitch-Enhanced
open LangSwitch.xcodeproj
```

Select the **LangSwitch** scheme in Xcode and run (⌘R).

---

## First-time setup (required)

LangSwitch needs two system settings before it works:

### 1. Accessibility permission

1. Launch LangSwitch
2. Open **Settings → Permissions**
3. Click **Open System Settings** and enable LangSwitch under **Privacy & Security → Accessibility**
4. If the status does not update after granting access, switch back to the app or reopen Settings

### 2. Set the Globe key to “Do Nothing”

macOS may use the Globe key for switching input sources, Emoji & Symbols, dictation, etc. That conflicts with LangSwitch. **This must be configured manually in System Settings** — the app cannot change it for you.

1. Open LangSwitch **Settings**; if an orange banner appears at the top, click **Open Keyboard Settings**
2. Or open **System Settings → Keyboard** yourself
3. Find **“Press 🌐 key to”** or **“Press fn key to”**
4. Choose **“Do Nothing”**

---

## Usage

1. After setup, LangSwitch shows a globe icon in the menu bar (you can hide it in Settings)
2. Press the **Globe key** in any app to switch to the next input source
3. Click the menu bar icon for:
   - Today / last-7-days switch summary
   - View trends (dedicated statistics window)
   - Settings and Quit

**After hiding the menu bar icon:** LangSwitch keeps running in the background and the Globe key still works. To restore the icon, relaunch LangSwitch from Applications or Spotlight (⌘Space).

---

## Settings

| Option | Description |
|--------|-------------|
| App language | UI display language |
| Show menu bar icon | When off, runs in the background only; relaunch the app to restore the icon |
| Launch at login | Start automatically after login |
| Switch debounce | Prevents double-switching on rapid Globe key presses (50–300 ms) |
| Show input source HUD after switch | Brief overlay near the cursor (off by default) |
| Sync menu bar input icon | Off can be slightly faster, but the menu bar icon may drift |

---

## FAQ

**Globe key does nothing?**

1. Check Accessibility permission
2. Confirm the Globe key is set to “Do Nothing”
3. Make sure no other Globe key shortcut conflicts

**How is this different from the original LangSwitch?**

This repo ([beaumelon/LangSwitch-Enhanced](https://github.com/beaumelon/LangSwitch-Enhanced)) is a community-maintained enhanced fork with improved stability, a settings panel, statistics, and localization. It is not the official Nikeev release. For a minimal build, see the [original project](https://github.com/Nikeev/LangSwitch).

---

## Acknowledgments

- Original project: [Nikeev/LangSwitch](https://github.com/Nikeev/LangSwitch) by [@Nikeev](https://github.com/Nikeev)
- License: MIT — see [LICENSE](LICENSE)

Issues and pull requests are welcome in this repository.

---

## License

MIT License — Copyright (c) 2023 Nikeev

This fork is distributed and modified under the same license with the original copyright notice preserved. See [LICENSE](LICENSE).
