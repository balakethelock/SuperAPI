-- No superwow, no superapi
if not SetAutoloot then
	return
end

SuperAPI.AUTOLOOT_OPTIONS = {
	"Always on",
	"Always off",
	"Shift to toggle on",
	"Shift to toggle off",
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
				Clickthrough(v)
				SuperAPI.db.profile.clickthrough = v
			end,
		},
		guidcombatlog = {
			type = "toggle",
			name = "GUID Combat Log",
			desc = "Changes the combat log to print GUIDs instead of names, will break a lot of addons.",
			order = 30,
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
