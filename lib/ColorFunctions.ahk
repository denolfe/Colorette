HexToRGB(Color, Message="") ; Input: 6 letters
{
   ; If df, d is *16 and f is *1. Thus, Rx = R*16 while Rn = R*1
   Rx := SubStr(Color, 1,1)
   Rn := SubStr(Color, 2,1)
   Gx := SubStr(Color, 3,1)
   Gn := SubStr(Color, 4, 1)
   Bx := SubStr(Color, 5,1)
   Bn := SubStr(Color, 6,1)
   AllVars := "Rx|Rn|Gx|Gn|Bx|Bn"
   Loop, Parse, Allvars, |
   {
      StringReplace, %A_LoopField%, %A_LoopField%, a, 10
      StringReplace, %A_LoopField%, %A_LoopField%, b, 11
      StringReplace, %A_LoopField%, %A_LoopField%, c, 12
      StringReplace, %A_LoopField%, %A_LoopField%, d, 13
      StringReplace, %A_LoopField%, %A_LoopField%, e, 14
      StringReplace, %A_LoopField%, %A_LoopField%, f, 15
   }
   R := Rx*16+Rn
   G := Gx*16+Gn
   B := Bx*16+Bn
   If (Message)
      Out := "R:" . R . " G:" . G . " B:" . B
   else
      Out := R . G . B
    return Out
}

; Majkinetor's Dlg_Color included with Forms Framework: http://www.autohotkey.com/board/topic/49214-ahk-ahk-l-forms-framework-08/#entry306544
Dlg_Color(ByRef Color, hGui=0) 
{
   ;convert from rgb
   clr := ((Color & 0xFF) << 16) + (Color & 0xFF00) + ((Color >> 16) & 0xFF)
   VarSetCapacity(CHOOSECOLOR, 0x24, 0), VarSetCapacity(CUSTOM, 64, 0)
   , NumPut(0x24, CHOOSECOLOR, 0) ; DWORD lStructSize
   , NumPut(hGui, CHOOSECOLOR, 4) ; HWND hwndOwner (makes dialog "modal").
   , NumPut(clr, CHOOSECOLOR, 12) ; clr.rgbResult
   , NumPut(&CUSTOM, CHOOSECOLOR, 16) ; COLORREF *lpCustColors
   , NumPut(0x00000103,CHOOSECOLOR, 20) ; Flag: CC_ANYCOLOR || CC_RGBINIT
   nRC := DllCall("comdlg32\ChooseColorA", str, CHOOSECOLOR) ; Display the dialog.
   if (errorlevel <> 0) || (nRC = 0)
       return false
   clr := NumGet(CHOOSECOLOR, 12)
   oldFormat := A_FormatInteger
   SetFormat, integer, hex ; Show RGB color extracted below in hex format.
   ;convert to rgb
   Color := (clr & 0xff00) + ((clr & 0xff0000) >> 16) + ((clr & 0xff) << 16)
   StringTrimLeft, Color, Color, 2
   Loop, % 6-strlen(Color)
   Color=0%Color%
   Color=0x%Color%
   SetFormat, integer, %oldFormat%
   return true
}