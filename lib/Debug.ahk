Class Debug
{
	Static LogFile := ""
	
	Benchmark(loops)	; Speed benchmark. 
	{
		starting_tick := A_TickCount
		
		Loop % loops
		{
			;Tooltip % AutoOS.Coordinates.GameTab.Magic.Standard.Spell1[1] ; Add funcion or label here.
			Tooltip % AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(1)[1]
		}
		Clipboard := (A_TickCount - starting_tick)
		Tooltip % "Ran the command/function " . loops . " times in: " .  (Clipboard) . "miliseconds. Last result is: "
	}
	
	CreateLog()
	{
		file_counter := 0
		Loop, Files, logs\log*.txt
		{
			++file_counter
		}
		Debug.LogFile := "logs\log" . ++file_counter . ".txt"
		
		FormatTime, TIME_STAMP,, [dd-MM-yyyy HH:mm:ss]:
		FileAppend, % TIME_STAMP . " AutoOS Starting.`r`n`r`n", % Debug.LogFile
	}
	
	AddLine(line, verbose := false)
	{
		if !verbose
			return
		If !Debug.LogFile
			Debug.CreateLog()
		FormatTime, TIME_STAMP,, [dd-MM-yyyy HH:mm:ss]:
		FileAppend, % "`r`n" . TIME_STAMP . " " . line, % Debug.LogFile
		FileRead, debug_file, % Debug.LogFile
		ControlSetText,, % debug_file , % "ahk_id " . UserInterface.MainGUI.ScriptDebugger	; Rewrites the script debugger to add the new lines. There's probably a better
																							; way to do this but for now this is good enough.
																							
		PostMessage, 0x115, 7,,, % "ahk_id " . UserInterface.MainGUI.ScriptDebugger			; This scrolls the edit control down to the bottom.
	}
	
	
}