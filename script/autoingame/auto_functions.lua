IL("AI")

count = 0

function test_function_2()
	-- delay count
	if not count then
		count = 0
	end
	count = mod(count+1, 18) -- 1 giay co 18 khac

	-- moi giay check mana neu nho hon 20% thi bom
	if AI_GetManaPercent() < 20 then
		if count == 1 then
			Eat(2) -- // mana
			Msg2Player("¡n mana")
		end
	end

	-- chuyen skill [A] va [S] moi 0.5s
	if count == 2 then
		ShortcutSkill(3) -- chu A
	elseif count == 11 then -- 50% cua 18 offset 2
		ShortcutSkill(4) -- chu S
	end

	-- tu dong danh
	SetVisionRadius(600)
	SetActiveRange(2000)
	local TargetIndex = GetNearestNpc()
	SetActiveSkill(GetLeftSkill())
	FollowAttack(TargetIndex)
	-- Msg2Player("§©y lµ nót Tù ®éng ®¸nh")
end

function test_function_3()
	local nTime = GetCurServerTime() + 60 * 60
	ShowFisherUi(nTime)
	Msg2Player("§©y lµ hàm test")
end
