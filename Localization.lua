local L = AceLibrary("AceLocale-2.2"):new("SuperAPI")

L:RegisterTranslations("enUS", function()
	return {
        -- SuperAPI.lua
        ["No SuperWoW detected"] = true,
        ["%d/511 Characters Used"] = true,
        ["Shows whisper, party, raid, and battleground chat text in speech bubbles above characters' heads."] = true,
        ["Show Whisper and Group Chat Bubbles"] = true,
        ["|cffffcc00SuperAPI|cffffaaaa Loaded.  Check the minimap icon for options."] = true,

        -- SuperAPIOptions.lua
        ["Always on"] = true,
        ["Always off"] = true,
        ["Shift to toggle on"] = true,
        ["Shift to toggle off"] = true,
        ["Default - incomplete circle"] = true,
        ["Full circle (must download texture)"] = true,
        ["Full circle with arrow for facing direction (must download texture)"] = true,
        ["Classic incomplete circle oriented in facing direction"] = true,
        ["Autoloot (Read tooltip)"] = true,
        ["Specifies autoloot behavior.  If using Vanilla Tweaks quickloot all of these will be reversed (always on will actually be always off, Shift to toggle on will be Shift to toggle off etc)."] = true,
        ["Clickthrough corpses"] = true,
        ["Allows you to click through corpses to loot corpses underneath them."] = true,
        ["Field of view (Requires reload)"] = true,
        ["Changes the field of view of the game.  Requires reload to take effect."] = true,
        ["Selection circle style"] = true,
        ["Changes the style of the selection circle."] = true,
        ["Background sound"] = true,
        ["Allows game sound to play even when the window is in the background."] = true,
        ["Uncapped sounds"] = true,
        ["Allows more game sounds to play at the same time by removing hardcoded limit.  This will also set SoundSoftwareChannels and SoundMaxHardwareChannels to 64.  If you experience any weird crashes you may want to turn this off."] = true,
        ["Loot Sparkle"] = true,
        ["Toggle loot sparkle effect on lootable treasure."] = true,
        ["SuperAPI Options Menu"] = true,
        ["FuBar - SuperAPI"] = true,
    }
end)

L:RegisterTranslations("zhCN", function()
	return {
        -- SuperAPI.lua
        ["No SuperWoW detected"] = "未检测到 SuperWoW",
        ["%d/511 Characters Used"] = "%d/511 个字符已使用",
        ["Shows whisper, party, raid, and battleground chat text in speech bubbles above characters' heads."] = "在角色头顶的聊天气泡中显示私聊、队伍、团队和战场聊天文本。",
        ["Show Whisper and Group Chat Bubbles"] = "显示私聊及队伍聊天气泡",
        ["|cffffcc00SuperAPI|cffffaaaa Loaded.  Check the minimap icon for options."] = "|cffffcc00SuperAPI|cffffaaaa 已加载。点击小地图图标打开设置。",

        -- SuperAPIOptions.lua
        ["Always on"] = "始终开启",
        ["Always off"] = "始终关闭",
        ["Shift to toggle on"] = "按住 Shift 键切换开启",
        ["Shift to toggle off"] = "按住 Shift 键切换关闭",
        ["Default - incomplete circle"] = "默认 - 不完整圆圈",
        ["Full circle (must download texture)"] = "完整圆圈（需下载纹理）",
        ["Full circle with arrow for facing direction (must download texture)"] = "带朝向箭头的完整圆圈（需下载纹理）",
        ["Classic incomplete circle oriented in facing direction"] = "经典朝向不完整圆圈",
        ["Autoloot (Read tooltip)"] = "自动拾取（阅读提示）",
        ["Specifies autoloot behavior.  If using Vanilla Tweaks quickloot all of these will be reversed (always on will actually be always off, Shift to toggle on will be Shift to toggle off etc)."] = "指定自动拾取行为。若使用 Vanilla Tweaks 快速拾取，所有设置将反转（如始终开启会变为始终关闭，按住 Shift 切换开启会变为按住 Shift 切换关闭等）。",
        ["Clickthrough corpses"] = "尸体穿透点击",
        ["Allows you to click through corpses to loot corpses underneath them."] = "允许点击穿透上层尸体以拾取下方尸体的物品。",
        ["Field of view (Requires reload)"] = "视野范围（需重载界面）",
        ["Changes the field of view of the game.  Requires reload to take effect."] = "更改游戏视野范围，需重载界面生效。",
        ["Selection circle style"] = "选中圈样式",
        ["Changes the style of the selection circle."] = "更改选中圈的样式。",
        ["Background sound"] = "后台音效",
        ["Allows game sound to play even when the window is in the background."] = "即使窗口在后台也能播放游戏音效。",
        ["Uncapped sounds"] = "无限制音效",
        ["Allows more game sounds to play at the same time by removing hardcoded limit.  This will also set SoundSoftwareChannels and SoundMaxHardwareChannels to 64.  If you experience any weird crashes you may want to turn this off."] = "移除硬编码限制，允许多个游戏音效同时播放。这将把软件声道和最大硬件声道设置为 64。若遇到异常崩溃，可关闭此选项。",
        ["Loot Sparkle"] = "拾取闪光效果",
        ["Toggle loot sparkle effect on lootable treasure."] = "切换可拾取物品的闪光效果。",
        ["SuperAPI Options Menu"] = "SuperAPI 选项菜单",
        ["FuBar - SuperAPI"] = "FuBar - SuperAPI",
    }
end)