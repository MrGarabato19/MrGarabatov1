local autoitems = {} Log.Write("Loaded script: Autoitems.lua") local BsleepTick = nil  function autoitems.OnUpdate()	 if not Menu.IsEnabled(MrGarabato_v1_MenuHx.optionEnable) then return true end     if not Menu.IsEnabled(MrGarabato_v1_MenuHx.EnableUtility) then return end  if not Menu.IsEnabled(MrGarabato_v1_MenuHx.autoitemsoptionMenu) then return end   local me = Heroes.GetLocal()   if not me then return	end    MrGarabato_v1_MenuHx.autoitemsLongnum = Menu.GetValue(MrGarabato_v1_MenuHx.autoitemsLong)   local bottle = NPC.GetItem(me, "item_bottle")  	local lowstick = NPC.GetItem(me, "item_magic_stick") 	local gradestick = NPC.GetItem(me, "item_magic_wand")    if Menu.IsEnabled(MrGarabato_v1_MenuHx.autoitemsoptionEnable) and bottle and (NPC.HasModifier(me, "modifier_item_invisibility_edge_windwalk") or NPC.HasModifier(me, "modifier_item_silver_edge_windwalk" or NPC.HasModifier(me, "modifier_invisible")))     and not NPC.IsChannellingAbility(me) and Item.GetCurrentCharges(bottle) > 0 and Entity.GetHealth(me) < MrGarabato_v1_MenuHx.autoitemsLongnum then       Ability.CastNoTarget(bottle)     end    if Menu.IsEnabled(MrGarabato_v1_MenuHx.autoitemsstickEnable) and lowstick  and Item.GetCurrentCharges(lowstick) > 0 and Entity.GetHealth(me) < MrGarabato_v1_MenuHx.autoitemsLongnum then     Ability.CastNoTarget(lowstick)   end    if Menu.IsEnabled(MrGarabato_v1_MenuHx.autoitemswandEnable) and gradestick and Item.GetCurrentCharges(gradestick) > 0 and Entity.GetHealth(me) < MrGarabato_v1_MenuHx.autoitemsLongnum then     Ability.CastNoTarget(gradestick)   end   end return autoitems 