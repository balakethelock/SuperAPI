local SUPERAPIHOOK_SetItemRefOriginal = SetItemRef
local SUPERAPIHOOK_SpellButton_OnClickOriginal = SpellButton_OnClick
local SUPERAPIHOOK_SetItemButtonCountOriginal = SetItemButtonCount
local SUPERAPIHOOK_SetActionOriginal = GameTooltip.SetAction
local SUPERAPIHOOK_UnitFrame_OnEnterOriginal = UnitFrame_OnEnter
local SUPERAPIHOOK_UnitFrame_OnLeaveOriginal = UnitFrame_OnLeave

SUPERAPI_ContainerItemsTable = {}

function SuperAPI_Load()

	-- if client was not launched with the mod, shutdown
	if not SetAutoloot then this:SetScript("OnUpdate", nil) return end
	
	-- Let macro frame allow 511 characters
	MacroFrame_LoadUI();
	MacroFrameText:SetMaxLetters(511);
	MACROFRAME_CHAR_LIMIT = "%d/511 Characters Used";

	-- Change chat bubbles options name
	OPTION_TOOLTIP_PARTY_CHAT_BUBBLES = "Shows whisper, party, raid, and battleground chat text in speech bubbles above characters' heads.";
	PARTY_CHAT_BUBBLES_TEXT = "Show Whisper and Group Chat Bubbles";
	
	
	SetItemRef = SUPERAPIHOOK_SetItemRef
	SpellButton_OnClick = SUPERAPIHOOK_SpellButton_OnClick
	SetItemButtonCount = SUPERAPIHOOK_SetItemButtonCount
	GameTooltip.SetAction = SUPERAPIHOOK_SetAction
	UnitFrame_OnEnter = SUPERAPIHOOK_UnitFrame_OnEnter
	UnitFrame_OnLeave = SUPERAPIHOOK_UnitFrame_OnLeave
	
	this:RegisterEvent("PLAYER_ENTERING_WORLD")
	this:RegisterEvent("BAG_UPDATE")
	this:RegisterEvent("BAG_UPDATE_COOLDOWN")
	this:SetScript("OnEvent", SuperAPI_OnEvent)

	-- this chatcommand is empty. It is essential for showing tooltips of macros
	-- the format for showing a tooltip on a macro is EXACTLY this: /tooltip spell:spellid and then skip line
	SLASH_MACROTOOLTIP1 = "/tooltip"
	SlashCmdList["MACROTOOLTIP"] = function(cmd) end

end

function SuperAPI_Update(elapsed)
	IfShiftAutoloot()
end

function SuperAPI_OnEvent()
	if (event == "BAG_UPDATE_COOLDOWN" or event == "BAG_UPDATE") then
		SUPERAPI_ContainerItemsTable = {}
		for ibag = 0, 4 do
			for islot = 1, GetContainerNumSlots(ibag) do
				local bagitemlink = GetContainerItemLink(ibag, islot)
				if bagitemlink then
					local _,_,bagitemID = strfind(bagitemlink, "item:(%d+)")
					bagitemID = tonumber(bagitemID)
					SUPERAPI_ContainerItemsTable[bagitemID] = { bag = ibag ; slot = islot}
				end
			end
		end
	end
end

-- Runs on update to get back old functionality of autoloot on shift. You can hook this away into an empty function to control Autoloot however you want.
function IfShiftAutoloot()
	if IsShiftKeyDown() then 
		SetAutoloot(1)
	else
		SetAutoloot(0)
	end
end


-- Function to toggle raw combat log mode (Print unit guid instead of unit name in combat log)
-- the actual function is LoggingCombat("RAW", toggle), this is just a helper function to simply it. Note LoggingCombat(toggle) is still used the old way to turn on writing into text file.
function CombatLogGUID(on)
	local info = ChatTypeInfo["SYSTEM"];
	if on then LoggingCombat("RAW", on) else LoggingCombat("RAW", LoggingCombat("RAW") == 0) end
	
	if LoggingCombat("RAW") == 1 then
		DEFAULT_CHAT_FRAME:AddMessage("Raw GUID logging enabled.", info.r, info.g, info.b, info.id);
	else
		DEFAULT_CHAT_FRAME:AddMessage("Raw GUID logging disabled.", info.r, info.g, info.b, info.id);
	end
end

-- Global function to get a spell link from its exact id
function GetSpellLink(id)
	local spellname = SpellInfo(id)
	local link = "\124cffffffff\124Hspell:"..id.."\124h["..spellname.."]\124h\124r"
	return link
end



-- reformat "Enchant" itemlinks to better supported "Spell" itemlinks
function SUPERAPIHOOK_SetItemRef(link, text, button)
	link = gsub(link, "enchant:", "spell:")
	SUPERAPIHOOK_SetItemRefOriginal(link, text, button)
end

-- hooking spellbook frame to get a spell link on shift clicking a spell's button with chatframe open
function SUPERAPIHOOK_SpellButton_OnClick(drag)
	if ( (not drag) and IsShiftKeyDown() and ChatFrameEditBox:IsVisible() and (not MacroFrame or not MacroFrame:IsVisible())) then
		local bookId = SpellBook_GetSpellID(this:GetID());
		local _,_, spellID = GetSpellName(bookId, SpellBookFrame.bookType)
		local link = GetSpellLink(spellID)
		ChatFrameEditBox:Insert(link)
	else
		SUPERAPIHOOK_SpellButton_OnClickOriginal(drag)
	end
end

-- hooking bags item button frames to show uses count
function SUPERAPIHOOK_SetItemButtonCount(button, count)
	count = type(count) == "number" and count or 0
	SUPERAPIHOOK_SetItemButtonCountOriginal(button, math.abs(count))
	if not button then
		return
	end
	if (count < 0) then
		button.count = 0
		getglobal(button:GetName().."Count"):SetFontObject(NumberFontNormalYellow)
	else
		getglobal(button:GetName().."Count"):SetFontObject(NumberFontNormal)
	end
end

-- hooking actionbutton tooltip to show item tooltip on macros
function SUPERAPIHOOK_SetAction(this, buttonID)
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
	return SUPERAPIHOOK_SetActionOriginal(this, buttonID)
end

-- Add Mouseover casting to default blizzard unitframes and all unitframe addons that use the same function
function SUPERAPIHOOK_UnitFrame_OnEnter()
	SUPERAPIHOOK_UnitFrame_OnEnterOriginal()
	SetMouseoverUnit(this.unit)
end

function SUPERAPIHOOK_UnitFrame_OnLeave()
	SUPERAPIHOOK_UnitFrame_OnLeaveOriginal()
	SetMouseoverUnit()
end
