-- No superwow, no superapi
if not SuperAPI then
	return
end

SuperAPI.AUTOLOOT_OPTIONS = {
	"Always on",
	"Always off",
	"Shift to toggle on",
	"Shift to toggle off",
}

SuperAPI.SELECTION_CIRCLE_STYLE = {
	"Default - incomplete circle",
	"Full circle (must download texture)",
	"Full circle with arrow for facing direction (must download texture)",
	"Classic incomplete circle oriented in facing direction",
}

SuperAPI.NAMEPLATE_MOTION = {
	"Overlap",
	"Default spread",
	"Smart spread",
	"Compact spread",
}

SuperAPI:RegisterDefaults("profile", {
	autoloot = SuperAPI.AUTOLOOT_OPTIONS[3],
	clickthrough = false,
})

SuperAPI.IfShiftAutoloot = function()
	if IsShiftKeyDown() then
		SetAutoloot(1)
	else
		SetAutoloot(0)
	end
end

SuperAPI.IfShiftNoAutoloot = function()
	if IsShiftKeyDown() then
		SetAutoloot(0)
	else
		SetAutoloot(1)
	end
end

SuperAPI.cmdtable = {
	type = "group",
	handler = SuperAPI,
	args = {
		autoloot = {
			type = "text",
			name = "Autoloot (Read tooltip)",
			desc = "Specifies autoloot behavior.  If using Vanilla Tweaks quickloot all of these will be reversed (always on will actually be always off, Shift to toggle on will be Shift to toggle off etc).",
			order = 10,
			validate = SuperAPI.AUTOLOOT_OPTIONS,
			get = function()
				return SuperAPI.db.profile.autoloot
			end,
			set = function(v)
				SuperAPI.db.profile.autoloot = v
				if v == SuperAPI.AUTOLOOT_OPTIONS[1] then
					-- "Always on"
					SetAutoloot(1)
					SuperAPI.frame:SetScript("OnUpdate", nil)
				elseif v == SuperAPI.AUTOLOOT_OPTIONS[2] then
					-- "Always off"
					SetAutoloot(0)
					SuperAPI.frame:SetScript("OnUpdate", nil)
				elseif v == SuperAPI.AUTOLOOT_OPTIONS[3] then
					-- "Shift to toggle on"
					SetAutoloot(0)
					SuperAPI.frame:SetScript("OnUpdate", SuperAPI.IfShiftAutoloot)
				elseif v == SuperAPI.AUTOLOOT_OPTIONS[4] then
					-- "Shift to toggle off"
					SetAutoloot(1)
					SuperAPI.frame:SetScript("OnUpdate", SuperAPI.IfShiftNoAutoloot)
				end
			end,
		},
		clickthrough = {
			type = "toggle",
			name = "Clickthrough corpses",
			desc = "Allows you to click through corpses to loot corpses underneath them.",
			order = 20,
			get = function()
				return Clickthrough() == 1
			end,
			set = function(v)
				if v == true then
					Clickthrough(1)
				else
					Clickthrough(0)
				end
				SuperAPI.db.profile.clickthrough = v
			end,
		},
		fov = {
			type = "range",
			name = "Field of view",
			desc = "Changes the field of view of the game. Requires UI Reload.",
			order = 30,
			min = 0.1,
			max = 3.14,
			step = 0.05,
			get = function()
				return GetCVar("FoV")
			end,
			set = function(v)
				SetCVar("FoV", v)
			end,
		},
		selectioncircle = {
			type = "text",
			name = "Selection circle style",
			desc = "Changes the style of the selection circle.",
			order = 40,
			validate = SuperAPI.SELECTION_CIRCLE_STYLE,
			get = function()
				local selectioncircle = GetCVar("SelectionCircleStyle")
				if selectioncircle then
					return SuperAPI.SELECTION_CIRCLE_STYLE[tonumber(selectioncircle)]
				end
			end,
			set = function(v)
				if v == SuperAPI.SELECTION_CIRCLE_STYLE[1] then
					SetCVar("SelectionCircleStyle", "1")
				elseif v == SuperAPI.SELECTION_CIRCLE_STYLE[2] then
					SetCVar("SelectionCircleStyle", "2")
				elseif v == SuperAPI.SELECTION_CIRCLE_STYLE[3] then
					SetCVar("SelectionCircleStyle", "3")
				elseif v == SuperAPI.SELECTION_CIRCLE_STYLE[4] then
					SetCVar("SelectionCircleStyle", "4")
				end
			end,
		},
		backgroundsound = {
			type = "toggle",
			name = "Background sound",
			desc = "Allows game sound to play even when the window is in the background.",
			order = 60,
			get = function()
				return GetCVar("BackgroundSound") == "1"
			end,
			set = function(v)
				if v == true then
					SetCVar("BackgroundSound", "1")
				else
					SetCVar("BackgroundSound", "0")
				end
			end,
		},
		uncappedsounds = {
			type = "toggle",
			name = "Uncapped sounds",
			desc = "Allows more game sounds to play at the same time by removing hardcoded limit.  This will also set SoundSoftwareChannels and SoundMaxHardwareChannels to 64.  If you experience any weird crashes you may want to turn this off.",
			order = 70,
			get = function()
				return GetCVar("UncapSounds") == "1"
			end,
			set = function(v)
				if v == true then
					SetCVar("UncapSounds", "1")
					SetCVar("SoundSoftwareChannels", "64")
					SetCVar("SoundMaxHardwareChannels", "64")
				else
					SetCVar("UncapSounds", "0")
					SetCVar("SoundSoftwareChannels", "12")
					SetCVar("SoundMaxHardwareChannels", "12")
				end
			end,
		},
		lootsparkle = {
			type = "toggle",
			name = "Loot Sparkle",
			desc = "Toggle loot sparkle effect on lootable treasure.",
			order = 80,
			get = function()
				return GetCVar("LootSparkle") == "1"
			end,
			set = function(v)
				if v == true then
					SetCVar("LootSparkle", "1")
				else
					SetCVar("LootSparkle", "0")
				end
			end,
		},
		healingtext = {
			type = "toggle",
			name = "Floating Healing Text",
			desc = "Toggle display of in-world healing feedback.",
			order = 85,
			get = function()
				return GetCVar("HealingText") == "1"
			end,
			set = function(v)
				if v == true then
					SetCVar("HealingText", "1")
				else
					SetCVar("HealingText", "0")
				end
			end,
		},
		nameplates = {
			type = "group",
			name = "Nameplate Settings",
			desc = "Group of settings related to Nameplates",
			order = 90,
			args = {
				nameplaterange = {
				type = "range",
				name = "Nameplate range",
				desc = "Changes the range at which Nameplates appear.",
				order = 1,
				min = 10,
				max = 80,
				step = 1,
				get = function()
					return GetCVar("NameplateRange")
				end,
				set = function(v)
					SetCVar("NameplateRange", v)
				end,
				},
				nameplatemotion = {
				type = "text",
				name = "Nameplate Motion",
				desc = "Changes the behavior of moving nameplates.",
				order = 2,
				validate = SuperAPI.NAMEPLATE_MOTION,
				get = function()
					local nameplatemotionSetting = GetCVar("NameplateMotion")
					if nameplatemotionSetting then
						return SuperAPI.NAMEPLATE_MOTION[(tonumber(nameplatemotionSetting))+1]
					end
				end,
				set = function(v)
					if v == SuperAPI.NAMEPLATE_MOTION[1] then
						SetCVar("NameplateMotion", "0")
					elseif v == SuperAPI.NAMEPLATE_MOTION[2] then
						SetCVar("NameplateMotion", "1")
					elseif v == SuperAPI.NAMEPLATE_MOTION[3] then
						SetCVar("NameplateMotion", "2")
					elseif v == SuperAPI.NAMEPLATE_MOTION[4] then
						SetCVar("NameplateMotion", "3")
					end
				end,
				},
			}
		},
		chatbubbles = {
			type = "group",
			name = "Chat Bubble Settings",
			desc = "Group of settings related to Chat Bubbles that appear above units",
			order = 100,
			args = {
				chatbubblerange = {
				type = "range",
				name = "Chat Bubbles range",
				desc = "Changes the range at which Chat Bubbles appear.",
				order = 1007,
				min = 10,
				max = 200,
				step = 5,
				get = function()
					return GetCVar("ChatBubbleRange")
				end,
				set = function(v)
					SetCVar("ChatBubbleRange", v)
				end,
				},
				togglesay = {
				type = "toggle",
				name = "Say Chat Bubbles",
				desc = "Toggle say and yell chat bubbles on/off",
				order = 1009,
				get = function()
					return GetCVar("ChatBubbles") == "1"
				end,
				set = function(v)
					if v == true then
						SetCVar("ChatBubbles", "1")
					else
						SetCVar("ChatBubbles", "0")
					end
				end,
				},
				togglepartybubbles = {
				type = "toggle",
				name = "Party Chat Bubbles",
				desc = "Toggle party chat bubbles on/off",
				order = 1008,
				get = function()
					return GetCVar("ChatBubblesParty") == "1"
				end,
				set = function(v)
					if v == true then
						SetCVar("ChatBubblesParty", "1")
					else
						SetCVar("ChatBubblesParty", "0")
					end
				end,
				},
				toggleraidbubbles = {
				type = "toggle",
				name = "Raid Chat Bubbles",
				desc = "Toggle raid chat bubbles on/off",
				order = 1010,
				get = function()
					return GetCVar("ChatBubblesRaid") == "1"
				end,
				set = function(v)
					if v == true then
						SetCVar("ChatBubblesRaid", "1")
					else
						SetCVar("ChatBubblesRaid", "0")
					end
				end,
				},
				togglebgbubbles = {
				type = "toggle",
				name = "Battleground Chat Bubbles",
				desc = "Toggle battleground chat bubbles on/off",
				order = 1020,
				get = function()
					return GetCVar("ChatBubblesBattleground") == "1"
				end,
				set = function(v)
					if v == true then
						SetCVar("ChatBubblesBattleground", "1")
					else
						SetCVar("ChatBubblesBattleground", "0")
					end
				end,
				},
				togglewhisperbubbles = {
				type = "toggle",
				name = "Whisper Chat Bubbles",
				desc = "Toggle whisper chat bubbles on/off",
				order = 1030,
				get = function()
					return GetCVar("ChatBubblesWhisper") == "1"
				end,
				set = function(v)
					if v == true then
						SetCVar("ChatBubblesWhisper", "1")
					else
						SetCVar("ChatBubblesWhisper", "0")
					end
				end,
				},
				togglecreaturebubbles = {
				type = "toggle",
				name = "Creature Chat Bubbles",
				desc = "Toggle chat bubbles on creatures on/off",
				order = 1040,
				get = function()
					return GetCVar("ChatBubblesCreatures") == "1"
				end,
				set = function(v)
					if v == true then
						SetCVar("ChatBubblesCreatures", "1")
					else
						SetCVar("ChatBubblesCreatures", "0")
					end
				end,
				},
			}
		},
		superwowLink = {
			type = "execute",
			name = "Support The Project",
			desc = "All your donations are deeply appreciated! The community support is what keeps SuperWoW going",
			func = function()
				local url = "https://ko-fi.com/balakesuperwow"

				if not ChatFrameEditBox:IsVisible() then
					ChatFrameEditBox:Show()
				end
				
				ChatFrameEditBox:SetText(url)
				ChatFrameEditBox:SetFocus()
				ChatFrameEditBox:HighlightText()
				
			end,
		},
	}
}

local deuce = SuperAPI:NewModule("SuperAPI Options Menu")
deuce.hasFuBar = IsAddOnLoaded("FuBar") and FuBar
deuce.consoleCmd = not deuce.hasFuBar

SuperAPIOptions = AceLibrary("AceAddon-2.0"):new("AceDB-2.0", "FuBarPlugin-2.0")
SuperAPIOptions.name = "FuBar - SuperAPI"
SuperAPIOptions:RegisterDB("SuperAPIDB")
SuperAPIOptions.hasIcon = "Interface\\Icons\\inv_misc_book_06"
SuperAPIOptions.defaultMinimapPosition = 180
SuperAPIOptions.independentProfile = true
SuperAPIOptions.hideWithoutStandby = false

SuperAPIOptions.OnMenuRequest = SuperAPI.cmdtable
local args = AceLibrary("FuBarPlugin-2.0"):GetAceOptionsDataTable(SuperAPIOptions)
for k, v in pairs(args) do
	if SuperAPIOptions.OnMenuRequest.args[k] == nil then
		SuperAPIOptions.OnMenuRequest.args[k] = v
	end
end

function SuperAPIOptions:OnEnable()
	-- activate saved settings
	SuperAPI.cmdtable.args.autoloot.set(SuperAPI.db.profile.autoloot)
	SuperAPI.cmdtable.args.clickthrough.set(SuperAPI.db.profile.clickthrough)
end
