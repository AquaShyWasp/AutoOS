
AutoOSStart(player, async_input := true)
{
	Thread, Priority, High
	AutoOS.Player := player
	AutoOS.PlayerManager.GetPlayer(player)
	AutoOS.Client.BootstrapCoordinates()
	AutoOS.Setup()
	Input.AsyncMouse := async_input, Input.AsyncKeyboard := async_input
	If async_input
	{
		DetectHiddenWindows On
		SetTitleMatchMode 2
		IfWinNotExist, % "AsyncMouse.ahk ahk_class AutoHotkey"
			Run, "AutoHotkey.exe" "plugins/AsyncMouse.ahk" %player%
		IfWinNotExist, % "AsyncKeyboard.ahk ahk_class AutoHotkey"
			Run, "AutoHotkey.exe" "plugins/AsyncKeyboard.ahk" %player%
		DetectHiddenWindows Off

	}
	UserInterface.MainGUI.Load()
	return
}

Class AutoOS
{
	Static Player := 1
	
	Class PlayerManager
	{
		Static MasterPassword := ""
		Static Client := "RuneLite", Login, Password, PinNumber, Username := ""
		Static CombatFKey, SkillsFKey, QuestsFKey, InventoryFKey, EquipmentFKey, PrayerFKey, MagicFKey := ""
		Static ClanChatFKey, FriendListFKey, AccountManagementFKey, LogoutFKey, OptionsFKey, EmotesFKey, MusicPlayerFKey := ""
		Static MouseSlowSpeed, MouseFastSpeed, FkeyProbability, InventoryPattern := ""
		
		NewPlayer(client, login, password, pin_number, user, combat_fkey, skills_fkey, quests_fkey, inventory_fkey, equipment_fkey, prayer_fkey, magic_fkey, clan_chat_fkey, friend_list_fkey, account_management_fkey, logout_fkey, options_fkey, emotes_fkey, music_player_fkey) ; Need to add default fkeys has optional parameters.
		{
			player_count := 1
			If FileExist("account.ini")
				player_count := player_count + Text.CountIniSections("account.ini")
			
			player := "Player" . player_count
			IniWrite, % client, account.ini, % player, Client
			IniWrite, % login, account.ini, % player, Login
			IniWrite, % password, account.ini, % player, Password
			IniWrite, % pin_number, account.ini, % player, PinNumber
			IniWrite, % user, account.ini, % player, Username
			
			IniWrite, % combat_fkey, account.ini, % player, CombatFKey
			IniWrite, % skills_fkey, account.ini, % player, SkillsFKey
			IniWrite, % quests_fkey, account.ini, % player, QuestsFKey
			IniWrite, % inventory_fkey, account.ini, % player, InventoryFKey
			IniWrite, % equipment_fkey, account.ini, % player, EquipmentFKey
			IniWrite, % prayer_fkey, account.ini, % player, PrayerFKey
			IniWrite, % magic_fkey, account.ini, % player, MagicFKey
			
			IniWrite, % clan_chat_fkey, account.ini, % player, ClanChatFKey
			IniWrite, % friend_list_fkey, account.ini, % player, FriendListFKey
			IniWrite, % account_management_fkey, account.ini, % player, AccountManagementFKey
			IniWrite, % logout_fkey, account.ini, % player, LogoutFKey
			IniWrite, % options_fkey, account.ini, % player, OptionsFKey
			IniWrite, % emotes_fkey, account.ini, % player, EmotesFKey
			IniWrite, % music_player_fkey, account.ini, % player, MusicPlayerFKey
			
			; We are going to make random mouse speed variables for the player.
			Random, PlayerMSpeed, 0, 2
			If (PlayerMSpeed == 0) ; If 0 we get a fast player.
			{
				Random, fast, 2, 4
				Random, slow, 5, 7
			}
			Else if (PlayerMSpeed == 1) ; If 1 we get a slower player.
			{
				Random, fast, 4, 5
				Random, slow, 6, 9
			}
			Else if (PlayerMSpeed == 2) ; If 2 we get a player that moves fast sometimes, and slower other times.
			{
				Random, fast, 2, 4
				Random, slow, 6, 9
			}
			IniWrite, % slow, account.ini, % player, MouseSlowSpeed
			IniWrite, % fast, account.ini, % player, MouseFastSpeed
			IniWrite, % Math.Random(0, 99), account.ini, % player, FkeyProbability
			; Player favourite inventory clicking pattern. The player uses other patterns too but this one most often.
			IniWrite, % Math.Random(0, 5), account.ini, % player, InventoryPattern
	
		}
		
		GetPlayer(n)
		{
			player := "Player" . n
			ini_read_array := ["Client", "Login", "Password", "PinNumber", "Username", "CombatFKey", "SkillsFKey", "QuestsFKey", "InventoryFKey", "EquipmentFKey", "PrayerFKey", "MagicFKey", "ClanChatFKey", "FriendListFKey", "AccountManagementFKey", "LogoutFKey", "OptionsFKey", "EmotesFKey", "MusicPlayerFKey", "MouseSlowSpeed", "MouseFastSpeed", "FkeyProbability", "InventoryPattern"]
			for key in ini_read_array
			{
				current_key := ini_read_array[key]
				IniRead, %current_key%, account.ini, % player, % current_key
			}
			; If anyone knows how I can reduce this mess underneath into less lines
			; to keep it cleaner while still readable like I did above, I'm all ears.
			If (Client == "Official")
				Client := "JagexLauncher"
			AutoOS.PlayerManager.Client := Client
			AutoOS.PlayerManager.Login := Login
			AutoOS.PlayerManager.Password := Password
			AutoOS.PlayerManager.PinNumber := PinNumber
			AutoOS.PlayerManager.Username := Username
			AutoOS.PlayerManager.CombatFKey := CombatFKey
			AutoOS.PlayerManager.SkillsFKey := SkillsFKey
			AutoOS.PlayerManager.QuestsFKey := QuestsFKey
			AutoOS.PlayerManager.InventoryFKey := InventoryFKey
			AutoOS.PlayerManager.EquipmentFKey := EquipmentFKey
			AutoOS.PlayerManager.PrayerFKey := PrayerFKey
			AutoOS.PlayerManager.MagicFKey := MagicFKey
			AutoOS.PlayerManager.ClanChatFKey := ClanChatFKey
			AutoOS.PlayerManager.FriendListFKey := FriendListFKey
			AutoOS.PlayerManager.AccountManagementFKey := AccountManagementFKey
			AutoOS.PlayerManager.LogoutFKey := LogoutFKey
			AutoOS.PlayerManager.OptionsFKey := OptionsFKey
			AutoOS.PlayerManager.EmotesFKey := EmotesFKey
			AutoOS.PlayerManager.MusicPlayerFKey := MusicPlayerFKey
			AutoOS.PlayerManager.MouseSlowSpeed := MouseSlowSpeed
			AutoOS.PlayerManager.MouseFastSpeed := MouseFastSpeed
			AutoOS.PlayerManager.FkeyProbability := FkeyProbability
			AutoOS.PlayerManager.InventoryPattern := InventoryPattern
		}
		
		GetPlayerMouseSpeed(n)
		{
			player := "Player" . n
			ini_read_array := ["MouseSlowSpeed", "MouseFastSpeed"]
			for key in ini_read_array
			{
				current_key := ini_read_array[key]
				IniRead, %current_key%, account.ini, % player, % current_key
			}
			; If anyone knows how I can reduce this mess underneath into less lines
			; to keep it cleaner while still readable like I did above, I'm all ears.
			AutoOS.PlayerManager.MouseSlowSpeed := MouseSlowSpeed
			AutoOS.PlayerManager.MouseFastSpeed := MouseFastSpeed
		}
		
		GetPlayerSensitiveData(n, masterpass) ; Gets only the player sensitive data.
		{
			player := "Player" . n
			ini_read_array := ["Login", "Password", "PinNumber", "Username"]
			for key in ini_read_array
			{
				current_key := ini_read_array[key]
				IniRead, %current_key%, account.ini, % player, % current_key
			}
			AutoOS.PlayerManager.Login := Encryption.AES.Decrypt(Login, masterpass, 256)
			AutoOS.PlayerManager.Password := Encryption.AES.Decrypt(Password, masterpass, 256)
			AutoOS.PlayerManager.PinNumber := Encryption.AES.Decrypt(PinNumber, masterpass, 256)
			AutoOS.PlayerManager.Username := Encryption.AES.Decrypt(Username, masterpass, 256)
		}
		
		EditPlayerData(n, data, field)
		{
			player := "Player" . n
			IniWrite, % data, account.ini, % player, % field
		}
		
		EditPlayer(n, client, login, password, pin_number, user, combat_fkey, skills_fkey, quests_fkey, inventory_fkey, equipment_fkey, prayer_fkey, magic_fkey, clan_chat_fkey, friend_list_fkey, account_management_fkey, logout_fkey, options_fkey, emotes_fkey, music_player_fkey)
		{
			player := "Player" . n
			IniWrite, % client, account.ini, % player, Client
			IniWrite, % login, account.ini, % player, Login
			IniWrite, % password, account.ini, % player, Password
			IniWrite, % pin_number, account.ini, % player, PinNumber
			IniWrite, % user, account.ini, % player, Username
			
			IniWrite, % combat_fkey, account.ini, % player, CombatFKey
			IniWrite, % skills_fkey, account.ini, % player, SkillsFKey
			IniWrite, % quests_fkey, account.ini, % player, QuestsFKey
			IniWrite, % inventory_fkey, account.ini, % player, InventoryFKey
			IniWrite, % equipment_fkey, account.ini, % player, EquipmentFKey
			IniWrite, % prayer_fkey, account.ini, % player, PrayerFKey
			IniWrite, % magic_fkey, account.ini, % player, MagicFKey
			
			IniWrite, % clan_chat_fkey, account.ini, % player, ClanChatFKey
			IniWrite, % friend_list_fkey, account.ini, % player, FriendListFKey
			IniWrite, % account_management_fkey, account.ini, % player, AccountManagementFKey
			IniWrite, % logout_fkey, account.ini, % player, LogoutFKey
			IniWrite, % options_fkey, account.ini, % player, OptionsFKey
			IniWrite, % emotes_fkey, account.ini, % player, EmotesFKey
			IniWrite, % music_player_fkey, account.ini, % player, MusicPlayerFKey
		}
		
		ClearPlayerSensitiveData()						; This should clear the player sensitive data from the variables and therefore,
		{												; from memory. The masterpass is still saved and I guess it could be extracted 
			AutoOS.PlayerManager.Login := ""			; from memory with the know how but this is the best I could come up with without
			AutoOS.PlayerManager.Password := ""			; making it troublesome to use. Either way, If someone got into your computer,
			AutoOS.PlayerManager.PinNumber := ""		; they will likely hack your account one way or another ¯\_(ツ)_/¯
			AutoOS.PlayerManager.Username := ""
		}
		
		DeletePlayer(n)
		{
			If !FileExist("account.ini")
				Exit

			player := "Player" . n
			IniDelete, account.ini, % player
			
			player_count := Text.CountIniSections("account.ini")			
			FileRead, ini_contents, account.ini
			Loop, % (player_count - n) + 1
			{
				next_player := "Player" . ++n
				ini_contents := StrReplace(ini_contents, next_player, player)
				player := next_player
			}
			FileDelete, account.ini
			FileAppend, % ini_contents, account.ini
		}

	}
	
	Class Client
	{
		Static ClientID := "", Coordinates := []
		
		BootstrapCoordinates()
		{
			If !WinExist("ahk_exe " . AutoOS.PlayerManager.Client ".exe")
			{
				MsgBox % "The client " . AutoOS.PlayerManager.Client . ".exe is not running."
				OnExit()
			}
			WinGet, ClientID, ID, % "ahk_exe " . AutoOS.PlayerManager.Client ".exe"
			If (AutoOS.PlayerManager.Client == "RuneLite")
				client_control := "SunAwtCanvas2"
			else
				client_control := "SunAwtCanvas3"
			ControlGetPos, control_x, control_y, control_w, control_h,  % client_control, % "ahk_exe " . AutoOS.PlayerManager.Client ".exe"
			
			AutoOS.Client.ClientID := ClientID
			If !(AutoOS.PlayerManager.Client == "RuneLite")
				control_x := control_x - 12, control_y := control_y - 13
			AutoOS.Client.Coordinates := [control_x, control_y, (control_w + control_x), (control_y + control_h)]
		}
		
		ActivateClient()
		{
			If WinExist("ahk_id " . AutoOS.Client.ClientID)
				WinActivate, % "ahk_id " . AutoOS.Client.ClientID
			else
			{
				MsgBox % "The client " . AutoOS.PlayerManager.Client . ".exe is not running."
				OnExit()
			}
			return
		}
	}
	
	Class Coordinates	; This whole Class is just a group of Static variables for all the coordinates I could think of. The only 2 methods are used to convert 
	{					; Client coordinates to Screen coordinates.
		Static GameScreen := AutoOS.Coordinates.ClientPositionBox(6, 5, 773, 505)
		Static UpText := AutoOS.Coordinates.ClientPositionBox(6, 5, 300, 23)
		
		Static GameTab1 := AutoOS.Coordinates.ClientPositionBox(522, 168, 559, 203)
		Static GameTab2 := AutoOS.Coordinates.ClientPositionBox(560, 168, 592, 203)
		Static GameTab3 := AutoOS.Coordinates.ClientPositionBox(593, 168, 625, 203)
		Static GameTab4 := AutoOS.Coordinates.ClientPositionBox(626, 168, 658, 203)
		Static GameTab5 := AutoOS.Coordinates.ClientPositionBox(659, 168, 691, 203)
		Static GameTab6 := AutoOS.Coordinates.ClientPositionBox(692, 168, 724, 203)
		Static GameTab7 := AutoOS.Coordinates.ClientPositionBox(725, 168, 762, 203)
		
		Static GameTab8 := AutoOS.Coordinates.ClientPositionBox(522, 466, 559, 501)
		Static GameTab9 := AutoOS.Coordinates.ClientPositionBox(560, 466, 592, 501)
		Static GameTab10 := AutoOS.Coordinates.ClientPositionBox(593, 466, 625, 501)
		Static GameTab11 := AutoOS.Coordinates.ClientPositionBox(626, 466, 658, 501)
		Static GameTab12 := AutoOS.Coordinates.ClientPositionBox(659, 466, 691, 501)
		Static GameTab13 := AutoOS.Coordinates.ClientPositionBox(692, 466, 724, 501)
		Static GameTab14 := AutoOS.Coordinates.ClientPositionBox(725, 466, 762, 501)
		
		GetTab(tab)
		{
			if (tab==1)
				return AutoOS.Coordinates.GameTab1
			else if (tab==2)
				return AutoOS.Coordinates.GameTab2
			else if (tab==3)
				return AutoOS.Coordinates.GameTab3
			else if (tab==4)
				return AutoOS.Coordinates.GameTab4
			else if (tab==5)
				return AutoOS.Coordinates.GameTab5
			else if (tab==6)
				return AutoOS.Coordinates.GameTab6
			else if (tab==7)
				return AutoOS.Coordinates.GameTab7
			else if (tab==8)
				return AutoOS.Coordinates.GameTab8
			else if (tab==9)
				return AutoOS.Coordinates.GameTab9
			else if (tab==10)
				return AutoOS.Coordinates.GameTab10
			else if (tab==11)
				return AutoOS.Coordinates.GameTab11
			else if (tab==12)
				return AutoOS.Coordinates.GameTab12
			else if (tab==13)
				return AutoOS.Coordinates.GameTab13
			else if (tab==14)
				return AutoOS.Coordinates.GameTab14
			
		}
		
		ClientPositionX(coordinate)	; Converts coordinates relative to the client to coordinates relative to the window on the X axis.
		{
			If AutoOS.Client.Coordinates[1] = ""
				AutoOS.Client.BootstrapCoordinates()
			return % (Math.DPIScale(coordinate) + AutoOS.Client.Coordinates[1])
		}
		
		ClientPositionY(coordinate)	; Converts coordinates relative to the client to coordinates relative to the window on the Y axis.
		{
			If AutoOS.Client.Coordinates[2] = ""
				AutoOS.Client.BootstrapCoordinates()
			return % Math.DPIScale(coordinate) + AutoOS.Client.Coordinates[2]
		}
		
		ClientPosition(x, y)
		{
			return [AutoOS.Coordinates.ClientPositionX(x), AutoOS.Coordinates.ClientPositionY(y)]
		}
		
		ClientPositionBox(x, y, w, h)	; Joins both methods above for an fast and easy to write/read way of converting coordinates.
		{
			return [AutoOS.Coordinates.ClientPositionX(x), AutoOS.Coordinates.ClientPositionY(y), AutoOS.Coordinates.ClientPositionX(w), AutoOS.Coordinates.ClientPositionY(h)]
		}
		
		Class Minimap
		{
			Static MidPoint := [AutoOS.Coordinates.ClientPositionX(643)	; Minimap center point.
							  , AutoOS.Coordinates.ClientPositionY(84)]
			
			Static Radius := 70 ; Real radius is about 75 pixels but I think setting it up slightly smaller is probably better
			
			Static Compass := AutoOS.Coordinates.ClientPositionBox(546, 6, 574, 34)
							
		}
		
		Class StatOrbs
		{
			Static Experience := AutoOS.Coordinates.ClientPositionBox(517, 21, 542, 47)
	
			; Health orb
			Static Health := AutoOS.Coordinates.ClientPositionBox(544, 45, 567, 70)
			; Hitpoints number
			Static Hitpoints := AutoOS.Coordinates.ClientPositionBox(520, 50, 540, 70)
				
			Static QuickPray := AutoOS.Coordinates.ClientPositionBox(542, 80, 567, 105)
			Static PrayPoints := AutoOS.Coordinates.ClientPositionBox(520, 85, 540, 105)
			
			Static Energy := AutoOS.Coordinates.ClientPositionBox(553, 112, 578, 137)
			Static EnergyPoints := AutoOS.Coordinates.ClientPositionBox(530, 120, 550, 135)
			
			Static SpecialAttack := AutoOS.Coordinates.ClientPositionBox(575, 138, 600, 162)
			Static SpecAttPoints := AutoOS.Coordinates.ClientPositionBox(551, 143, 574, 159)

		}
	
		Class GameTab
		{
			
			Class Combat	; TODO add staves.
			{
				Static WeaponNCombat := AutoOS.Coordinates.ClientPositionBox(559, 208, 732, 246)
				Static AttackStyle1 := AutoOS.Coordinates.ClientPositionBox(567, 250, 637, 296)
				Static AttackStyle2 := AutoOS.Coordinates.ClientPositionBox(646, 250, 716, 296)
				Static AttackStyle3 := AutoOS.Coordinates.ClientPositionBox(567, 304, 637, 350)
				Static AttackStyle4 := AutoOS.Coordinates.ClientPositionBox(646, 304, 716, 350)
				Static AutoRetaliate := AutoOS.Coordinates.ClientPositionBox(567, 358, 716, 401)
				Static SpecAttackBar := AutoOS.Coordinates.ClientPositionBox(567, 409, 716, 434)
			}
		
			Class Skills
			{
				Static Skill1 := AutoOS.Coordinates.GameTab.Skills.GetSkill(1)
				Static Skill2 := AutoOS.Coordinates.GameTab.Skills.GetSkill(2)
				Static Skill3 := AutoOS.Coordinates.GameTab.Skills.GetSkill(3)
				
				Static Skill4 := AutoOS.Coordinates.GameTab.Skills.GetSkill(4)
				Static Skill5 := AutoOS.Coordinates.GameTab.Skills.GetSkill(5)
				Static Skill6 := AutoOS.Coordinates.GameTab.Skills.GetSkill(6)
				
				Static Skill7 := AutoOS.Coordinates.GameTab.Skills.GetSkill(7)
				Static Skill8 := AutoOS.Coordinates.GameTab.Skills.GetSkill(8)
				Static Skill9 := AutoOS.Coordinates.GameTab.Skills.GetSkill(9)
				
				Static Skill10 := AutoOS.Coordinates.GameTab.Skills.GetSkill(10)
				Static Skill11 := AutoOS.Coordinates.GameTab.Skills.GetSkill(11)
				Static Skill12 := AutoOS.Coordinates.GameTab.Skills.GetSkill(12)
				
				Static Skill13 := AutoOS.Coordinates.GameTab.Skills.GetSkill(13)
				Static Skill14 := AutoOS.Coordinates.GameTab.Skills.GetSkill(14)
				Static Skill15 := AutoOS.Coordinates.GameTab.Skills.GetSkill(15)
				
				Static Skill16 := AutoOS.Coordinates.GameTab.Skills.GetSkill(16)
				Static Skill17 := AutoOS.Coordinates.GameTab.Skills.GetSkill(17)
				Static Skill18 := AutoOS.Coordinates.GameTab.Skills.GetSkill(18)
				
				Static Skill19 := AutoOS.Coordinates.GameTab.Skills.GetSkill(19)
				Static Skill20 := AutoOS.Coordinates.GameTab.Skills.GetSkill(20)
				Static Skill21 := AutoOS.Coordinates.GameTab.Skills.GetSkill(21)
				
				Static Skill22 := AutoOS.Coordinates.GameTab.Skills.GetSkill(22)
				Static Skill23 := AutoOS.Coordinates.GameTab.Skills.GetSkill(23)
				Static Skill24 := AutoOS.Coordinates.GameTab.Skills.GetSkill(24) ; Total level
								 
				GetSkill(n)	; For more info on what's going on on this function, check AutoOS.Coordinates.GameTab.Inventory.GetSlot()
				{
					
					If ((n >= 1) and (n <= 24))
						return AutoOS.Coordinates.ClientPositionBox((485 + (63 * ((n-(Floor(n/3)*3)) != 0 ? (n-(Floor(n/3)*3)) : 3))), (174 + (32 * Ceil(n/3)))
															    , (546 + (63 * ((n-(Floor(n/3)*3)) != 0 ? (n-(Floor(n/3)*3)) : 3))), (205 + (32 * Ceil(n/3))))
				}
				 
								 
								 
			}
		
			Class Quests	; TODO
			{
				
			}
			
			Class Inventory
			{				
				Static Inventory := Array(AutoOS.Coordinates.GameTab.Inventory.GetSlot(1)[1]
									    , AutoOS.Coordinates.GameTab.Inventory.GetSlot(1)[2]
									    , AutoOS.Coordinates.GameTab.Inventory.GetSlot(28)[3]
									    , AutoOS.Coordinates.GameTab.Inventory.GetSlot(28)[4])
				
				Static Slot1 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(1)
				Static Slot2 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(2)
				Static Slot3 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(3)
				Static Slot4 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(4)

				Static Slot5 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(5)
				Static Slot6 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(6)
				Static Slot7 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(7)
				Static Slot8 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(8)

				Static Slot9 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(9)
				Static Slot10 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(10)
				Static Slot11 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(11)
				Static Slot12 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(12)
				
				Static Slot13 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(13)
				Static Slot14 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(14)
				Static Slot15 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(15)
				Static Slot16 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(16)	

				Static Slot17 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(17)
				Static Slot18 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(18)
				Static Slot19 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(19)
				Static Slot20 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(20)

				Static Slot21 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(21)
				Static Slot22 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(22)
				Static Slot23 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(23)
				Static Slot24 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(24)

				Static Slot25 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(25)
				Static Slot26 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(26)
				Static Slot27 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(27)
				Static Slot28 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(28)
						
				GetSlot(n)
				{
					/*	Alright this is hard to understand so I'm going to break it down as a comment.
						Even though I could leave it simplIfied as I have it in the comment, for the
						sake of performance I'll leave it the way it this way.
						
						First we need to get the row and column number of "n".
						
						row := Ceil(n/4)
						column := ((n-(Floor(n/4)*4)) != 0 ? (n-(Floor(n/4)*4)) : 4)
						
						Column is hard to understand but it pretty much means this:
													
						If (n-(Floor(n/4)*4)) != 0
							Column := (n-(Floor(n/4)*4))
						Else
							Column := 4
						
						(n-(Floor(n/4)*4)) gives us 1, 2, 3 or 0 depending on the spell... That gives us the 3 first columns
						but when the slot is in the 4th column it gives us a 0 instead of a 4.
						So we use an Else statement to get 4 when it gives us a 0.
						
						Now that we have a way to get both the rows and the columns we can just use simple math to get every slot:
						
						return [521 * (42 * column), 177 * (36 * row), 552 * (42 * column), 208 * (36 * row)]						
					*/
					
					If ((n >= 1) and (n <= 28))
						return AutoOS.Coordinates.ClientPositionBox((521 + (42 * ((n-(Floor(n/4)*4)) != 0 ? (n-(Floor(n/4)*4)) : 4))), (177 + (36 * Ceil(n/4)))
															    , (552 + (42 * ((n-(Floor(n/4)*4)) != 0 ? (n-(Floor(n/4)*4)) : 4))), (208 + (36 * Ceil(n/4))))
				}

				GetRow(n)
				{
					If ((n >= 1) and (n <= 7))
						return AutoOS.Coordinates.ClientPositionBox(563, (177 + (36 * n)) , 594, (208 + (36 * n)))
				}
				
				
			}
			
			Class Equipment	; TODO
			{
				
			}
			
			Class Prayer
			{
				Static Pray1 := AutoOS.Coordinates.GameTab.Prayer.GetPray(1)				
				Static Pray2 := AutoOS.Coordinates.GameTab.Prayer.GetPray(2)						
				Static Pray3 := AutoOS.Coordinates.GameTab.Prayer.GetPray(3)								
				Static Pray4 := AutoOS.Coordinates.GameTab.Prayer.GetPray(4)									
				Static Pray5 := AutoOS.Coordinates.GameTab.Prayer.GetPray(5)			
				
				Static Pray6 := AutoOS.Coordinates.GameTab.Prayer.GetPray(6)
				Static Pray7 := AutoOS.Coordinates.GameTab.Prayer.GetPray(7)
				Static Pray8 := AutoOS.Coordinates.GameTab.Prayer.GetPray(8)			
				Static Pray9 := AutoOS.Coordinates.GameTab.Prayer.GetPray(9)			
				Static Pray10 := AutoOS.Coordinates.GameTab.Prayer.GetPray(10)			
				
				Static Pray11 := AutoOS.Coordinates.GameTab.Prayer.GetPray(11)
				Static Pray12 := AutoOS.Coordinates.GameTab.Prayer.GetPray(12)			
				Static Pray13 := AutoOS.Coordinates.GameTab.Prayer.GetPray(13)					
				Static Pray14 := AutoOS.Coordinates.GameTab.Prayer.GetPray(14)
				Static Pray15 := AutoOS.Coordinates.GameTab.Prayer.GetPray(15)			
						
				Static Pray16 := AutoOS.Coordinates.GameTab.Prayer.GetPray(16)			
				Static Pray17 := AutoOS.Coordinates.GameTab.Prayer.GetPray(17)
				Static Pray18 := AutoOS.Coordinates.GameTab.Prayer.GetPray(18)
				Static Pray19 := AutoOS.Coordinates.GameTab.Prayer.GetPray(19)
				Static Pray20 := AutoOS.Coordinates.GameTab.Prayer.GetPray(20)
				
				Static Pray21 := AutoOS.Coordinates.GameTab.Prayer.GetPray(21)
				Static Pray22 := AutoOS.Coordinates.GameTab.Prayer.GetPray(22)
				Static Pray23 := AutoOS.Coordinates.GameTab.Prayer.GetPray(23)		
				Static Pray24 := AutoOS.Coordinates.GameTab.Prayer.GetPray(24)				
				Static Pray25 := AutoOS.Coordinates.GameTab.Prayer.GetPray(25)
				
				Static Pray26 := AutoOS.Coordinates.GameTab.Prayer.GetPray(26)
				Static Pray27 := AutoOS.Coordinates.GameTab.Prayer.GetPray(27)
				Static Pray28 := AutoOS.Coordinates.GameTab.Prayer.GetPray(28)
				Static Pray29 := AutoOS.Coordinates.GameTab.Prayer.GetPray(29)
						 
				GetPray(n)	; For more info on what's going on on this function, check AutoOS.Coordinates.GameTab.Inventory.GetSlot()
				{
					If ((n >= 1) and (n <= 29))
						return AutoOS.Coordinates.ClientPositionBox((514 + (37 * ((n-(Floor(n/5)*5)) != 0 ? (n-(Floor(n/5)*5)) : 5))), (177 + (37 * Ceil(n/5)))
															    , (547 + (37 * ((n-(Floor(n/5)*5)) != 0 ? (n-(Floor(n/5)*5)) : 5))), (210 + (37 * Ceil(n/5))))
				}
				
			}
			
			Class Magic
			{
				Class Standard
				{
					Static Spell1 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(1)
					Static Spell2 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(2)
					Static Spell3 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(3)
					Static Spell4 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(4)
					Static Spell5 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(5)
					Static Spell6 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(6)
					Static Spell7 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(7)
					 
					Static Spell8 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(8)
					Static Spell9 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(9)
					Static Spell10 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(10)
					Static Spell11 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(11)
					Static Spell12 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(12)
					Static Spell13 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(13)
					Static Spell14 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(14)
					 
					Static Spell15 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(15)
					Static Spell16 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(16)
					Static Spell17 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(17)
					Static Spell18 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(18)
					Static Spell19 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(19)
					Static Spell20 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(20)
					Static Spell21 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(21)
					 
					Static Spell22 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(22)
					Static Spell23 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(23)
					Static Spell24 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(24)
					Static Spell25 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(25)
					Static Spell26 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(26)
					Static Spell27 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(27)
					Static Spell28 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(28)
					 
					Static Spell29 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(29)
					Static Spell30 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(30)
					Static Spell31 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(31)
					Static Spell32 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(32)
					Static Spell33 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(33)
					Static Spell34 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(34)
					Static Spell35 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(35)
					 
					Static Spell36 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(36)
					Static Spell37 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(37)
					Static Spell38 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(38)
					Static Spell39 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(39)
					Static Spell40 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(40)
					Static Spell41 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(41)
					Static Spell42 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(42)
					 
					Static Spell43 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(43)
					Static Spell44 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(44)
					Static Spell45 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(45)
					Static Spell46 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(46)
					Static Spell47 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(47)
					Static Spell48 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(48)
					Static Spell49 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(49)
					 
					Static Spell50 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(50)
					Static Spell51 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(51)
					Static Spell52 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(52)
					Static Spell53 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(53)
					Static Spell54 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(54)
					Static Spell55 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(55)
					Static Spell56 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(56)
					 
					Static Spell57 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(57)
					Static Spell58 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(58)
					Static Spell59 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(59)
					Static Spell60 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(60)
					Static Spell61 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(61)
					Static Spell62 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(62)
					Static Spell63 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(63)
				
					Static Spell64 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(64)
					Static Spell65 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(65)
					Static Spell66 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(66)
					Static Spell67 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(67)
					Static Spell68 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(68)
					Static Spell69 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(69)
					Static Spell70 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(70)

					GetSpell(n)	; For more info on what's going on on this function, check AutoOS.Coordinates.GameTab.Inventory.GetSlot()
					{
						If ((n >= 1) and (n <= 70))
							return AutoOS.Coordinates.ClientPositionBox((526 + (26 * ((n-(Floor(n/7)*7)) != 0 ? (n-(Floor(n/7)*7)) : 7))), (181 + (24 * Ceil(n/7)))
																   , (549 + (26 * ((n-(Floor(n/7)*7)) != 0 ? (n-(Floor(n/7)*7)) : 7))), (204 + (24 * Ceil(n/7))))
					}
					
				}

				Class Ancient
				{
					Static Spell1 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(1)
					Static Spell2 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(2)
					Static Spell3 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(3)
					Static Spell4 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(4)
					
					Static Spell5 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(5)
					Static Spell6 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(6)
					Static Spell7 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(7)
					Static Spell8 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(8)
					
					Static Spell9 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(9)
					Static Spell10 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(10)
					Static Spell11 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(11)
					Static Spell12 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(12)
					
					Static Spell13 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(13)
					Static Spell14 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(14)
					Static Spell15 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(15)
					Static Spell16 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(16)
					
					Static Spell17 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(17)
					Static Spell18 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(18)
					Static Spell19 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(19)
					Static Spell20 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(20)
					
					Static Spell21 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(21)
					Static Spell22 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(22)
					Static Spell23 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(23)
					Static Spell24 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(24)
					
					Static Spell25 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(25)
					Static Spell26 := AutoOS.Coordinates.GameTab.Magic.Ancient.GetSpell(26)
					
					GetSpell(n)	; For more info on what's going on on this function, check AutoOS.Coordinates.GameTab.Inventory.GetSlot()
					{
						If ((n >= 1) and (n <= 26))
							return AutoOS.Coordinates.ClientPositionBox((510 + (48 * ((n-(Floor(n/4)*4)) != 0 ? (n-(Floor(n/4)*4)) : 4))), (169 + (36 * Ceil(n/4)))
																   , (533 + (48 * ((n-(Floor(n/4)*4)) != 0 ? (n-(Floor(n/4)*4)) : 4))), (192 + (36 * Ceil(n/4))))
					}
				}

				Class Lunar
				{
					Static Spell1 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(1)
					Static Spell2 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(2)
					Static Spell3 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(3)
					Static Spell4 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(4)
					Static Spell5 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(5)
					
					Static Spell6 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(6)
					Static Spell7 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(7)
					Static Spell8 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(8)
					Static Spell9 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(9)
					
					Static Spell10 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(10)
					Static Spell11 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(11)
					Static Spell12 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(12)
					Static Spell13 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(13)
					Static Spell14 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(14)
					
					Static Spell15 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(15)
					Static Spell16 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(16)
					Static Spell17 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(17)
					Static Spell18 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(18)
					Static Spell19 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(19)
					
					Static Spell20 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(20)
					Static Spell21 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(21)
					Static Spell22 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(22)
					Static Spell23 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(23)
					Static Spell24 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(24)
					
					Static Spell25 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(25)
					Static Spell26 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(26)
					Static Spell27 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(27)
					Static Spell28 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(28)
					Static Spell29 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(29)
					
					Static Spell30 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(30)
					Static Spell31 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(31)
					Static Spell32 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(32)
					Static Spell33 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(33)
					Static Spell34 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(34)
					Static Spell35 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(35)
					
					Static Spell36 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(36)
					Static Spell37 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(37)
					Static Spell38 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(38)
					Static Spell39 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(39)
					Static Spell40 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(40)
					
					Static Spell41 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(41)
					Static Spell42 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(42)
					Static Spell43 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(43)
					Static Spell44 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(44)
					Static Spell45 := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(45)

					GetSpell(n)	; For more info on what's going on on this function, check AutoOS.Coordinates.GameTab.Inventory.GetSlot()
					{
						If ((n >= 1) and (n <= 45))
							return AutoOS.Coordinates.ClientPositionBox((510 + (40 * ((n-(Floor(n/5)*5)) != 0 ? (n-(Floor(n/5)*5)) : 5))), (178 + (27 * Ceil(n/5)))
																   , (533 + (40 * ((n-(Floor(n/5)*5)) != 0 ? (n-(Floor(n/5)*5)) : 5))), (201 + (27 * Ceil(n/5))))
					}
				}

				Class Arceuus
				{
					
					Static Spell1 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(1)
					Static Spell2 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(2)
					Static Spell3 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(3)
					Static Spell4 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(4)
					
					Static Spell5 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(5)
					Static Spell6 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(6)
					Static Spell7 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(7)
					Static Spell8 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(8)
					
					Static Spell9 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(9)
					Static Spell10 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(10)
					Static Spell11 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(11)
					Static Spell12 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(12)
					
					Static Spell13 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(13)
					Static Spell14 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(14)
					Static Spell15 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(15)
					Static Spell16 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(16)
					
					Static Spell17 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(17)
					Static Spell18 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(18)
					Static Spell19 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(19)
					Static Spell20 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(20)
					
					Static Spell21 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(21)
					Static Spell22 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(22)
					Static Spell23 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(23)
					Static Spell24 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(24)
					
					Static Spell25 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(25)
					Static Spell26 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(26)
					Static Spell27 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(27)
					Static Spell28 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(28)
					 
					Static Spell29 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(29)
					Static Spell30 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(30)
					Static Spell31 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(31)
					Static Spell32 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(32)
					
					Static Spell33 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(33)
					Static Spell34 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(34)
					Static Spell35 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(35)
					Static Spell36 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(36)
					
					GetSpell(n)	; For more info on what's going on on this function, check AutoOS.Coordinates.GameTab.Inventory.GetSlot()
					{
						If ((n >= 1) and (n <= 36))
							return AutoOS.Coordinates.ClientPositionBox((510 + (48 * ((n-(Floor(n/4)*4)) != 0 ? (n-(Floor(n/4)*4)) : 4))), (178 + (27 * Ceil(n/4)))
																   , (533 + (48 * ((n-(Floor(n/4)*4)) != 0 ? (n-(Floor(n/4)*4)) : 4))), (201 + (27 * Ceil(n/4))))
					}
				}
								
			}
		
			Class ClanChat	; TODO
			{
				
			}
			
			Class FriendList	; TODO
			{
				
			}
			
			Class AccountManagement	; TODO
			{
				
			}
			
			Class Logout	; TODO
			{
				Static WorldSwitcherButton := AutoOS.Coordinates.ClientPositionBox(570, 366, 713, 401)
				Static LogoutButton := AutoOS.Coordinates.ClientPositionBox(570, 414, 713, 449)
									  
				Class WorldSwitcher	; TODO
				{
					
				}
				
			}
			
			Class Options	; TODO
			{
				Static Display := AutoOS.Coordinates.ClientPositionBox(553, 206, 592, 245)
				Static Audio := AutoOS.Coordinates.ClientPositionBox(599, 206, 638, 245)
				Static Chat := AutoOS.Coordinates.ClientPositionBox(645, 206, 684, 245)
				Static Controls := AutoOS.Coordinates.ClientPositionBox(691, 206, 730, 245)
					
				Static ZoomIcon := AutoOS.Coordinates.ClientPositionBox(558, 256, 589, 287)
				Static ZoomBar := AutoOS.Coordinates.ClientPositionBox(601, 265, 712, 280)
				
				Static BrightnessIcon := AutoOS.Coordinates.ClientPositionBox(558, 290, 589, 321)
				Static BrightnessBar := AutoOS.Coordinates.ClientPositionBox(593, 299, 720, 314)
				
				Static FixedClient := AutoOS.Coordinates.ClientPositionBox(572, 325, 633, 378)
				Static ScaleableClient := AutoOS.Coordinates.ClientPositionBox(650, 325, 711, 378)
				
				Static AdvancedOptions := AutoOS.Coordinates.ClientPositionBox(572, 382, 711, 411)
				
				Static AcceptAid := AutoOS.Coordinates.ClientPositionBox(553, 425, 592, 464)
				Static RunButton := AutoOS.Coordinates.ClientPositionBox(599, 425, 638, 464)
				Static HouseOptions := AutoOS.Coordinates.ClientPositionBox(645, 425, 684, 464)
				Static BondPouch := AutoOS.Coordinates.ClientPositionBox(691, 425, 730, 464)
				
				Class POH	; TODO
				{
					Static Title := AutoOS.Coordinates.ClientPositionBox(589, 204, 691, 224)
					Static Close := AutoOS.Coordinates.ClientPositionBox(710, 212, 735, 234)
					Static Viewer := AutoOS.Coordinates.ClientPositionBox(557, 230, 661, 269)
					Static BuildModeOn := AutoOS.Coordinates.ClientPositionBox(685, 273, 701, 289)
					Static BuildModeOff := AutoOS.Coordinates.ClientPositionBox(710, 273, 726, 289)
					Static TeleportInsideOn := AutoOS.Coordinates.ClientPositionBox(685, 293, 701, 309)
					Static TeleportInsideOff := AutoOS.Coordinates.ClientPositionBox(710, 293, 726, 309)
					
					Static DoorsClosed := AutoOS.Coordinates.ClientPositionBox(617, 318, 633, 334)
					Static DoorsOpen := AutoOS.Coordinates.ClientPositionBox(665, 318, 681, 334)
					Static DoorsOff := AutoOS.Coordinates.ClientPositionBox(712, 318, 728, 334)
					
					Static ExpellGuests := AutoOS.Coordinates.ClientPositionBox(557, 340, 726, 374)
					Static LeaveHouse := AutoOS.Coordinates.ClientPositionBox(557, 375, 726, 409)
					Static CallServant := AutoOS.Coordinates.ClientPositionBox(557, 410, 726, 445)
				}
				
			}
		
			Class Emotes	; TODO
			{
				
			}
		
			Class MusicPlayer	; TODO
			{
				
			}
			
			
			GetTab(tab)	; Need to find a better way to get the tabs...
			{
				; Until I figure a way to call variables inside a Class dynamically I need this... 
				; What I mean is... If I want to get the coordinates of a tab number I have stored in %var%. I can't call it
				; by with AutoOS.Coordinates.GameTab%var%... It throws an error because of the dot. I've tried several way nothing worked.
				; If anyone knows how to do it please tell me, thanks in advance!
				If (tab==1)
					return AutoOS.Coordinates.GameTab1
				Else if (tab==2)
					return AutoOS.Coordinates.GameTab2
				Else if (tab==3)
					return AutoOS.Coordinates.GameTab3
				Else if (tab==4)
					return AutoOS.Coordinates.GameTab4
				Else if (tab==5)
					return AutoOS.Coordinates.GameTab5
				Else if (tab==6)
					return AutoOS.Coordinates.GameTab6
				Else if (tab==7)
					return AutoOS.Coordinates.GameTab7
				Else if (tab==8)
					return AutoOS.Coordinates.GameTab8
				Else if (tab==9)
					return AutoOS.Coordinates.GameTab9
				Else if (tab==10)
					return AutoOS.Coordinates.GameTab10
				Else if (tab==11)
					return AutoOS.Coordinates.GameTab11
				Else if (tab==12)
					return AutoOS.Coordinates.GameTab12
				Else if (tab==13)
					return AutoOS.Coordinates.GameTab13
				Else if (tab==14)
					return AutoOS.Coordinates.GameTab14
			}
		}
	
		Class Chat
		{
			Static ChatBox := AutoOS.Coordinates.ClientPositionBox(0, 338, 477, 520)
			Static Scroll := AutoOS.Coordinates.ClientPositionBox(497, 343, 511, 455)
			Static UserInput := AutoOS.Coordinates.ClientPositionBox(7, 455, 511, 473)
			Static UITitle := AutoOS.Coordinates.ClientPositionBox(13, 355, 507, 374) ; I don't remember what's this lol.... need to check and probably name it better.
			
			Static Option1 := AutoOS.Coordinates.ClientPositionBox(5, 480, 60, 501)
			Static Option2 := AutoOS.Coordinates.ClientPositionBox(71, 480, 126, 501)
			Static Option3 := AutoOS.Coordinates.ClientPositionBox(137, 480, 192, 501)
			Static Option4 := AutoOS.Coordinates.ClientPositionBox(203, 480, 258, 501)
			Static Option5 := AutoOS.Coordinates.ClientPositionBox(269, 480, 324, 501)
			Static Option6 := AutoOS.Coordinates.ClientPositionBox(335, 480, 390, 501)
			Static Option7 := AutoOS.Coordinates.ClientPositionBox(403, 480, 513, 501)
			
		}
	
		Class Interface
		{
			Class Bank
			{
				Class Pin
				{
					Static Slot0 := AutoOS.Coordinates.ClientPositionBox(37, 107, 100, 170)
						 , Slot1 := AutoOS.Coordinates.ClientPositionBox(131, 107, 194, 170)
						 , Slot2 := AutoOS.Coordinates.ClientPositionBox(225, 107, 288, 170)
						 , Slot3 := AutoOS.Coordinates.ClientPositionBox(309, 107, 372, 170)
					
					Static Slot4 := AutoOS.Coordinates.ClientPositionBox(37, 179, 100, 242)
						 , Slot5 := AutoOS.Coordinates.ClientPositionBox(131, 179, 194, 242)
						 , Slot6 := AutoOS.Coordinates.ClientPositionBox(225, 179, 288, 242)
					
					Static Slot7 := AutoOS.Coordinates.ClientPositionBox(37, 251, 100, 314)
						 , Slot8 := AutoOS.Coordinates.ClientPositionBox(131, 251, 194, 314)
						 , Slot9 := AutoOS.Coordinates.ClientPositionBox(225, 251, 288, 314)
					
					Static ExitButton := AutoOS.Coordinates.ClientPositionBox(326, 251, 483, 275)
						 , ForgotPin := AutoOS.Coordinates.ClientPositionBox(326, 276, 483, 300)
						 
					Static Steps := AutoOS.Coordinates.ClientPositionBox(427, 29, 493, 50)
				}
					 	 
				GetTab(n)
				{	
					if ((n < 0) or (n > 9))
						return false
					if (n == 0)
						return AutoOS.Coordinates.ClientPositionBox(62, 45, 97, 76)
					else
						return AutoOS.Coordinates.ClientPositionBox((63 + (40 * n)), 45, (98 + (40 * n)), 76)
				}
						 
					 
				Static ShowEquipment := AutoOS.Coordinates.ClientPositionBox(28, 48, 52, 72)
					 , ShowEquipmentRuneLite := AutoOS.Coordinates.ClientPositionBox(22, 10, 46, 34)
						
				Static BankCloseButton := AutoOS.Coordinates.ClientPositionBox(475, 12, 500, 34)
				
				 
				Static ShowMenuButton := AutoOS.Coordinates.ClientPositionBox(467, 48, 491, 72)
				
				Static RearrangeMode := AutoOS.Coordinates.ClientPositionBox(22, 294, 118, 307)
					 , WithdrawAs := AutoOS.Coordinates.ClientPositionBox(130, 294, 207, 308)
					 , Quantity := AutoOS.Coordinates.ClientPositionBox(253, 293, 309, 309)
					 
				Static SwapButton := AutoOS.Coordinates.ClientPositionBox(21, 310, 70, 331)
					 , InsertButton := AutoOS.Coordinates.ClientPositionBox(71, 310, 120, 331)
					 , ItemButton := AutoOS.Coordinates.ClientPositionBox(121, 310, 170, 331)
					 , NoteButton := AutoOS.Coordinates.ClientPositionBox(171, 310, 220, 331)
					 , 1Button := AutoOS.Coordinates.ClientPositionBox(221, 310, 245, 331)
					 , 5Button := AutoOS.Coordinates.ClientPositionBox(246, 310, 270, 331)
					 , 10Button := AutoOS.Coordinates.ClientPositionBox(271, 310, 295, 331)
					 , XButton := AutoOS.Coordinates.ClientPositionBox(296, 310, 320, 331)
					 , AllButton := AutoOS.Coordinates.ClientPositionBox(321, 310, 345, 331)
					 
				Static PlaceholderButton := AutoOS.Coordinates.ClientPositionBox(347, 295, 382, 330)
					 , SearchButton := AutoOS.Coordinates.ClientPositionBox(386, 295, 421, 330)
					 , InventoryButton := AutoOS.Coordinates.ClientPositionBox(425, 295, 460, 330)
					 , EquipmentButton := AutoOS.Coordinates.ClientPositionBox(462, 295, 497, 330)
					 
					 
			}
		}
	}
	
	Class Core	; TODO
	{	
		
		Class StatOrbs
		{
			QPrayClick(flick := false)
			{
				Debug.AddLine("Activating quick prayers")
				If Input.AsyncMouse
				{
					QuickPray := AutoOS.Coordinates.StatOrbs.QuickPray[1] . ", "
								   . AutoOS.Coordinates.StatOrbs.QuickPray[2] . ", "
								   . AutoOS.Coordinates.StatOrbs.QuickPray[3] . ", "
								   . AutoOS.Coordinates.StatOrbs.QuickPray[4]
					If !flick
						Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(" . QuickPray . ", ""Left"")", "AsyncMouse.ahk ahk_class AutoHotkey")
					Else if flick
						
						Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(" . QuickPray . ", ""doubleclick"")", "AsyncMouse.ahk ahk_class AutoHotkey")
				}
				Else
				{
					If !flick
						Input.Human.Mouse.HumanCoordinates(AutoOS.Coordinates.StatOrbs.QuickPray[1]
														 , AutoOS.Coordinates.StatOrbs.QuickPray[2]
														 , AutoOS.Coordinates.StatOrbs.QuickPray[3]
														 , AutoOS.Coordinates.StatOrbs.QuickPray[4], "Left")
					Else if flick
						Input.Human.Mouse.HumanCoordinates(AutoOS.Coordinates.StatOrbs.QuickPray[1]
														 , AutoOS.Coordinates.StatOrbs.QuickPray[2]
														 , AutoOS.Coordinates.StatOrbs.QuickPray[3]
														 , AutoOS.Coordinates.StatOrbs.QuickPray[4], "doubleclick")
				}
				Sleep, Math.Random(10, 50)
			}

			CheckIfSpecWeapon()
			{
				SpecAttackOrb := AutoOS.Coordinates.StatOrbs.SpecialAttack
				Debug.AddLine("Checking if our weapon has a spec attack")
				If (Color.Multi.Pixel.InBox(SpecAttackOrb, 0x3a9bb5, 0x014b5d, 1, 4, , 0x2e9ab5, 0x013c4e))
				{
					Debug.AddLine("Is spec weapon")
					return true
				}
				Else
				{
					Debug.AddLine("Is not a spec weapon or we have 0 spec") ; TODO ADD OCR to get Spec %
					return false
				}
			}
			
			SpecAttOrbClick() ; TODO add OCR to check spec amount available
			{
				If !AutoOs.Core.StatOrbs.CheckIfSpecWeapon()
					return
				Debug.AddLine("Activating special attack orb")
				
				If Input.AsyncMouse
				{
					SpecAttackOrb := AutoOS.Coordinates.StatOrbs.SpecialAttack[1] . ", "
								   . AutoOS.Coordinates.StatOrbs.SpecialAttack[2] . ", "
								   . AutoOS.Coordinates.StatOrbs.SpecialAttack[3] . ", "
								   . AutoOS.Coordinates.StatOrbs.SpecialAttack[4]
					Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(" . SpecAttackOrb . ", ""Left"")", "AsyncMouse.ahk ahk_class AutoHotkey")
				}
				else
					Input.Human.Mouse.HumanCoordinates(AutoOS.Coordinates.StatOrbs.SpecialAttack[1]
													 , AutoOS.Coordinates.StatOrbs.SpecialAttack[2]
													 , AutoOS.Coordinates.StatOrbs.SpecialAttack[3]
													 , AutoOS.Coordinates.StatOrbs.SpecialAttack[4], "Left")
				Sleep, Math.Random(10, 50)
			}
		
		}
		
		Class GameTab	; TODO
		{
			Static TabName := {1: "Combat", 2: "Skills", 3: "Quests", 4: "Inventory", 5: "Equipment", 6: "Prayer", 7: "Magic"
							 , 8: "ClanChat", 9: "FriendList", 10: "AccountManagement", 11: "Logout", 12: "Options", 13: "Emotes", 14: "MusicPlayer"}
				   
			Static TabNumber := {"Combat": 1, "Skills": 2, "Quests": 3, "Inventory": 4, "Equipment": 5, "Prayer": 6, "Magic": 7
							   , "ClanChat": 8, "FriendList": 9, "AccountManagement": 10, "Logout": 11, "Options": 12, "Emotes": 13, "MusicPlayer": 14}
			
			GetTabFKey(tab)	; This seems useless but it's the only way I know to call variables and and methods inside a class dinamically
			{
				if tab is not integer
					tab := AutoOS.Core.GameTab.TabNumber[tab]	; Converts tab into string in case we were passed an integer. e.g. "Combat"
				
				if (tab == 1)
					return AutoOS.PlayerManager.CombatFKey
				else if (tab == 2)
					return AutoOS.PlayerManager.SkillsFKey
				else if (tab == 3)
					return AutoOS.PlayerManager.QuestsFKey
				else if (tab == 4)
					return AutoOS.PlayerManager.InventoryFKey
				else if (tab == 5)
					return AutoOS.PlayerManager.EquipmentFKey
				else if (tab == 6)
					return AutoOS.PlayerManager.PrayerFKey
				else if (tab == 7)
					return AutoOS.PlayerManager.MagicFKey
				else if (tab == 8)
					return AutoOS.PlayerManager.ClanChatFKey
				else if (tab == 9)
					return AutoOS.PlayerManager.FriendListFKey
				else if (tab == 10)
					return AutoOS.PlayerManager.AccountManagementFKey
				else if (tab == 11)
					return AutoOS.PlayerManager.LogoutFKey
				else if (tab == 12)
					return AutoOS.PlayerManager.OptionsFKey
				else if (tab == 13)
					return AutoOS.PlayerManager.EmotesFKey
				else if (tab == 14)
					return AutoOS.PlayerManager.MusicPlayerFKey
				else
					return "Error"
			}
			
			IsActive(tab)
			{
				if tab is not integer
				tab := AutoOS.Core.GameTab.TabNumber[tab]	; Converts tab into integer in case we were passed a string. e.g. "Combat"
				
				If Color.Multi.Pixel.InBox(AutoOS.Coordinates.GameTab.GetTab(tab), 0x75281e, 0x3b140f, 2, 5, 0x441812)
					return true
				Else if ((tab == 4) and !AutoOS.Core.GameTab.GetActiveRow())	; If tab is inventory and no tab is active, we probably are at bank or shop.
					return true
				Else
					return false
			}
			
			GetActive()	; This was my third attempt and the best attempt at this. This only uses pixel search a maximum
			{			; of 6 times and uses math to figure out which tab is active. Benchmarks were over 200 times faster sometimes than the other methods.
						; And I think this is the definitive best way to do it. Though If you can make it faster, I'll be happy to know how :)
				row := AutoOS.Core.GameTab.GetActiveRow()

				Loop, 14
				{
					If (Math.InBox(row[1], row[2], AutoOS.Coordinates.GameTab.GetTab(A_Index)) == true)
					{
						Debug.AddLine("Active Gametab is: " . A_Index)
						return A_Index
					}
				}
				return 4 ; TODO ADD BANK AND STORE CHECK
				
			}
			
			GetActiveRow()
			{
				If (A_ScreenDPI >= 168)
					variation := 3
				Else
					variation := 5
				If (top_row := Color.Multi.Pixel.InBox([AutoOS.Coordinates.GameTab.GetTab(1)[1], AutoOS.Coordinates.GameTab.GetTab(1)[2]	; Checks for red
											  , AutoOS.Coordinates.GameTab.GetTab(7)[3], AutoOS.Coordinates.GameTab.GetTab(7)[4]], 0x75281e, 0x3b140f, 2, variation, 0x441812))
					return top_row
				Else if (bottom_row := Color.Multi.Pixel.InBox([AutoOS.Coordinates.GameTab.GetTab(8)[1], AutoOS.Coordinates.GameTab.GetTab(8)[2] ; Checks for red
											   , AutoOS.Coordinates.GameTab.GetTab(14)[3], AutoOS.Coordinates.GameTab.GetTab(14)[4]], 0x75281e, 0x3b140f, 2, variation, 0x441812))
					return bottom_row
				Else
					return false
			}
			
			Click(tab)
			{				
				if tab is not integer
					tab := AutoOS.Core.GameTab.TabNumber[tab]	; Converts tab into integer in case we were passed a string. e.g. "Combat"
				
				Debug.AddLine("Switching to game tab: " . AutoOS.Core.GameTab.TabName[tab] . " with mouse click")
				
				if !Math.Between(tab, 1, 14)
					return false	; If tab doesn't exist returns false.
				
				if (AutoOS.Core.GameTab.IsActive(tab))
				{
					Debug.AddLine(AutoOS.Core.GameTab.TabName[tab] . " tab is already active.")
					return true
				}
				
				tab := AutoOS.Coordinates.GetTab(tab)
				
				If Input.AsyncMouse
				{
					tab := tab[1] . ", " . tab[2] . ", " . tab[3] . ", " . tab[4]
					Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(" . tab . ", ""Left"")", "AsyncMouse.ahk ahk_class AutoHotkey")
				}
				else
					Input.Human.Mouse.HumanCoordinates(tab[1], tab[2], tab[3], tab[4], "Left")
				Sleep, Math.Random(10, 50)
			}

			FKeySwitch(tab)
			{
				if tab is not integer
					tab := AutoOS.Core.GameTab.TabNumber[tab]	; Converts tab into string in case we were passed an integer. e.g. "Combat"
				
				Debug.AddLine("Switching to game tab: " . AutoOS.Core.GameTab.TabName[tab] . " with FKey")
				
				if !Math.Between(tab, 1, 14)
					return false	; If tab doesn't exist returns false.
				
				if (AutoOS.Core.GameTab.IsActive(tab))
				{
					Debug.AddLine(AutoOS.Core.GameTab.TabName[tab] . " tab is already active.")
					return true
				}

				key := AutoOS.Core.GameTab.GetTabFKey(tab)
				
				if ((key == "Error") or (key == "None"))
				{
					Debug.AddLine("Couldn't find FKey for " . AutoOS.Core.GameTab.TabName[tab] . " tab. Will click the tab instead.")
					AutoOs.Core.GameTab.Click(tab)
					return
				}
				
				If Input.AsyncMouse
				{
					Input.SendAsyncInput("Input.Human.Keyboard.PressKey(" . key . ", " . Math.Random(10, 50) . ")", "AsyncKeyboard.ahk ahk_class AutoHotkey")
				}
				else
					Input.Human.Keyboard.PressKey(key, Math.Random(10, 50))
				Sleep, Math.Random(10, 50)
			}
			
			Switch(tab)
			{
				case := Math.Random(0, 99)
				if (case < AutoOS.PlayerManager.FkeyProbability)
					AutoOs.Core.GameTab.FKeySwitch(tab)
				else
					AutoOs.Core.GameTab.Click(tab)
			}
			
			WaitTab(tab, t := 1000)
			{
				start_tick := A_TickCount, current_tick := A_TickCount
				While ((current_tick - start_tick) < t)
				{
					If AutoOS.Core.GameTab.IsActive(tab)
						return true
					Else
					{
						Sleep, 50
						current_tick := A_TickCount
					}
				}
				return false
			}
			
			Class Combat	; TODO Add attack styles
			{
				
				SpecAttBarClick()
				{
					If !AutoOs.Core.StatOrbs.CheckIfSpecWeapon()
						return
					AutoOS.Core.GameTab.Switch("Combat")
					Debug.AddLine("Activating special attack bar")
					If Input.AsyncMouse
					{
						spec_attack_bar := AutoOS.Coordinates.GameTab.Combat.SpecAttackBar[1] . ", "
									   . AutoOS.Coordinates.GameTab.Combat.SpecAttackBar[2] . ", "
									   . AutoOS.Coordinates.GameTab.Combat.SpecAttackBar[3] . ", "
									   . AutoOS.Coordinates.GameTab.Combat.SpecAttackBar[4]
						Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(" . spec_attack_bar . ", ""Left"")", "AsyncMouse.ahk ahk_class AutoHotkey")
					}
					else
						Input.Human.Mouse.HumanCoordinates(AutoOS.Coordinates.GameTab.Combat.SpecAttackBar[1]
														 , AutoOS.Coordinates.GameTab.Combat.SpecAttackBar[2]
														 , AutoOS.Coordinates.GameTab.Combat.SpecAttackBar[3]
														 , AutoOS.Coordinates.GameTab.Combat.SpecAttackBar[4], "Left")
					Sleep, Math.Random(10, 50)
				}
				
				
				UseSpecAttack()
				{
					case := Math.Random(0, 99)
					if (case < AutoOS.PlayerManager.FkeyProbability)	; Since FkeyProbability is more or less a probability of how efficient is the player is, 
						AutoOs.Core.StatOrbs.SpecAttOrbClick()			; we use this for the special attack probability.
					else
						AutoOs.Core.GameTab.Combat.SpecAttBarClick()
				}

			}
		
			Class Skills	; TODO
			{
				
				Static SkillName := {1: Attack, 2: Hitpoints, 3: Mining, 4: Strength, 5: Agility, 6: Smithing, 7: Defense, 8: Herblore, 9: Fishing
						, 10: Ranged, 11: Thieving, 12: Cooking, 13: Prayer, 14: Crafting, 15: Firemaking, 16: Magic, 17: Fletching, 18: Woodcutting
						, 19: Runecrafting, 20: Slayer, 21: Farming, 22: Construction, 23: Hunter, 24: TotalLevel}
						
				Static SkillNumber := {Attack: 1, Hitpoints: 2, Mining: 3, Strength: 4, Agility: 5, Smithing: 6, Defense: 7, Herblore: 8, Fishing: 9
						, Ranged: 10, Thieving:11, Cooking: 12, Prayer: 13, Crafting: 14, Firemaking: 15, Magic: 16, Fletching: 17, Woodcutting: 18
						, Runecrafting: 19, Slayer: 20, Farming: 21, Construction: 22, Hunter: 23, TotalLevel: 24}
			
			}
		
			Class Quests	; TODO
			{
				
			}
			
			Class Inventory	; TODO
			{
				
				IsEmpty()
				{
					; This functions searchs for near black pixels all items have in their borders
					AutoOS.Core.GameTab.Switch("Inventory")
					if Color.Multi.Pixel.InBox(AutoOS.Coordinates.GameTab.Inventory.Inventory, 0x090607, 0x040304, 2, 4, 0x0b0a09)
						return true
					else
						return false
				}
				
				IsSlotEmpty(n)
				{
					; This functions searchs for near black pixels all items have in their borders
					AutoOS.Core.GameTab.Switch("Inventory")
					if Color.Multi.Pixel.InBox(AutoOS.Coordinates.GameTab.Inventory.GetSlot(n), 0x090607, 0x040304, 2, 4, 0x0b0a09)
						return true
					else
						return false
				}
				
				ClickSlot(n, check_item_exists := false)
				{

					If !Math.Between(n, 1, 28) ; no need to check if it's an integer, if it's not it will not validate and will return
						return false
					if check_item_exists
						AutoOS.Core.GameTab.Inventory.IsSlotEmpty(n)	; AutoOS.Core.GameTab.Switch("Inventory") is already called
					else												; in AutoOS.Core.GameTab.Inventory.IsSlotEmpty(n)... no need to call it twice.
						AutoOS.Core.GameTab.Switch("Inventory")
					
					Debug.AddLine("Going to click inventory slot " . n)
					
					slot := AutoOS.Coordinates.GameTab.Inventory.GetSlot(n)
					
					If Input.AsyncMouse
					{
						slot := slot[1] . ", " . slot[2] . ", " . slot[3] . ", " . slot[4] . ", ""Left"""
						Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(" . slot . ")", "AsyncMouse.ahk ahk_class AutoHotkey")
					}
					else
						Input.Human.Mouse.HumanCoordinates(slot[1], slot[2], slot[3], slot[4], "Left")
					Sleep, Math.Random(10, 50)
				}
			
				SlotHasPotion(slot, potion := "Any")
				{
					Debug.AddLine("Checking if inventory slot " . slot . " has " . potion . " potion")
					if AutoOS.Core.Item.HasPotion(AutoOS.Coordinates.GameTab.Inventory.GetSlot(slot), potion)
						return true
					else
						return false
				}
				
				HasPotion(potion := "Any")	; Checks the whole inventory
				{
					Debug.AddLine("Checking if inventory has " . potion . " potion")
					return AutoOS.Core.Item.CountPotion(AutoOS.Coordinates.GameTab.Inventory.Inventory, potion)
				}
				
				
				SlotHasNMZPotion(slot, potion := "Any")
				{
					Debug.AddLine("Checking if inventory slot " . slot . " has " . potion . " NMZ potion")
					if AutoOS.Core.Item.HasNMZPotion(AutoOS.Coordinates.GameTab.Inventory.GetSlot(slot), potion)
						return true
					else
						return false
				}
				
				HasNMZPotion(potion := "Any")	; Checks the whole inventory
				{
					Debug.AddLine("Checking if inventory has " . potion . " NMZ potion")
					return AutoOS.Core.Item.CountNMZPotion(AutoOS.Coordinates.GameTab.Inventory.Inventory, potion)
				}
				
				
				SlotHasDivinePotion(slot, potion := "Any")
				{
					Debug.AddLine("Checking if inventory slot " . slot . " has " . potion . " divine potion")
					if AutoOS.Core.Item.HasDivinePotion(AutoOS.Coordinates.GameTab.Inventory.GetSlot(slot), potion)
						return true
					else
						return false
				}
				
				HasDivinePotion(potion := "Any")	; Checks the whole inventory
				{
					Debug.AddLine("Checking if inventory has " . potion . " divine potion")
					return AutoOS.Core.Item.CountDivinePotion(AutoOS.Coordinates.GameTab.Inventory.Inventory, potion)
				}
			
			}
			
			Class Equipment	; TODO
			{
				Static SlotName := {1: "Head", 2: "Cape", 3: "Amulet", 4: "Quiver", 5: "Weapon", 6: "Chest", 7: "Shield", 8: "Legs", 9: "Gloves", 10: "Boots", 11: "Ring"}
					   
				Static SlotNumber := {"Head": 1, "Cape": 2, "Amulet": 3, "Quiver": 4, "Weapon": 5, "Chest": 6, "Shield": 7, "Legs": 8, "Gloves": 9, "Boots": 10, "Ring": 11}
				
				IsEmpty()	; TODO Checks if we have items.
				{
					
				}
				
				IsSlotEmpty(n)
				{
					
				}
				
			}
			
			Class Prayer	; TODO
			{
				Static PrayerName := {1: "ThickSkin", 2: "BurstOfStrength", 3: "ClarityOfThought", 4: "SharpEye", 5: "MysticWill", 6: "RockSkin", 7: "SuperhumanStrength"
								    , 8: "ImprovedReflexes", 9: "RapidRestore", 10: "RapidHeal", 11: "ProtectItem", 12: "HawkEye", 13: "MysticLore", 14: "SteelSkin"
								    , 15: "UltimateStrength", 16: "IncredibleReflexes", 17: "ProtectFromMagic", 18: "ProtectFromMissiles", 19: "ProtectFromMelee"
								    , 20: "EagleEye", 21: "MysticMight", 22: "Retribution", 23: "Redemption", 24: "Smite", 25: "Preserve", 26: "Chivalry", 27: "Piety"
								    , 28: "Rigour", 29: "Augury"}
				
				Static PrayerNumber := {"ThickSkin": 1, "BurstOfStrength": 2, "ClarityOfThought": 3, "SharpEye": 4, "MysticWill": 5, "RockSkin": 6, "SuperhumanStrength": 7
									  , "ImprovedReflexes": 8, "RapidRestore": 9, "RapidHeal": 10, "ProtectItem": 11, "HawkEye": 12, "MysticLore": 13, "SteelSkin": 14
								      , "UltimateStrength": 15, "IncredibleReflexes": 16, "ProtectFromMagic": 17, "ProtectFromMissiles": 18, "ProtectFromMelee": 19
									  , "EagleEye": 20, "MysticMight": 21, "Retribution": 22, "Redemption": 23, "Smite": 24, "Preserve": 25, "Chivalry": 26, "Piety": 27
									  , "Rigour": 28, "Augury": 29}
				
				
				ClickPray(n, flick := false, level_check := false)
				{
					If n is not Integer
							n := AutoOS.Core.GameTab.Prayer.PrayerNumber[n]
					If !Math.Between(n, 1, 29) ; no need to check if it's an integer, if it's not it will not validate and will return
						return false
					
					AutoOS.Core.GameTab.Switch("Prayer")
					
					Debug.AddLine("Going to click " . n . " prayer")
					
					pray := AutoOS.Coordinates.GameTab.Prayer.GetPray(n)
					
					If Input.AsyncMouse
					{
						pray := pray[1] . ", " . pray[2] . ", " . pray[3] . ", " . pray[4]
						If !flick
							Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(" . pray . ", ""Left"")", "AsyncMouse.ahk ahk_class AutoHotkey")
						Else if flick
							Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(" . pray . ", ""doubleclick"")", "AsyncMouse.ahk ahk_class AutoHotkey")
					}
					else
					{
						If !flick
							Input.Human.Mouse.HumanCoordinates(pray[1], pray[2], pray[3], pray[4], "Left")
						Else if flick
							Input.Human.Mouse.HumanCoordinates(pray[1], pray[2], pray[3], pray[4], "doubleclick")
					}
					Sleep, Math.Random(10, 50)
				}
				
				PrayMelee()
				{
					AutoOS.Core.GameTab.Prayer.ClickPray("ProtectFromMelee")
					return
				}
				
				PrayRanged()
				{
					AutoOS.Core.GameTab.Prayer.ClickPray("ProtectFromMissiles")
					return
				}
				
				PrayMage()
				{
					AutoOS.Core.GameTab.Prayer.ClickPray("ProtectFromMagic")
					return
				}
				
			}
			
			Class Magic	; TODO
			{
				
				IsSpellBook(book)
				{
					Debug.AddLine("Going to check if our spell book is: " . book)
					if (book == "Standard")
					{
						If Color.Multi.Pixel.InBox(AutoOS.Coordinates.GameTab7, 0xd7c19b, 0x9a6c34, 2, 6, 0xa89050)
						{
							Debug.AddLine("We are on Standard spell book")
							return true
						}
						else
						{
							Debug.AddLine("We are not on Standard spell book")
							return false
						}
					}
					else if (book == "Ancient")
					{
						If Color.Multi.Pixel.InBox(AutoOS.Coordinates.GameTab7, 0x593e83, 0xd2bd9b, 2, 5, 0x5b4086)
							{
							Debug.AddLine("We are on Ancient spell book")
							return true
						}
						else
						{
							Debug.AddLine("We are not on Ancient spell book")
							return false
						}
					}
					else if (book == "Lunar")
					{
						If Color.Multi.Pixel.InBox(AutoOS.Coordinates.GameTab7, 0xb3bcc0, 0xdcdcec, 2, 5, 0xbfc5d6)
							{
							Debug.AddLine("We are on Lunar spell book")
							return true
						}
						else
						{
							Debug.AddLine("We are not on Lunar spell book")
							return false
						}
					}
					else if (book == "Arceuus")
					{
						If Color.Multi.Pixel.InBox(AutoOS.Coordinates.GameTab7, 0x68677c, 0x654b8e, 2, 6, 0x57566b)
							{
							Debug.AddLine("We are on Arceuus spell book")
							return true
						}
						else
						{
							Debug.AddLine("We are not on Arceuus spell book")
							return false
						}
					}
					
				}
				
				GetSpellBook()
				{
					Debug.AddLine("Going to check which spell book we have active")
					If AutoOS.Core.GameTab.Magic.IsSpellBook("Standard")
						return "Standard"
					Else If AutoOS.Core.GameTab.Magic.IsSpellBook("Ancient")
						return "Ancient"
					Else If AutoOS.Core.GameTab.Magic.IsSpellBook("Lunar")
						return "Lunar"
					Else If AutoOS.Core.GameTab.Magic.IsSpellBook("Arceuus")
						return "Arceuus"
				}
				
				Class Standard
				{
					
					Static SpellName := {1: "HomeTeleport", 2: "WindStrike", 3: "Confuse", 4: "EnchantBolt", 5: "WaterStrike", 6: "Lvl1Enchant", 7: "EarthStrike"
					, 8: "Weaken", 9: "FireStrike", 10: "BonesToBananas", 11: "WindBolt", 12: "Curse", 13: "Bind", 14: "LowAlchemy"
					, 15: "WaterBolt", 16: "VarrockTeleport", 17: "Lvl2Enchant", 18: "EarthBolt", 19: "LumbridgeTeleport", 20: "TeleGrab", 21: "FireBolt"
					, 22: "FaladorTeleport", 23: "CrumbleUndead", 24: "HouseTeleport", 25: "WindBlast", 26: "SuperHeat", 27: "CamelotTeleport", 28: "WaterBlast"
					, 29: "Lvl3Enchant", 30: "IbanBlast", 31: "Snare", 32: "MagicDart", 33: "ArdougneTeleport", 34: "EarthBlast", 35: "HighAlchemy"
					, 36: "ChargeWaterOrb", 37: "Lvl4Enchant", 38: "WatchtowerTeleport", 39: "FireBlast", 40: "ChargeEarthOrb", 41: "BonesToPeaches", 42: "SaradominStrike"
					, 43: "ClawsOfGuthix", 44: "FlamesOfZamorak", 45: "TrollheimTeleport", 46: "WindWave", 47: "ChargeFireOrb", 48: "ApeAtollTeleport", 49: "WaterWave"
					, 50: "ChargeAirOrb", 51: "Vulnerability", 52: "Lvl5Enchant", 53: "KourendTeleport", 54: "EarthWave", 55: "Enfeeble", 56: "TeleotherLumbridge"
					, 57: "FireWave", 58: "Entangle", 59: "Stun", 60: "Charge", 61: "WindSurge", 62: "TeleotherFalador", 63: "WaterSurge"
					, 64: "TeleBlock", 65: "BountyTeleport", 66: "Lvl6Enchant", 67: "TeleotherCamelot", 68: "EarthSurge", 69: "Lvl7Enchant", 70: "FireSurge"}
					   
					Static SpellNumber := {"HomeTeleport": 1, "WindStrike": 2, "Confuse": 3, "EnchantBolt": 4, "WaterStrike": 5, "Lvl1Enchant": 6, "EarthStrike": 7
					, "Weaken": 8, "FireStrike": 9, "BonesToBananas": 10, "WindBolt": 11, "Curse": 12, "Bind": 13, "LowAlchemy": 14
					, "WaterBolt": 15, "VarrockTeleport": 16, "Lvl2Enchant": 17, "EarthBolt": 18, "LumbridgeTeleport": 19, "TeleGrab": 20, "FireBolt": 21
					, "FaladorTeleport": 22, "CrumbleUndead": 23, "HouseTeleport": 24, "WindBlast": 25, "SuperHeat": 26, "CamelotTeleport": 27, "WaterBlast": 28
					, "Lvl3Enchant": 29, "IbanBlast": 30, "Snare": 31, "MagicDart": 32, "ArdougneTeleport": 33, "EarthBlast": 34, "HighAlchemy": 35
					, "ChargeWaterOrb": 36, "Lvl4Enchant": 37, "WatchtowerTeleport": 38, "FireBlast": 39, "ChargeEarthOrb": 40, "BonesToPeaches": 41, "SaradominStrike": 42
					, "ClawsOfGuthix": 43, "FlamesOfZamorak": 44, "TrollheimTeleport": 45, "WindWave": 46, "ChargeFireOrb": 47, "ApeAtollTeleport": 48, "WaterWave": 49
					, "ChargeAirOrb": 50, "Vulnerability": 51, "Lvl5Enchant": 52, "KourendTeleport": 53, "EarthWave": 54, "Enfeeble": 55, "TeleotherLumbridge": 56
					, "FireWave": 57, "Entangle": 58, "Stun": 59, "Charge": 60, "WindSurge": 61, "TeleotherFalador": 62, "WaterSurge": 63
					, "TeleBlock": 64, "BountyTeleport": 65, "Lvl6Enchant": 66, "TeleotherCamelot": 67, "EarthSurge": 68, "Lvl7Enchant": 69, "FireSurge": 70}
					
					
					CastSpell(n) ; TODO Add check if spell is grayed out.
					{
						If !AutoOS.Core.GameTab.Magic.IsSpellBook("Standard")
							return
						If n is not Integer
							n := AutoOS.Core.GameTab.Magic.Standard.SpellNumber[n]
						
						AutoOS.Core.GameTab.Switch("Magic")
						Debug.AddLine("Going to cast " . AutoOS.Core.GameTab.Magic.Standard.SpellName[n])
				
						; TODO Add check if spell is grayed out.
						
						spell := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(n)
						
						If Input.AsyncMouse
						{
							spell := spell[1] . ", " . spell[2] . ", " . spell[3] . ", " . spell[4] . ", ""Left"""
							Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(" . spell . ")", "AsyncMouse.ahk ahk_class AutoHotkey")
						}
						else
							Input.Human.Mouse.HumanCoordinates(spell[1], spell[2], spell[3], spell[4], "Left")
						Sleep, Math.Random(10, 50)
					}
				
				}

				Class Ancient	; TODO
				{
					
				}

				Class Lunar	; TODO
				{
					
					Static SpellName := {1: "HomeTeleport", 2: "BakePie", 3: "Geomancy", 4: "CurePlant", 5: "MonsterExamine"
					, 6: "NPCContact", 7: "CureOther", 8: "Humidify", 9: "MoonclanTeleport", 10: "TeleGroupMoonclan"
					, 11: "CureMe", 12: "OuraniaTeleport", 13: "HunterKit", 14: "WaterbirthTeleport", 15: "TeleGroupWaterbirth"
					, 16: "CureGroup", 17: "StatSpy", 18: "BarbarianTeleport", 19: "TeleGroupBarbarian", 20: "SpinFlax"
					, 21: "SuperglassMake", 22: "TanLeather", 23: "KhazardTeleport", 24: "TeleGroupKhazard", 25: "Dream"
					, 26: "StringJewellery", 27: "StatRestorePotShare", 28: "MagicImbue", 29: "FertileSoil", 30: "BoostPotionShare"
					, 31: "FishingGuildTeleport", 32: "BountyTeleport", 33: "TeleGroupFishingGuild", 34: "PlankMake", 35: "CatherbyTeleport"
					, 36: "TeleGroupCatherby", 37: "RechargeDragonstone", 38: "IcePlateuTeleport", 39: "TeleGroupIcePlateu", 40: "EnergyTransfer"
					, 41: "HealOther", 42: "VengeanceOther", 43: "Vengeance", 44: "HealGroup", 45: "SpellbookSwap"}
					   
					Static SpellNumber := {"HomeTeleport": 1, "BakePie": 2, "Geomancy": 3, "CurePlant": 4, "MonsterExamine": 5
					, "NPCContact": 6, "CureOther": 7, "Humidify": 8, "MoonclanTeleport": 9, "TeleGroupMoonclan": 10
					, "CureMe": 11, "OuraniaTeleport": 12, "HunterKit": 13, "WaterbirthTeleport": 14, "TeleGroupWaterbirth": 15
					, "CureGroup": 16, "StatSpy": 17, "BarbarianTeleport": 18, "TeleGroupBarbarian": 19, "SpinFlax": 20
					, "SuperglassMake": 21, "TanLeather": 22, "KhazardTeleport": 23, "TeleGroupKhazard": 24, "Dream": 25
					, "StringJewellery": 26, "StatRestorePotShare": 27, "MagicImbue": 28, "FertileSoil": 29, "BoostPotionShare": 30
					, "FishingGuildTeleport": 31, "BountyTeleport": 32, "TeleGroupFishingGuild": 33, "PlankMake": 34, "CatherbyTeleport": 35
					, "TeleGroupCatherby": 36, "RechargeDragonstone": 37, "IcePlateuTeleport": 38, "TeleGroupIcePlateu": 39, "EnergyTransfer": 40
					, "HealOther": 41, "VengeanceOther": 42, "Vengeance": 43, "HealGroup": 44, "SpellbookSwap": 45}
					
					static InvSpell := [34]
					static Teleport := [1]
					
					CastSpell(n) ; TODO Add check if spell is grayed out.
					{
						If !AutoOS.Core.GameTab.Magic.IsSpellBook("Lunar")
							return
						If n is not Integer
							n := AutoOS.Core.GameTab.Magic.Lunar.SpellNumber[n]
						
						AutoOS.Core.GameTab.Switch("Magic")
						Debug.AddLine("Going to cast " . AutoOS.Core.GameTab.Magic.Lunar.SpellName[n])
						
						; TODO Add check if spell is grayed out.
						
						spell := AutoOS.Coordinates.GameTab.Magic.Lunar.GetSpell(n)
						
						If Input.AsyncMouse
						{
							spell := spell[1] . ", " . spell[2] . ", " . spell[3] . ", " . spell[4] . ", ""Left"""
							Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(" . spell . ")", "AsyncMouse.ahk ahk_class AutoHotkey")
						}
						else
							Input.Human.Mouse.HumanCoordinates(spell[1], spell[2], spell[3], spell[4], "Left")
						Sleep, Math.Random(10, 50)
						For i, spell in AutoOS.Core.GameTab.Magic.Lunar.InvSpell
						{
							If (n == spell)
							{
								AutoOS.Core.GameTab.WaitTab("Inventory", 1000)
								return
							}
						}
					}
				}

				Class Arceuus	; TODO
				{
					
				}
								
			}
		
			Class ClanChat	; TODO
			{
				
			}
			
			Class FriendList	; TODO
			{
				
			}
			
			Class AccountManagement	; TODO
			{
				
			}
			
			Class Logout	; TODO
			{
									  
				Class WorldSwitcher	; TODO
				{
					
				}
				
			}
			
			Class Options	; TODO
			{
				
			}
		
			Class Emotes	; TODO
			{
				
			}
		
			Class MusicPlayer	; TODO
			{
				
			}
			
		}
		
		Class Interface
		{
			
			IsOpen()	; TODO add image search for other close button
			{
				If Color.Image.InBox(AutoOS.Coordinates.ClientPositionBox(375, 3, 514, 77), "interface\close1", 50)
					return true
				else if AutoOS.Core.Interface.Bank.Pin.IsOpen()
					return true
				else
					return false
			}
			
			Class Bank
			{
				Class Pin
				{
					IsOpen()
					{
						Debug.AddLine("Checking if bank pin screen is open")
						slot0 := AutoOS.Coordinates.Interface.Bank.Pin.Slot0
						slot1 := AutoOS.Coordinates.Interface.Bank.Pin.Slot1
						slot2 := AutoOS.Coordinates.Interface.Bank.Pin.Slot2
						slot3 := AutoOS.Coordinates.Interface.Bank.Pin.Slot3
						slot4 := AutoOS.Coordinates.Interface.Bank.Pin.Slot4
						slot5 := AutoOS.Coordinates.Interface.Bank.Pin.Slot5
						slot6 := AutoOS.Coordinates.Interface.Bank.Pin.Slot6
						slot7 := AutoOS.Coordinates.Interface.Bank.Pin.Slot7
						slot8 := AutoOS.Coordinates.Interface.Bank.Pin.Slot8
						slot9 := AutoOS.Coordinates.Interface.Bank.Pin.Slot9
						
						If Color.Pixel.InBoxes(0xff7f00, slot0, slot1, 5, 3, slot2, slot3, slot4)
						{
							Debug.AddLine("Bank pin screen is open")
							return true
						}
						Else if Color.Pixel.InBoxes(0xff7f00, slot5, slot6, 2, 3, slot7, slot8, slot9)
						{
							Debug.AddLine("Bank pin screen is open")
							return true
						}
						Else
						{
							Debug.AddLine("Bank pin screen is not open")
							return false
						}
					}
					
					ClickPinNumber(n)
					{
						
						if ((n is not integer) or !AutoOS.Core.Interface.Bank.Pin.IsOpen() or (0 > n) or (0 > 9))
							return false
						
						pin_box := [AutoOS.Coordinates.Interface.Bank.Pin.Slot0[1]
								  , AutoOS.Coordinates.Interface.Bank.Pin.Slot0[2]
								  , AutoOS.Coordinates.Interface.Bank.Pin.slot3[3]
								  , AutoOS.Coordinates.Interface.Bank.Pin.Slot8[4]]
						img := "interface\bank\pin\" . n
						pin_number := Color.Image.InBox(pin_box, img, 10)
						If pin_number
						{
							number_box := Math.WhichBox(pin_number[1], pin_number[2]
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot0
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot1
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot2
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot3
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot4
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot5
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot6
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot7
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot8
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot9
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot10)
						}
						else
						{
							AutoOS.Client.ActivateClient()
							MouseGetPos, out_x, out_y
							number_box := Math.WhichBox(out_x, out_y
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot0
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot1
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot2
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot3
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot4
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot5
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot6
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot7
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot8
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot9
													  , AutoOS.Coordinates.Interface.Bank.Pin.Slot10)
						}
						
						If Input.AsyncMouse
						{
							number_box := number_box[1] . ", " . number_box[2] . ", " . number_box[3] . ", " . number_box[4]
							Input.SendAsyncInput("Input.Human.Mouse.HumanCoordinates(" . number_box . ", ""Left"")", "AsyncMouse.ahk ahk_class AutoHotkey")
						}
						else
							Input.Human.Mouse.HumanCoordinates(number_box[1], number_box[2], number_box[3], number_box[4], "Left")
						Sleep, Math.Random(10, 50)
						
					}
				
					FindStep()
					{
						if Color.Image.InBox(AutoOS.Coordinates.Interface.Bank.Pin.Steps, "interface\bank\pin\step0")
							return "step0"
						else if Color.Image.InBox(AutoOS.Coordinates.Interface.Bank.Pin.Steps, "interface\bank\pin\step1")
							return "step1"
						else if Color.Image.InBox(AutoOS.Coordinates.Interface.Bank.Pin.Steps, "interface\bank\pin\step2")
							return "step2"
						else if Color.Image.InBox(AutoOS.Coordinates.Interface.Bank.Pin.Steps, "interface\bank\pin\step3")
							return "step3"
						else
							return false
					}
				
					WaitStep(step, t)
					{
						Debug.AddLine("Going for " . step)
						start_tick := A_TickCount, current_tick := A_TickCount
						While ((current_tick - start_tick) < t)
						{
							If (AutoOS.Core.Interface.Bank.Pin.FindStep() == step)
								return true
							Else
							{
								Sleep, 50
								current_tick := A_TickCount
							}
						}
						return false
					}
					
					UnlockBank(n1, n2, n3, n4)
					{
						
						If AutoOS.Core.Interface.Bank.Pin.FindStep() == "step0"
						{
							Debug.AddLine("Going to click the first pin number")
							AutoOS.Core.Interface.Bank.Pin.ClickPinNumber(n1)
							AutoOS.Core.Interface.Bank.Pin.WaitStep("step1", 500)
						}
						
						If AutoOS.Core.Interface.Bank.Pin.FindStep() == "step1"
						{
							Debug.AddLine("Going to click the second pin number")
							AutoOS.Core.Interface.Bank.Pin.ClickPinNumber(n2)
							AutoOS.Core.Interface.Bank.Pin.WaitStep("step2", 500)
						}
						
						If AutoOS.Core.Interface.Bank.Pin.FindStep() == "step2"
						{
							Debug.AddLine("Going to click the third pin number")
							AutoOS.Core.Interface.Bank.Pin.ClickPinNumber(n3)
							AutoOS.Core.Interface.Bank.Pin.WaitStep("step3", 500)
						}
						
						If AutoOS.Core.Interface.Bank.Pin.FindStep() == "step3"
						{
							Debug.AddLine("Going to click the fourth pin number")
							AutoOS.Core.Interface.Bank.Pin.ClickPinNumber(n4)
							AutoOS.Core.Interface.Bank.WaitBank(1000)
						}
						
						
					}
					
				}
				
				IsOpen()	; TODO need testing in higher dpi. should work though.
				{
					Debug.AddLine("Checking if bank is open")
					If Color.Multi.Pixel.InBox(AutoOS.Coordinates.Interface.Bank.RearrangeMode, 0xff981f, 0x000000, 2, 3, 0x494034)
					{
						Debug.AddLine("Bank is open")
						return true
					}
					Else if Color.Multi.Pixel.InBox(AutoOS.Coordinates.Interface.Bank.WithdrawAs, 0xff981f, 0x000000, 2, 3, 0x494034)
					{
						Debug.AddLine("Bank is open")
						return true
					}
					Else
					{
						Debug.AddLine("Bank is not open")
						Return false
					}
				}
				
				WaitBank(t)
				{
					Debug.AddLine("Waiting for bank screen")
					start_tick := A_TickCount, current_tick := A_TickCount
					While ((current_tick - start_tick) < t)
					{
						If AutoOS.Core.Interface.Bank.IsOpen()
							return true
						Else
						{
							Sleep, 50
							current_tick := A_TickCount
						}
					}
					return false
				}
				
				
			}
			
			
		}
		
		Class Item
		{
			Static PotionColor := {"Attack": 0x4bced2, "Antipoison": 0x7cdb21, "Strength": 0xd2d24b, "Compost": 0x87625c, "Restore": 0xd2544b, "GuthixBalance": 0x58be7d
									, "Energy": 0xa75e6a, "Defence": 0x4bd24e, "Agility": 0x7b9312, "Combat": 0x88ba74, "Prayer": 0x4bd2a3, "SuperAttack": 0x4b4ed2, "SuperAntipoison": 0xdb2176
									, "Fishing": 0x4f4a4a, "SuperEnergy": 0xbe589b, "Hunter": 0x0b5c5f, "SuperStrength": 0xd2d0d0, "WeaponPoison": 0x2182db
									, "SuperRestore": 0xb3406f, "SanfewSerum": 0xb76f69, "SuperDefence": 0xd2b24b, "AntidotePlus": 0x7d7c62, "Antifire": 0x751298, "Ranging": 0x4bafd2
									, "WeaponPoisonPlus": 0xa75c3c, "Magic": 0xc6a69b, "Stamina": 0x9b7747, "ZamorakBrew": 0x87650e, "AntidotePlusPlus": 0x7d813a, "Bastion": 0xb86216
									, "Battlemage": 0xdba82e, "SaradominBrew": 0xcbca59, "WeaponPoisonPlusPlus": 0xb9b9c5, "ExtendedAntifire": 0x6d34d0, "AntiVenom": 0x3c4b43
									, "SuperCombat": 0x1c6c0b, "SuperAntifire": 0x8c61aa, "AntiVenomPlus": 0x5a474d, "ExtendedSuperAntifire": 0xad87c9}
									

			Static PotionName := {0x4bced2: "Attack", 0x7cdb21: "Antipoison", 0xd2d24b: "Strength", 0x87625c: "Compost", 0xd2544b: "Restore", 0x58be7d: "GuthixBalance"
								 , 0xa75e6a: "Energy", 0x4bd24e: "Defence", 0x7b9312: "Agility", 0x88ba74: "Combat", 0x4bd2a3: "Prayer", 0x4b4ed2: "SuperAttack", 0xdb2176: "SuperAntipoison"
								 , 0x4f4a4a: "Fishing", 0x: "SuperEnergy", 0xd2b24b: "Hunter", 0xd2d0d0: "SuperStrength", 0x2182db: "WeaponPoison"
								 , 0xb3406f: "SuperRestore", 0xb76f69: "SanfewSerum", 0xd2b24b: "SuperDefence", 0x7d7c62: "AntidotePlus", 0x751298: "Antifire", 0x4bafd2: "Ranging"
								 , 0xa75c3c: "WeaponPoisonPlus", 0xc6a69b: "Magic", 0x9b7747: "Stamina", 0x87650e: "ZamorakBrew", 0x7d813a: "AntidotePlusPlus", 0xb86216: "Bastion"
								 , 0xdba82e: "Battlemage", 0xcbca59: "SaradominBrew", 0xb9b9c5: "WeaponPoisonPlusPlus", 0x6d34d0: "ExtendedAntifire", 0x3c4b43: "AntiVenom"
								 , 0x1c6c0b: "SuperCombat", 0x8c61aa: "SuperAntifire", 0x5a474d: "AntiVenomPlus", 0xad87c9: "ExtendedSuperAntifire"}
				
			Static NMZPotionColor := {"SuperMagic": 0x5797bd, "SuperRanging": 0x4bafd2, "Overload": 0x120e0e, "Absorption": 0xb6c0c4}

			Static NMZPotionName := {0x5797bd: "SuperMagic", 0x4bafd2: "SuperRanging", 0x120e0e: "Overload", 0xb6c0c4: "Absorption"}

			Static DivinePotionColor := {"SuperAttack": 0x3f42d2, "SuperStrength": 0xcdcaca, "Ranging": 0x3facd2, "Bastion": 0xac5b15
									  , "Battlemage": 0xd09c19, "SuperCombat": 0x19650b}
								
			Static DivinePotionName := {0x3f42d2: "SuperAttack", 0xcdcaca: "SuperStrength", 0x3facd2: "SuperRanging", 0xac5b15: "Bastion"
									   , 0xd09c19: "Battlemage", 0x19650b: "SuperCombat"}
			
			HasItem(box, shape)
			{
				path := "items\" . shape
				If Color.Image.InBox(box, path, 50)
					return Array(potion_shape[1], potion_shape[2])
				else
					return false
			}
			
			CountInventoryRow(row, shape)
			{
				item_count := 0
				box := AutoOS.Coordinates.GameTab.Inventory.GetRow(row)
				
				Loop, 4	; Loops a maximum of 8 times. Bank has 8 columns, inventory has 4.
				{		; In case of the bank you shouldn't need to count items as every item stacks ¯\_(ツ)_/¯
					slot_box := [AutoOS.Coordinates.GameTab.Inventory.GetSlot(A_Index)[1], box[2], AutoOS.Coordinates.GameTab.Inventory.GetSlot(A_Index)[3], box[4]]
					pot := AutoOS.Core.Item.HasItem(slot_box, shape)
					if pot
						++item_count
				}
				return item_count
			}
			
			CountItem(shape)	; TODO need to make this smarter. Right now it's checking every single slot and shouldn't need to.
			{
				item_count := 0
				Loop, 7
				{
					item_count += AutoOS.Core.Item.CountInventoryRow(A_Index, shape)
				}
				return item_count
			}
			
			
			
			HasPotion(box, potion := "Any")
			{
				potion_shape := AutoOS.Core.Item.HasItem(box, "potion")
				if !potion_shape
					return false
				if (potion == "Any")
					return Array(potion_shape[1], potion_shape[2])
				else
				{
					box_width := box[3]-box[1]
					box_height := box[4]-box[2]
					
					box := [box[1] + Round(box_width/2.5)
						  , box[2] + Round(box_height/1.5)
						  , box[3] - Round(box_width/2.5)
						  , Round(box[4] - (box_height/8))]
					if Color.Pixel.InBox(AutoOS.Core.Item.PotionColor[potion], box)
						return Array(potion_shape[1], potion_shape[2])
					else
						return false
				}
			}
			
			CountInventoryRowPotion(row, potion := "Any")
			{
				item_count := 0
				box := AutoOS.Coordinates.GameTab.Inventory.GetRow(row)
				
				Loop, 4	; Loops a maximum of 8 times. Bank has 8 columns, inventory has 4.
				{		; In case of the bank you shouldn't need to count items as every item stacks ¯\_(ツ)_/¯
					slot_box := [AutoOS.Coordinates.GameTab.Inventory.GetSlot(A_Index)[1], box[2], AutoOS.Coordinates.GameTab.Inventory.GetSlot(A_Index)[3], box[4]]
					pot := AutoOS.Core.Item.HasPotion(slot_box, potion)
					if pot
						++item_count
				}
				return item_count
			}
			
			CountPotion(potion := "Any")	; TODO need to make this smarter. Right now it's checking every single slot and shouldn't need to.
			{
				item_count := 0

				Loop, 7
				{
					item_count += AutoOS.Core.Item.CountInventoryRowPotion(A_Index, potion)
				}
				return item_count
			}
			
			
			
			HasNMZPotion(box, potion := "Any")
			{
				potion_shape := AutoOS.Core.Item.HasItem(box, "potion")
				if !potion_shape
					return false
				if (potion == "Any")
					return Array(potion_shape[1], potion_shape[2])
				else
				{
					box_width := box[3]-box[1]
					box_height := box[4]-box[2]
					
					box := [box[1] + Round(box_width/2.5)
						  , box[2] + Round(box_height/1.5)
						  , box[3] - Round(box_width/2.5)
						  , Round(box[4] - (box_height/8))]
					if Color.Pixel.InBox(AutoOS.Core.Item.NMZPotionColor[potion], box)
						return Array(potion_shape[1], potion_shape[2])
					else
						return false
				}
			}
			
			CountInventoryRowNMZPotion(row, potion := "Any")
			{
				item_count := 0
				box := AutoOS.Coordinates.GameTab.Inventory.GetRow(row)
				
				Loop, 4	; Loops a maximum of 8 times. Bank has 8 columns, inventory has 4.
				{		; In case of the bank you shouldn't need to count items as every item stacks ¯\_(ツ)_/¯
					slot_box := [AutoOS.Coordinates.GameTab.Inventory.GetSlot(A_Index)[1], box[2], AutoOS.Coordinates.GameTab.Inventory.GetSlot(A_Index)[3], box[4]]
					pot := AutoOS.Core.Item.HasNMZPotion(slot_box, potion)
					if pot
						++item_count
				}
				return item_count
			}
			
			CountNMZPotion(potion := "Any")	; TODO need to make this smarter. Right now it's checking every single slot and shouldn't need to.
			{
				item_count := 0

				Loop, 7
				{
					item_count += AutoOS.Core.Item.CountInventoryRowNMZPotion(A_Index, potion)
				}
				return item_count
			}
			
			
			
			HasDivinePotion(box, potion := "Any")
			{
				potion_shape := AutoOS.Core.Item.HasItem(box, "divine_potion")
				if !potion_shape
					return false
				if (potion == "Any")
					return Array(potion_shape[1], potion_shape[2])
				else
				{
					box_width := box[3]-box[1]
					box_height := box[4]-box[2]
					
					box := [box[1] + Round(box_width/2.5)
						  , box[2] + Round(box_height/1.5)
						  , box[3] - Round(box_width/2.5)
						  , Round(box[4] - (box_height/8))]
					if Color.Pixel.InBox(AutoOS.Core.Item.DivinePotionColor[potion], box)
						return Array(potion_shape[1], potion_shape[2])
					else
						return false
				}
			}
			
			CountInventoryRowDivinePotion(row, potion := "Any")
			{
				item_count := 0
				box := AutoOS.Coordinates.GameTab.Inventory.GetRow(row)
				
				Loop, 4	; Loops a maximum of 8 times. Bank has 8 columns, inventory has 4.
				{		; In case of the bank you shouldn't need to count items as every item stacks ¯\_(ツ)_/¯
					slot_box := [AutoOS.Coordinates.GameTab.Inventory.GetSlot(A_Index)[1], box[2], AutoOS.Coordinates.GameTab.Inventory.GetSlot(A_Index)[3], box[4]]
					pot := AutoOS.Core.Item.HasDivinePotion(slot_box, potion)
					if pot
						++item_count
				}
				return item_count
			}
			
			CountDivinePotion(potion := "Any")	; TODO need to make this smarter. Right now it's checking every single slot and shouldn't need to.
			{
				item_count := 0

				Loop, 7
				{
					item_count += AutoOS.Core.Item.CountInventoryRowDivinePotion(A_Index, potion)
				}
				return item_count
			}
			
			
		}
	}
	
	Setup()
	{
		If (A_CoordModePixel != "Screen")
			CoordMode, Pixel, Screen
		If (A_CoordModeMouse != "Screen")
			CoordMode, Mouse, Screen
	}
	
	
}

OnExit()
{
	Gdip_Shutdown(pToken)
	Input.SendAsyncInput("Exit", "AsyncMouse.ahk ahk_Class AutoHotkey")
	Input.SendAsyncInput("Exit", "AsyncKeyboard.ahk ahk_Class AutoHotkey")
	ExitApp	
}