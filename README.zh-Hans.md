# LangSwitch Enhanced

[English](README.md) · [Releases](https://github.com/beaumelon/LangSwitch-Enhanced/releases)

基于 [Nikeev/LangSwitch](https://github.com/Nikeev/LangSwitch) 优化改进的 macOS 菜单栏工具：按地球键（🌐 / Fn）瞬间切换输入法，无弹窗、无需等待。

> **非官方 fork** · 维护者 [@beaumelon](https://github.com/beaumelon) · 感谢原作者 [@Nikeev](https://github.com/Nikeev) 的开源项目（[MIT License](LICENSE)）

![langswitch-example](https://github.com/Nikeev/LangSwitch/assets/1555773/2850313a-f70d-4f76-b629-3d5798754f86)

---

## 相对原版的改进

| 类别 | 说明 |
|------|------|
| **提高稳定性** | 自动重连地球键监听并保留事件引用，提升长时间使用下的切换稳定性 |
| **设置面板** | 独立设置窗口：防抖、登录启动、菜单栏图标、HUD、多语言界面等 |
| **使用统计** | 今日/累计切换次数、近 7 天与本月趋势、输入法占比 |
| **多语言** | 界面支持 English、简体中文、Français、日本語、한국어、Deutsch、Español |
| **地球键引导** | 检测地球键是否已设为「不执行任何操作」；未配置时在设置页顶部醒目提示并一键打开键盘设置 |
| **输入法 HUD** | 可选的切换后提示（默认关闭，因 macOS 已在光标处显示当前输入法） |
| **系统要求** | 部署目标提升至 **macOS 14.0+** |

---

## 系统要求

- macOS 14.0（Sonoma）或更高版本
- 带地球键（🌐 / Fn）的键盘

---

## 安装

### 方式一：下载 Release（推荐）

1. 在 [Releases](https://github.com/beaumelon/LangSwitch-Enhanced/releases) 页面下载最新 `.zip`
2. 解压后将 `LangSwitch.app` 拖入「应用程序」文件夹
3. 首次打开若被拦截，请在 **系统设置 → 隐私与安全性** 中允许打开

### 方式二：自行编译

```bash
git clone https://github.com/beaumelon/LangSwitch-Enhanced.git
cd LangSwitch-Enhanced
open LangSwitch.xcodeproj
```

在 Xcode 中选择 **LangSwitch** scheme，编译运行（⌘R）。

---

## 首次使用（必做）

LangSwitch 需要两项系统配置才能正常工作：

### 1. 辅助功能权限

1. 运行 LangSwitch
2. 打开 **设置 → 权限**
3. 点击「打开系统设置」，在 **隐私与安全性 → 辅助功能** 中启用 LangSwitch
4. 授权后若状态未更新，切换回应用或重新打开设置窗口即可

### 2. 地球键设为「不执行任何操作」

系统默认可能将地球键用于切换输入法、表情符号等，会与 LangSwitch 冲突。此项需在系统设置中手动配置，应用无法代为修改。

1. 打开 LangSwitch **设置**，若顶部出现橙色提示条，点击 **「打开键盘设置」**
2. 或自行打开 **系统设置 → 键盘**
3. 找到 **「按下 🌐 键以」** 或 **「按下 Fn 键以」**
4. 选择 **「不执行任何操作」**

---

## 使用方法

1. 完成上述配置后，LangSwitch 在菜单栏显示地球图标（可在设置中隐藏）
2. 在任意应用中按下 **地球键**，即可切换到下一个输入法
3. 点击菜单栏图标可查看：
   - 今日 / 近 7 天切换摘要
   - 查看趋势（独立统计窗口）
   - 打开设置、退出

**隐藏菜单栏图标后**：程序仍在后台运行，地球键照常生效。要找回图标，从「应用程序」或 Spotlight（⌘Space）重新打开 LangSwitch 即可。

---

## 设置说明

| 选项 | 说明 |
|------|------|
| 界面语言 | 应用显示语言 |
| 显示菜单栏图标 | 关闭后仅后台运行，需重新打开应用恢复图标 |
| 登录时自动启动 | 开机后自动运行 |
| 切换防抖 | 防止连按地球键时重复切换（50–300 ms） |
| 切换后显示输入法提示 | 光标附近弹出 HUD（默认关闭） |
| 同步菜单栏输入法图标 | 关闭可略快，但菜单栏图标可能与实际输入法不一致 |

---

## 常见问题

**按地球键没反应？**

1. 检查辅助功能权限是否已授予
2. 确认地球键已设为「不执行任何操作」
3. 确认未与其他地球键快捷键冲突

**与原版 LangSwitch 有什么区别？**

本仓库（[beaumelon/LangSwitch-Enhanced](https://github.com/beaumelon/LangSwitch-Enhanced)）是社区维护的增强 fork，包含稳定性增强、设置面板、统计与多语言等，并非 Nikeev 官方版本。若只需最简功能，也可使用 [原版](https://github.com/Nikeev/LangSwitch)。

---

## 致谢

- 原项目：[Nikeev/LangSwitch](https://github.com/Nikeev/LangSwitch) by [@Nikeev](https://github.com/Nikeev)
- 许可证：MIT（见 [LICENSE](LICENSE)）

欢迎在本仓库提交 Issue 与 Pull Request。

---

## License

MIT License — Copyright (c) 2023 Nikeev

本 fork 在保留原许可证与版权声明的前提下分发与修改。详见 [LICENSE](LICENSE)。
