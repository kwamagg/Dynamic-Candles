Scriptname DynamicCandles extends ObjectReference


FormList Property DC_On Auto
FormList Property DC_Off Auto
FormList Property DC_CandleSticks Auto
GlobalVariable Property DC_SearchAllowed Auto
GlobalVariable Property DC_CD_Slider Auto

ObjectReference DC_LightFlagClose
Float scale



Function DC_DisableLightClose()
	Cell kCell = Game.GetPlayer().GetParentCell()
	Int i = kCell.GetNumRefs(31) - 1

	While i >= 0
        DC_LightFlagClose = kCell.GetNthRef(i, 31)
        Float distance = self.GetDistance(DC_LightFlagClose)
        If (distance < DC_CD_Slider.GetValue()) && (DC_LightFlagClose != self) && !(DC_LightFlagClose as Actor)
            ConsoleUtil.SetSelectedReference(DC_LightFlagClose)
            ConsoleUtil.ExecuteCommand("Disable")
        EndIf
        i -= 1
	EndWhile

    ConsoleUtil.SetSelectedReference(Game.GetPlayer())
EndFunction


Event OnActivate(ObjectReference akActionRef)
    GoToState("Busy")

    ; Blow Out
    If DC_On.HasForm(self.GetBaseObject())
        Int index = DC_On.Find(self.GetBaseObject())
        If DC_SearchAllowed.GetValue() == 1.0
            DC_DisableLightClose()
        EndIf
        scale = self.GetScale()
        ObjectReference DC_New = self.PlaceAtMe(DC_Off.GetAt(index), 1, True) as ObjectReference
        DC_New.SetScale(scale)
        self.Delete()
    
    ; Light
    ElseIf DC_Off.HasForm(self.GetBaseObject())
        Int index = DC_Off.Find(self.GetBaseObject())
        scale = self.GetScale()
        ObjectReference DC_New = self.PlaceAtMe(DC_On.GetAt(index), 1, True) as ObjectReference
        DC_New.SetScale(scale)
        self.Delete()

    EndIf
    GoToState("")
EndEvent


State Busy

    Event OnActivate(ObjectReference akActionRef)
    EndEvent

EndState
