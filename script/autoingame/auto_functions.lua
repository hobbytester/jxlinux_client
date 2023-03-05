IL("AI")

AI_FPS = 18;
AI_MAXTIME = 5 * 60 * AI_FPS;
AI_REPORTTIME = 2 * 60 * AI_FPS;
AI_ASSISTSKILLTIME = 1 * 60 * AI_FPS;

ai_totaltime = 0
report_count = 0
assist_count = 0

function debug_msg(str)
	--NpcChat(GetSelfIndex(), str);
	Msg2Player(str)
end

function auto_main()
	ai_totaltime = mod(ai_totaltime + 1, AI_MAXTIME);
	dbg_str = "Debug"

	if (mod(ai_totaltime,  AI_REPORTTIME) == 0) then
		report_count = report_count + 1;
		Msg2Player("§©y lµ b¸o c¸o lÇn <color=yellow>"..report_count);
	end

	if (mod(ai_totaltime, AI_ASSISTSKILLTIME) == 0) then
		assist_count = assist_count + 1;
		NpcChat(GetSelfIndex(), "Sö dông chiªu Tay Ph¶i lÇn thø <color=green>"..assist_count);
		DoAttack(GetRightSkill(), GetSelfIndex());
		dbg_str = dbg_str..":AssistSkill"
		debug_msg(dbg_str)
		return
	end
end

auto_attack_enabled = 0

function test_function_2()
	-- delay count
	if not count then
		count = 0
		-- get current pos when script startup
		local w1, x1, y1 = GetWorldPos()
		local range = 500
		set_go_around(x1, y1, range)
	end
	count = mod(count+1, 18) -- 1 giay co 18 khac

	if not count_sec then
		count_sec = 0
	end

	-- moi giay check mana neu nho hon 20% thi bom
	if AI_GetManaPercent() < 20 then
		if count == 1 then
			Eat(2) -- // mana
			Msg2Player("¡n mana")
		end
	end

	if count == 1 then -- Delay 1 giay
		count_sec = mod(count_sec + 1, 10) -- Timer 10 giay
		auto_attack_enabled = go_to_coordinate(GetTaskTemp(1), GetTaskTemp(2), GetTaskTemp(3))
	end

	auto_switch_skills_A_and_S(count)
	if auto_attack_enabled == 1 then
		if count_sec == 1 then -- action ngay lap tuc 0-119
			-- SetTarget(0) -- truoc khi buff 0.5s ???
			DoAttack(150, GetSelfIndex()) -- DoAttack(<ID_SKILL> 150: Tran phai ThienNhan)
			return -- cancel this function - -- issue: double buff due to count_sec is not updated yet
		end

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

function go_to_coordinate(x8, y16, range)
	SetOriginPos(x8*32, y16*32)
	SetActiveRange(range)
	if (KeepActiveRange() == 1) then
		SetTarget(0)
		NpcChat(GetSelfIndex(), "Xa qu¸, quay l¹i "..floor(x8/8).."/"..floor(y16/16)..": "..range)
		return 0
	end
	return 1
end

function set_go_around(x8, y16, range)
	SetOriginPos(x8*32, y16*32)
	SetActiveRange(range)
	SetTaskTemp(1, x8) -- store global 1
	SetTaskTemp(2, y16) -- store global 2
	SetTaskTemp(3, range) -- store global 3
	Msg2Player("Quanh ®iÓm <color=yellow>"..floor(x8/8).."/"..floor(y16/16)..": "..range)
end
