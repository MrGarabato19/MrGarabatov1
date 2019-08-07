local Utility = {}

Utility.AncientCreepNameList = {
    "npc_dota_neutral_black_drake",
    "npc_dota_neutral_black_dragon",
    "npc_dota_neutral_granite_golem",
    "npc_dota_neutral_prowler_acolyte",
    "npc_dota_neutral_prowler_shaman",
    "npc_dota_neutral_rock_golem",
    "npc_dota_neutral_big_thunder_lizard",
    "npc_dota_neutral_small_thunder_lizard",
    "npc_dota_roshan"
}

function Utility.GetAttackDamageVersus(source, target)
    return NPC.GetDamageMultiplierVersus(source, target)
end

function Utility.HasItemOrAbility(npc, name)
    if NPC.HasAbility(npc, name) then
        return true
    elseif NPC.HasItem(npc, name, true) then
        return true
    else
        return false
    end
end

function Utility.GetItemOrAbility(npc, name)
    if NPC.GetAbility(npc, name) then
        return NPC.GetAbility(npc, name)
    elseif NPC.GetItem(npc, name, true) then
        return NPC.GetItem(npc, name, true)
    else
        return nil
    end
end

function Utility.Attack(source, target)
    Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET, target, Vector(0,0,0), ability, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, source)
end

function Utility.IsInAbilityPhase(myHero)
	if not myHero then return false end
    if NPC.HasModifier(myHero, "modifier_spirit_breaker_charge_of_darkness") then return true end
	local myAbilities = {}

	for i= 0, 10 do
		local ability = NPC.GetAbilityByIndex(myHero, i)
		if ability and Entity.IsAbility(ability) and Ability.GetLevel(ability) > 0 then
			table.insert(myAbilities, ability)
		end
	end

	if #myAbilities < 1 then return false end

	for _, v in ipairs(myAbilities) do
		if v then
			if Ability.IsInAbilityPhase(v) then
				return true
			end
		end
	end

	return false
end

function Utility.Check(ability, source, target)
    if not Utility.HasItemOrAbility(source, ability) then return false end
    if target == "pos" then return true end -- for blink dagger
    if Entity.IsDormant(target) or Entity.GetHealth(target) <= 0 or NPC.IsWaitingToSpawn(target) or not Entity.IsAlive(target) then return false end
    for i, name in ipairs(Utility.UntargetableUnits) do
        if NPC.GetUnitName(target) == name then return false end
    end
    trueAbility = Utility.GetItemOrAbility(source, ability)
    if not NPC.IsEntityInRange(source, target, Ability.GetCastRange(trueAbility)) then return false end
    if NPC.IsPositionInRange(source, NPC.GetAbsOrigin(target), Ability.GetCastRange(trueAbility), 0) and Utility.IsSuitableToCastSpell(source) and Utility.CanCastSpellOn(target) and not Ability.IsInAbilityPhase(trueAbility) and not Utility.IsDisabled(source) and Ability.IsCastable(trueAbility, NPC.GetMana(source)) and Ability.IsReady(trueAbility) then return true else return false end
end

function Utility.Use(ability, source, target)
    if ability == "auto_attack" then Utility.Attack(source, target) return end
    if not Utility.Check(ability, source, target) then return end
    if ability == "item_blink" then Utility.Blink(source, target) return end
    trueAbility = Utility.GetItemOrAbility(source, ability)
    local abilityType = Utility.GetAbilityType(trueAbility)
    if abilityType == "CastPosition" then
        if not NPC.IsEntityInRange(source, target, Ability.GetCastRange(trueAbility)) then end
        Ability.CastPosition(trueAbility, target)
    elseif abilityType == "CastNoTarget" then
        Ability.CastNoTarget(trueAbility)
    elseif abilityType == "CastTarget" then
        if not NPC.IsEntityInRange(source, target, Ability.GetCastRange(trueAbility)) then end
        Ability.CastTarget(trueAbility, target)
    end
end

-- function Utility.GetAbilityType(ability)
--     if 
-- end

function Utility.Move(source, target)
    Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, target, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, source)
end

function Utility.GetNearestHeroToCursor()
    local myHero = Heroes.GetLocal()
    local cursorPos = Input.GetWorldCursorPos()
    local distTable = {}
    local firstDist = 99999
    local secondDist = 99999
    local closestNPC = nil
    for i = 1, NPCs.Count() do
      local npc = NPCs.Get(i)
      if npc and Entity.GetHealth(npc) > 0 and not Entity.IsSameTeam(myHero, npc) and not Entity.IsDormant(npc) and NPC.IsPositionInRange(npc, cursorPos, 2500) and not NPC.IsIllusion(npc) and (NPC.IsHero(npc) or NPC.HasModifier(npc, "modifier_morphling_replicate_timer")) then --  
        local npcPos = Entity.GetAbsOrigin(npc)
        secondDist = (cursorPos - npcPos):Length2D()
        if secondDist and firstDist and secondDist < firstDist and npc then
          firstDist = secondDist
          closestNPC = npc
        end
      end
    end
    if closestNPC ~= nil then return closestNPC else return nil end
  end

  function Utility.GetNearestHeroToNpc(npcPassed)
    local myHero = Heroes.GetLocal()
    local cursorPos = Entity.GetAbsOrigin(npcPassed)
    local distTable = {}
    local firstDist = 99999
    local secondDist = 99999
    local closestNPC = nil
    for i = 1, NPCs.Count() do
      local npc = NPCs.Get(i)
      if npc and Entity.GetHealth(npc) > 0 and not Entity.IsSameTeam(myHero, npc) and NPC.IsPositionInRange(npc, cursorPos, 2500) and not NPC.IsIllusion(npc) and (NPC.IsHero(npc) or NPC.HasModifier(npc, "modifier_morphling_replicate_timer")) then --  
        local npcPos = Entity.GetAbsOrigin(npc)
        secondDist = (cursorPos - npcPos):Length2D()
        if secondDist and firstDist and secondDist < firstDist and npc then
          firstDist = secondDist
          closestNPC = npc
        end
      end
    end
    if closestNPC ~= nil then return closestNPC else return nil end
  end

-- return best position to cast certain spells
-- eg. axe's call, void's chrono, enigma's black hole
-- input  : unitsAround, radius
-- return : positon (a vector)
function Utility.BestPosition(unitsAround, radius)
    if not unitsAround or #unitsAround <= 0 then return nil end
    local enemyNum = #unitsAround

	if enemyNum == 1 then return Entity.GetAbsOrigin(unitsAround[1]) end

	-- find all mid points of every two enemy heroes,
	-- then find out the best position among these.
	-- O(n^3) complexity
	local maxNum = 1
	local bestPos = Entity.GetAbsOrigin(unitsAround[1])
	for i = 1, enemyNum-1 do
		for j = i+1, enemyNum do
			if unitsAround[i] and unitsAround[j] then
				local pos1 = Entity.GetAbsOrigin(unitsAround[i])
				local pos2 = Entity.GetAbsOrigin(unitsAround[j])
				local mid = pos1:__add(pos2):Scaled(0.5)

				local heroesNum = 0
				for k = 1, enemyNum do
					if NPC.IsPositionInRange(unitsAround[k], mid, radius, 0) then
						heroesNum = heroesNum + 1
					end
				end

				if heroesNum > maxNum then
					maxNum = heroesNum
					bestPos = mid
				end

			end
		end
	end

	return bestPos
end

-- return predicted position
function Utility.GetPredictedPosition(npc, delay)
    local pos = Entity.GetAbsOrigin(npc)
    if Utility.CantMove(npc) then return pos end
    if not NPC.IsRunning(npc) or not delay then return pos end

    local dir = Entity.GetRotation(npc):GetForward():Normalized()
    local speed = Utility.GetMoveSpeed(npc)

    return pos + dir:Scaled(speed * delay)
end

-- return predicted position
function Utility.GetPredictedPositionAround(npc, delay)
    local pos = Entity.GetAbsOrigin(npc)
    if Utility.CantMove(npc) then return pos end
    if not NPC.IsRunning(npc) or not delay then return pos end

    local dir = Entity.GetRotation(npc):GetRight():Normalized()
    local speed = Utility.GetMoveSpeed(npc)

    return pos + dir:Scaled(speed * delay)
end

Utility.BaseMoveSpeeds = {
    {"npc_dota_neutral_granite_golem", 270},
    {"npc_dota_neutral_black_dragon", 300},
    {"npc_dota_neutral_big_thunder_lizard", 270},
    {"npc_dota_neutral_prowler_acolyte", 270},
    {"npc_dota_neutral_prowler_shaman", 300},
    {"npc_dota_neutral_satyr_hellcaller", 290},
    {"npc_dota_neutral_dark_troll_warlord", 320},
    {"npc_dota_neutral_centaur_khan", 320},
    {"npc_dota_neutral_enraged_wildkin", 320},
    {"npc_dota_neutral_alpha_wolf", 350},
    {"npc_dota_neutral_ogre_magi", 270},
    {"npc_dota_neutral_polar_furbolg_ursa_warrior", 320},
    {"npc_dota_neutral_harpy_storm", 310},
    {"npc_dota_neutral_mud_golem", 310},
    {"npc_dota_neutral_ghost", 320},
    {"npc_dota_neutral_forest_troll_high_priest", 290},
    {"npc_dota_neutral_kobold_taskmaster", 330},
    {"npc_dota_invoker_forged_spirit", 320},
    {"npc_dota_beastmaster_boar_4", 350},
    {"npc_dota_beastmaster_boar_3", 350},
    {"npc_dota_beastmaster_boar_2", 350},
    {"npc_dota_beastmaster_boar", 350},
    {"npc_dota_beastmaster_boar_1", 350},
    {"npc_dota_necronomicon_archer_3", 390},
    {"npc_dota_necronomicon_warrior_3", 350},
    {"npc_dota_necronomicon_warrior_2", 350},
    {"npc_dota_necronomicon_archer_2", 360},
    {"npc_dota_necronomicon_warrior_1", 350},
    {"npc_dota_necronomicon_archer_1", 330},
    {"npc_dota_lycan_wolf4", 460},
    {"npc_dota_lycan_wolf3", 440}
}

function Utility.GetMoveSpeed(enemy)
    if not enemy then return end

    local base_speed = NPC.GetMoveSpeed(enemy)
    local bonus_speed = 0
    local modifierHex
    local modSheep = NPC.HasModifier(enemy, "modifier_sheepstick_debuff")
    local modLionVoodoo = NPC.HasModifier(enemy, "modifier_lion_voodoo")
    local modShamanVoodoo = NPC.HasModifier(enemy, "modifier_shadow_shaman_voodoo")

    for _, bms in ipairs(Utility.BaseMoveSpeeds) do
        if bms[1] == NPC.GetUnitName(enemy) then
            if NPC.HasModifier(enemy, "modifier_dominated") and not NPC.HasModifier(enemy, "modifier_chen_holy_persuasion") then
                base_speed = 425
                bonus_speed = 0
            else
                base_speed = bms[2]
                bonus_speed = 0
            end
        end
    end

    if NPC.HasModifier(enemy, "modifier_kobold_taskmaster_speed_aura") or NPC.HasModifier(enemy, "modifier_kobold_taskmaster_speed_aura_bonus") or NPC.GetUnitName(enemy) == "npc_dota_neutral_kobold_taskmaster" then
        bonus_speed = base_speed * 0.12
    end
  
    if modSheep then
      modifierHex = modSheep
    end
    if modLionVoodoo then
      modifierHex = modLionVoodoo
    end
    if modShamanVoodoo then
      modifierHex = modShamanVoodoo
    end

    -- if NPC.HasModifier(enemy, "modifier_dominated") then
    --     Log.Write("has")
    --     return 425 + bonus_speed
    -- end
  
    if modifierHex then
      if math.max(Modifier.GetDieTime(modifierHex) - GameRules.GetGameTime(), 0) > 0 then
        return 140 + bonus_speed
      end
    end
  
    if NPC.HasModifier(enemy, "modifier_invoker_ice_wall_slow_debuff") then
      return 100
    end
  
    if NPC.HasModifier(enemy, "modifier_invoker_cold_snap_freeze") or NPC.HasModifier(enemy, "modifier_invoker_cold_snap") then
      return (base_speed + bonus_speed) * 0.5
    end

    if NPC.HasModifier(enemy, "modifier_rune_haste") then
        return 550
    end
  
    if NPC.HasModifier(enemy, "modifier_spirit_breaker_charge_of_darkness") then
      local chargeAbility = NPC.GetAbility(enemy, "spirit_breaker_charge_of_darkness")
      if chargeAbility then
        local specialAbility = NPC.GetAbility(enemy, "special_bonus_unique_spirit_breaker_2")
        if specialAbility then
          if Ability.GetLevel(specialAbility) < 1 then
            return Ability.GetLevel(chargeAbility) * 50 + 550
          else
            return Ability.GetLevel(chargeAbility) * 50 + 1050
          end
        end
      end
    end
    return base_speed + bonus_speed
end

-- return true if is protected by lotus orb or AM's aghs
function Utility.IsLotusProtected(npc)
	if NPC.HasModifier(npc, "modifier_item_lotus_orb_active") then return true end

	local shield = NPC.GetAbility(npc, "antimage_spell_shield")
	if shield and Ability.IsReady(shield) and NPC.HasItem(npc, "item_ultimate_scepter", true) then
		return true
	end

	return false
end

-- extend NPC.IsLinkensProtected(), check AM's aghs case
function Utility.IsLinkensProtected(npc)
    local shield = NPC.GetAbility(npc, "antimage_spell_shield")
	if shield and Ability.IsReady(shield) and NPC.HasItem(npc, "item_ultimate_scepter", true) then
		return true
	end

    return NPC.IsLinkensProtected(npc)
end

-- return true if this npc is disabled, return false otherwise
function Utility.IsDisabled(npc)
	if not Entity.IsAlive(npc) then return true end
	if NPC.IsStunned(npc) then return true end
	if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_HEXED) then return true end

    return false
end

-- return true if can cast spell on this npc, return false otherwise
function Utility.CanCastSpellOn(npc)
	if Entity.IsDormant(npc) or not Entity.IsAlive(npc) then return false end
    if NPC.IsStructure(npc) then return false end
    for i, name in ipairs(Utility.UntargetableUnits) do
        if NPC.GetUnitName(npc) == name then return false end
    end
	if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then return false end
    if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then return false end
    if NPC.HasModifier(npc, "modifier_eul_cyclone") then return false end

	return true
end

-- check if it is safe to cast spell or item on enemy
-- in case enemy has blademail or lotus.
-- Caster will take double damage if target has both lotus and blademail
function Utility.IsSafeToCast(myHero, enemy, magic_damage)
    if not myHero or not enemy or not magic_damage then return true end
    if magic_damage <= 0 then return true end

    local counter = 0
    if NPC.HasModifier(enemy, "modifier_item_lotus_orb_active") then counter = counter + 1 end
    if NPC.HasModifier(enemy, "modifier_item_blade_mail_reflect") then counter = counter + 1 end

    local reflect_damage = counter * magic_damage * NPC.GetMagicalArmorDamageMultiplier(myHero)
    return Entity.GetHealth(myHero) > reflect_damage
end

-- situations that ally need to be saved
function Utility.NeedToBeSaved(npc)
	if not npc or NPC.IsIllusion(npc) or not Entity.IsAlive(npc) then return false end

	if NPC.IsStunned(npc) or NPC.IsSilenced(npc) then return true end
	if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_ROOTED) then return true end
	if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_DISARMED) then return true end
	if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_HEXED) then return true end
	if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_PASSIVES_DISABLED) then return true end
	if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_BLIND) then return true end

	if Entity.GetHealth(npc) <= 0.3 * Entity.GetMaxHealth(npc) then return true end

	return false
end

-- pop all defensive items
function Utility.PopDefensiveItems(myHero)
	if not myHero then return end

    -- blade mail
    if NPC.HasItem(myHero, "item_blade_mail", true) then
    	local item = NPC.GetItem(myHero, "item_blade_mail", true)
    	if Ability.IsCastable(item, NPC.GetMana(myHero)) then
    		Ability.CastNoTarget(item)
    	end
    end

    -- hood of defiance
    if NPC.HasItem(myHero, "item_hood_of_defiance", true) then
    	local item = NPC.GetItem(myHero, "item_hood_of_defiance", true)
    	if Ability.IsCastable(item, NPC.GetMana(myHero)) then
    		Ability.CastNoTarget(item)
    	end
    end

    -- pipe of insight
    if NPC.HasItem(myHero, "item_pipe", true) then
    	local item = NPC.GetItem(myHero, "item_pipe", true)
    	if Ability.IsCastable(item, NPC.GetMana(myHero)) then
    		Ability.CastNoTarget(item)
    	end
    end

-- buckler
    if NPC.HasItem(myHero, "item_buckler", true) then
    	local item = NPC.GetItem(myHero, "item_buckler", true)
    	if Ability.IsCastable(item, NPC.GetMana(myHero)) then
    		Ability.CastNoTarget(item)
    	end
    end

    -- crimson guard
    if NPC.HasItem(myHero, "item_crimson_guard", true) then
    	local item = NPC.GetItem(myHero, "item_crimson_guard", true)
    	if Ability.IsCastable(item, NPC.GetMana(myHero)) then
    		Ability.CastNoTarget(item)
    	end
    end

    -- shiva's guard
    if NPC.HasItem(myHero, "item_shivas_guard", true) then
    	local item = NPC.GetItem(myHero, "item_shivas_guard", true)
    	if Ability.IsCastable(item, NPC.GetMana(myHero)) then
    		Ability.CastNoTarget(item)
    	end
    end

    -- lotus orb
    if NPC.HasItem(myHero, "item_lotus_orb", true) then
    	local item = NPC.GetItem(myHero, "item_lotus_orb", true)
    	if Ability.IsCastable(item, NPC.GetMana(myHero)) then
    		Ability.CastTarget(item, myHero)
    	end
    end

    -- mjollnir
    if NPC.HasItem(myHero, "item_mjollnir", true) then
    	local item = NPC.GetItem(myHero, "item_mjollnir", true)
    	if Ability.IsCastable(item, NPC.GetMana(myHero)) then
    		Ability.CastTarget(item, myHero)
    	end
    end

end

function Utility.IsAncientCreep(npc)
    if not npc then return false end

    for i, name in ipairs(Utility.AncientCreepNameList) do
        if name and NPC.GetUnitName(npc) == name then return true end
    end

    return false
end

function Utility.CantMove(npc)
    if not npc then return false end

    if NPC.IsRooted(npc) or Utility.GetStunTimeLeft(npc) >= 1 then return true end
    if Utility.GetFrozenTimeLeft(npc) >= 1 then return true end
    if NPC.HasModifier(npc, "modifier_axe_berserkers_call") then return true end
    if NPC.HasModifier(npc, "modifier_legion_commander_duel") then return true end
    if Utility.GetFixTimeLeft(npc) >= 1 then return true end
    if NPC.IsStunned(npc) then return true end
	if NPC.HasModifier(npc, "modifier_bashed") then return true end
	if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then return true end	
	if NPC.HasModifier(npc, "modifier_eul_cyclone") then return true end
	if NPC.HasModifier(npc, "modifier_obsidian_destroyer_astral_imprisonment_prison") then return true end
	if NPC.HasModifier(npc, "modifier_shadow_demon_disruption") then return true end	
	if NPC.HasModifier(npc, "modifier_invoker_tornado") then return true end
	if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_HEXED) then return true end
	if NPC.HasModifier(npc, "modifier_legion_commander_duel") then return true end
	if NPC.HasModifier(npc, "modifier_axe_berserkers_call") then return true end
	if NPC.HasModifier(npc, "modifier_winter_wyvern_winters_curse") then return true end
	if NPC.HasModifier(npc, "modifier_bane_fiends_grip") then return true end
	if NPC.HasModifier(npc, "modifier_bane_nightmare") then return true end
	if NPC.HasModifier(npc, "modifier_faceless_void_chronosphere_freeze") then return true end
	if NPC.HasModifier(npc, "modifier_enigma_black_hole_pull") then return true end
	if NPC.HasModifier(npc, "modifier_magnataur_reverse_polarity") then return true end
	if NPC.HasModifier(npc, "modifier_pudge_dismember") then return true end
	if NPC.HasModifier(npc, "modifier_shadow_shaman_shackles") then return true end
	if NPC.HasModifier(npc, "modifier_techies_stasis_trap_stunned") then return true end
	if NPC.HasModifier(npc, "modifier_storm_spirit_electric_vortex_pull") then return true end
	if NPC.HasModifier(npc, "modifier_tidehunter_ravage") then return true end
	if NPC.HasModifier(npc, "modifier_windrunner_shackle_shot") then return true end
    if NPC.HasModifier(npc, "modifier_item_nullifier_mute") then return true end
    if Utility.IsDisabled(npc) then return true end

    return false
end


-- Reference: https://dota2.gamepedia.com/Stun
-- black items on the list seems are not included in "modifier_stunned"
Utility.StunModifiers = {
    "modifier_stunned",
    "modifier_bashed",
    "modifier_jakiro_ice_path_stun", 
    "modifier_kunkka_torrent",
    "modifier_earthshaker_fissure_stun",
    "modifier_rattletrap_hookshot",
    "modifier_keeper_of_the_light_mana_leak_stun", 
    "modifier_earth_spirit_boulder_smash",
    "modifier_faceless_void_chronosphere_freeze",
    "modifier_alchemist_unstable_concoction", 
    "modifier_antimage_mana_void",
    "modifier_morphling_adaptive_strike", 
    "modifier_bane_fiends_grip",
    "modifier_batrider_flaming_lasso",
    "modifier_beastmaster_primal_roar",
    "modifier_enigma_black_hole",
    "modifier_enigma_black_hole_pull",
    "modifier_faceless_void_chronosphere",
    "modifier_crystal_maiden_frostbite", 
    "modifier_kunkka_ghostship",
    "modifier_luna_eclipse",
    "modifier_lion_impale", 
    "modifier_naga_siren_ensnare", 
    "modifier_storm_spirit_electric_vortex_pull",
    "modifier_magnataur_reverse_polarity",
    "modifier_medusa_stone_gaze_stone", 
    "modifier_ember_spirit_searing_chains", 
    "modifier_naga_siren_song_of_the_siren",
    "modifier_necrolyte_reapers_scythe",
    "modifier_pangolier_gyroshell",
    "modifier_pudge_dismember", 
    "modifier_puck_dream_coil",
    "modifier_pudge_dismember",
    "modifier_rattletrap_hookshot",
    "modifier_nyx_assassin_impale", 
    "modifier_sandking_impale", 
    "modifier_tidehunter_ravage",
    "modifier_tusk_walrus_punch",
    "modifier_warlock_rain_of_chaos",
    "modifier_winter_wyvern_winters_curse_aura",
    "modifier_windrunner_shackle_shot",
    "modifier_shadow_shaman_shackles", 
    "modifier_ancientapparition_coldfeet_freeze"
}
--    "modifier_phoenix_supernova",
--    "modifier_windrunner_focusfire",

-- Reference: https://dota2.gamepedia.com/Sleep
Utility.SleepModifiers = {
    "modifier_bane_nightmare",
    "modifier_elder_titan_echo_stomp",
    "modifier_naga_siren_song_of_the_siren"
}

-- Reference: https://dota2.gamepedia.com/Root
Utility.RootModifiers = {
    "modifier_abyssal_underlord_pit_of_malice_ensare",
    "modifier_crystal_maiden_frostbite",
    "modifier_dark_troll_warlord_ensnare",
    "modifier_dark_willow_bramble_maze",
    "modifier_ember_spirit_searing_chains",
    "modifier_lone_druid_spirit_bear_entangle_effect",
    "modifier_meepo_earthbind",
    "modifier_naga_siren_ensnare",
    "modifier_oracle_fortunes_end_purge",
    "modifier_rod_of_atos_debuff",
    "modifier_spawnlord_master_freeze",
    "modifier_techies_stasis_trap_stunned",
    "modifier_treant_natures_guise_root",
    "modifier_rooted", 
    "modifier_item_rod_of_atos_debuff",
    "modifier_treant_overgrowth"
}

-- Reference: https://dota2.gamepedia.com/Taunt
Utility.TauntModifiers = {
    "modifier_axe_berserkers_call",
    "modifier_legion_commander_duel",
    "modifier_winter_wyvern_winters_curse"
}

Utility.UntargetableUnits = {
    "npc_dota_unit_tombstone1",
    "npc_dota_unit_tombstone2",
    "npc_dota_unit_tombstone3",
    "npc_dota_unit_tombstone4",
    "npc_dota_unit_undying_zombie",
    "npc_dota_venomancer_plague_ward_1",
    "npc_dota_venomancer_plague_ward_2",
    "npc_dota_venomancer_plague_ward_3",
    "npc_dota_venomancer_plague_ward_4",
    "npc_dota_neutral_caster",
    "npc_dota_observer_wards",
    "npc_dota_sentry_wards",
    "npc_dota_techies_remote_mine",
    "npc_dota_techies_minefield_sign",
    "npc_dota_treant_eyes",
    "npc_dota_phantomassassin_gravestone",
    "npc_dota_techies_land_mine",
    "npc_dota_witch_doctor_death_ward",
    "npc_dota_rattletrap_cog",
    "npc_dota_gyrocopter_homing_missile",
    "npc_dota_juggernaut_healing_ward",
    "npc_dota_pugna_nether_ward_1",
    "npc_dota_pugna_nether_ward_2",
    "npc_dota_pugna_nether_ward_3",
    "npc_dota_pugna_nether_ward_4",
    "npc_dota_templar_assassin_psionic_trap",
    "npc_dota_stormspirit_remnant",
    "npc_dota_ember_spirit_remnant",
    "npc_dota_earth_spirit_stone",
    "npc_dota_slark_visual",
    "npc_dota_weaver_swarm",
    "npc_dota_phoenix_sun",
    "npc_dota_death_prophet_torment",
    "npc_dota_plasma_field",
    "npc_dota_shadow_shaman_ward_1",
    "npc_dota_shadow_shaman_ward_2",
    "npc_dota_shadow_shaman_ward_3",
    "npc_dota_zeus_cloud",
    "npc_dota_tusk_frozen_sigil1",
    "npc_dota_enraged_wildkin_tornado",
    "npc_dota_broodmother_web"
  }

-- only able to get stun modifier. no specific modifier for root or hex.
function Utility.GetStunTimeLeft(npc)
    local mod = NPC.GetModifier(npc, "modifier_stunned")
    if not mod then return 0 end
    return math.max(Modifier.GetDieTime(mod) - GameRules.GetGameTime(), 0)
end

function Utility.Round(number, digits)

	if not number then return end

  	local mult = 10^(digits or 0)
  	return math.floor(number * mult + 0.5) / mult

end



function Utility.GetFrozenTimeLeft(npc)
    local mod = NPC.GetModifier(npc, "modifier_ancientapparition_coldfeet_freeze")
    if not mod then return 0 end
    return math.max(Modifier.GetDieTime(mod) - GameRules.GetGameTime(), 0)
end

-- time left to be fixed in a position (stunned, sleeped, rooted, or taunted)
function Utility.GetFixTimeLeft(npc)
    for i, val in ipairs(Utility.StunModifiers) do
        local mod = NPC.GetModifier(npc, val)
        if mod then return math.max(Modifier.GetDieTime(mod) - GameRules.GetGameTime(), 0) end
    end

    for i, val in ipairs(Utility.SleepModifiers) do
        local mod = NPC.GetModifier(npc, val)
        if mod then return math.max(Modifier.GetDieTime(mod) - GameRules.GetGameTime(), 0) end
    end

    for i, val in ipairs(Utility.RootModifiers) do
        local mod = NPC.GetModifier(npc, val)
        if mod then return math.max(Modifier.GetDieTime(mod) - GameRules.GetGameTime(), 0) end
    end

    for i, val in ipairs(Utility.TauntModifiers) do
        local mod = NPC.GetModifier(npc, val)
        if mod then return math.max(Modifier.GetDieTime(mod) - GameRules.GetGameTime(), 0) end
    end

    return 0
end

-- hex only has three types: sheepstick, lion's hex, shadow shaman's hex
function Utility.GetHexTimeLeft(npc)
    local mod
    local mod1 = NPC.GetModifier(npc, "modifier_sheepstick_debuff")
    local mod2 = NPC.GetModifier(npc, "modifier_lion_voodoo")
    local mod3 = NPC.GetModifier(npc, "modifier_shadow_shaman_voodoo")

    if mod1 then mod = mod1 end
    if mod2 then mod = mod2 end
    if mod3 then mod = mod3 end

    if not mod then return 0 end
    return math.max(Modifier.GetDieTime(mod) - GameRules.GetGameTime(), 0)
end

-- return false for conditions that are not suitable to cast spell (like TPing, being invisible)
-- return true otherwise
function Utility.IsSuitableToCastSpell(myHero)
    if NPC.IsSilenced(myHero) or NPC.IsStunned(myHero) or not Entity.IsAlive(myHero) then return false end
    if NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then return false end
    if NPC.HasModifier(myHero, "modifier_teleporting") then return false end
    if NPC.IsChannellingAbility(myHero) then return false end

    return true
end

function Utility.IsSuitableToUseItem(myHero)
    if NPC.IsStunned(myHero) or not Entity.IsAlive(myHero) then return false end
    if NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then return false end
    if NPC.HasModifier(myHero, "modifier_teleporting") then return false end
    if NPC.IsChannellingAbility(myHero) then return false end

    return true
end

-- return true if: (1) channeling ability; (2) TPing
function Utility.IsChannellingAbility(npc)
    if NPC.HasModifier(npc, "modifier_teleporting") then return true end
    if NPC.IsChannellingAbility(npc) then return true end
    return false
end

function Utility.DrawCircle(pos, radius, degree)
	local x, y, visible = Renderer.WorldToScreen(pos + Vector(0, radius, 0))
	if visible == 1 then
		for angle = 0, 360 / degree do
			local x1, y1 = Renderer.WorldToScreen(pos + Vector(0, radius, 0):Rotated(Angle(0, angle * degree, 0)))
			Renderer.DrawLine(x, y, x1, y1)
			x, y = x1, y1
		end
	end
end

function Utility.IsAffectedByDoT(npc)
    if not npc then return false end

    if NPC.HasModifier(npc, "modifier_item_radiance_debuff") then return true end
    if NPC.HasModifier(npc, "modifier_item_urn_damage") then return true end
    if NPC.HasModifier(npc, "modifier_abyssal_underlord_firestorm_burn") then return true end
    if NPC.HasModifier(npc, "modifier_alchemist_acid_spray") then return true end
    if NPC.HasModifier(npc, "modifier_axe_battle_hunger") then return true end
    if NPC.HasModifier(npc, "modifier_bane_fiends_grip") then return true end
    if NPC.HasModifier(npc, "modifier_batrider_firefly") then return true end
    if NPC.HasModifier(npc, "modifier_brewmaster_fire_permanent_immolation") then return true end
    if NPC.HasModifier(npc, "modifier_cold_feet") then return true end
    if NPC.HasModifier(npc, "modifier_crystal_maiden_freezing_field") then return true end
    if NPC.HasModifier(npc, "modifier_crystal_maiden_frostbite") then return true end
    if NPC.HasModifier(npc, "modifier_dazzle_poison_touch") then return true end
    if NPC.HasModifier(npc, "modifier_disruptor_static_storm") then return true end
    if NPC.HasModifier(npc, "modifier_disruptor_thunder_strike") then return true end
    if NPC.HasModifier(npc, "modifier_doom_bringer_doom") then return true end
    if NPC.HasModifier(npc, "modifier_doom_bringer_scorched_earth_effect") then return true end
    if NPC.HasModifier(npc, "modifier_dragon_knight_corrosive_breath_dot") then return true end
    if NPC.HasModifier(npc, "modifier_earth_spirit_magnetize") then return true end
    if NPC.HasModifier(npc, "modifier_ember_spirit_flame_guard") then return true end
    if NPC.HasModifier(npc, "modifier_enigma_malefice") then return true end
    if NPC.HasModifier(npc, "modifier_gyrocopter_rocket_barrage") then return true end
    if NPC.HasModifier(npc, "modifier_huskar_burning_spear_debuff") then return true end
    if NPC.HasModifier(npc, "modifier_ice_blast") then return true end
    if NPC.HasModifier(npc, "modifier_invoker_chaos_meteor_burn") then return true end
    if NPC.HasModifier(npc, "modifier_invoker_ice_wall_slow_debuff") then return true end
    if NPC.HasModifier(npc, "modifier_jakiro_dual_breath_burn") then return true end
    if NPC.HasModifier(npc, "modifier_jakiro_macropyre") then return true end
    if NPC.HasModifier(npc, "modifier_juggernaut_blade_fury") then return true end
    if NPC.HasModifier(npc, "modifier_leshrac_diabolic_edict") then return true end
    if NPC.HasModifier(npc, "modifier_leshrac_pulse_nova") then return true end
    if NPC.HasModifier(npc, "modifier_maledict") then return true end
    if NPC.HasModifier(npc, "modifier_ogre_magi_ignite") then return true end
    if NPC.HasModifier(npc, "modifier_phoenix_fire_spirit_burn") then return true end
    if NPC.HasModifier(npc, "modifier_phoenix_icarus_dive_burn") then return true end
    if NPC.HasModifier(npc, "modifier_phoenix_sun_debuff") then return true end
    if NPC.HasModifier(npc, "modifier_pudge_rot") then return true end
    if NPC.HasModifier(npc, "modifier_pugna_life_drain") then return true end
    if NPC.HasModifier(npc, "modifier_queenofpain_shadow_strike") then return true end
    if NPC.HasModifier(npc, "modifier_rattletrap_battery_assault") then return true end
    if NPC.HasModifier(npc, "modifier_razor_eye_of_the_storm") then return true end
    if NPC.HasModifier(npc, "modifier_sandking_sand_storm") then return true end
    if NPC.HasModifier(npc, "modifier_silencer_curse_of_the_silent") then return true end
    if NPC.HasModifier(npc, "modifier_sniper_shrapnel_slow") then return true end
    if NPC.HasModifier(npc, "modifier_shredder_chakram_debuff") then return true end
    if NPC.HasModifier(npc, "modifier_treant_leech_seed") then return true end
    if NPC.HasModifier(npc, "modifier_venomancer_poison_nova") then return true end
    if NPC.HasModifier(npc, "modifier_venomancer_venomous_gale") then return true end
    if NPC.HasModifier(npc, "modifier_viper_viper_strike") then return true end
    if NPC.HasModifier(npc, "modifier_warlock_shadow_word") then return true end
    if NPC.HasModifier(npc, "modifier_warlock_golem_permanent_immolation_debuff") then return true end

    return false
end

-- standard APIs have fixed this issue
function Utility.GetCastRange(myHero, ability)
    return Ability.GetCastRange(ability)
    -- if not myHero or not ability then return 0 end
    --
    -- local range = Ability.GetCastRange(ability)
    --
    -- if NPC.HasItem(myHero, "item_aether_lens", true) then
    --     range = range + 250
    -- end
    --
    -- for i = 0, 24 do
    --     local ability = NPC.GetAbilityByIndex(myHero, i)
    --     if ability and Ability.GetLevel(ability) > 0 then
    --         local bonus_name = Ability.GetName(ability)
    --         if string.find(bonus_name, "special_bonus_cast_range") then
    --             local diff = tonumber(string.match(bonus_name, "[0-9]+"))
    --             range = range + diff
    --         end
    --     end
    -- end
    --
    -- return range
end

function Utility.GetSafeDirection(myHero)
    local mid = Vector()
    local pos = Entity.GetAbsOrigin(myHero)

    for i = 1, Heroes.Count() do
        local enemy = Heroes.Get(i)
        if enemy and not Entity.IsSameTeam(myHero, enemy) then
            mid = mid + Entity.GetAbsOrigin(enemy)
        end
	end

    mid:Set(mid:GetX()/Heroes.Count(), mid:GetY()/Heroes.Count(), mid:GetZ()/Heroes.Count())
    return (pos + pos - mid):Normalized()
end

return Utility