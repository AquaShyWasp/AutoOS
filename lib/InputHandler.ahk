Class Input	; Core Class of our input
{	; TODO: Need to add a client check before every input I think, so we don't send input to the wrong place and mess the bot.
	
	Static AsyncMouse, AsyncKeyboard
	
	SendAsyncInput(ByRef StringToSend, ByRef TargetScriptTitle)
	{	
		Critical
		VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  ; Set up the structure's memory area.
		; First set the structure's cbData member to the size of the string, including its zero terminator:
		SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
		NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; OS requires that this be done.
		NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself.
		Prev_DetectHiddenWindows := A_DetectHiddenWindows
		Prev_TitleMatchMode := A_TitleMatchMode
		DetectHiddenWindows On
		SetTitleMatchMode 2
		time_out := 25  ; I set this to 1 so it doesn't hang waiting for a response... I don't like having a confirmation though
		SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%,,,, % time_out ; 0x4a is WM_COPYDATA.
		If (ErrorLevel != 1)
			SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%,,,, % time_out ; 0x4a is WM_COPYDATA.
		DetectHiddenWindows %Prev_DetectHiddenWindows%  ; Restore original setting for the caller.
		SetTitleMatchMode %Prev_TitleMatchMode%         ; Same.
		
		return
	}
	
	DynamicMouseMethod(string)	; Runs an input method dynamically (a method inside a variable).
	{
		; When you call a input method through this, you need to declare all parameters. Haven't tested it but it's very likely it won't work well If you don't declare all params.
		params := Text.ExtractParams(StrSplit(StrSplit(string, "(")[2], ")")[1])
		If InStr(string, "Human.")	; need to include the period at the or it will be messed up by "HumanCoordinates" method.
		{
			If InStr(string, "Box")
				Input.Human.Mouse.Box(params[1], params[2], params[3], params[4], params[5])
			Else if InStr(string, "Mid")
				Input.Human.Mouse.Mid(params[1], params[2], params[3], params[4], params[5])
			Else if InStr(string, "Circle")
				Input.Human.Mouse.Circle(params[1], params[2], params[3], params[4])
			Else if InStr(string, "CwBox")
				Input.Human.Mouse.CwBox(params[1], params[2], params[3], params[4], params[5])
			Else if InStr(string, "HumanCoordinates")
				Input.Human.Mouse.HumanCoordinates(params[1], params[2], params[3], params[4], params[5])
		}
		Else
		{
			If InStr(string, "Box")
				Input.Mouse.Box(params[1], params[2], params[3], params[4], params[5])
			Else if InStr(string, "Mid")
				Input.Mouse.Mid(params[1], params[2], params[3], params[4], params[5])
			Else if InStr(string, "Circle")
				Input.Mouse.Circle(params[1], params[2], params[3], params[4])
			Else if InStr(string, "CwBox")
				Input.Mouse.CwBox(params[1], params[2], params[3], params[4], params[5])
			Else if InStr(string, "HumanCoordinates")
				Input.Mouse.HumanCoordinates(params[1], params[2], params[3], params[4], params[5])
			Else if InStr(string, "RandomBezier")
				Input.Mouse.RandomBezier(params[1], params[2], params[3], params[4], params[5], params[6], params[7])
		}



	}
	
	DynamicKeyboardMethod(string)	; Runs an input method dynamically (a method inside a variable).
	{
		; When you call a input method through this, you need to declare all parameters. Haven't tested it but it's very likely it won't work well If you don't declare all params.
		
		
		params := Text.ExtractParams(StrSplit(StrSplit(string, "(")[2], ")")[1])
		
		If InStr(string, "Human.")	; need to include the period at the or it will be messed up by "HumanCoordinates" method.
		{
			If InStr(string, "PressKey")
				Input.Human.Keyboard.PressKey(params[1], params[2])
			Else if InStr(string, "MultiKeyPress")
				Input.Human.Keyboard.MultiKeyPress(params[1], params[2], params[3], params[4], params[5], params[6])
			Else if InStr(string, "SendSentence")
				Input.Human.Keyboard.SendSentence()
		}
		Else
		{
			If InStr(string, "PressKey")
				Input.Keyboard.PressKey(params[1], params[2])
			Else if InStr(string, "MultiKeyPress")
				Input.Keyboard.MultiKeyPress(params[1], params[2], params[3], params[4], params[5], params[6])
			Else if InStr(string, "SendSentence")
				Input.Keyboard.SendSentence()
		}

	}
	
	Class Mouse	; Basic Mouse functionality
	{
		
		Box(x, y, w, h, action := "move")
		{
			box := Math.GetPoint.Box(x, y, w, h)
			AutoOS.Client.ActivateClient()
			MouseMove, box[1], box[2], Math.Random(AutoOS.PlayerManager.MouseSlowSpeed, AutoOS.PlayerManager.MouseFastSpeed)
			If (action != "move")
				MouseClick, % action
		}
				
		Mid(x, y, w, h, action := "move")
		{
			mid := Math.GetPoint.Mid(x, y, w, h)
			AutoOS.Client.ActivateClient()
			MouseMove, mid[1], mid[2], Math.Random(AutoOS.PlayerManager.MouseSlowSpeed, AutoOS.PlayerManager.MouseFastSpeed)
			If (action != "move")
				MouseClick, % action
		}
		
		Circle(x, y, radius, action := "move")
		{
			circle := Math.GetPoint.Circle(x, y, radius)
			AutoOS.Client.ActivateClient()
			MouseMove, circle[1], circle[2], Math.Random(AutoOS.PlayerManager.MouseSlowSpeed, AutoOS.PlayerManager.MouseFastSpeed)
			If (action != "move")
				MouseClick, % action
		}
		
		CwBox(x, y, w, h, action := "move") ; CwBox := Circle within box
		{
			cwb := Math.GetPoint.CwBox(x, y, w, h)
			AutoOS.Client.ActivateClient()
			MouseMove, cwb[1], cwb[2], Math.Random(AutoOS.PlayerManager.MouseSlowSpeed, AutoOS.PlayerManager.MouseFastSpeed)
			If (action != "move")
				MouseClick, % action
		}
		
		HumanCoordinates(x, y, w, h, action := "move")
		{
			coord := Math.GetPoint.HumanCoordinates(x, y, w, h)
			AutoOS.Client.ActivateClient()
			MouseMove, coord[1], coord[2], Math.Random(AutoOS.PlayerManager.MouseSlowSpeed, AutoOS.PlayerManager.MouseFastSpeed)
			If (action != "move")
				MouseClick, % action
		}

		; MasterFocus's RandomBezier function.
		; Source at: https://github.com/MasterFocus/AutoHotkey/tree/master/Functions/RandomBezier
		; Slightly modIfied and simplIfied for my use... Would like to completely redo this later on as it's not very clear IMO.
		RandomBezier(X0, Y0, Xf, Yf, action := "move", p1 := 2, p2 := 4, speed1 := 3, speed2 := 8)
		{	
			x_distance := X0 - Xf
			y_distance := Y0 - Yf

			; speed1 and speed2 are mousespeeds. Like the ones we have with MouseMove, X, Y, *Speed*
			; Did some benchmarks with A_TickCount to figure more or less how do the mouse speed numbers translate to miliseconds.
			; This formula depending on the distance is what I came up with.
			speed_modIfier := Round(Math.GetLowest(Math.MakePositive(x_distance), Math.MakePositive(y_distance)) / 3.5)
			time := Math.Random((speed2 * speed_modIfier), (speed1 * speed_modIfier))
			N := Math.Random(p1, p2)
			
			If (N > 20)
				N := 19
			Else if (N < 2)
				N := 2
			
			If (Math.Between(x_distance, -50, 50) or Math.Between(y_distance, -50, 50))	; If the distance is short, doesn't make sense having the
				N := 2																						; mouse doing crazy curves.
	
			
			OfT := 100, OfB := 100
			OfL := 100, OfR := 100
			
			AutoOS.Client.ActivateClient()
			MouseGetPos, XM, YM
			
			If (X0 < Xf)
				sX := X0-OfL, bX := Xf+OfR
			Else
				sX := Xf-OfL, bX := X0+OfR
				
			If (Y0 < Yf)
				sY := Y0-OfT, bY := Yf+OfB
			Else
				sY := Yf-OfT, bY := Y0+OfB
				
			Loop, % (--N)-1
			{
				Random, X%A_Index%, sX, bX
				Random, Y%A_Index%, sY, bY
			}
			
			X%N% := Xf
			Y%N% := Yf
			E := (I := A_TickCount) + time
			While (A_TickCount < E)
			{
				U := 1 - (T := (A_TickCount - I) / time)
				Loop, % N + 1 + (X := Y := 0)
				{
					Loop, % Idx := A_Index - (F1 := F2 := F3 := 1)
						F2 *= A_Index, F1 *= A_Index
					Loop, % D := N-Idx
						F3 *= A_Index, F1 *= A_Index+Idx
					M := (F1/(F2*F3))*((T+0.000001)**Idx)*((U-0.000001)**D), X+=M*X%Idx%, Y+=M*Y%Idx%
				}
				MouseMove, X, Y, 0
			}
			MouseMove, Xf, Yf, Math.Random(AutoOS.PlayerManager.MouseSlowSpeed, AutoOS.PlayerManager.MouseFastSpeed)
			
			If ((action != "move") and (action != "doubleclick"))
				MouseClick, % action
			Else if (action == "doubleclick")
			{
				MouseClick, Left
				Sleep, Math.Random(300, 400)	; This should be passed to the function later on but for now i'll leave it like this since this is barely ever used.
				MouseClick, Left
			}
			return N+1
		}
	
	}
	
	Class Keyboard ; Basic Keyboard functionality
	{
		PressKey(key, time := 30)
		{
			AutoOS.Client.ActivateClient()
			Send, {%key% Down}
			Sleep, time
			Send, {%key% Up}
		}
		
		MultiKeyPress(key1, key2, key3 := "", key4 := "", key5 := "", time := 30)
		{
			AutoOS.Client.ActivateClient()
			Send, {%key1% Down}
			Send, {%key2% Down}
			If key3
				Send, {%key3% Down}
			If key4
				Send, {%key4% Down}
			If key5
				Send, {%key5% Down}
			Sleep, time
			Send, {%key1% Up}
			Send, {%key2% Up}
			If key3
				Send, {%key3% Up}
			If key4
				Send, {%key4% Up}
			If key5
				Send, {%key5% Up}
		}
		
		SendSentence()	; TODO. When done, need to finish async keyboard too.
		{
			
		}
		
	}
	
	Class Human	; Uses input that looks more like a human.
	{
		Class Mouse	; This Class is an identical copy of Input.Mouse Class but uses RandomBezier for all mouse movements. Making it look more like a human.
		{
			Box(x, y, w, h, action := "move")
			{
				box := Math.GetPoint.Box(x, y, w, h)
				AutoOS.Client.ActivateClient()
				MouseGetPos, current_x, current_y
				Input.Mouse.RandomBezier(current_x, current_y, box[1], box[2], action, 2, 4, AutoOS.PlayerManager.MouseFastSpeed, AutoOS.PlayerManager.MouseSlowSpeed)
			}
		
			Mid(x, y, w, h, action := "move")
			{
				mid := Math.GetPoint.Mid(x, y, w, h)
				AutoOS.Client.ActivateClient()
				MouseGetPos, current_x, current_y
				Input.Mouse.RandomBezier(current_x, current_y, mid[1], mid[2], action, 2, 4, AutoOS.PlayerManager.MouseFastSpeed, AutoOS.PlayerManager.MouseSlowSpeed)
			}
			
			Circle(x, y, radius, action := "move")
			{
				circle := Math.GetPoint.Circle(x, y, radius)
				AutoOS.Client.ActivateClient()
				MouseGetPos, current_x, current_y
				Input.Mouse.RandomBezier(current_x, current_y, circle[1], circle[2], action, 2, 4, AutoOS.PlayerManager.MouseFastSpeed, AutoOS.PlayerManager.MouseSlowSpeed)
			}
			
			CwBox(x, y, w, h, action := "move") ; CwBox := Circle within box
			{
				cwb := Math.GetPoint.CwBox(x, y, w, h)
				AutoOS.Client.ActivateClient()
				MouseGetPos, current_x, current_y
				Input.Mouse.RandomBezier(current_x, current_y, cwb[1], cwb[2], action, 2, 4, AutoOS.PlayerManager.MouseFastSpeed, AutoOS.PlayerManager.MouseSlowSpeed)
			}
			
			HumanCoordinates(x, y, w, h, action := "move")
			{
				coord := Math.GetPoint.HumanCoordinates(x, y, w, h)
				AutoOS.Client.ActivateClient()
				MouseGetPos, current_x, current_y
				Input.Mouse.RandomBezier(current_x, current_y, coord[1], coord[2], action, 2, 4, AutoOS.PlayerManager.MouseFastSpeed, AutoOS.PlayerManager.MouseSlowSpeed)
			}

		}
	
		Class Keyboard ; Uses the keyboard in a more human convincing way.
		{
			PressKey(key, time := 30)	; This function mimics the auto-repeat feature most keyboards have.
			{
				AutoOS.Client.ActivateClient()
				Send, {%key% Down}
				If (time > 500)			; This might be dIfferent with other keyboards but mine holds the key down
				{						; for 500 miliseconds before starting the auto-repeat ¯\_(ツ)_/¯
					Sleep, 500
					time := time-500
					loop_counter := Round((time/30))
					Loop % loop_counter
					{
						Send, {%key% Down}
						Sleep, 30
					}
					
					If ((loop_counter * 30) < time)				; Fixes the rounding we've done before... there's probably
						Sleep, ((loop_counter * 30) - time)		; no need to be this precise, but I'm a perfectionist.
				}
				Else
					Sleep, time
				Send, {%key% Up}
			}
			
			MultiKeyPress(key1, key2, key3 := "", key4 := "", key := "", time := 30) ; Haven't tested this yet. Should work though.
			{
				AutoOS.Client.ActivateClient()
				Send, {%key1% Down}
				Send, {%key2% Down}
				If key3
					Send, {%key3% Down}
				If key4
					Send, {%key4% Down}
				If key5
					Send, {%key5% Down}
				If (time > 500)
				{
					Sleep, 500
					time := time-500
					loop_counter := Round((time/30))
					Loop % loop_counter
					{
						Send, {%key1% Down}
						Send, {%key2% Down}
						If key3
							Send, {%key3% Down}
						If key4
							Send, {%key4% Down}
						If key5
							Send, {%key5% Down}
						Sleep, 30
					}
					
					If ((loop_counter * 30) < time)
						Sleep, ((loop_counter * 30) - time)
				}
				Else
					Sleep, time
				Send, {%key1% Up}
				Send, {%key2% Up}
				If key3
					Send, {%key3% Up}
				If key4
					Send, {%key4% Up}
				If key5
					Send, {%key5% Up}
			}
		
			SendSentence()	; TODO. When done, need to finish async keyboard too.
			{
				
			}
		
		}
	}

}