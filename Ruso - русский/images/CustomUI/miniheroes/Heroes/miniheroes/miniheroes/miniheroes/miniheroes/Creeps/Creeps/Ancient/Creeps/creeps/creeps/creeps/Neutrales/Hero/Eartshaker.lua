local EarthshakerMrG = {} Log.Write("Loaded script: Earthshaker.lua") Menu.AddMenuIcon({"MrGarabato", "Select Hero"}, "panorama/images/heroes/icons/npc_dota_hero_earthshaker_png.vtex_c")EarthshakerMrG.poisonKey = Menu.AddKeyOption({"MrGarabato", "Select Hero"}," Combo Key not incluye Echo Slam",Enum.ButtonCode.KEY_F) Menu.AddOptionIcon(EarthshakerMrG.poisonKey , "panorama/images/icon_treasure_arrow_psd.vtex_c") EarthshakerMrG.optionTarget = Menu.AddOptionSlider({"MrGarabato", "Select Hero"}, "Target Radius", 200, 1000, 500) EarthshakerMrG.optionTargetStyle = Menu.AddOptionCombo({"MrGarabato", "Select Hero"}, "Target Style", {"Free Target", "Lock Target"}, 1) Menu.AddMenuIcon({"MrGarabato", "Select Hero","Skill"}, "panorama/images/icon_plus_white_png.vtex_c") EarthshakerMrG.Addskill1 = Menu.AddOptionBool({ "MrGarabato", "Select Hero","Skill"}," Use Fissure","") Menu.AddOptionIcon(EarthshakerMrG.Addskill1, "panorama/images/spellicons/earthshaker_fissure_alt_gold_png.vtex_c") EarthshakerMrG.Addskill2 = Menu.AddOptionBool({ "MrGarabato", "Select Hero","Skill"}," Use Enchant Totem","") Menu.AddOptionIcon(EarthshakerMrG.Addskill2, "panorama/images/spellicons/earthshaker_enchant_totem_png.vtex_c") EarthshakerMrG.Addskill3 = Menu.AddOptionBool({ "MrGarabato", "Select Hero","Skill"}," Use Echo Slam",false) Menu.AddOptionIcon(EarthshakerMrG.Addskill3, "panorama/images/spellicons/earthshaker_echo_slam_egset_png.vtex_c")  Menu.AddMenuIcon({"MrGarabato", "Select Hero","Items"}, "panorama/images/icon_plus_white_png.vtex_c") EarthshakerMrG.optionSDBlink = Menu.AddOptionBool({ "MrGarabato", "Select Hero","Items"}, " Use Blink to Initiate", false) Menu.AddOptionIcon(EarthshakerMrG.optionSDBlink, "panorama/images/items/blink_png.vtex_c") EarthshakerMrG.optionSDBlinkRange = Menu.AddOptionSlider({ "MrGarabato", "Select Hero","Items"}, " Set Safe Blink Initiation Range", 200, 800, 25) EarthshakerMrG.Atos = Menu.AddOptionBool({ "MrGarabato", "Select Hero","Items"}," Use Atos",false) Menu.AddOptionIcon(EarthshakerMrG.Atos, "panorama/images/items/rod_of_atos_png.vtex_c") EarthshakerMrG.optionEnableVeil = Menu.AddOptionBool({ "MrGarabato", "Select Hero","Items"}," Use Veil Of Discord",false) Menu.AddOptionIcon(EarthshakerMrG.optionEnableVeil, "panorama/images/items/veil_of_discord_png.vtex_c") EarthshakerMrG.optionEnableHex = Menu.AddOptionBool({ "MrGarabato", "Select Hero","Items"}," Use Scythe Of Vyse",false) Menu.AddOptionIcon(EarthshakerMrG.optionEnableHex, "panorama/images/items/sheepstick_png.vtex_c") EarthshakerMrG.optionEnableBloth = Menu.AddOptionBool({ "MrGarabato", "Select Hero","Items"}," Use Bloodthorn",false) Menu.AddOptionIcon(EarthshakerMrG.optionEnableBloth, "panorama/images/items/bloodthorn_png.vtex_c") EarthshakerMrG.optionEnableEblade = Menu.AddOptionBool({ "MrGarabato", "Select Hero","Items"}," Use Ethereal Blade",false) Menu.AddOptionIcon(EarthshakerMrG.optionEnableEblade, "panorama/images/items/ethereal_blade_png.vtex_c") EarthshakerMrG.optionEnableOrchid = Menu.AddOptionBool({ "MrGarabato", "Select Hero","Items"}," Use Orchid Malevolence",false) Menu.AddOptionIcon(EarthshakerMrG.optionEnableOrchid, "panorama/images/items/orchid_png.vtex_c") EarthshakerMrG.optionEnableSring = Menu.AddOptionBool({ "MrGarabato", "Select Hero","Items"},"Use Soul Ring",false) Menu.AddOptionIcon(EarthshakerMrG.optionEnableSring, "panorama/images/items/soul_ring_png.vtex_c") EarthshakerMrG.optionEnableSguard = Menu.AddOptionBool({ "MrGarabato", "Select Hero","Items"},"Use Shivas Guard",false) Menu.AddOptionIcon(EarthshakerMrG.optionEnableSguard, "panorama/images/items/shivas_guard_png.vtex_c") EarthshakerMrG.optionEnableDagon = Menu.AddOptionBool({ "MrGarabato", "Select Hero","Items"},"Use Dagon (Little Lag)",false) Menu.AddOptionIcon(EarthshakerMrG.optionEnableDagon, "panorama/images/items/dagon_5_png.vtex_c") EarthshakerMrG.optionEnableEuls = Menu.AddOptionBool({ "MrGarabato", "Select Hero","Items"}," Use Euls",false) Menu.AddOptionIcon(EarthshakerMrG.optionEnableEuls, "panorama/images/items/cyclone_png.vtex_c") EarthshakerMrG.optionEnableGlimmer = Menu.AddOptionBool({ "MrGarabato", "Select Hero","Items"}," Use Glimmer Cape",false)  local myPlayer, myTeam, myMana, myFaction, attackRange, myPos, myBase, enemyBase, enemyPosition function EarthshakerMrG.OnUpdate() if not Menu.IsEnabled(MrGarabato_v1_MenuHx.optionEnable) then return true end     if not Menu.IsEnabled(MrGarabato_v1_MenuHx.EnableHero) then return end local myHero = Heroes.GetLocal() if not myHero then return end if NPC.GetUnitName(myHero) ~= "npc_dota_hero_earthshaker" then return end myTeam = Entity.GetTeamNum(myHero) if myTeam == 2 then myBase = Vector(-7328.000000, -6816.000000, 512.000000) enemyBase = Vector(7141.750000, 6666.125000, 512.000000) myFaction = "radiant" else myBase = Vector(7141.750000, 6666.125000, 512.000000) enemyBase = Vector(-7328.000000, -6816.000000, 512.000000) myFaction = "dire" end if Menu.IsKeyDown(MrGarabato_v1_MenuHx.optionComboKey) then if Menu.GetValue(EarthshakerMrG.optionTargetStyle) == 1 and not hero then 	hero = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY) elseif Menu.GetValue(EarthshakerMrG.optionTargetStyle) == 0 then 	hero = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY) end if hero and Entity.IsAlive(hero) then 	enemyPosition = Entity.GetAbsOrigin(hero) 	EarthshakerMrG.Combo() end else hero = nil end if Menu.IsKeyDown(EarthshakerMrG.poisonKey) then if Menu.GetValue(EarthshakerMrG.optionTargetStyle) == 1 and not hero then 	hero = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY) elseif Menu.GetValue(EarthshakerMrG.optionTargetStyle) == 0 then 	hero = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY) end if hero and Entity.IsAlive(hero) then 	enemyPosition = Entity.GetAbsOrigin(hero) 	EarthshakerMrG.Harass() end else hero = nil end end function EarthshakerMrG.Harass(myHero) if not Menu.IsKeyDown(EarthshakerMrG.poisonKey) then return end local myHero = Heroes.GetLocal() if NPC.GetUnitName(myHero) ~= "npc_dota_hero_earthshaker" then return end hero = EarthshakerMrG.Target(myHero) local heroPos if hero ~= nil then heroPos = Entity.GetAbsOrigin(hero) end local mousePos = Input.GetWorldCursorPos() local mana = NPC.GetMana(myHero)  if not hero then return end  local fissure = NPC.GetAbility(myHero, "earthshaker_fissure") local totem = NPC.GetAbility(myHero, "earthshaker_enchant_totem")  local ulti = NPC.GetAbility(myHero, "earthshaker_echo_slam") local dagon = NPC.GetItem(myHero, "item_dagon", true) if not dagon then for i = 2, 5 do  dagon = NPC.GetItem(myHero, "item_dagon_" .. i, true)  		if dagon then  		break  	end end end local Blink = NPC.GetItem(myHero, "item_blink", true) local Atos = NPC.GetItem(myHero, "item_rod_of_atos", true) local Veil = NPC.GetItem(myHero, "item_veil_of_discord", true) local Euls = NPC.GetItem(myHero, "item_cyclone", true) local Glimmer = NPC.GetItem(myHero, "item_glimmer_cape", true) local veil = NPC.GetItem(myHero, "item_veil_of_discord", true) local hex = NPC.GetItem(myHero, "item_sheepstick", true) local bloth = NPC.GetItem(myHero, "item_bloodthorn", true) local eblade = NPC.GetItem(myHero, "item_ethereal_blade", true) local orchid = NPC.GetItem(myHero, "item_orchid", true) local refresh = NPC.GetItem(myHero, "item_refresher", true) local RoA = NPC.GetItem(myHero, "item_rod_of_atos", true) local Sguard = NPC.GetItem(myHero, "item_shivas_guard", true) local Sring = NPC.GetItem(myHero, "item_soul_ring", true) local Fstaff = NPC.GetItem(myHero, "item_force_staff", true) local BladeM = NPC.GetItem(myHero, "item_blade_mail", true) local Hstaff = NPC.GetItem(myHero, "item_hurricane_pike", true) local EUL = NPC.GetItem(myHero, "item_cyclone", true) local shadowblyad = NPC.GetItem(myHero, "item_invis_sword", true) local silveredge = NPC.GetItem(myHero, "item_silver_edge", true) local glimmer = NPC.GetItem(myHero, "item_glimmer_cape", true)    if Menu.IsEnabled(EarthshakerMrG.optionEnableVeil) and Veil and Ability.IsCastable(Veil, mana) and not NPC.IsIllusion(hero) and NPC.IsPositionInRange(myHero, Entity.GetAbsOrigin(hero), Ability.GetCastRange(Veil),0) and heroPos then Ability.CastPosition(Veil, heroPos) return end if Menu.IsEnabled(EarthshakerMrG.optionEnableSguard) and Sguard and Ability.IsCastable(Sguard, mana) and NPC.IsEntityInRange(hero, myHero, Ability.GetCastRange(Sguard) - 10) then Ability.CastNoTarget(Sguard); return end  if hero and not NPC.IsIllusion(hero) then if Blink and Menu.IsEnabled(EarthshakerMrG.optionSDBlink) and Ability.IsReady(Blink) and NPC.IsEntityInRange(myHero, hero, 1150 + Menu.GetValue(EarthshakerMrG.optionSDBlinkRange)) then   Ability.CastPosition(Blink, (Entity.GetAbsOrigin(hero) + (Entity.GetAbsOrigin(myHero) - Entity.GetAbsOrigin(hero)):Normalized():Scaled(Menu.GetValue(EarthshakerMrG.optionSDBlinkRange)))) return end end if Menu.IsEnabled(EarthshakerMrG.optionEnableSring) and Sring and Ability.IsCastable(Sring, 0) then Ability.CastNoTarget(Sring); return end if Menu.IsEnabled(EarthshakerMrG.optionEnableDagon) and dagon and Ability.IsCastable(dagon, mana) and NPC.IsEntityInRange(hero, myHero, Ability.GetCastRange(dagon) - 10) then Ability.CastTarget(dagon, hero) return end  if Menu.IsEnabled(EarthshakerMrG.Addskill1) and fissure and Ability.IsCastable(fissure, mana) and Ability.IsReady(fissure)then Ability.CastPosition(fissure, (Entity.GetAbsOrigin(hero) + (Entity.GetAbsOrigin(myHero) - Entity.GetAbsOrigin(hero)):Normalized():Scaled(Menu.GetValue(EarthshakerMrG.optionSDBlinkRange)))) return end if Menu.IsEnabled(EarthshakerMrG.Addskill2) and totem and Ability.IsReady(totem) and Ability.IsCastable(totem, mana) then Ability.CastNoTarget(totem); return end  if Menu.IsEnabled(EarthshakerMrG.optionEnableBloth) and bloth and Ability.IsCastable(bloth, mana) and NPC.IsEntityInRange(hero, myHero, Ability.GetCastRange(bloth) - 10) then Ability.CastTarget(bloth, hero); return end if Menu.IsEnabled(EarthshakerMrG.optionEnableOrchid) and orchid and Ability.IsCastable(orchid, mana) and NPC.IsEntityInRange(hero, myHero, Ability.GetCastRange(orchid) - 10) then Ability.CastTarget(orchid, hero); return end   if Menu.IsEnabled(EarthshakerMrG.Atos) and Atos and Ability.IsCastable(Atos, mana) and not NPC.IsIllusion(hero) and not NPC.GetModifier(hero, "modifier_sheepstick_debuff") and NPC.IsPositionInRange(myHero, Entity.GetAbsOrigin(hero),Ability.GetCastRange(Atos),0) then Ability.CastTarget(Atos, hero) return end if Menu.IsEnabled(EarthshakerMrG.optionEnableEuls) and Euls and Ability.IsCastable(Euls, mana) and NPC.IsPositionInRange(myHero, Entity.GetAbsOrigin(hero), Ability.GetCastRange(Euls),0) then Ability.CastTarget(Euls, hero) return end if Menu.IsEnabled(EarthshakerMrG.optionEnableGlimmer) and Glimmer and Ability.IsCastable(Glimmer, mana) and NPC.IsPositionInRange(myHero, Entity.GetAbsOrigin(hero), Ability.GetCastRange(Glimmer),0) then Ability.CastTarget(Glimmer, myHero) return end Player.AttackTarget(Players.GetLocal(), myHero, hero, false) end function EarthshakerMrG.Combo() if not Menu.IsKeyDown(MrGarabato_v1_MenuHx.optionComboKey) then return end local myHero = Heroes.GetLocal() if NPC.GetUnitName(myHero) ~= "npc_dota_hero_earthshaker" then return end hero = EarthshakerMrG.Target(myHero) local heroPos if hero ~= nil then heroPos = Entity.GetAbsOrigin(hero) end local mousePos = Input.GetWorldCursorPos() local mana = NPC.GetMana(myHero)  if not hero then return end  local fissure = NPC.GetAbility(myHero, "earthshaker_fissure") local totem = NPC.GetAbility(myHero, "earthshaker_enchant_totem")  local ulti = NPC.GetAbility(myHero, "earthshaker_echo_slam") local dagon = NPC.GetItem(myHero, "item_dagon", true) if not dagon then for i = 2, 5 do  dagon = NPC.GetItem(myHero, "item_dagon_" .. i, true)  		if dagon then  		break  	end end end local Blink = NPC.GetItem(myHero, "item_blink", true) local Atos = NPC.GetItem(myHero, "item_rod_of_atos", true) local Veil = NPC.GetItem(myHero, "item_veil_of_discord", true) local Euls = NPC.GetItem(myHero, "item_cyclone", true) local Glimmer = NPC.GetItem(myHero, "item_glimmer_cape", true) local veil = NPC.GetItem(myHero, "item_veil_of_discord", true) local hex = NPC.GetItem(myHero, "item_sheepstick", true) local bloth = NPC.GetItem(myHero, "item_bloodthorn", true) local eblade = NPC.GetItem(myHero, "item_ethereal_blade", true) local orchid = NPC.GetItem(myHero, "item_orchid", true) local refresh = NPC.GetItem(myHero, "item_refresher", true) local RoA = NPC.GetItem(myHero, "item_rod_of_atos", true) local Sguard = NPC.GetItem(myHero, "item_shivas_guard", true) local Sring = NPC.GetItem(myHero, "item_soul_ring", true) local Fstaff = NPC.GetItem(myHero, "item_force_staff", true) local BladeM = NPC.GetItem(myHero, "item_blade_mail", true) local Hstaff = NPC.GetItem(myHero, "item_hurricane_pike", true) local EUL = NPC.GetItem(myHero, "item_cyclone", true) local shadowblyad = NPC.GetItem(myHero, "item_invis_sword", true) local silveredge = NPC.GetItem(myHero, "item_silver_edge", true) local glimmer = NPC.GetItem(myHero, "item_glimmer_cape", true)  if hero and not NPC.IsIllusion(hero) then if Blink and Menu.IsEnabled(EarthshakerMrG.optionSDBlink) and Ability.IsReady(Blink) and NPC.IsEntityInRange(myHero, hero, 1150 + Menu.GetValue(EarthshakerMrG.optionSDBlinkRange)) then   Ability.CastPosition(Blink, (Entity.GetAbsOrigin(hero) + (Entity.GetAbsOrigin(myHero) - Entity.GetAbsOrigin(hero)):Normalized():Scaled(Menu.GetValue(EarthshakerMrG.optionSDBlinkRange)))) return end end if Menu.IsEnabled(EarthshakerMrG.optionEnableSring) and Sring and Ability.IsCastable(Sring, 0) then Ability.CastNoTarget(Sring); return end  if Menu.IsEnabled(EarthshakerMrG.Addskill3) and ulti and Ability.IsReady(ulti) and Ability.IsCastable(ulti, mana) then Ability.CastNoTarget(ulti); return end if Menu.IsEnabled(EarthshakerMrG.Addskill1) and fissure and Ability.IsCastable(fissure, mana) and Ability.IsReady(fissure)then Ability.CastPosition(fissure, (Entity.GetAbsOrigin(hero) + (Entity.GetAbsOrigin(myHero) - Entity.GetAbsOrigin(hero)):Normalized():Scaled(Menu.GetValue(EarthshakerMrG.optionSDBlinkRange)))) return end if Menu.IsEnabled(EarthshakerMrG.Addskill2) and totem and Ability.IsReady(totem) and Ability.IsCastable(totem, mana) then Ability.CastNoTarget(totem); return end  if Menu.IsEnabled(EarthshakerMrG.optionEnableBloth) and bloth and Ability.IsCastable(bloth, mana) and NPC.IsEntityInRange(hero, myHero, Ability.GetCastRange(bloth) - 10) then Ability.CastTarget(bloth, hero); return end if Menu.IsEnabled(EarthshakerMrG.optionEnableOrchid) and orchid and Ability.IsCastable(orchid, mana) and NPC.IsEntityInRange(hero, myHero, Ability.GetCastRange(orchid) - 10) then Ability.CastTarget(orchid, hero); return end if Menu.IsEnabled(EarthshakerMrG.optionEnableDagon) and dagon and Ability.IsCastable(dagon, mana) and NPC.IsEntityInRange(hero, myHero, Ability.GetCastRange(dagon) - 10) then Ability.CastTarget(dagon, hero) return end if Menu.IsEnabled(EarthshakerMrG.optionEnableHex) and hex and Ability.IsCastable(hex, mana) and NPC.IsEntityInRange(hero, myHero, Ability.GetCastRange(hex) - 10) then Ability.CastTarget(hex, hero); return end if Menu.IsEnabled(EarthshakerMrG.optionEnableSguard) and Sguard and Ability.IsCastable(Sguard, mana) and NPC.IsEntityInRange(hero, myHero, Ability.GetCastRange(Sguard) - 10) then Ability.CastNoTarget(Sguard); return end if Menu.IsEnabled(EarthshakerMrG.optionEnableDagon) and dagon and Ability.IsCastable(dagon, mana) and NPC.IsEntityInRange(hero, myHero, Ability.GetCastRange(dagon) - 10) then Ability.CastTarget(dagon, hero) return end if Menu.IsEnabled(EarthshakerMrG.optionEnableEblade) and eblade and Ability.IsCastable(eblade, mana) and NPC.IsEntityInRange(hero, myHero, Ability.GetCastRange(eblade) - 10) then Ability.CastTarget(eblade, hero); return end if Menu.IsEnabled(EarthshakerMrG.Atos) and Atos and Ability.IsCastable(Atos, mana) and not NPC.IsIllusion(hero) and not NPC.GetModifier(hero, "modifier_sheepstick_debuff") and NPC.IsPositionInRange(myHero, Entity.GetAbsOrigin(hero),Ability.GetCastRange(Atos),0) then Ability.CastTarget(Atos, hero) return end if Menu.IsEnabled(EarthshakerMrG.optionEnableVeil) and Veil and Ability.IsCastable(Veil, mana) and not NPC.IsIllusion(hero) and NPC.IsPositionInRange(myHero, Entity.GetAbsOrigin(hero), Ability.GetCastRange(Veil),0) and heroPos then Ability.CastPosition(Veil, heroPos) return end  if Menu.IsEnabled(EarthshakerMrG.optionEnableEuls) and Euls and Ability.IsCastable(Euls, mana) and NPC.IsPositionInRange(myHero, Entity.GetAbsOrigin(hero), Ability.GetCastRange(Euls),0) then Ability.CastTarget(Euls, hero) return end if Menu.IsEnabled(EarthshakerMrG.optionEnableGlimmer) and Glimmer and Ability.IsCastable(Glimmer, mana) and NPC.IsPositionInRange(myHero, Entity.GetAbsOrigin(hero), Ability.GetCastRange(Glimmer),0) then Ability.CastTarget(Glimmer, myHero) return end Player.AttackTarget(Players.GetLocal(), myHero, hero, false) end function EarthshakerMrG.Target(myHero) if not myHero then return end hero = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY) if not hero then return end local targetingRange = Menu.GetValue(EarthshakerMrG.optionTarget) local mousePos = Input.GetWorldCursorPos() local enemyDist = (Entity.GetAbsOrigin(hero) - mousePos):Length2D() if enemyDist < targetingRange then  return hero else return mousePos end end  return EarthshakerMrG