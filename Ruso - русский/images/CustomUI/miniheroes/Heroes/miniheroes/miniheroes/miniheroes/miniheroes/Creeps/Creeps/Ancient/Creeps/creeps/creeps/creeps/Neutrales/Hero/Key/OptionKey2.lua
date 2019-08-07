
local Key = {}

-----------------------------MrGarabato------------------------------------
Log.Write("Loaded script: CodKey2.lua")

-----------------------------MrGarabato------------------------------------
Key.comboKey = Menu.AddKeyOption({"MrGarabato", "Select Hero" },"1) Combo Key without items",Enum.ButtonCode.KEY_D)
Menu.AddOptionIcon(Key.comboKey , "panorama/images/icon_treasure_arrow_psd.vtex_c")

return Key 