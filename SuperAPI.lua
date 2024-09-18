-- No superwow, no superapi
if not SetAutoloot then
	return
end

SUPERAPI_ContainerItemsTable = {}

SuperAPI = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDebug-2.0", "AceModuleCore-2.0", "AceConsole-2.0", "AceDB-2.0", "AceHook-2.1")
SuperAPI:RegisterDB("SuperAPIDB")
SuperAPI.frame = CreateFrame("Frame", "SuperAPI", UIParent)

function SuperAPI:OnEnable()
	-- Let macro frame allow 511 characters
	MacroFrame_LoadUI();
	MacroFrameText:SetMaxLetters(511);
	MACROFRAME_CHAR_LIMIT = "%d/511 Characters Used";

	-- Change chat bubbles options name
	OPTION_TOOLTIP_PARTY_CHAT_BUBBLES = "Shows whisper, party, raid, and battleground chat text in speech bubbles above characters' heads.";
	PARTY_CHAT_BUBBLES_TEXT = "Show Whisper and Group Chat Bubbles";

	SuperAPI.SetItemRefOriginal = SetItemRef
	-- SuperAPI.SpellButton_OnClickOriginal = SpellButton_OnClick -- must be disabled to fix shift-click spell linking from spellbook into chat window
	SuperAPI.SetItemButtonCountOriginal = SetItemButtonCount
	SuperAPI.SetActionOriginal = GameTooltip.SetAction
	SuperAPI.UnitFrame_OnEnterOriginal = UnitFrame_OnEnter
	SuperAPI.UnitFrame_OnLeaveOriginal = UnitFrame_OnLeave

	-- activate hooks
	SetItemRef = SuperAPI.SetItemRef
	-- SpellButton_OnClick = SuperAPI.SpellButton_OnClick -- must be disabled to fix shift-click spell linking from spellbook into chat window
	SetItemButtonCount = SuperAPI.SetItemButtonCount
	GameTooltip.SetAction = SuperAPI.SetAction
	UnitFrame_OnEnter = SuperAPI.UnitFrame_OnEnter
	UnitFrame_OnLeave = SuperAPI.UnitFrame_OnLeave

	SuperAPI.frame:RegisterEvent("BAG_UPDATE")
	SuperAPI.frame:RegisterEvent("BAG_UPDATE_COOLDOWN")
	SuperAPI.frame:SetScript("OnEvent", SuperAPI.OnEvent)

	-- this chatcommand is empty. It is essential for showing tooltips of macros
	-- the format for showing a tooltip on a macro is EXACTLY this: /tooltip spell:spellid and then skip line
	SLASH_MACROTOOLTIP1 = "/tooltip"
	SlashCmdList["MACROTOOLTIP"] = function(cmd)
	end
	DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00SuperAPI|cffffaaaa Loaded.  Check the minimap icon for options.")
end

function SuperAPI:OnEvent()
	if (event == "BAG_UPDATE_COOLDOWN" or event == "BAG_UPDATE") then
		SUPERAPI_ContainerItemsTable = {}
		for ibag = 0, 4 do
			for islot = 1, GetContainerNumSlots(ibag) do
				local bagitemlink = GetContainerItemLink(ibag, islot)
				if bagitemlink then
					local _, _, bagitemID = strfind(bagitemlink, "item:(%d+)")
					bagitemID = tonumber(bagitemID)
					SUPERAPI_ContainerItemsTable[bagitemID] = { bag = ibag; slot = islot }
				end
			end
		end
	end
end

-- Function to toggle raw combat log mode (Print unit guid instead of unit name in combat log)
-- the actual function is LoggingCombat("RAW", toggle), this is just a helper function to simply it. Note LoggingCombat(toggle) is still used the old way to turn on writing into text file.
function SuperAPI:CombatLogGUID(on)
	local info = ChatTypeInfo["SYSTEM"];
	if on then
		LoggingCombat("RAW", on)
	else
		LoggingCombat("RAW", LoggingCombat("RAW") == 0)
	end

	if LoggingCombat("RAW") == 1 then
		DEFAULT_CHAT_FRAME:AddMessage("Raw GUID logging enabled.", info.r, info.g, info.b, info.id);
	else
		DEFAULT_CHAT_FRAME:AddMessage("Raw GUID logging disabled.", info.r, info.g, info.b, info.id);
	end
end

-- HOOKS --
-- Global function to get a spell link from its exact id
SuperAPI.GetSpellLink = function(id)
	local spellname = SpellInfo(id)
	local link = "\124cffffffff\124Hspell:" .. id .. "\124h[" .. spellname .. "]\124h\124r"
	return link
end

-- reformat "Enchant" itemlinks to better supported "Spell" itemlinks
SuperAPI.SetItemRef = function(link, text, button)
	link = gsub(link, "enchant:", "spell:")
	SuperAPI.SetItemRefOriginal(link, text, button)
end

-- hooking spellbook frame to get a spell link on shift clicking a spell's button with chatframe open
SuperAPI.SpellButton_OnClick = function(drag)
	if ((not drag) and IsShiftKeyDown() and ChatFrameEditBox:IsVisible() and (not MacroFrame or not MacroFrame:IsVisible())) then
		local bookId = SpellBook_GetSpellID(this:GetID());
		local _, _, spellID = GetSpellName(bookId, SpellBookFrame.bookType)
		local link = SuperAPI.GetSpellLink(spellID)
		ChatFrameEditBox:Insert(link)
	else
		SuperAPI.SpellButton_OnClickOriginal(drag)
	end
end

-- hooking bags item button frames to show uses count
SuperAPI.SetItemButtonCount = function(button, count)
	if not button or not count then
		return SuperAPI.SetItemButtonCountOriginal(button, count)
	end
	if (count < 0) then
		if (count < -999) then
			count = "*";
		end
		getglobal(button:GetName() .. "Count"):SetText(-count);
		getglobal(button:GetName() .. "Count"):Show();
		getglobal(button:GetName() .. "Count"):SetFontObject(NumberFontNormalYellow);
	else
		getglobal(button:GetName() .. "Count"):SetFontObject(NumberFontNormal);
		SuperAPI.SetItemButtonCountOriginal(button, count)
	end
end

-- hooking actionbutton tooltip to show item tooltip on macros
SuperAPI.SetAction = function(this, buttonID)
	--local name, actiontype, macroID = GetActionText(buttonID)
	--if actiontype == "MACRO" then
	--	local _,_, body = GetMacroInfo(macroID)
	--	local _,_, itemID = strfind(body, "^/tooltip item:(%d+)")
	--	if itemID then
	--		itemID = tonumber(itemID)
	--		iteminfo = SUPERAPI_ContainerItemsTable[itemID]
	--		if iteminfo then
	--			return this:SetBagItem(iteminfo.bag, iteminfo.slot)
	--		end
	--	end
	--end
	--
	return SuperAPI.SetActionOriginal(this, buttonID)
end

-- Add Mouseover casting to default blizzard unitframes and all unitframe addons that use the same function
SuperAPI.UnitFrame_OnEnter = function()
	SuperAPI.UnitFrame_OnEnterOriginal()
	SetMouseoverUnit(this.unit)
end

SuperAPI.UnitFrame_OnLeave = function()
	SuperAPI.UnitFrame_OnLeaveOriginal()
	SetMouseoverUnit()
end
