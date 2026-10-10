//
//  L10n.swift
//  LangSwitch
//

import Foundation

enum L10nKey: String {
    case menuSettings
    case menuQuit
    case menuViewTrends
    case menuSummaryToday
    case menuSummaryWeek
    case quickTrendsTitle
    case openFullStatistics

    case alertHideIconTitle
    case alertHideIconMessage
    case alertOK

    case sectionGeneral
    case sectionLanguage
    case sectionSwitching
    case sectionPermissions
    case sectionAbout
    case sectionStatistics

    case todaySwitches
    case totalSwitches
    case todayBreakdown
    case noStatisticsYet
    case resetStatistics
    case resetStatisticsTitle
    case resetStatisticsMessage
    case last7DaysTrend
    case monthTrend
    case trendNoData

    case showStatusBarIcon
    case launchAtLogin
    case appLanguage
    case switchDebounce
    case timeUnitMs
    case debounceHelp
    case showSwitchHUD
    case syncMenuBarIcon
    case syncHelp
    case accessibilityGranted
    case accessibilityDenied
    case openSystemSettings
    case accessibilityHelp
    case accessibilityRequiredTitle
    case accessibilityDeniedWarning
    case accessibilitySetupSteps
    case version
    case statusBarIconHelp

    case globeKeySetupTitle
    case globeKeySetupMessage
    case globeKeySetupOpenKeyboard

    case inputSourceShortcutDisabledTitle
    case inputSourceShortcutDisabledMessage
}

enum L10n {
    static func t(_ key: L10nKey) -> String {
        let language = AppSettings.shared.appLanguage.rawValue
        if let value = table[language]?[key] {
            return value
        }
        return table[AppLanguage.default.rawValue]![key]!
    }

    static func format(_ key: L10nKey, _ arguments: CVarArg...) -> String {
        String(format: t(key), arguments: arguments)
    }

    private static let table: [String: [L10nKey: String]] = [
        "en": en,
        "zh-Hans": zhHans,
        "fr": fr,
        "ja": ja,
        "ko": ko,
        "de": de,
        "es": es,
    ]

    private static let en: [L10nKey: String] = [
        .menuSettings: "Settings…",
        .menuQuit: "Quit",
        .menuViewTrends: "View Trends",
        .menuSummaryToday: "Today: %d",
        .menuSummaryWeek: "Last 7 days: %d",
        .quickTrendsTitle: "Trends",
        .openFullStatistics: "All Statistics in Settings…",
        .alertHideIconTitle: "Menu Bar Icon Hidden",
        .alertHideIconMessage: """
        LangSwitch keeps running in the background. The Globe key still switches input sources.

        To open the menu again, relaunch LangSwitch from Applications or Spotlight (⌘Space).
        """,
        .alertOK: "OK",
        .sectionGeneral: "General",
        .sectionLanguage: "Language",
        .sectionSwitching: "Switching",
        .sectionPermissions: "Permissions",
        .sectionAbout: "About",
        .sectionStatistics: "Usage Statistics",
        .todaySwitches: "Switches today",
        .totalSwitches: "Total switches",
        .todayBreakdown: "Today's input source breakdown",
        .noStatisticsYet: "No switches recorded yet. Use the Globe key to start collecting stats.",
        .resetStatistics: "Reset Statistics",
        .resetStatisticsTitle: "Reset all statistics?",
        .resetStatisticsMessage: "This clears today's counts, totals, trends, and per-input-source breakdown.",
        .last7DaysTrend: "Last 7 days",
        .monthTrend: "This month",
        .trendNoData: "No data for this period yet.",
        .showStatusBarIcon: "Show menu bar icon",
        .launchAtLogin: "Launch at login",
        .appLanguage: "App language",
        .switchDebounce: "Switch debounce",
        .timeUnitMs: "ms",
        .debounceHelp: "Prevents double-switching when the Globe key is pressed quickly. Lower is faster.",
        .showSwitchHUD: "Show input source HUD after switch",
        .syncMenuBarIcon: "Sync menu bar input icon",
        .syncHelp: "Turn off for slightly faster switching, but the menu bar icon may drift.",
        .accessibilityGranted: "Granted",
        .accessibilityDenied: "Not granted",
        .openSystemSettings: "Open System Settings",
        .accessibilityHelp: "Accessibility is enabled. LangSwitch can listen for the Globe key and switch input sources in other apps.",
        .accessibilityRequiredTitle: "Accessibility Required",
        .accessibilityDeniedWarning: """
        LangSwitch cannot work properly without Accessibility permission. The menu bar input icon may change, but your actual input method in other apps will not switch.
        """,
        .accessibilitySetupSteps: """
        1. Click “Open System Settings” and enable LangSwitch under Privacy & Security → Accessibility.
        2. Quit LangSwitch completely, then reopen it.
        3. Test in Notes or Safari: the input method should actually change while typing.
        """,
        .version: "Version",
        .statusBarIconHelp: "If the menu bar icon is hidden, relaunch LangSwitch from Applications or Spotlight to show it again.",
        .globeKeySetupTitle: "Globe Key Setup Required",
        .globeKeySetupMessage: """
        LangSwitch needs the Globe/Fn key set to “Do Nothing” in System Settings.

        Open System Settings → Keyboard, then set “Press 🌐 key to” (or “Press fn key to”) to “Do Nothing”.
        """,
        .globeKeySetupOpenKeyboard: "Open Keyboard Settings",
        .inputSourceShortcutDisabledTitle: "Input Source Shortcut Disabled",
        .inputSourceShortcutDisabledMessage: """
        LangSwitch switches input sources by sending the system “Select next source in Input menu” shortcut, but it is turned off. Some apps (e.g. Slack, Telegram) may receive it as a typed space, and switching may be delayed or not work.

        Open System Settings → Keyboard → Keyboard Shortcuts → Input Sources, then enable “Select next source in Input menu”.
        """,
    ]

    private static let zhHans: [L10nKey: String] = [
        .menuSettings: "设置…",
        .menuQuit: "退出",
        .menuViewTrends: "查看趋势",
        .menuSummaryToday: "今日：%d 次",
        .menuSummaryWeek: "近 7 天：%d 次",
        .quickTrendsTitle: "切换趋势",
        .openFullStatistics: "在设置中查看完整统计…",
        .alertHideIconTitle: "菜单栏图标已隐藏",
        .alertHideIconMessage: """
        程序仍在后台运行，按地球键仍可切换输入法。

        如需再次打开菜单，请从「应用程序」文件夹或 Spotlight（⌘Space 搜索 LangSwitch）重新打开本程序。
        """,
        .alertOK: "知道了",
        .sectionGeneral: "通用",
        .sectionLanguage: "语言",
        .sectionSwitching: "切换",
        .sectionPermissions: "权限",
        .sectionAbout: "关于",
        .sectionStatistics: "使用统计",
        .todaySwitches: "今日切换次数",
        .totalSwitches: "累计切换次数",
        .todayBreakdown: "今日各输入法占比",
        .noStatisticsYet: "暂无记录。按地球键切换后会开始统计。",
        .resetStatistics: "重置统计",
        .resetStatisticsTitle: "重置所有统计数据？",
        .resetStatisticsMessage: "将清空今日次数、累计次数、趋势图表和各输入法占比。",
        .last7DaysTrend: "近 7 天趋势",
        .monthTrend: "本月趋势",
        .trendNoData: "该时段暂无数据。",
        .showStatusBarIcon: "显示菜单栏图标",
        .launchAtLogin: "登录时自动启动",
        .appLanguage: "界面语言",
        .switchDebounce: "切换防抖",
        .timeUnitMs: "毫秒",
        .debounceHelp: "防止连按地球键时重复切换。数值越小响应越快。",
        .showSwitchHUD: "切换后显示输入法提示",
        .syncMenuBarIcon: "同步菜单栏输入法图标",
        .syncHelp: "关闭可略快一点，但菜单栏图标可能与实际输入法不一致。",
        .accessibilityGranted: "已授权",
        .accessibilityDenied: "未授权",
        .openSystemSettings: "打开系统设置",
        .accessibilityHelp: "辅助功能已开启，LangSwitch 可在其他应用中监听地球键并真正切换输入法。",
        .accessibilityRequiredTitle: "必须开启辅助功能权限",
        .accessibilityDeniedWarning: """
        未授权时 LangSwitch 无法正常使用。按地球键可能只改变菜单栏输入法图标，但在备忘录、浏览器等应用中并不能真正切换输入法。
        """,
        .accessibilitySetupSteps: """
        1. 点击「打开系统设置」，在「隐私与安全性 → 辅助功能」中启用 LangSwitch。
        2. 完全退出 LangSwitch 后重新打开。
        3. 在备忘录或 Safari 中测试：打字时的输入法应切实改变。
        """,
        .version: "版本",
        .statusBarIconHelp: "隐藏菜单栏图标后，可从「应用程序」或 Spotlight 重新打开本程序以再次显示图标。",
        .globeKeySetupTitle: "需要配置地球键",
        .globeKeySetupMessage: """
        LangSwitch 需要把地球键设为「不执行任何操作」，否则系统会先响应地球键，本程序无法正常切换。

        请打开 系统设置 → 键盘，将「按下 🌐 键以」或「按下 Fn 键以」设为「不执行任何操作」。
        """,
        .globeKeySetupOpenKeyboard: "打开键盘设置",
        .inputSourceShortcutDisabledTitle: "输入法切换快捷键已关闭",
        .inputSourceShortcutDisabledMessage: """
        LangSwitch 通过系统「选择输入法菜单中的下一个输入法」快捷键切换输入法，但该快捷键当前已关闭。部分应用（如 Slack、Telegram）可能会收到一个空格，切换也会变慢或失效。

        请打开「系统设置 → 键盘 → 键盘快捷键 → 输入法」，启用「选择输入法菜单中的下一个输入法」。
        """,
    ]

    private static let fr: [L10nKey: String] = [
        .menuSettings: "Réglages…",
        .menuQuit: "Quitter",
        .menuViewTrends: "Voir les tendances",
        .menuSummaryToday: "Aujourd’hui : %d",
        .menuSummaryWeek: "7 derniers jours : %d",
        .quickTrendsTitle: "Tendances",
        .openFullStatistics: "Statistiques complètes dans Réglages…",
        .alertHideIconTitle: "Icône de la barre de menus masquée",
        .alertHideIconMessage: """
        LangSwitch continue de fonctionner en arrière-plan. La touche Globe change toujours de source de saisie.

        Pour rouvrir le menu, relancez LangSwitch depuis Applications ou Spotlight (⌘Espace).
        """,
        .alertOK: "OK",
        .sectionGeneral: "Général",
        .sectionLanguage: "Langue",
        .sectionSwitching: "Changement",
        .sectionPermissions: "Autorisations",
        .sectionAbout: "À propos",
        .sectionStatistics: "Statistiques d’utilisation",
        .todaySwitches: "Changements aujourd’hui",
        .totalSwitches: "Total des changements",
        .todayBreakdown: "Répartition des sources de saisie aujourd’hui",
        .noStatisticsYet: "Aucune donnée pour le moment. Utilisez la touche Globe pour commencer.",
        .resetStatistics: "Réinitialiser les statistiques",
        .resetStatisticsTitle: "Réinitialiser toutes les statistiques ?",
        .resetStatisticsMessage: "Efface les totaux du jour, le cumul, les tendances et la répartition par source.",
        .last7DaysTrend: "7 derniers jours",
        .monthTrend: "Ce mois-ci",
        .trendNoData: "Aucune donnée pour cette période.",
        .showStatusBarIcon: "Afficher l’icône dans la barre de menus",
        .launchAtLogin: "Ouvrir à la connexion",
        .appLanguage: "Langue de l’application",
        .switchDebounce: "Anti-rebond",
        .timeUnitMs: "ms",
        .debounceHelp: "Évite un double changement si la touche Globe est pressée trop vite.",
        .showSwitchHUD: "Afficher la source de saisie après le changement",
        .syncMenuBarIcon: "Synchroniser l’icône de la barre de menus",
        .syncHelp: "Désactiver pour un changement un peu plus rapide, mais l’icône peut être incorrecte.",
        .accessibilityGranted: "Autorisé",
        .accessibilityDenied: "Non autorisé",
        .openSystemSettings: "Ouvrir Réglages Système",
        .accessibilityHelp: "L’accessibilité est activée. LangSwitch peut écouter la touche Globe et changer réellement de source de saisie dans les autres apps.",
        .accessibilityRequiredTitle: "Accessibilité requise",
        .accessibilityDeniedWarning: """
        Sans l’autorisation Accessibilité, LangSwitch ne fonctionne pas correctement. L’icône de la barre de menus peut changer, mais la source de saisie réelle ne change pas dans les autres apps.
        """,
        .accessibilitySetupSteps: """
        1. Cliquez sur « Ouvrir Réglages Système » et activez LangSwitch dans Confidentialité et sécurité → Accessibilité.
        2. Quittez complètement LangSwitch, puis rouvrez-le.
        3. Testez dans Notes ou Safari : la source de saisie doit réellement changer pendant la frappe.
        """,
        .version: "Version",
        .statusBarIconHelp: "Si l’icône est masquée, relancez LangSwitch depuis Applications ou Spotlight pour l’afficher à nouveau.",
        .globeKeySetupTitle: "Configuration de la touche Globe requise",
        .globeKeySetupMessage: """
        LangSwitch a besoin que la touche Globe/Fn soit réglée sur « Ne rien faire » dans Réglages Système.

        Ouvrez Réglages Système → Clavier, puis réglez « Appuyer sur la touche 🌐 pour » sur « Ne rien faire ».
        """,
        .globeKeySetupOpenKeyboard: "Ouvrir Réglages Clavier",
        .inputSourceShortcutDisabledTitle: "Raccourci de source d’entrée désactivé",
        .inputSourceShortcutDisabledMessage: """
        LangSwitch change de source d’entrée via le raccourci système « Sélectionner la source suivante dans le menu Entrée », mais il est désactivé. Certaines apps (p. ex. Slack, Telegram) peuvent recevoir une espace, et le changement peut être lent ou échouer.

        Ouvrez Réglages Système → Clavier → Raccourcis clavier → Sources d’entrée, puis activez « Sélectionner la source suivante dans le menu Entrée ».
        """,
    ]

    private static let ja: [L10nKey: String] = [
        .menuSettings: "設定…",
        .menuQuit: "終了",
        .menuViewTrends: "推移を表示",
        .menuSummaryToday: "今日：%d 回",
        .menuSummaryWeek: "直近 7 日：%d 回",
        .quickTrendsTitle: "切り替え推移",
        .openFullStatistics: "設定で詳細統計を表示…",
        .alertHideIconTitle: "メニューバーアイコンを非表示にしました",
        .alertHideIconMessage: """
        LangSwitch はバックグラウンドで動作し続けます。地球儀キーでの切り替えは利用できます。

        メニューを再度開くには、アプリケーションまたは Spotlight（⌘Space）から LangSwitch を起動してください。
        """,
        .alertOK: "OK",
        .sectionGeneral: "一般",
        .sectionLanguage: "言語",
        .sectionSwitching: "切り替え",
        .sectionPermissions: "権限",
        .sectionAbout: "情報",
        .sectionStatistics: "使用統計",
        .todaySwitches: "今日の切り替え回数",
        .totalSwitches: "累計切り替え回数",
        .todayBreakdown: "今日の入力ソース内訳",
        .noStatisticsYet: "まだ記録がありません。地球儀キーで切り替えると統計が始まります。",
        .resetStatistics: "統計をリセット",
        .resetStatisticsTitle: "すべての統計をリセットしますか？",
        .resetStatisticsMessage: "今日の回数、累計、推移グラフ、入力ソース別の内訳を消去します。",
        .last7DaysTrend: "直近 7 日間",
        .monthTrend: "今月",
        .trendNoData: "この期間のデータはまだありません。",
        .showStatusBarIcon: "メニューバーアイコンを表示",
        .launchAtLogin: "ログイン時に起動",
        .appLanguage: "表示言語",
        .switchDebounce: "切り替え間隔",
        .timeUnitMs: "ミリ秒",
        .debounceHelp: "地球儀キーの連打による二重切り替えを防ぎます。値が小さいほど速く反応します。",
        .showSwitchHUD: "切り替え後に入力ソースを表示",
        .syncMenuBarIcon: "メニューバーの入力アイコンを同期",
        .syncHelp: "オフにすると少し速くなりますが、アイコンが一致しない場合があります。",
        .accessibilityGranted: "許可済み",
        .accessibilityDenied: "未許可",
        .openSystemSettings: "システム設定を開く",
        .accessibilityHelp: "アクセシビリティが有効です。LangSwitch は他のアプリでも地球儀キーを監視し、実際に入力ソースを切り替えられます。",
        .accessibilityRequiredTitle: "アクセシビリティの許可が必要です",
        .accessibilityDeniedWarning: """
        許可がないと LangSwitch は正常に動作しません。地球儀キーでメニューバーのアイコンだけが変わり、メモや Safari などでは実際の入力ソースが切り替わらない場合があります。
        """,
        .accessibilitySetupSteps: """
        1. 「システム設定を開く」をクリックし、「プライバシーとセキュリティ → アクセシビリティ」で LangSwitch を有効にします。
        2. LangSwitch を完全に終了してから再度開きます。
        3. メモや Safari でテストし、入力中に入力ソースが実際に変わることを確認します。
        """,
        .version: "バージョン",
        .statusBarIconHelp: "メニューバーアイコンを隠した場合は、アプリケーションまたは Spotlight から LangSwitch を再起動すると再表示できます。",
        .globeKeySetupTitle: "地球儀キーの設定が必要です",
        .globeKeySetupMessage: """
        LangSwitch では地球儀/Fn キーを「何もしない」に設定する必要があります。

        システム設定 → キーボード で「🌐 キーを押して」を「何もしない」に設定してください。
        """,
        .globeKeySetupOpenKeyboard: "キーボード設定を開く",
        .inputSourceShortcutDisabledTitle: "入力ソース切り替えショートカットがオフです",
        .inputSourceShortcutDisabledMessage: """
        LangSwitch はシステムの「入力メニューから次の入力ソースを選択」ショートカットで切り替えますが、現在オフになっています。Slack や Telegram などでスペースが入力されたり、切り替えが遅れたり動作しないことがあります。

        「システム設定 → キーボード → キーボードショートカット → 入力ソース」を開き、「入力メニューから次の入力ソースを選択」を有効にしてください。
        """,
    ]

    private static let ko: [L10nKey: String] = [
        .menuSettings: "설정…",
        .menuQuit: "종료",
        .menuViewTrends: "추세 보기",
        .menuSummaryToday: "오늘: %d회",
        .menuSummaryWeek: "최근 7일: %d회",
        .quickTrendsTitle: "전환 추세",
        .openFullStatistics: "설정에서 전체 통계 보기…",
        .alertHideIconTitle: "메뉴 막대 아이콘이 숨겨졌습니다",
        .alertHideIconMessage: """
        LangSwitch는 백그라운드에서 계속 실행됩니다. 지구본 키로 입력 소스를 전환할 수 있습니다.

        메뉴를 다시 열려면 응용 프로그램 또는 Spotlight(⌘Space)에서 LangSwitch를 다시 실행하세요.
        """,
        .alertOK: "확인",
        .sectionGeneral: "일반",
        .sectionLanguage: "언어",
        .sectionSwitching: "전환",
        .sectionPermissions: "권한",
        .sectionAbout: "정보",
        .sectionStatistics: "사용 통계",
        .todaySwitches: "오늘 전환 횟수",
        .totalSwitches: "누적 전환 횟수",
        .todayBreakdown: "오늘 입력 소스 비율",
        .noStatisticsYet: "아직 기록이 없습니다. 지구본 키로 전환하면 통계가 시작됩니다.",
        .resetStatistics: "통계 초기화",
        .resetStatisticsTitle: "모든 통계를 초기화할까요?",
        .resetStatisticsMessage: "오늘 횟수, 누적 횟수, 추세 그래프, 입력 소스별 비율이 모두 삭제됩니다.",
        .last7DaysTrend: "최근 7일",
        .monthTrend: "이번 달",
        .trendNoData: "이 기간의 데이터가 아직 없습니다.",
        .showStatusBarIcon: "메뉴 막대 아이콘 표시",
        .launchAtLogin: "로그인 시 시작",
        .appLanguage: "앱 언어",
        .switchDebounce: "전환 지연",
        .timeUnitMs: "ms",
        .debounceHelp: "지구본 키를 빠르게 눌렀을 때 중복 전환을 방지합니다.",
        .showSwitchHUD: "전환 후 입력 소스 표시",
        .syncMenuBarIcon: "메뉴 막대 입력 아이콘 동기화",
        .syncHelp: "끄면 조금 더 빠르지만 아이콘이 맞지 않을 수 있습니다.",
        .accessibilityGranted: "허용됨",
        .accessibilityDenied: "허용 안 됨",
        .openSystemSettings: "시스템 설정 열기",
        .accessibilityHelp: "손쉬운 사용 권한이 켜져 있습니다. LangSwitch는 다른 앱에서도 지구본 키를 감지하고 실제로 입력 소스를 전환할 수 있습니다.",
        .accessibilityRequiredTitle: "손쉬운 사용 권한이 필요합니다",
        .accessibilityDeniedWarning: """
        권한이 없으면 LangSwitch가 정상적으로 작동하지 않습니다. 지구본 키를 눌렀을 때 메뉴 막대 아이콘만 바뀌고, 메모나 Safari 등에서는 실제 입력 소스가 바뀌지 않을 수 있습니다.
        """,
        .accessibilitySetupSteps: """
        1. 「시스템 설정 열기」를 누르고 「개인정보 보호 및 보안 → 손쉬운 사용」에서 LangSwitch를 켭니다.
        2. LangSwitch를 완전히 종료한 뒤 다시 실행합니다.
        3. 메모 또는 Safari에서 테스트하여 입력 중 입력 소스가 실제로 바뀌는지 확인합니다.
        """,
        .version: "버전",
        .statusBarIconHelp: "메뉴 막대 아이콘을 숨긴 경우 응용 프로그램 또는 Spotlight에서 LangSwitch를 다시 실행하면 다시 표시됩니다.",
        .globeKeySetupTitle: "지구본 키 설정 필요",
        .globeKeySetupMessage: """
        LangSwitch는 지구본/Fn 키가 시스템 설정에서 「아무 작업도 안 함」으로 설정되어 있어야 합니다.

        시스템 설정 → 키보드에서 「🌐 키를 눌러」를 「아무 작업도 안 함」으로 설정하세요.
        """,
        .globeKeySetupOpenKeyboard: "키보드 설정 열기",
        .inputSourceShortcutDisabledTitle: "입력 소스 단축키가 꺼져 있음",
        .inputSourceShortcutDisabledMessage: """
        LangSwitch는 시스템의 「입력 메뉴에서 다음 소스 선택」 단축키로 입력기를 전환하지만, 현재 꺼져 있습니다. Slack, Telegram 등에서 공백이 입력되거나 전환이 늦어지거나 실패할 수 있습니다.

        「시스템 설정 → 키보드 → 키보드 단축키 → 입력 소스」에서 「입력 메뉴에서 다음 소스 선택」을 켜세요.
        """,
    ]

    private static let de: [L10nKey: String] = [
        .menuSettings: "Einstellungen…",
        .menuQuit: "Beenden",
        .menuViewTrends: "Trends anzeigen",
        .menuSummaryToday: "Heute: %d",
        .menuSummaryWeek: "Letzte 7 Tage: %d",
        .quickTrendsTitle: "Wechsel-Trends",
        .openFullStatistics: "Alle Statistiken in Einstellungen…",
        .alertHideIconTitle: "Symbol in der Menüleiste ausgeblendet",
        .alertHideIconMessage: """
        LangSwitch läuft im Hintergrund weiter. Die Globustaste schaltet weiterhin Eingabequellen um.

        Öffnen Sie LangSwitch erneut über Programme oder Spotlight (⌘Leertaste), um das Menü wieder anzuzeigen.
        """,
        .alertOK: "OK",
        .sectionGeneral: "Allgemein",
        .sectionLanguage: "Sprache",
        .sectionSwitching: "Umschalten",
        .sectionPermissions: "Berechtigungen",
        .sectionAbout: "Info",
        .sectionStatistics: "Nutzungsstatistik",
        .todaySwitches: "Wechsel heute",
        .totalSwitches: "Wechsel gesamt",
        .todayBreakdown: "Aufschlüsselung der Eingabequellen heute",
        .noStatisticsYet: "Noch keine Daten. Verwenden Sie die Globustaste, um Statistiken zu sammeln.",
        .resetStatistics: "Statistik zurücksetzen",
        .resetStatisticsTitle: "Alle Statistiken zurücksetzen?",
        .resetStatisticsMessage: "Löscht die heutigen Werte, Gesamtzahlen, Verlaufstrends und die Aufschlüsselung nach Eingabequelle.",
        .last7DaysTrend: "Letzte 7 Tage",
        .monthTrend: "Dieser Monat",
        .trendNoData: "Für diesen Zeitraum liegen noch keine Daten vor.",
        .showStatusBarIcon: "Symbol in der Menüleiste anzeigen",
        .launchAtLogin: "Beim Anmelden starten",
        .appLanguage: "App-Sprache",
        .switchDebounce: "Entprellung",
        .timeUnitMs: "ms",
        .debounceHelp: "Verhindert Doppelumschaltungen bei schnellem Drücken der Globustaste.",
        .showSwitchHUD: "Eingabequelle nach Umschalten anzeigen",
        .syncMenuBarIcon: "Eingabesymbol in der Menüleiste synchronisieren",
        .syncHelp: "Aus für etwas schnelleres Umschalten, aber das Symbol kann abweichen.",
        .accessibilityGranted: "Erteilt",
        .accessibilityDenied: "Nicht erteilt",
        .openSystemSettings: "Systemeinstellungen öffnen",
        .accessibilityHelp: "Bedienungshilfen sind aktiviert. LangSwitch kann die Globustaste überwachen und in anderen Apps wirklich die Eingabequelle wechseln.",
        .accessibilityRequiredTitle: "Bedienungshilfen erforderlich",
        .accessibilityDeniedWarning: """
        Ohne die Bedienungshilfen-Berechtigung funktioniert LangSwitch nicht richtig. Das Symbol in der Menüleiste kann sich ändern, aber die tatsächliche Eingabequelle in anderen Apps bleibt unverändert.
        """,
        .accessibilitySetupSteps: """
        1. Klicken Sie auf „Systemeinstellungen öffnen“ und aktivieren Sie LangSwitch unter Datenschutz & Sicherheit → Bedienungshilfen.
        2. Beenden Sie LangSwitch vollständig und starten Sie es neu.
        3. Testen Sie in Notizen oder Safari: Die Eingabequelle sollte sich beim Tippen wirklich ändern.
        """,
        .version: "Version",
        .statusBarIconHelp: "Wenn das Symbol ausgeblendet ist, starten Sie LangSwitch über Programme oder Spotlight neu, um es wieder anzuzeigen.",
        .globeKeySetupTitle: "Globustaste muss eingerichtet werden",
        .globeKeySetupMessage: """
        LangSwitch benötigt die Einstellung „Keine Aktion“ für die Globus-/Fn-Taste.

        Öffnen Sie Systemeinstellungen → Tastatur und setzen Sie „Bei Drücken der 🌐-Taste“ auf „Keine Aktion“.
        """,
        .globeKeySetupOpenKeyboard: "Tastatureinstellungen öffnen",
        .inputSourceShortcutDisabledTitle: "Eingabequellen-Kurzbefehl deaktiviert",
        .inputSourceShortcutDisabledMessage: """
        LangSwitch wechselt Eingabequellen über den Systemkurzbefehl „Nächste Quelle im Eingabemenü auswählen“, der derzeit deaktiviert ist. In manchen Apps (z. B. Slack, Telegram) kann ein Leerzeichen ankommen, und der Wechsel kann verzögert sein oder fehlschlagen.

        Öffnen Sie Systemeinstellungen → Tastatur → Tastaturkurzbefehle → Eingabequellen und aktivieren Sie „Nächste Quelle im Eingabemenü auswählen“.
        """,
    ]

    private static let es: [L10nKey: String] = [
        .menuSettings: "Ajustes…",
        .menuQuit: "Salir",
        .menuViewTrends: "Ver tendencias",
        .menuSummaryToday: "Hoy: %d",
        .menuSummaryWeek: "Últimos 7 días: %d",
        .quickTrendsTitle: "Tendencias",
        .openFullStatistics: "Estadísticas completas en Ajustes…",
        .alertHideIconTitle: "Icono de la barra de menús oculto",
        .alertHideIconMessage: """
        LangSwitch sigue ejecutándose en segundo plano. La tecla Globo sigue cambiando el método de entrada.

        Para volver a abrir el menú, inicie LangSwitch desde Aplicaciones o Spotlight (⌘Espacio).
        """,
        .alertOK: "OK",
        .sectionGeneral: "General",
        .sectionLanguage: "Idioma",
        .sectionSwitching: "Cambio",
        .sectionPermissions: "Permisos",
        .sectionAbout: "Acerca de",
        .sectionStatistics: "Estadísticas de uso",
        .todaySwitches: "Cambios hoy",
        .totalSwitches: "Cambios totales",
        .todayBreakdown: "Desglose de métodos de entrada hoy",
        .noStatisticsYet: "Aún no hay datos. Use la tecla Globo para empezar a registrar estadísticas.",
        .resetStatistics: "Restablecer estadísticas",
        .resetStatisticsTitle: "¿Restablecer todas las estadísticas?",
        .resetStatisticsMessage: "Borra los totales de hoy, el acumulado, las tendencias y el desglose por método de entrada.",
        .last7DaysTrend: "Últimos 7 días",
        .monthTrend: "Este mes",
        .trendNoData: "Aún no hay datos para este periodo.",
        .showStatusBarIcon: "Mostrar icono en la barra de menús",
        .launchAtLogin: "Iniciar al iniciar sesión",
        .appLanguage: "Idioma de la app",
        .switchDebounce: "Antirrebote",
        .timeUnitMs: "ms",
        .debounceHelp: "Evita cambios dobles al pulsar rápidamente la tecla Globo.",
        .showSwitchHUD: "Mostrar método de entrada tras el cambio",
        .syncMenuBarIcon: "Sincronizar icono de entrada en la barra de menús",
        .syncHelp: "Desactivar para un cambio algo más rápido, pero el icono puede no coincidir.",
        .accessibilityGranted: "Concedido",
        .accessibilityDenied: "No concedido",
        .openSystemSettings: "Abrir Ajustes del Sistema",
        .accessibilityHelp: "Accesibilidad está activada. LangSwitch puede escuchar la tecla Globo y cambiar realmente el método de entrada en otras apps.",
        .accessibilityRequiredTitle: "Se requiere Accesibilidad",
        .accessibilityDeniedWarning: """
        Sin el permiso de Accesibilidad, LangSwitch no funciona correctamente. El icono de la barra de menús puede cambiar, pero el método de entrada real no cambia en otras apps.
        """,
        .accessibilitySetupSteps: """
        1. Pulse «Abrir Ajustes del Sistema» y active LangSwitch en Privacidad y seguridad → Accesibilidad.
        2. Cierre LangSwitch por completo y vuelva a abrirlo.
        3. Pruebe en Notas o Safari: el método de entrada debe cambiar realmente al escribir.
        """,
        .version: "Version",
        .statusBarIconHelp: "Si el icono está oculto, vuelva a abrir LangSwitch desde Aplicaciones o Spotlight para mostrarlo de nuevo.",
        .globeKeySetupTitle: "Configuración de la tecla Globo requerida",
        .globeKeySetupMessage: """
        LangSwitch necesita que la tecla Globo/Fn esté en «No hacer nada» en Ajustes del Sistema.

        Abra Ajustes del Sistema → Teclado y configure «Al pulsar la tecla 🌐» en «No hacer nada».
        """,
        .globeKeySetupOpenKeyboard: "Abrir ajustes de Teclado",
        .inputSourceShortcutDisabledTitle: "Atajo de fuente de entrada desactivado",
        .inputSourceShortcutDisabledMessage: """
        LangSwitch cambia la fuente de entrada con el atajo del sistema «Seleccionar la siguiente fuente en el menú Entrada», pero está desactivado. Algunas apps (p. ej. Slack, Telegram) pueden recibir un espacio, y el cambio puede retrasarse o fallar.

        Abre Ajustes del Sistema → Teclado → Atajos de teclado → Fuentes de entrada y activa «Seleccionar la siguiente fuente en el menú Entrada».
        """,
    ]
}
