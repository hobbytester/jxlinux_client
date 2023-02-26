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

	auto_switch_skills_A_and_S(count)
	auto_attack()
end

function test_function_3()
	local nTime = GetCurServerTime() + 60 * 60
	ShowFisherUi(nTime)
	Msg2Player("§©y lµ hàm test")
end

function auto_attack()
	Msg2Player("Tu dong danh!")
	SetVisionRadius(600)
	SetActiveRange(2000)
	local TargetIndex = GetNearestNpc()
	SetActiveSkill(GetLeftSkill())
	FollowAttack(TargetIndex)
end

function auto_switch_skills_A_and_S(timer_count)
	-- chuyen skill [A] va [S] moi 0.5s
	Msg2Player("Tu dong chuyen ky nang!")
	if timer_count == 2 then
		ShortcutSkill(3) -- chu A
	elseif timer_count == 11 then -- 50% cua 18 offset 2  = 0.5s
		ShortcutSkill(4) -- chu S
	end
end
