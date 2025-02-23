Scriptname DynamicCandles extends ObjectReference


FormList Property DC_On Auto
FormList Property DC_Off Auto
Keyword Property DC_Fire Auto
Keyword Property DC_Frost Auto
GlobalVariable Property DC_SearchAllowed Auto
GlobalVariable Property DC_CD_Slider Auto

ObjectReference DC_LightFlagClose
Float scale



Function DC_DisableLightClose(ObjectReference marker)

	Cell kCell = Game.GetPlayer().GetParentCell()
	Int i = kCell.GetNumRefs(31) - 1
    Float maxDistance = DC_CD_Slider.GetValue()
    String disabledListKey = "DC_DisabledLights_" + marker.GetFormID()
    String disabledListCountKey = "DC_DisabledLightsCount_" + marker.GetFormID()
    Int disabledListCount = 0

	While i >= 0

        DC_LightFlagClose = kCell.GetNthRef(i, 31)
        Float distance = self.GetDistance(DC_LightFlagClose)
        i -= 1

        If distance < maxDistance
            disabledListCount += 1
            StorageUtil.FormListAdd(marker, disabledListKey, DC_LightFlagClose)
            ConsoleUtil.SetSelectedReference(DC_LightFlagClose)
            ConsoleUtil.ExecuteCommand("Disable")
        EndIf
        
	EndWhile

    StorageUtil.SetIntValue(marker, disabledListCountKey, disabledListCount)
    ConsoleUtil.SetSelectedReference(None)

EndFunction


Function DC_EnableLightClose(ObjectReference marker)
    String disabledListKey = "DC_DisabledLights_" + marker.GetFormID()
    String disabledListCountKey = "DC_DisabledLightsCount_" + marker.GetFormID()
    Int count = StorageUtil.GetIntValue(marker, disabledListCountKey)

    If count <= 0
        Return
    EndIf

    While count > 0

        count -= 1
        Form disabledForm = StorageUtil.FormListGet(marker, disabledListKey, count)

        If disabledForm != None

            ObjectReference disabledRef = disabledForm as ObjectReference
            If disabledRef != None
                ConsoleUtil.SetSelectedReference(disabledRef)
                ConsoleUtil.ExecuteCommand("Enable")
            EndIf

        EndIf

    EndWhile

    ConsoleUtil.SetSelectedReference(None)
    StorageUtil.UnsetIntValue(marker, disabledListCountKey)
    StorageUtil.FormListClear(marker, disabledListKey)

EndFunction


Event OnActivate(ObjectReference akActionRef)
    GoToState("Busy")

    ;If !(Game.GetCameraState() == 0) && !(Game.GetPlayer().IsWeaponDrawn())
        ;Debug.SendAnimationEvent(Game.GetPlayer(), "IdleActivatePickUp")
        ;Utility.Wait(0.6)
        ;Debug.SendAnimationEvent(Game.GetPlayer(), "IdleStop")
    ;EndIf

    ; Blow Out
    If DC_On.HasForm(self.GetBaseObject())
        Int index = DC_On.Find(self.GetBaseObject())
        scale = self.GetScale()
        ObjectReference DC_New = self.PlaceAtMe(DC_Off.GetAt(index), 1, True, True) as ObjectReference
        If DC_SearchAllowed.GetValue() == 1.0
            DC_DisableLightClose(DC_New)
        EndIf
        DC_New.SetScale(scale)
        DC_New.Enable()
        self.Disable()
        Utility.Wait(1)
        self.Delete()
    

    ; Light
    ElseIf DC_Off.HasForm(self.GetBaseObject())
        Int index = DC_Off.Find(self.GetBaseObject())
        scale = self.GetScale()
        If DC_SearchAllowed.GetValue() == 1.0
            String disabledListCountKey = "DC_DisabledLightsCount_" + self.GetFormID()
            If (StorageUtil.GetIntValue(self, disabledListCountKey) > 0)
                DC_EnableLightClose(self)
            EndIf
        EndIf
        ObjectReference DC_New = self.PlaceAtMe(DC_On.GetAt(index), 1, True, True) as ObjectReference
        DC_New.SetScale(scale)
        DC_New.Enable()
        self.Disable()
        Utility.Wait(1)
        self.Delete()

    EndIf
    GoToState("")
EndEvent


Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    GoToState("Busy")
    
    ; Extinguish
    If akSource.HasKeyword(DC_Frost) && DC_On.HasForm(self.GetBaseObject())

        Int index = DC_On.Find(self.GetBaseObject())
        scale = self.GetScale()
        ObjectReference DC_New = self.PlaceAtMe(DC_Off.GetAt(index), 1, True, True) as ObjectReference
        If DC_SearchAllowed.GetValue() == 1.0
            DC_DisableLightClose(DC_New)
        EndIf
        DC_New.SetScale(scale)
        DC_New.Enable()
        self.Disable()
        Utility.Wait(1)
        self.Delete()


    ; Light
    ElseIf akSource.HasKeyword(DC_Fire) && DC_Off.HasForm(self.GetBaseObject())

        Int index = DC_Off.Find(self.GetBaseObject())
        scale = self.GetScale()
        If DC_SearchAllowed.GetValue() == 1.0
            String disabledListCountKey = "DC_DisabledLightsCount_" + self.GetFormID()
            If (StorageUtil.GetIntValue(self, disabledListCountKey) > 0)
                DC_EnableLightClose(self)
            EndIf
        EndIf
        ObjectReference DC_New = self.PlaceAtMe(DC_On.GetAt(index), 1, True, True) as ObjectReference
        DC_New.SetScale(scale)
        DC_New.Enable()
        self.Disable()
        Utility.Wait(1)
        self.Delete()

    EndIf
    GoToState("")
EndEvent


Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
    GoToState("Busy")
    
    ; Extinguish
    If akEffect.HasKeyword(DC_Frost) && DC_On.HasForm(self.GetBaseObject())

        Int index = DC_On.Find(self.GetBaseObject())
        scale = self.GetScale()
        ObjectReference DC_New = self.PlaceAtMe(DC_Off.GetAt(index), 1, True, True) as ObjectReference
        If DC_SearchAllowed.GetValue() == 1.0
            DC_DisableLightClose(DC_New)
        EndIf
        DC_New.SetScale(scale)
        DC_New.Enable()
        self.Disable()
        Utility.Wait(1)
        self.Delete()


    ; Light
    ElseIf akEffect.HasKeyword(DC_Fire) && DC_Off.HasForm(self.GetBaseObject())

        Int index = DC_Off.Find(self.GetBaseObject())
        scale = self.GetScale()
        If DC_SearchAllowed.GetValue() == 1.0
            String disabledListCountKey = "DC_DisabledLightsCount_" + self.GetFormID()
            If (StorageUtil.GetIntValue(self, disabledListCountKey) > 0)
                DC_EnableLightClose(self)
            EndIf
        EndIf
        ObjectReference DC_New = self.PlaceAtMe(DC_On.GetAt(index), 1, True, True) as ObjectReference
        DC_New.SetScale(scale)
        DC_New.Enable()
        self.Disable()
        Utility.Wait(1)
        self.Delete()

    EndIf
    GoToState("")
EndEvent


State Busy

    Event OnActivate(ObjectReference akActionRef)
    EndEvent

    Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    EndEvent

    Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
    EndEvent

EndState
