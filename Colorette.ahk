#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force

Hotkey, Rbutton, CatchColor
Hotkey, !Rbutton, CatchColor
ColoretteIcon := A_ScriptFullPath
Traytip, Colorette:, RIGHTCLICK to copy HEX value`nAdd ALT for RGB value`nPress SPACE for a color dialogue, 5
OnExit, Exit
SetSystemCursor("IDC_Cross")
FileCreateDir, data
FileInstall, data\pick_click.wav, data\pick_click.wav
If (FileExist("colorette.exe"))
   Menu, Tray, Icon, Colorette.exe
; MAIN LOOOP: Pick Color

Gui, -Caption +ToolWindow +LastFound +AlwaysOnTop +Border
Gui, Font, Bold
Gui, Add, Text, xCenter yCenter cGray vVar, 0000000

Loop
{
   CoordMode, Mouse, Screen
   MouseGetPos X, Y
   PixelGetColor Color, X, Y, RGB
   StringRight, color, color, 6 ;removes 0x prefix

   Gui, Color, %color%
   CoordMode, Pixel 
   mX := X - 25
   mY := Y - 80
   GuiControl,,Var,%color%
   Gui, Show, NoActivate x%mX% y%mY% w50 h50
}

CatchColor: ; Catch Hover'd color
   If (A_ThisHotkey = "!Rbutton")
      Out := "RGB"
   If (FileExist("data\pick_click.wav"))
      SoundPlay, data\pick_click.wav

ColorPicked:
   StringRight, color, color, 6 ; Color HEX to RGB (or RGB to RGB)
   ClipSaved := Clipboard ; Restore if replacing
      Clipboard := "null" ; So a void Clipboard doesn't seem as a capture
      Send ^c
      ClipboardCurrent := Clipboard ; To check StrLen
   If (Out = "RGB")
   {
      OutColor := HexToRGB(Color)
      OutMsg := HexToRGB(Color, "Message")
      Time := 14
   }
   else
   {
      OutColor := Color
      OutMsg :=  "#" . Color  
      Clipboard := OutColor
      Time := 2
   }
   If (Out = "RGB" AND RegExMatch(ClipboardCurrent, "[0-9A-Fa-f]{6}")) ; WHY ALL THIS? Because, if someone selects a colorcode, Colorette will replace it with the chosen color. Otherwise it'll just go to the clipboard.
   { 
      Send ^v
      Traytip, Colorette:, %outmsg% inserted, %Time%
      Clipboard := ClipSaved
   }
   else
      Traytip, Colorette:, %outmsg% picked, %Time%
   ClipSaved := "" ; Empty var

   RestoreCursors()
   Gui, Destroy
   Sleep 500
   Hotkey, !Rbutton, Off
   Hotkey, Rbutton, Off ; Position this in a nice place
   If (Out = "RGB") ; Needs more time to display
      Sleep 10000
   Sleep 1500
   Gosub, Exit
Return

esc::
Exit:
   RestoreCursors()
   ExitApp
return

Space::  
   Gui, Destroy
   RestoreCursors()
   Hotkey, Rbutton, Off
   Dlg_Color(color)
   Gosub, ColorPicked
return

#Include lib/ColorFunctions.ahk
#Include lib/Cursors.ahk
