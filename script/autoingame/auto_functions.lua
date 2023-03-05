IL("AI")

AI_FPS = 18;
AI_MAXTIME = 5 * 60 * AI_FPS;
AI_REPORTTIME = 2 * 60 * AI_FPS;
AI_ASSISTSKILLTIME = 1 * 60 * AI_FPS;

g_total_time = 0;
g_report_count = 0;
g_assist_count = 0;
g_use_life_potion_delay = 4;
g_use_mana_potion_delay = 4;

function debug_msg(str)
	--NpcChat(GetSelfIndex(), str);
	Msg2Player(str);
end

g_str_dbg = "";
function auto_main()
	g_total_time = mod(g_total_time + 1, AI_MAXTIME);
	g_str_dbg = "Debug";

	if (mod(g_total_time,  AI_REPORTTIME) == 0) then
		g_report_count = g_report_count + 1;
		Msg2Player("§©y lµ b¸o c¸o lÇn <color=yellow>"..g_report_count);
	end

	if (mod(g_total_time, AI_ASSISTSKILLTIME) == 0) then
		g_assist_count = g_assist_count + 1;
		NpcChat(GetSelfIndex(), "Sö dông chiªu Tay Ph¶i lÇn thø <color=green>"..g_assist_count);
		DoAttack(GetRightSkill(), GetSelfIndex());
		g_str_dbg = g_str_dbg..":AssistSkill";
		debug_msg(g_str_dbg);
		return
	end

	life_percent = AI_GetLifePercent();
	if (life_percent < 30) then
		auto_return_to_town();
	elseif (life_percent < 70) then
		if (g_use_life_potion_delay > 0) then
			g_use_life_potion_delay = auto_next_delay(g_use_life_potion_delay);
		else
			auto_use_life_potion();
			auto_reset_use_life_potion_delay();
		end
	end
	if (AI_GetManaPercent() < 40) then
		if (g_use_mana_potion_delay > 0) then
			g_use_mana_potion_delay = auto_next_delay(g_use_mana_potion_delay);
		else
			auto_use_mana_potion();
			auto_reset_use_mana_potion_delay();
		end
	end
end

function auto_use_life_potion()
	if (Eat(1) == 0) then
		auto_return_to_town();
		Msg2Player("HÕt b×nh sinh lùc!");
		return
	else
		Msg2Player("Håi sinh lùc")
	end
end

function auto_use_mana_potion()
	if (Eat(2) == 0) then
		NpcChat(GetSelfIndex(), "HÕt néi lùc råi ®¹i hiÖp ¬i!");
		return
	else
		Msg2Player("Håi néi lùc");
	end
end

function auto_return_to_town()
	ReturnCity(); -- TODO: not working
	Msg2Player("Nguy hiÓm! Trë vÒ thµnh.");
end

function auto_next_delay(delay)
	if (delay > 0) then
		return (delay - 1);
	end
	return 0;
end

function auto_reset_use_life_potion_delay()
	g_use_life_potion_delay = 12;
end

function auto_reset_use_mana_potion_delay()
	g_use_mana_potion_delay = 18;
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
