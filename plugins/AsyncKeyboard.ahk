#NoEnv
#SingleInstance Force
;#NoTrayIcon
#Include ./lib/AOS.ahk
#Include ./lib/Gdip.ahk
#Include ./lib/Math.ahk
#Include ./lib/Text.ahk
#Include ./lib/InputHandler.ahk

DATA_ARRAY := []
OnMessage(0x4a, "ReceiveAsyncInput")  ; 0x4a is WM_COPYDATA
return

ReceiveAsyncInput(wParam, lParam)
{
	Critical, On	; This was the only way I found out so far to remove lag.... there should be a better way.
	string_address := NumGet(lParam + 2*A_PtrSize)  ; Retrieves the CopyDataStruct's lpData member.
	data := StrGet(string_address) 					; Copy the string out of the structure	.
	global DATA_ARRAY
	DATA_ARRAY.Push(data)
	if InStr(data, "Exit", true)
		ExitApp
	SetTimer, DelayedThread, -5
	return true  ; Returning 1 (true) is the traditional way to acknowledge this message.
	
	DelayedThread:
	While % DATA_ARRAY.Length()
	{
		Input.DynamicKeyboardMethod(DATA_ARRAY[1])
		DATA_ARRAY.RemoveAt(1)
	}
	return
}

^#ESC::
	ExitApp
return