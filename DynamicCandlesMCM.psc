Scriptname DynamicCandlesMCM extends MCM_ConfigBase

Quest Property DynamicCandlesQuest Auto
GlobalVariable Property DC_SearchAllowed Auto
GlobalVariable Property DC_CD_Slider Auto


Bool migrated = False

Int Function GetVersion()
    return 1
EndFunction

Event OnUpdate()
    parent.OnUpdate()
    If !migrated
        MigrateToMCMHelper()
        migrated = True
    EndIf
EndEvent

Event OnGameReload()
    parent.OnGameReload()
    If !migrated
        MigrateToMCMHelper()
        migrated = True
    EndIf
    If GetModSettingBool("bLoadSettingsonReload:Maintenance")
        LoadSettings()
    EndIf
EndEvent

Event OnConfigOpen()
    parent.OnConfigOpen()
    If !migrated
        MigrateToMCMHelper()
        migrated = True
    EndIf
EndEvent

Event OnConfigInit()
    parent.OnConfigInit()
    migrated = True
    LoadSettings()
EndEvent

Event OnSettingChange(String a_ID)
    parent.OnSettingChange(a_ID)
    If a_ID == "bSearchAllowed:General"
        DC_SearchAllowed.SetValue(GetModSettingBool("bSearchAllowed:General") as Float)
        (DynamicCandlesQuest.GetAlias(0) as ReferenceAlias).OnPlayerLoadGame()
        RefreshMenu()
    ElseIf a_ID == "fCD_Slider:General"
        DC_CD_Slider.SetValue(GetModSettingFloat("fCD_Slider:General") as Float)
        (DynamicCandlesQuest.GetAlias(0) as ReferenceAlias).OnPlayerLoadGame()
        RefreshMenu()
    EndIf
EndEvent

Event OnPageSelect(String a_page)
    parent.OnPageSelect(a_page)
EndEvent

Function Default()
    SetModSettingBool("bSearchAllowed:General", False)
    SetModSettingFloat("fCD_Slider:General", 35.0)
    SetModSettingBool("bEnabled:Maintenance", True)
    SetModSettingInt("iLoadingDelay:Maintenance", 0)
    SetModSettingBool("bLoadSettingsonReload:Maintenance", False)
    SetModSettingBool("buninstallEnabled:Maintenance", False)
    Load()
EndFunction

Function Load()
    DC_SearchAllowed.SetValue(GetModSettingBool("bSearchAllowed:General") as Float)
    DC_CD_Slider.SetValue(GetModSettingFloat("fCD_Slider:General") as Float)
    (DynamicCandlesQuest.GetAlias(0) as ReferenceAlias).OnPlayerLoadGame()
EndFunction

Function LoadSettings()
    If GetModSettingBool("bEnabled:Maintenance") == False
        Return
    EndIf
    Utility.Wait(GetModSettingInt("iLoadingDelay:Maintenance"))
    Load()
EndFunction

Function MigrateToMCMHelper()
    SetModSettingBool("bSearchAllowed:General", DC_SearchAllowed.GetValue() as Bool)
    SetModSettingFloat("fCD_Slider:General", DC_CD_Slider.GetValue() as Float)
EndFunction
