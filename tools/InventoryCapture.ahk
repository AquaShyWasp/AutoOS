#NoEnv
SetBatchLines -1
ListLines Off
#SingleInstance Force
SetWorkingDir % A_ScriptDir  ; Ensures a consistent starting directory.

#Include ../lib/AOS.ahk
#Include ../lib/Gdip.ahk


return


^1::
	ScreenShotInvSlot(1, 0xff000001, 0xffff0000, 15)
return

^2::
	bitmap1 := "bitmap1.bmp"
	bitmap2 := "bitmap2.bmp"
	CompareBitmaps(bitmap1, bitmap2)
	
	bitmap1 := "combined.bmp"
	bitmap2 := "bitmap3.bmp"
	CompareBitmaps(bitmap1, bitmap2)
	
	bitmap1 := "combined.bmp"
	bitmap2 := "bitmap4.bmp"
	CompareBitmaps(bitmap1, bitmap2)
return

^ESC::
	ExitApp
return


ScreenShotInvSlot(slot, focus_color := 0xff000001, background_color := 0xffff0000, variation := 50)
{
	static i := 0
	AutoOS.Client.ActivateClient()
	pToken := Gdip_Startup()
	slot := AutoOS.Coordinates.GameTab.Inventory.GetSlot(slot)
	x := slot[1], y := slot[2], w := slot[3] - slot[1], h := slot[4] - slot[2]
	bitmap := Gdip_BitmapFromScreen(x "|" y "|" w "|" h)
	x := 0
	y := 0
	While !(y >= h)
	{
		While !(x >= w)
		{
			If !Color.IsEqualColor(focus_color, Gdip_GetPixel(bitmap, x, y), variation)
				Gdip_SetPixel(bitmap, x, y, background_color)
			else
				Gdip_SetPixel(bitmap, x, y, focus_color)
			If (x < w)
				++x
		}
		x := 0
		If (y < h)
			++y
	}
	
	Gdip_SaveBitmapToFile(bitmap, "bitmap" . ++i . ".bmp")
	ToolTip % "done"
	
	Gdip_DisposeImage(bitmap)
	Gdip_ShutDown(pToken)	
	return
}

CompareBitmaps(bitmap1 := "bitmap1.bmp", bitmap2 := "bitmap2.bmp", common_color := 0xff000001, different_color := 0xffff0000)
{
	pToken := Gdip_Startup()
	bitmap1 := Gdip_CreateBitmapFromFile(bitmap1), bitmap2 := Gdip_CreateBitmapFromFile(bitmap2)
	x := 0, y := 0, w := Gdip_GetImageWidth(bitmap1), h := Gdip_GetImageHeight(bitmap1)   
	
	If ((w != Gdip_GetImageWidth(bitmap2)) or h != Gdip_GetImageHeight(bitmap2))
	{
		MsgBox % "The images are not the same size."
		Exit
	}
	
	While !(y >= h)
	{
		While !(x >= w)
		{
			If ((Gdip_GetPixel(bitmap1, x, y) == Gdip_GetPixel(bitmap2, x, y)) && (Gdip_GetPixel(bitmap1, x, y) == common_color))
				Gdip_SetPixel(bitmap1, x, y, focus_color)
			else
				Gdip_SetPixel(bitmap1, x, y, different_color)
			If (x < w)
				++x
		}
		x := 0
		If (y < h)
			++y
	}
	
	
	Gdip_SaveBitmapToFile(bitmap1, "combined.bmp")
	ToolTip % "done"
	Gdip_DisposeImage(bitmap1)
	Gdip_DisposeImage(bitmap2)
	Gdip_ShutDown(pToken)	
	return
}