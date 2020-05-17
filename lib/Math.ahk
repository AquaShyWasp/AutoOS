Class Math
{
	Random(n1, n2)
	{
		Random, r, %n1%, %n2%
		return %r%
	}
	
	Between(n, min, max)	; Between function that can be used in expressions. Checks If n is between min and max
	{
		If ((min <=  n) and (n <= max))
			return true
		Else
			return false	
	}
	
	InBox(x, y, box)
	{
		If (Math.Between(x, box[1], box[3]) and Math.Between(y, box[2], box[4]))
			return true
		Else
			return false
		
	}
	
	WhichBox(x, y, box1, box2, box3 := "", box4 := "", box5 := "", box6 := "", box7 := "", box8 := "", box9 := "", box10 := "")
	{
		If Math.InBox(x, y, box1)
			return box1
		Else if Math.InBox(x, y, box2)
			return box2
		Else if (box3 and Math.InBox(x, y, box3))
			return box3
		Else if (box4 and Math.InBox(x, y, box4))
			return box4
		Else if (box5 and Math.InBox(x, y, box5))
			return box5
		Else if (box6 and Math.InBox(x, y, box6))
			return box6
		Else if (box7 and Math.InBox(x, y, box7))
			return box7
		Else if (box8 and Math.InBox(x, y, box8))
			return box8
		Else if (box9 and Math.InBox(x, y, box9))
			return box9
		Else if (box10 and Math.InBox(x, y, box10))
			return box10
		Else
			return false
	}
	
	GetLowest(n1, n2)
	{
		If (n1 > n2)
			return n2
		Else if (n1 < n2)
			return n1
	}
	
	GetHighest(n1, n2)
	{
		If (n1 > n2)
			return n1
		Else if (n1 < n2)
			return n2
	}
	
	MakePositive(n)
	{
		If (n < 0)
			return (n * -1)
		Else
			return n
	}
	
	MakeNegative(n)
	{
		If (n > 0)
			return (n * -1)
		Else
			return n
	}
	
	DPIScale(n, operation := "scale")
	{
		If (operation == "scale")
		{
			If (A_ScreenDPI == 96)
				return % n
			Else if (A_ScreenDPI == 120)
				return % n
				;return % Round(n * 1.25)
			Else if (A_ScreenDPI == 144)
				return % n
				;return % Round(n * 1.5)
			Else if (A_ScreenDPI == 168)
				return % n
				;return % Round(n * 1.75)
			Else if (A_ScreenDPI == 192)
				return % n
				;return % n * 2
		}
		Else if (operation == "descale")
		{
			If (A_ScreenDPI == 96)
				return % n
			Else if (A_ScreenDPI == 120)
				return % n
				;return % Round(n / 1.25)
			Else if (A_ScreenDPI == 144)
				return % n
				;return % Round(n / 1.5)
			Else if (A_ScreenDPI == 168)
				return % n
				;return % Round(n / 1.75)
			Else if (A_ScreenDPI == 192)
				return % n
				;return % Round(n / 2)
		}
	}
	
	Class GetPoint
	{
		Box(x, y, w, h)
		{
			return Array(Math.Random(x, w), Math.Random(y, h))
		}
		
		; Get Middle point of 2 coordinates (same axis) or 4 points (2 axis).
		; If only 2 points are used, n1 and n2 MUST be of the same axis.
		; When all 4 points are used n1, n2, n3 and n4 should be x, y, w, h respectively.
		Mid(n1, n2, n3 := "", n4 := "")
		{
			If (!n3 and !n4)
				return Round((n1 + n2) / 2)
			Else if (n3 and n4)			
				return Array(Round((n1 + n3) / 2), Round((n2 + n4) / 2))
			Else if ((n3 and !n4) or (!n3 and n4))
				return "Error"
		}
		
		; Calculates a random point within a radius of x and y.
		Circle(x, y, radius)
		{
			final_x := Round((Math.Random(-1.0, 1.0) * radius) + x)
			final_y := Round((sqrt(1 - Math.Random(-1.0, 1.0) ** 2) * radius * Math.Random(-1.0, 1.0)) + y)
			return Array(final_x, final_y)
		}
		
		; Calculates a random point in a circle within a box.
		CwBox(x, y, w, h)
		{
			; Checks which diameter is smaller and uses it to calculate the radius.
			; If both axis have the same diameter it uses the first one since they would be the same.
			If ((x - w) <= (y - h))
				radius := Round((w - x) / 2)
			Else if ((x -w) > (y - h))
				radius := Round((h - y) / 2)
			mid_point := Math.GetPoint.Mid(x, y, w, h)
			return Math.GetPoint.Circle(mid_point[1], mid_point[2], radius)
		}
		
		; One thing that annoys me on some bots and scripts is that they take your mouse to a random coordinate inside a border.
		; I deslike it because you end up click a lot of times close to the borders of whatever your are clicking,
		; where usually there's only "empty" space and doesn't look human at all.
		; This function attempts to solve that.
		; It gives you coordinates that are more likely to be in the center where the icon of whatever you want to click likely is.
		HumanCoordinates(x, y, w, h) ; TODO NEED TO MAKE THIS BETTER
		{
			Random, probability, 0, 99
			
			if ((((w-x) - (h-y)) >= 10) OR (((w-x) - (h-y)) <= -10)) ; checks if the box is a square or a rectangle. 
			{
				x := x+2, y := y+2, w := w-2, h := h-2
				return Array(Math.Random(x, w), Math.Random(y, h))
			}
			Else
			{
				If (probability <= 49)
				{
					case := 1
					x_circle := Round(x + ((w - x) * 0.2))	; 50% probability the coordinates will be in the "eye" of the box.
					w_circle := Round(w + ((x - w) * 0.2))
					y_circle := Round(y + ((h - y) * 0.2))
					h_circle := Round(h + ((y - h) * 0.2))
				}
				Else if (probability <= 84)
				{
					case := 2
					x_circle := Round(x + ((w - x) * 0.35))	; 35% probability the coordinates will be in the inner circle inside of the box.
					w_circle := Round(w + ((x - w) * 0.35))	; This includes the "eye" above, so in reality the probability of having the coordinates closer to the center
					y_circle := Round(y + ((h - y) * 0.35))	; is higher than 50%.
					h_circle := Round(h + ((y - h) * 0.35))
				}
				Else if (probability >= 85)
				{
					case := 3
					x_circle := Round(x + ((w - x) * 0.45))	; 15% probability the coordinates will be in the outter parts of the circle inside of the box.
					w_circle := Round(w + ((x - w) * 0.45))	; This includes the "eye" and the inner circle above, so in reality the probability of having
					y_circle := Round(y + ((h - y) * 0.45))	; the coordinates closer to the center is higher than 50% for the "eye" and 35% for the inner circle.
					h_circle := Round(h + ((y - h) * 0.45))
				}
				return Math.GetPoint.CwBox(x_circle, y_circle, w_circle, h_circle)
			}
		}

	}
	
	
}

Class Encryption
{
	; Code by jNizM on GitHub modIfied to UTF-8 as it was causing some errors. Link: https://gist.github.com/jNizM/79aa6a4b8ec428bf780f
	Class AES
	{
		Encrypt(string, password, alg)
		{
			len := this.StrPutVar(string, str_buf, 0, "UTF-8")
			this.Crypt(str_buf, len, password, alg, 1)
			return this.b64Encode(str_buf, len)
		}
		Decrypt(string, password, alg)
		{
			len := this.b64Decode(string, encr_Buf)
			sLen := this.Crypt(encr_Buf, len, password, alg, 0)
			sLen /= 2
			return StrGet(&encr_Buf, sLen, "UTF-8")
		}

		Crypt(ByRef encr_Buf, ByRef Buf_Len, password, ALG_ID, CryptMode := 1)
		{
			; WinCrypt.h
			Static MS_ENH_RSA_AES_PROV := "Microsoft Enhanced RSA and AES Cryptographic Provider"
			Static PROV_RSA_AES        := 24
			Static CRYPT_VERIFYCONTEXT := 0xF0000000
			Static CALG_SHA1           := 0x00008004
			Static CALG_SHA_256        := 0x0000800c
			Static CALG_SHA_384        := 0x0000800d
			Static CALG_SHA_512        := 0x0000800e
			Static CALG_AES_128        := 0x0000660e ; KEY_LENGHT := 0x80  ; (128)
			Static CALG_AES_192        := 0x0000660f ; KEY_LENGHT := 0xC0  ; (192)
			Static CALG_AES_256        := 0x00006610 ; KEY_LENGHT := 0x100 ; (256)
			Static KP_BLOCKLEN         := 8

			If !(DllCall("advapi32.dll\CryptAcquireContext", "Ptr*", hProv, "Ptr", 0, "Ptr", 0, "Uint", PROV_RSA_AES, "UInt", CRYPT_VERIFYCONTEXT))
				MsgBox % "*CryptAcquireContext (" DllCall("kernel32.dll\GetLastError") ")"

			If !(DllCall("advapi32.dll\CryptCreateHash", "Ptr", hProv, "Uint", CALG_SHA1, "Ptr", 0, "Uint", 0, "Ptr*", hHash))
				MsgBox % "*CryptCreateHash (" DllCall("kernel32.dll\GetLastError") ")"

			passLen := this.StrPutVar(password, passBuf, 0, "UTF-8")
			If !(DllCall("advapi32.dll\CryptHashData", "Ptr", hHash, "Ptr", &passBuf, "Uint", passLen, "Uint", 0))
				MsgBox % "*CryptHashData (" DllCall("kernel32.dll\GetLastError") ")"
			
			If !(DllCall("advapi32.dll\CryptDeriveKey", "Ptr", hProv, "Uint", CALG_AES_%ALG_ID%, "Ptr", hHash, "Uint", (ALG_ID << 0x10), "Ptr*", hKey)) ; KEY_LENGHT << 0x10
				MsgBox % "*CryptDeriveKey (" DllCall("kernel32.dll\GetLastError") ")"

			If !(DllCall("advapi32.dll\CryptGetKeyParam", "Ptr", hKey, "Uint", KP_BLOCKLEN, "Uint*", BlockLen, "Uint*", 4, "Uint", 0))
				MsgBox % "*CryptGetKeyParam (" DllCall("kernel32.dll\GetLastError") ")"
			BlockLen /= 8

			If (CryptMode)
				DllCall("advapi32.dll\CryptEncrypt", "Ptr", hKey, "Ptr", 0, "Uint", 1, "Uint", 0, "Ptr", &encr_Buf, "Uint*", Buf_Len, "Uint", Buf_Len + BlockLen)
			Else
				DllCall("advapi32.dll\CryptDecrypt", "Ptr", hKey, "Ptr", 0, "Uint", 1, "Uint", 0, "Ptr", &encr_Buf, "Uint*", Buf_Len)

			DllCall("advapi32.dll\CryptDestroyKey", "Ptr", hKey)
			DllCall("advapi32.dll\CryptDestroyHash", "Ptr", hHash)
			DllCall("advapi32.dll\CryptReleaseContext", "Ptr", hProv, "UInt", 0)
			return Buf_Len
		}

		StrPutVar(string, ByRef var, addBufLen := 0, encoding := "UTF-8")
		{
			tlen := ((encoding = "UTF-8" || encoding = "CP1200") ? 2 : 1)
			str_len := StrPut(string, encoding) * tlen
			VarSetCapacity(var, str_len + addBufLen, 0)
			StrPut(string, &var, encoding)
			return str_len - tlen
		}

		b64Encode(ByRef VarIn, SizeIn)
		{
			Static CRYPT_STRING_BASE64 := 0x00000001
			Static CRYPT_STRING_NOCRLF := 0x40000000
			DllCall("crypt32.dll\CryptBinaryToStringA", "Ptr", &VarIn, "UInt", SizeIn, "Uint", (CRYPT_STRING_BASE64 | CRYPT_STRING_NOCRLF), "Ptr", 0, "UInt*", SizeOut)
			VarSetCapacity(VarOut, SizeOut, 0)
			DllCall("crypt32.dll\CryptBinaryToStringA", "Ptr", &VarIn, "UInt", SizeIn, "Uint", (CRYPT_STRING_BASE64 | CRYPT_STRING_NOCRLF), "Ptr", &VarOut, "UInt*", SizeOut)
			return StrGet(&VarOut, SizeOut, "CP0")
		}
		b64Decode(ByRef VarIn, ByRef VarOut)
		{
			Static CRYPT_STRING_BASE64 := 0x00000001
			Static CryptStringToBinary := "CryptStringToBinary" (A_IsUnicode ? "W" : "A")
			DllCall("crypt32.dll\" CryptStringToBinary, "Ptr", &VarIn, "UInt", 0, "Uint", CRYPT_STRING_BASE64, "Ptr", 0, "UInt*", SizeOut, "Ptr", 0, "Ptr", 0)
			VarSetCapacity(VarOut, SizeOut, 0)
			DllCall("crypt32.dll\" CryptStringToBinary, "Ptr", &VarIn, "UInt", 0, "Uint", CRYPT_STRING_BASE64, "Ptr", &VarOut, "UInt*", SizeOut, "Ptr", 0, "Ptr", 0)
			return SizeOut
		}
	}
}
