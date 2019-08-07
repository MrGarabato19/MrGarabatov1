
local Key = {}

-----------------------------MrGarabato------------------------------------
Log.Write("Loaded script: CodKey3.lua")

-----------------------------MrGarabato------------------------------------
Key.comboKey = Menu.AddKeyOption({"Support", "Auto section"  },"1) Combo without items Key",Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(Key.comboKey, "panorama/images/icon_treasure_arrow_psd.vtex_c")

return Key 