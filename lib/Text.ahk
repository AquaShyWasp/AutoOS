Class Text
{
	CountIniSections(file)
	{
		Loop, Read, % file
		{
				If InStr(A_LoopReadLine, "[")
					section_count++	; If the ini file exists, counts saved player to know know which player number to add.
		}
		return section_count
	}
	
	ExtractParams(string)	; Extract parameters of a function in a string.
	{
		string := StrSplit(string, ", ", " `t")
		Loop % string.Length()
			string[A_Index] := StrReplace(string[A_Index], """", "") ; removes quotes from quoted strings. Keyboard methods need this.
		return string
	}
}