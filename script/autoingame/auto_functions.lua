IL("AI")

AI_FPS = 18;
AI_MAXTIME = 5 * 60 * AI_FPS;
AI_ASSISTSKILLTIME = 1 * 60 * AI_FPS;
AI_ONE_SEC = 1 * AI_FPS;
AI_ATTACK_TIME = 3 * AI_FPS;

g_total_time = 0;
g_sleep_time = 0;
g_do_assist = 0;
g_assist_count = 0;
g_use_life_potion_delay = 4;
g_use_mana_potion_delay = 4;

g_target_index = 0;
g_ai_state = 0;
AI_STATE_FREE = 0;
AI_STATE_ATTACK = 1;

g_stay_around = 0; -- {0: disable, 1: enable}

AI_NPC_LIFE_PRECENT = 100;
g_ai_attack_time = 0;
g_npc_last_life_precent = AI_NPC_LIFE_PRECENT;


function debug_msg(str)
	--NpcChat(GetSelfIndex(), str);
	Msg2Player(str);
end

g_str_dbg = "";
function auto_main()
	g_total_time = mod(g_total_time + 1, AI_MAXTIME);
	g_str_dbg = "["..floor(g_total_time/AI_FPS).."]";

	SetVisionRadius(600); -- Need to set before GetNextNpc() and GetNearestNpc()
	SetActiveRange(2000);

	if (g_sleep_time > 0) then
		g_sleep_time = g_sleep_time - 1;
		return
	end

	if (g_do_assist == 1) then
		g_do_assist = 0;
		auto_do_right_skill();
		debug_msg(g_str_dbg);
		return
	end

	if (mod(g_total_time, AI_ASSISTSKILLTIME) == 0) then
		SetTarget(0);
		g_do_assist = 1;
		g_sleep_time = 0.6 * AI_ONE_SEC; -- Need to stop 0.6s before do right skill
		g_str_dbg = g_str_dbg..":sleep("..g_sleep_time.." frames)";
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

	if (g_stay_around == 1) then
		if (KeepActiveRange() == 1) then
			g_str_dbg = g_str_dbg..":Xa qu¸, quay l¹i!";
			g_target_index = 0;
			SetTarget(g_target_index);
			debug_msg(g_str_dbg);
			return
		end
	end

	if (g_ai_state == AI_STATE_FREE) then
		g_target_index = GetNearestNpc(); --auto_get_next_npc();
		SetTarget(g_target_index);
		if (g_target_index > 0) then
			g_ai_state = AI_STATE_ATTACK;
			g_ai_attack_time = AI_ATTACK_TIME;
		else
			g_str_dbg = g_str_dbg..":Ngåi ®îi";
			Sit();
		end
	end

	if (g_ai_state == AI_STATE_ATTACK) then
		auto_attack_target(g_target_index);
	end

	if (mod(g_total_time,  AI_ONE_SEC) == 0) then
		debug_msg(g_str_dbg);
	end
end

function auto_do_right_skill()
	g_assist_count = g_assist_count + 1;
	NpcChat(GetSelfIndex(), "Sö dông chiªu Tay Ph¶i lÇn thø <color=green>"..g_assist_count);
	DoAttack(GetRightSkill(), GetSelfIndex());
	g_str_dbg = g_str_dbg..":RightSkill";
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

function auto_get_next_npc()
	npc_id = 0;
	for i = 1, 10 do
		npc_id = GetNextNpc(i);
		if (npc_id <=  0) then
			break
		end
		g_str_dbg = g_str_dbg..":Npc["..npc_id.."]";
		return npc_id;
	end
	g_str_dbg = g_str_dbg..":Npc["..npc_id.."]";
	return npc_id;
end

function auto_attack_target(target_index)
	npc_id = GetCNpcId(target_index);
	if (npc_id == 0) then
		g_ai_state = AI_STATE_FREE;
	else
		g_str_dbg = g_str_dbg..":Npc["..npc_id.."]:Attack["..target_index.."]";
		auto_try_attack(target_index);
	end
end

function auto_try_attack(target_index)
	g_ai_attack_time = g_ai_attack_time - 1;
	if (g_ai_attack_time <= 0) then
		local npc_life_precent = AI_GetLifePercent(target_index);
		if (g_npc_last_life_precent ~= npc_life_precent) then
			if npc_life_precent == 0 then
				g_npc_last_life_precent = AI_NPC_LIFE_PRECENT;
			else
				g_npc_last_life_precent = npc_life_precent;
			end
			g_ai_attack_time = AI_ATTACK_TIME;
			NpcChat(GetSelfIndex(), "TiÕp tôc ®¸nh Npc["..target_index.."] <color=red>"..npc_life_precent.."%<color>");
		else
			NpcChat(GetSelfIndex(), "Npc["..target_index.."] <color=cyan>bÞ lag<color>! "..g_npc_last_life_precent.."% vs "..npc_life_precent.."%");
			-- Add missed NPC --
			g_ai_state = AI_STATE_FREE;
			return
		end
	end
	auto_do_attack(target_index);
end

function auto_do_attack(target_index)
	SetVisionRadius(1200);
	SetActiveSkill(GetLeftSkill());
	FollowAttack(target_index);
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
