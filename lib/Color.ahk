Class Color
{
	
	Class Pixel
	{
		InBox(color_id, box, tolerance := 0)
		{
			AutoOS.Client.ActivateClient()
			PixelSearch, output_x, output_y, box[1], box[2], box[3], box[4], color_id, tolerance, Fast RGB
			If ErrorLevel
				return false
			Else
				return true
		}
		
		CountInBox(color_id, box, tolerance := 0)	; returns the number of pixels found with specIfied color within a box
		{
			AutoOS.Client.ActivateClient()
			pixel_count := 0
			Loop
			{
				PixelSearch, output_x, output_y, box[1], box[2], box[3], box[4], color_id, tolerance, Fast RGB
				If !ErrorLevel
				{
					++pixel_count
					box[1] := output_x + 1
					box[2] := output_y
				}
				Else if ErrorLevel
					return pixel_count
			}
		}
		
		Shift(x, y, t := 100, tolerance := 0)	; Checks If the pixel at coordinates x and y shIfted color in t time. NEED TESTING!
		{
			AutoOS.Client.ActivateClient()
			PixelGetColor, output1, x, y, RGB
			Sleep % t
			PixelGetColor, output2, x, y, RGB
			If (output1 != output2)
				return true
			Else if (output1 == output2)
				return false
		}
		
		InBoxes(color_id, box1, box2, tolerance := 0, min := 2, box3 := "", box4 := "", box5 := "")	; Checks If color_id is present in the specIfied boxes. If the number of present pixels
		{																				; is above the minimum threshold (min)
			AutoOS.Client.ActivateClient()
			If (!IsObject(box1) or !IsObject(box2) or !IsObject(box3) or !IsObject(box4) or !IsObject(box5))
				return "Boxes must be objects with 4 coordinates (x, y, w and h)."
			
			pixel_counter := 0
			
			PixelSearch, output_x, output_y, box1[1], box1[2], box1[3], box1[4], color_id, tolerance, Fast RGB
			If !ErrorLevel
				If (++pixel_counter >= min)
					return true
			
			PixelSearch, output_x, output_y, box2[1], box2[2], box2[3], box2[4], color_id, tolerance, Fast RGB
			If !ErrorLevel
				If (++pixel_counter >= min)
					return true
			
			If box3	; Checks If Box3 exists.
			{
				PixelSearch, output_x, output_y, box3[1], box3[2], box3[3], box3[4], color_id, tolerance, Fast RGB
				If !ErrorLevel
					If (++pixel_counter >= min)
						return true
			}
			
			If box4	; Checks If Box4 exists.
			{
				PixelSearch, output_x, output_y, box4[1], box4[2], box4[3], box4[4], color_id, tolerance, Fast RGB
				If !ErrorLevel
					If (++pixel_counter >= min)
						return true
			}
			
			If box5	; Checks If Box5 exists.
			{
				PixelSearch, output_x, output_y, box5[1], box5[2], box5[3], box5[4], color_id, tolerance, Fast RGB
				If !ErrorLevel
					If (++pixel_counter >= min)
						return true
			}
		
			If (pixel_counter < min)
				return false
			Else
				return true
		}
		
		Gdip_PixelSearch(pBitmap, ARGB, x1, y1, x2, y2) ; This is slow as heck... but I'll leave it here anyway in case it's useful.
		{
			AutoOS.Client.ActivateClient()
			While !(y1 >= y2)
			{
				While !(x1 >= x2)
				{
					pixel_color := Gdip_GetPixel(pBitmap, x1, y1)
					If (pixel_color == ARGB)
						return Array(x1, y1)
					Else
					{
						If (x1 < x2)
							++x1
					}
				}
				
				x1 := 0
				If (y1 < y2)
					++y1
			}
			MsgBox % "we are here"
			return "Error"
		}
		
	}
	
	Class Multi
	{
		Class Pixel ; Pretty much the same thing as Color.Pixel Class but with several pixels in mind.
		{
			InBox(box, color_id1, color_id2, min := 2, tolerance := 0, color_id3 := "", color_id4 := "", color_id5 := "")
			{
				AutoOS.Client.ActivateClient()
				pixel_counter := 0, final_x := 0, final_y := 0
				PixelSearch, output_x1, output_y1, box[1], box[2], box[3], box[4], color_id1, tolerance, Fast RGB
				If !ErrorLevel
				{
					++pixel_counter
					final_x += output_x1
					final_y += output_y1
				}
				
				PixelSearch, output_x2, output_y2, box[1], box[2], box[3], box[4], color_id2, tolerance, Fast RGB
				If !ErrorLevel
				{
					++pixel_counter
					final_x += output_x2
					final_y += output_y2
				}
				
				If color_id3
				{
					PixelSearch, output_x3, output_y3, x, y, w, h, color_id3, tolerance, Fast RGB
					If !ErrorLevel
					{
						++pixel_counter
						final_x += output_x3
						final_y += output_y3
					}
					
				}
				
				If color_id4
				{
					PixelSearch, output_x4, output_y4, x, y, w, h, color_id4, tolerance, Fast RGB
					If !ErrorLevel
					{
						++pixel_counter
						final_x += output_x4
						final_y += output_y4
					}
				}
				
				If color_id5
				{
					PixelSearch, output_x5, output_y5, x, y, w, h, color_id5, tolerance, Fast RGB
					If !ErrorLevel
					{
						++pixel_counter
						final_x += output_x5
						final_y += output_y5
					}
				}
				
				final_x := Round(final_x/pixel_counter)
				final_y := Round(final_y/pixel_counter)
				If (pixel_counter >= min)
					return Array(final_x, final_y)
				Else
					return false
			}
			
			CountInBox(x, y, w, h, color_id1, color_id2, min := 2, tolerance := 0, color_id3 := "", color_id4 := "", color_id5 := "")
			{
				AutoOS.Client.ActivateClient()
				pixel_count := Color.Pixel.CountInBox(color_id1, x, y, w, h, tolerance)
				pixel_count += Color.Pixel.CountInBox(color_id2, x, y, w, h, tolerance)
				If color_id3
					pixel_count += Color.Pixel.CountInBox(color_id3, x, y, w, h, tolerance)
				If color_id4
					pixel_count += Color.Pixel.CountInBox(color_id4, x, y, w, h, tolerance)
				If color_id5
					pixel_count += Color.Pixel.CountInBox(color_id5, x, y, w, h, tolerance)
				return pixel_count
			}
			
			Shift(Obj1, Obj2, Obj3 := "", Obj4 := "", t := 100, tolerance := 0, min := 2) ; Checks If the pixels at coordinates x and y shIfted color in t time. NEED TESTING!
			{
				AutoOS.Client.ActivateClient()
				shift_counter := 0
				
				PixelGetColor, pixel1_start, Obj1[1], Obj1[2], RGB
				PixelGetColor, pixel2_start, Obj2[1], Obj2[2], RGB
				
				If Obj3
					PixelGetColor, pixel3_start, Obj3[1], Obj3[2], RGB
				If Obj4
					PixelGetColor, pixel4_start, Obj4[1], Obj4[2], RGB
				
				Sleep % t
				
				PixelGetColor, pixel1_final, Obj1[1], Obj1[2], RGB
				PixelGetColor, pixel2_final, Obj2[1], Obj2[2], RGB
				
				If Obj3
					PixelGetColor, pixel3_final, Obj3[1], Obj3[2], RGB
				If Obj4
					PixelGetColor, pixel4_final, Obj4[1], Obj4[2], RGB
				
				If (pixel1_start != pixel1_final)
					++shift_counter
				If (pixel2_start != pixel2_final)
					++shift_counter
				If (pixel3_start != pixel3_final)	; I think doesn't need a check If the object exist because If it doesn't both will be the same. NEED TESTING!
					++shift_counter
				If (pixel4_start != pixel4_final)	; I think doesn't need a check If the object exist because If it doesn't both will be the same. NEED TESTING!
					++shift_counter
				
				If (shift_counter >= 2)
					return true
				Else
					return false
			}
			
		}
	
	}
	
	Class Image
	{
		InBox(box, img, tolerance := 0)
		{
			AutoOS.Client.ActivateClient()
			ImageSearch, output_x, output_y, box[1], box[2], box[3], box[4]
					   , % "*" . tolerance . " *Trans0xff0000 " . A_WorkingDir . "\assets\" . img . ".bmp"
			If (ErrorLevel == 2)
			{
				Debug.AddLine("Can't find asset")
				return false
			}
			Else if (ErrorLevel == 1)
				return false
			Else
				return Array(output_x, output_y)
		}
	}
	
	; Function by nnnik @ https://www.autohotkey.com/boards/viewtopic.php?t=33197
	IsEqualColor(color1, color2, variation := 0)
	{
		Loop 4
			if (abs((color1 & 0xff) - (color2 & 0xff)) > variation)
				return false
			else
				color1 := color1 >> 8, color2 := color2 >> 8
		return true
	}

}