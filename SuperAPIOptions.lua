-- No superwow, no superapi
if not SetAutoloot then
	return
end
local L = AceLibrary("AceLocale-2.2"):new("SuperAPI")
SuperAPI.AUTOLOOT_OPTIONS = {
	L["Always on"],
	L["Always off"],
	L["Shift to toggle on"],
	L["Shift to toggle off"],
}

SuperAPI.SELECTION_CIRCLE_STYLE = {
	L["Default - incomplete circle"],
	L["Full circle (must download texture)"],
	L["Full circle with arrow for facing direction (must download texture)"],
	L["Classic incomplete circle oriented in facing direction"],
}

SuperAPI:RegisterDefaults("profile", {
	autoloot = SuperAPI.AUTOLOOT_OPTIONS[3],
	clickthrough = true,
	guidcombatlog = false,
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
			name = L["Autoloot (Read tooltip)"],
			desc = L["Specifies autoloot behavior.  If using Vanilla Tweaks quickloot all of these will be reversed (always on will actually be always off, Shift to toggle on will be Shift to toggle off etc)."],
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
			name = L["Clickthrough corpses"],
			desc = L["Allows you to click through corpses to loot corpses underneath them."],
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
			name = L["Field of view (Requires reload)"],
			desc = L["Changes the field of view of the game.  Requires reload to take effect."],
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
			name = L["Selection circle style"],
			desc = L["Changes the style of the selection circle."],
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
			name = L["Background sound"],
			desc = L["Allows game sound to play even when the window is in the background."],
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
			name = L["Uncapped sounds"],
			desc = L["Allows more game sounds to play at the same time by removing hardcoded limit.  This will also set SoundSoftwareChannels and SoundMaxHardwareChannels to 64.  If you experience any weird crashes you may want to turn this off."],
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
		guidcombatlog = {
			type = "toggle",
			name = L["GUID Combat Log"],
			desc = L["Changes the combat log to print GUIDs instead of names, will break a lot of addons."],
			order = 80,
			get = function()
				return LoggingCombat("RAW") == 1
			end,
			set = function(v)
				if v == true then
					LoggingCombat("RAW", 1)
				else
					LoggingCombat("RAW", 0)
				end
				SuperAPI.db.profile.guidcombatlog = v
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
	SuperAPI.cmdtable.args.guidcombatlog.set(SuperAPI.db.profile.guidcombatlog)
end
