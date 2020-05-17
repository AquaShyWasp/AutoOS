#NoEnv
SetBatchLines -1
ListLines Off

#SingleInstance Force
#Include <AOS>
#Include <Math>
#Include <Color>
#Include <Text>
#Include <Debug>
#Include <InputHandler>
#Include <UI>



SetWorkingDir % A_ScriptDir  ; Ensures a consistent starting directory.
AutoOSStart(1)
return


^f::
	;AutoOS.Core.GameTab.Magic.Lunar.CastSpell("PlankMake")
	AutoOS.Core.GameTab.Inventory.ClickSlot(5)
	;gosub, AsyncQueueTest
	;FileSelectFile, LoadedScript, Options, % A_WorkingDir . "\scripts" , Script Loader, *.ahk
	;if !ErrorLevel and LoadedScript
		;#IncludeAgain %LoadedScript%
return


AsyncQueueTest:
	Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(200, 300, 300, 300, move)", "AsyncMouse.ahk ahk_class AutoHotkey")
	Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(900, 900, 800, 800, move)", "AsyncMouse.ahk ahk_class AutoHotkey")
	Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(500, 500, 400, 400, move)", "AsyncMouse.ahk ahk_class AutoHotkey")
	Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(900, 900, 800, 800, move)", "AsyncMouse.ahk ahk_class AutoHotkey")
	Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(200, 300, 300, 300, move)", "AsyncMouse.ahk ahk_class AutoHotkey")
	Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(900, 900, 800, 800, move)", "AsyncMouse.ahk ahk_class AutoHotkey")
	Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(500, 500, 400, 400, move)", "AsyncMouse.ahk ahk_class AutoHotkey")
	Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(900, 900, 800, 800, move)", "AsyncMouse.ahk ahk_class AutoHotkey")
	Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(200, 300, 300, 300, move)", "AsyncMouse.ahk ahk_class AutoHotkey")
	Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(900, 900, 800, 800, move)", "AsyncMouse.ahk ahk_class AutoHotkey")
	Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(500, 500, 400, 400, move)", "AsyncMouse.ahk ahk_class AutoHotkey")
	Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(900, 900, 800, 800, move)", "AsyncMouse.ahk ahk_class AutoHotkey")
return



AsyncTest:
	; stats async mouse move, then keyboard press and then the loop. they don't start at the same time as each one is called one at a time but they all run in paralel.
	Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(200, 300, 500, 300, move)", "AsyncMouse.ahk ahk_class AutoHotkey")
	Input.SendAsyncInput("Input.Human.Keyboard.PressKey(""k"", 2000)", "AsyncKeyboard.ahk ahk_class AutoHotkey")
	Loop, 1000
		ToolTip % A_Index
return

^ESC::
	OnExit()
return