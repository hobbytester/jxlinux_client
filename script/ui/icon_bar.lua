if MODEL_GAMECLIENT ~= 1 then
	return
end

function OnClickIcon_0()
	OpenArenaUi()
	--IconBar_SetTwinkle(0, 0)
end

function OnClickIcon_1()
	OpenActivityGuideUi()
	--IconBar_SetTwinkle(1, 0)
end

function OnClickIcon_2()
	local szScript = "\\script\\autoingame\\auto_functions.lua"
	Require(szScript)
	DynamicExecute(szScript, "auto_toggle_auto_attack")
	--local szScript = "\\script\\event\\bingo_machine\\bingo_machine_c.lua"
	--Require(szScript)
	--DynamicExecute(szScript, "BingoMachine:ApplyOpenWindon", "")
end

function OnClickIcon_3()
	local szScript = "\\script\\event\\bingo_machine\\bingo_machine_c.lua"
	Require(szScript)
	DynamicExecute(szScript, "BingoMachine:ApplyOpenShop", "")
end

function OnClickIcon_4()
	local w1, x1, y1 = GetWorldPos()
	local range = 600
	local szScript = "\\script\\autoingame\\auto_functions.lua"
	Require(szScript)
	DynamicExecute(szScript, "auto_toggle_stay_around", x1, y1, range)
	--OpenPetUi()
end

function OnClickIcon_5()
	local szScript = "\\script\\event\\prize\\ui.lua"
	Require(szScript)
	DynamicExecute(szScript, "tbLoginPrize:ApplyData", "")
end

function OnClickIcon_6()
	OpenFuncPrize()
end