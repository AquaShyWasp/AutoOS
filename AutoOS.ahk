#NoEnv
SetBatchLines -1
ListLines Off
#SingleInstance Force
SetWorkingDir % A_ScriptDir  ; Ensures a consistent starting directory.

AOS_Start(1)
/*
UserInterface.PlayerManager.MasterPassword()
UserInterface.PlayerManager.Start()
UserInterface.PlayerManager.State(true)
*/

UserInterface.PlayerManager.NewPlayer()

return




^f::

	;gosub, AsyncTest
return



AsyncTest:
	; stats async mouse move, then keyboard press and then the loop. they don't start at the same time as each one is called one at a time but they all run in paralel.
	Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(200, 300, 500, 300, move)", "AsyncMouse.ahk ahk_class AutoHotkey")
	Input.SendAsyncInput("Input.Human.Keyboard.PressKey(""k"", 2000)", "AsyncKeyboard.ahk ahk_class AutoHotkey")
	Loop, 1000
		ToolTip % A_Index
return


PlayerManagerGuiClose:
	OnExit()
return

^ESC::
	OnExit()
return