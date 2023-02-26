IL("AI")

count = 0
auto_attack_enabled = 0

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

	if count == 1 then -- Delay 1 giay
		-- Danh quanh diem
		x_cor = 193
		y_cor = 204
		SetOriginPos(x_cor*8*32, y_cor*16*32)
		SetActiveRange(500)
		if (KeepActiveRange() == 1) then
			auto_attack_enabled = 0
			SetTarget(0)
			NpcChat(GetSelfIndex(), "Xa qu¸, quay l¹i!")
		else
			auto_attack_enabled = 1
		end
	end

	auto_switch_skills_A_and_S(count)
	if auto_attack_enabled == 1 then
		auto_attack()
	end
end

function test_function_3()
	local nTime = GetCurServerTime() + 60 * 60
	ShowFisherUi(nTime)
	Msg2Player("§©y lµ hàm test")
end

function auto_attack()
	-- Msg2Player("Tù ®éng ®¸nh!")
	SetVisionRadius(600)
	SetActiveRange(2000)
	local TargetIndex = GetNearestNpc()
	SetActiveSkill(GetLeftSkill())
	FollowAttack(TargetIndex)
end

function auto_switch_skills_A_and_S(timer_count)
	-- Msg2Player("Tù ®éng chuyÓn kü n¨ng gi÷a [A] vµ [S]!")
	if timer_count == 2 then
		ShortcutSkill(3) -- chu A
	elseif timer_count == 11 then -- 50% cua 18 offset 2  = 0.5s
		ShortcutSkill(4) -- chu S
	end
end
