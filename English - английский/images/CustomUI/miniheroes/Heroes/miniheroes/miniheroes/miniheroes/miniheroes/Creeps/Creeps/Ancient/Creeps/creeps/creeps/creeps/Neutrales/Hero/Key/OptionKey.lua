local Key = {}

-----------------------------MrGarabato------------------------------------
Log.Write("Loaded script: CodKey.lua")

-----------------------------MrGarabato------------------------------------
Key.comboKey = Menu.AddKeyOption({"MrGarabato", "Select Hero" },"Combo Key",Enum.ButtonCode.KEY_D)
Menu.AddOptionIcon(Key.comboKey , "panorama/images/icon_treasure_arrow_psd.vtex_c")

return Key 