Scriptname DynamicCandles extends ObjectReference


Light Property DC_CandleLight Auto
FormList Property DC_On Auto
FormList Property DC_Off Auto
Keyword Property DC_Fire Auto
Keyword Property DC_Frost Auto
GlobalVariable Property DC_SearchAllowed Auto
GlobalVariable Property DC_CD_Slider Auto

ObjectReference DC_LightFlagClose
Float scale



Function DC_DisableLightClose()
	Cell kCell = Game.GetPlayer().GetParentCell()
	Int i = kCell.GetNumRefs(31) - 1
    Float maxDistance = DC_CD_Slider.GetValue()

	While i >= 0
        DC_LightFlagClose = kCell.GetNthRef(i, 31)
        Float distance = self.GetDistance(DC_LightFlagClose)
        If (distance < maxDistance)
            ConsoleUtil.SetSelectedReference(DC_LightFlagClose)
            ConsoleUtil.ExecuteCommand("Disable")
            ConsoleUtil.ExecuteCommand("Markfordelete")
        EndIf
        i -= 1
	EndWhile

    ConsoleUtil.SetSelectedReference(None)
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
        If DC_SearchAllowed.GetValue() == 1.0
            DC_DisableLightClose()
        EndIf
        scale = self.GetScale()
        ObjectReference DC_New = self.PlaceAtMe(DC_Off.GetAt(index), 1, True, True) as ObjectReference
        DC_New.SetScale(scale)
        DC_New.Enable()
        self.Disable()
        Utility.Wait(1)
        self.Delete()
    

    ; Light
    ElseIf DC_Off.HasForm(self.GetBaseObject())
        Int index = DC_Off.Find(self.GetBaseObject())
        If DC_SearchAllowed.GetValue() == 1.0
            self.PlaceAtMe(DC_CandleLight, 1, True)
        EndIf
        scale = self.GetScale()
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
        If DC_SearchAllowed.GetValue() == 1.0
            DC_DisableLightClose()
        EndIf
        scale = self.GetScale()
        ObjectReference DC_New = self.PlaceAtMe(DC_Off.GetAt(index), 1, True, True) as ObjectReference
        DC_New.SetScale(scale)
        DC_New.Enable()
        self.Disable()
        Utility.Wait(1)
        self.Delete()


    ; Light
    ElseIf akSource.HasKeyword(DC_Fire) && DC_Off.HasForm(self.GetBaseObject())

        Int index = DC_Off.Find(self.GetBaseObject())
        If DC_SearchAllowed.GetValue() == 1.0
            self.PlaceAtMe(DC_CandleLight, 1, True)
        EndIf
        scale = self.GetScale()
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
        If DC_SearchAllowed.GetValue() == 1.0
            DC_DisableLightClose()
        EndIf
        scale = self.GetScale()
        ObjectReference DC_New = self.PlaceAtMe(DC_Off.GetAt(index), 1, True, True) as ObjectReference
        DC_New.SetScale(scale)
        DC_New.Enable()
        self.Disable()
        Utility.Wait(1)
        self.Delete()


    ; Light
    ElseIf akEffect.HasKeyword(DC_Fire) && DC_Off.HasForm(self.GetBaseObject())

        Int index = DC_Off.Find(self.GetBaseObject())
        If DC_SearchAllowed.GetValue() == 1.0
            self.PlaceAtMe(DC_CandleLight, 1, True)
        EndIf
        scale = self.GetScale()
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
