AOS_Start(player, async_input := true)
{
	AutoOS.Player := player
	AutoOS.PlayerManager.GetPlayer(player)
	AutoOS.Client.BootstrapCoordinates()
	Input.AsyncMouse := async_input, Input.AsyncKeyboard := async_input
	if async_input
	{
		Run, "AutoHotkey.exe" "plugins/AsyncMouse.ahk" %player%
		Run, "AutoHotkey.exe" "plugins/AsyncKeyboard.ahk" %player%
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
			AutoOS.PlayerManager.MusicPlayerFKeythis := MusicPlayerFKeythis
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
				ExitApp
			}
			WinGet, ClientID, ID, % "ahk_exe " . AutoOS.PlayerManager.Client ".exe"
			ControlGetPos, control_x, control_y, control_w, control_h,  SunAwtCanvas2, % "ahk_exe " . AutoOS.PlayerManager.Client ".exe"
			
			AutoOS.Client.ClientID := ClientID
			AutoOS.Client.Coordinates := [control_x, control_y, (control_w + control_x), (control_y + control_h)]
		}
		
	}
	
	Class Coordinates	; This whole Class is just a group of Static variables for all the coordinates I could think of. The only 2 methods are used to convert 
	{					; Client coordinates to Screen coordinates.
		Static GameScreen := AutoOS.Coordinates.ClientPosition(6, 5, 773, 505)
		Static UpText := AutoOS.Coordinates.ClientPosition(6, 5, 300, 23)
		
		Static GameTab1 := AutoOS.Coordinates.ClientPosition(522, 168, 559, 203)
		Static GameTab2 := AutoOS.Coordinates.ClientPosition(560, 168, 592, 203)
		Static GameTab3 := AutoOS.Coordinates.ClientPosition(593, 168, 625, 203)
		Static GameTab4 := AutoOS.Coordinates.ClientPosition(626, 168, 658, 203)
		Static GameTab5 := AutoOS.Coordinates.ClientPosition(659, 168, 691, 203)
		Static GameTab6 := AutoOS.Coordinates.ClientPosition(692, 168, 724, 203)
		Static GameTab7 := AutoOS.Coordinates.ClientPosition(725, 168, 762, 203)
		
		Static GameTab8 := AutoOS.Coordinates.ClientPosition(522, 466, 559, 501)
		Static GameTab9 := AutoOS.Coordinates.ClientPosition(560, 466, 592, 501)
		Static GameTab10 := AutoOS.Coordinates.ClientPosition(593, 466, 625, 501)
		Static GameTab11 := AutoOS.Coordinates.ClientPosition(626, 466, 658, 501)
		Static GameTab12 := AutoOS.Coordinates.ClientPosition(659, 466, 691, 501)
		Static GameTab13 := AutoOS.Coordinates.ClientPosition(692, 466, 724, 501)
		Static GameTab14 := AutoOS.Coordinates.ClientPosition(725, 466, 762, 501)
		
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
		
		ClientPosition(x, y, w, h)	; Joins both methods above for an fast and easy to write/read way of converting coordinates.
		{
			return [AutoOS.Coordinates.ClientPositionX(x), AutoOS.Coordinates.ClientPositionY(y), AutoOS.Coordinates.ClientPositionX(w), AutoOS.Coordinates.ClientPositionY(h)]
		}
		
		Class Minimap
		{
			Static MidPoint := [AutoOS.Coordinates.ClientPositionX(643)	; Minimap center point.
							  , AutoOS.Coordinates.ClientPositionY(84)]
			
			Static Radius := 70 ; Real radius is about 75 pixels but I think setting it up slightly smaller is probably better
			
			Static Compass := AutoOS.Coordinates.ClientPosition(546, 6, 574, 34)
							
		}
		
		Class StatOrbs
		{
			Static Experience := AutoOS.Coordinates.ClientPosition(517, 21, 542, 47)
	
			; Health orb
			Static Health := AutoOS.Coordinates.ClientPosition(544, 45, 567, 70)
			; Hitpoints number
			Static Hitpoints := AutoOS.Coordinates.ClientPosition(520, 50, 540, 70)
				
			Static QuickPray := AutoOS.Coordinates.ClientPosition(542, 80, 567, 105)
			Static PrayPoints := AutoOS.Coordinates.ClientPosition(520, 85, 540, 105)
			
			Static Energy := AutoOS.Coordinates.ClientPosition(553, 112, 578, 137)
			Static EnergyPoints := AutoOS.Coordinates.ClientPosition(530, 120, 550, 135)
			
			Static SpecialAttack := AutoOS.Coordinates.ClientPosition(575, 138, 600, 162)
			Static SpecAttPoints := AutoOS.Coordinates.ClientPosition(551, 143, 574, 159)

		}
	
		Class GameTab
		{
			
			Class Combat	; TODO add staves.
			{
				Static WeaponNCombat := AutoOS.Coordinates.ClientPosition(559, 208, 732, 246)
				Static AttackStyle1 := AutoOS.Coordinates.ClientPosition(567, 250, 637, 296)
				Static AttackStyle2 := AutoOS.Coordinates.ClientPosition(646, 250, 716, 296)
				Static AttackStyle3 := AutoOS.Coordinates.ClientPosition(567, 304, 637, 350)
				Static AttackStyle4 := AutoOS.Coordinates.ClientPosition(646, 304, 716, 350)
				Static AutoRetaliate := AutoOS.Coordinates.ClientPosition(567, 358, 716, 401)
				Static SpecAttackBar := AutoOS.Coordinates.ClientPosition(567, 409, 716, 434)
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
						return AutoOS.Coordinates.ClientPosition((485 + (63 * ((n-(Floor(n/3)*3)) != 0 ? (n-(Floor(n/3)*3)) : 3))), (174 + (32 * Ceil(n/3)))
															    , (546 + (63 * ((n-(Floor(n/3)*3)) != 0 ? (n-(Floor(n/3)*3)) : 3))), (205 + (32 * Ceil(n/3))))
				}
				 
								 
								 
			}
		
			Class Quests	; TODO
			{
				
			}
			
			Class Inventory
			{				
				Static Inventory := AutoOS.Coordinates.ClientPosition(563, 213, 720, 460)
				
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
						return AutoOS.Coordinates.ClientPosition((521 + (42 * ((n-(Floor(n/4)*4)) != 0 ? (n-(Floor(n/4)*4)) : 4))), (177 + (36 * Ceil(n/4)))
															    , (552 + (42 * ((n-(Floor(n/4)*4)) != 0 ? (n-(Floor(n/4)*4)) : 4))), (208 + (36 * Ceil(n/4))))
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
						return AutoOS.Coordinates.ClientPosition((514 + (37 * ((n-(Floor(n/5)*5)) != 0 ? (n-(Floor(n/5)*5)) : 5))), (177 + (37 * Ceil(n/5)))
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
							return AutoOS.Coordinates.ClientPosition((526 + (26 * ((n-(Floor(n/7)*7)) != 0 ? (n-(Floor(n/7)*7)) : 7))), (181 + (24 * Ceil(n/7)))
																   , (549 + (26 * ((n-(Floor(n/7)*7)) != 0 ? (n-(Floor(n/7)*7)) : 7))), (204 + (24 * Ceil(n/7))))
					}
	
				}

				Class Ancient	; TODO
				{
					
				}

				Class Lunar	; TODO
				{
					
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
				Static WorldSwitcherButton := AutoOS.Coordinates.ClientPosition(570, 366, 713, 401)
				Static LogoutButton := AutoOS.Coordinates.ClientPosition(570, 414, 713, 449)
									  
				Class WorldSwitcher	; TODO
				{
					
				}
				
			}
			
			Class Options	; TODO
			{
				Static Display := AutoOS.Coordinates.ClientPosition(553, 206, 592, 245)
				Static Audio := AutoOS.Coordinates.ClientPosition(599, 206, 638, 245)
				Static Chat := AutoOS.Coordinates.ClientPosition(645, 206, 684, 245)
				Static Controls := AutoOS.Coordinates.ClientPosition(691, 206, 730, 245)
					
				Static ZoomIcon := AutoOS.Coordinates.ClientPosition(558, 256, 589, 287)
				Static ZoomBar := AutoOS.Coordinates.ClientPosition(601, 265, 712, 280)
				
				Static BrightnessIcon := AutoOS.Coordinates.ClientPosition(558, 290, 589, 321)
				Static BrightnessBar := AutoOS.Coordinates.ClientPosition(593, 299, 720, 314)
				
				Static FixedClient := AutoOS.Coordinates.ClientPosition(572, 325, 633, 378)
				Static ScaleableClient := AutoOS.Coordinates.ClientPosition(650, 325, 711, 378)
				
				Static AdvancedOptions := AutoOS.Coordinates.ClientPosition(572, 382, 711, 411)
				
				Static AcceptAid := AutoOS.Coordinates.ClientPosition(553, 425, 592, 464)
				Static RunButton := AutoOS.Coordinates.ClientPosition(599, 425, 638, 464)
				Static HouseOptions := AutoOS.Coordinates.ClientPosition(645, 425, 684, 464)
				Static BondPouch := AutoOS.Coordinates.ClientPosition(691, 425, 730, 464)
				
				Class POH	; TODO
				{
					Static Title := AutoOS.Coordinates.ClientPosition(589, 204, 691, 224)
					Static Close := AutoOS.Coordinates.ClientPosition(710, 212, 735, 234)
					Static Viewer := AutoOS.Coordinates.ClientPosition(557, 230, 661, 269)
					Static BuildModeOn := AutoOS.Coordinates.ClientPosition(685, 273, 701, 289)
					Static BuildModeOff := AutoOS.Coordinates.ClientPosition(710, 273, 726, 289)
					Static TeleportInsideOn := AutoOS.Coordinates.ClientPosition(685, 293, 701, 309)
					Static TeleportInsideOff := AutoOS.Coordinates.ClientPosition(710, 293, 726, 309)
					
					Static DoorsClosed := AutoOS.Coordinates.ClientPosition(617, 318, 633, 334)
					Static DoorsOpen := AutoOS.Coordinates.ClientPosition(665, 318, 681, 334)
					Static DoorsOff := AutoOS.Coordinates.ClientPosition(712, 318, 728, 334)
					
					Static ExpellGuests := AutoOS.Coordinates.ClientPosition(557, 340, 726, 374)
					Static LeaveHouse := AutoOS.Coordinates.ClientPosition(557, 375, 726, 409)
					Static CallServant := AutoOS.Coordinates.ClientPosition(557, 410, 726, 445)
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
			Static ChatBox := AutoOS.Coordinates.ClientPosition(0, 338, 477, 520)
			Static Scroll := AutoOS.Coordinates.ClientPosition(497, 343, 511, 455)
			Static UserInput := AutoOS.Coordinates.ClientPosition(7, 455, 511, 473)
			Static UITitle := AutoOS.Coordinates.ClientPosition(13, 355, 507, 374) ; I don't remember what's this lol.... need to check and probably name it better.
			
			Static Option1 := AutoOS.Coordinates.ClientPosition(5, 480, 60, 501)
			Static Option2 := AutoOS.Coordinates.ClientPosition(71, 480, 126, 501)
			Static Option3 := AutoOS.Coordinates.ClientPosition(137, 480, 192, 501)
			Static Option4 := AutoOS.Coordinates.ClientPosition(203, 480, 258, 501)
			Static Option5 := AutoOS.Coordinates.ClientPosition(269, 480, 324, 501)
			Static Option6 := AutoOS.Coordinates.ClientPosition(335, 480, 390, 501)
			Static Option7 := AutoOS.Coordinates.ClientPosition(403, 480, 513, 501)
			
		}
	
	
	}
	
	Class Core	; TODO
	{
		Class GameTab	; TODO
		{
			IsActive(tab)
			{
				If Color.Multi.Pixel.InBox(AutoOS.Coordinates.GameTab.GetTab(tab), 0x75281e, 0x3b140f, 2, 5, 0x441812)
					return true
				Else if ((tab == 4) and !AutoOS.Core.GameTab.GetActiveRow())	; If tab is inventory and no tab is active, we probably are at bank or shop.
					return true
				Else
					return false
			}
			
			GetActive()	; This was my last attempt and the best attempt at this. This only uses pixel search a maximum
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
			
			GetActiveFaster()	; This was my second attempt at this method. It's slower than the original GetActiveSlow() on the first 7 tabs,
			{					; but much much faster on the last 7 tabs. Overall I think it's better than the original one. For more info read
								; the comments on GetActive() and GetActiveFast()
				row := AutoOS.Core.GameTab.GetActiveRow()
				MsgBox % row[1] . " and " . row[2]
				If (row == "top")
				{
					Loop, 7
					{
						If (AutoOS.Core.GameTab.IsActive(A_Index) == true)
						{
							Debug.AddLine("Active Gametab is: " . A_Index)
							return A_Index
						}
					}
				}
				
				Else if (row == "bottom")
				{
					Loop, 7
					{
						If (AutoOS.Core.GameTab.IsActive(A_Index+7) == true)
							{
								Debug.AddLine("Active Gametab is: " . (A_Index+7))
								return (A_Index+7)
							}
					}
				}
			}
		
			GetActiveSlow()	; I was originally using this method inspired by Simba's SRL include but I found it too slow on the last tabs.
			{				; The method I'm currently using is much faster and even though this one should be more accurate in theory, the 
							; current method never failed me so far. Read the comments on GetActive() and GetActiveFast() for more info.
				Loop, 14
				{
					If (AutoOS.Core.GameTab.IsActive(A_Index) == true)
					{
						Debug.AddLine("Active Gametab is: " . A_Index)
						return A_Index
					}
				}
				Debug.AddLine("We can't find active tab. Maybe we are logged out.")
				return "Error"
				; Add logout check.
			}
			
			GetActiveRow()
			{
				If (top_row := Color.Multi.Pixel.InBox([AutoOS.Coordinates.GameTab.GetTab(1)[1], AutoOS.Coordinates.GameTab.GetTab(1)[2]	; Checks for red
											  , AutoOS.Coordinates.GameTab.GetTab(7)[3], AutoOS.Coordinates.GameTab.GetTab(7)[4]], 0x75281e, 0x3b140f, 2, 5, 0x441812))
					return top_row
				Else if (bottom_row := Color.Multi.Pixel.InBox([AutoOS.Coordinates.GameTab.GetTab(8)[1], AutoOS.Coordinates.GameTab.GetTab(8)[2] ; Checks for red
											   , AutoOS.Coordinates.GameTab.GetTab(14)[3], AutoOS.Coordinates.GameTab.GetTab(14)[4]], 0x75281e, 0x3b140f, 2, 5, 0x441812))
					return bottom_row
				Else
					return false
			}
						
			Class Combat	; TODO
			{
				
			}
		
			Class Skills	; TODO
			{
				
			}
		
			Class Quests	; TODO
			{
				
			}
			
			Class Inventory	; TODO
			{

			}
			
			Class Equipment	; TODO
			{
				
			}
			
			Class Prayer	; TODO
			{
				
			}
			
			Class Magic	; TODO
			{
				Class Standard
				{
	
				}

				Class Ancient	; TODO
				{
					
				}

				Class Lunar	; TODO
				{
					
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
		
	}
	
	Setup()
	{
		If (A_CoordModePixel != "Screen")
			CoordMode, Pixel, Screen
		If (A_CoordModeMouse != "Screen")
			CoordMode, Mouse, Screen
	}
	
	
}

Class UserInterface
{
	Class PlayerManager
	{
		
		MasterPassword()
		{
			masterpass_text := "This will be the password we will use "
							 . "to encrypt and decrypt your account details.`n`r`n`r"
							 . "Your password should be at least 4 characters long.`n`r`n`r"
							 . "AutoOS doesn't check If your password is right, If it's not, "
							 . "it simply won't be able to fecth your account sensitive data."
			
			InputBox, pass, % "Master Password", % masterpass_text, HIDE, 300, 280,
			AutoOS.PlayerManager.MasterPassword := pass
			UserInterface.PlayerManager.UpdatePlayersData()
			UserInterface.PlayerManager.Start()
		}
		
		Class NewPlayer
		{

			Static NewPlayerClient, NewPlayerLogin, NewPlayerPassword, NewPlayerPinNumber, NewPlayerUsername
			Static NewPlayerCombatFkey, NewPlayerSkillsFkey, NewPlayerQuestsFkey, NewPlayerInventoryFkey
				 , NewPlayerEquipmentFkey, NewPlayerPrayerFkey, NewPlayerMagicFkey
			Static NewPlayerClanChatFkey, NewPlayerFriendListFkey, NewPlayerAccountManagementFkey, NewPlayerLogoutFkey
				 , NewPlayerOptionsFkey, NewPlayerEmotesFkey, NewPlayerMusicPlayerFkey
			
			Load()
			{
				Gui, PlayerManager: Hide
				Gui, NewPlayer: New, New Player
				Gui, NewPlayer: Add, Text, x10 y10, % "Client:"
				Gui, NewPlayer: Add, Text, x82 y10, % "Email/Login:"
				Gui, NewPlayer: Add, Text, x164 y10, % "Password:"
				Gui, NewPlayer: Add, Text, x246 y10, % "Pin number:"
				Gui, NewPlayer: Add, Text, x318 y10, % "Username:"
				Gui, NewPlayer: Add, ComboBox, x10 y25 w70 HwndNewPlayerClient, RuneLite||Official
				Gui, NewPlayer: Add, Edit, x82 y25 w80 r0.8 HwndNewPlayerLogin, Optional
				Gui, NewPlayer: Add, Edit, x164 y25 w80 r0.8 HwndNewPlayerPassword, Optional
				Gui, NewPlayer: Add, Edit, x246 y25 w70 r0.8 Number Limit4 HwndNewPlayerPinNumber, Optional
				Gui, NewPlayer: Add, Edit, x318 y25 w80 r0.8 Limit13 HwndNewPlayerUsername, Optional

				Gui, NewPlayer: Add, GroupBox, x5 y60 h110 w400, F-Keys
				Gui, NewPlayer: Add, Text, x10 y80, % "Combat:"
				Gui, NewPlayer: Add, Text, x65 y80, % "Skills:"
				Gui, NewPlayer: Add, Text, x120 y80, % "Quests:"
				Gui, NewPlayer: Add, Text, x175 y80, % "Inventory:"
				Gui, NewPlayer: Add, Text, x230 y80, % "Equip:"
				Gui, NewPlayer: Add, Text, x285 y80, % "Prayer:"
				Gui, NewPlayer: Add, Text, x340 y80, % "Magic:"
				Gui, NewPlayer: Add, ComboBox, x10 y95 w50 HwndNewPlayerCombatFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x65 y95 w50 HwndNewPlayerSkillsFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x120 y95 w50 HwndNewPlayerQuestsFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x175 y95 w50 HwndNewPlayerInventoryFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x230 y95 w50 HwndNewPlayerEquipmentFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x285 y95 w50 HwndNewPlayerPrayerFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x340 y95 w50 HwndNewPlayerMagicFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, Text, x10 y120, % "Clan chat:"
				Gui, NewPlayer: Add, Text, x65 y120, % "Friends:"
				Gui, NewPlayer: Add, Text, x120 y120, % "Acc.Man.:"
				Gui, NewPlayer: Add, Text, x175 y120, % "Logout:"
				Gui, NewPlayer: Add, Text, x230 y120, % "Options:"
				Gui, NewPlayer: Add, Text, x285 y120, % "Emotes:"
				Gui, NewPlayer: Add, Text, x340 y120, % "Music:"
				Gui, NewPlayer: Add, ComboBox, x10 y135 w50 HwndNewPlayerClanChatFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x65 y135 w50 HwndNewPlayerFriendListFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x120 y135 w50 HwndNewPlayerAccountManagementFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x175 y135 w50 HwndNewPlayerLogoutFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x230 y135 w50 HwndNewPlayerOptionsFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x285 y135 w50 HwndNewPlayerEmotesFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x340 y135 w50 HwndNewPlayerMusicPlayerFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				
				Gui, NewPlayer: Add, Button, x125 y180 w50 gSaveNewPlayer, Save
				Gui, NewPlayer: Add, Button, x225 y180 w50 gCancelNewPlayer, Cancel
				Gui, NewPlayer: Show
				
				UserInterface.PlayerManager.NewPlayer.NewPlayerClient := NewPlayerClient
				UserInterface.PlayerManager.NewPlayer.NewPlayerLogin := NewPlayerLogin
				UserInterface.PlayerManager.NewPlayer.NewPlayerPassword := NewPlayerPassword
				UserInterface.PlayerManager.NewPlayer.NewPlayerPinNumber := NewPlayerPinNumber
				UserInterface.PlayerManager.NewPlayer.NewPlayerUsername := NewPlayerUsername
				UserInterface.PlayerManager.NewPlayer.NewPlayerCombatFkey := NewPlayerCombatFkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerSkillsFkey := NewPlayerSkillsFkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerQuestsFkey := NewPlayerQuestsFkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerInventoryFkey := NewPlayerInventoryFkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerEquipmentFkey := NewPlayerEquipmentFkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerPrayerFkey := NewPlayerPrayerFkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerMagicFkey := NewPlayerMagicFkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerClanChatFkey := NewPlayerClanChatFkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerFriendListFkey := NewPlayerFriendListFkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerAccountManagementFkey := NewPlayerAccountManagementFkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerLogoutFkey := NewPlayerLogoutFkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerOptionsFkey := NewPlayerOptionsFkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerEmotesFkey := NewPlayerEmotesFkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerMusicPlayerFkey := NewPlayerMusicPlayerFkey
				return
				
				SaveNewPlayer:
					GuiControlGet, new_player_client,, % UserInterface.PlayerManager.NewPlayer.NewPlayerClient
					GuiControlGet, new_player_login,, % UserInterface.PlayerManager.NewPlayer.NewPlayerLogin
					GuiControlGet, new_player_password,, % UserInterface.PlayerManager.NewPlayer.NewPlayerPassword
					GuiControlGet, new_player_pin_number,, % UserInterface.PlayerManager.NewPlayer.NewPlayerPinNumber
					GuiControlGet, new_player_username,, % UserInterface.PlayerManager.NewPlayer.NewPlayerUsername
					GuiControlGet, new_player_combat,, % UserInterface.PlayerManager.NewPlayer.NewPlayerCombatFkey
					GuiControlGet, new_player_skills,, % UserInterface.PlayerManager.NewPlayer.NewPlayerSkillsFkey
					GuiControlGet, new_player_quests,, % UserInterface.PlayerManager.NewPlayer.NewPlayerQuestsFkey
					GuiControlGet, new_player_inventory,, % UserInterface.PlayerManager.NewPlayer.NewPlayerInventoryFkey
					GuiControlGet, new_player_equipment,, % UserInterface.PlayerManager.NewPlayer.NewPlayerEquipmentFkey
					GuiControlGet, new_player_prayer,, % UserInterface.PlayerManager.NewPlayer.NewPlayerPrayerFkey
					GuiControlGet, new_player_magic,, % UserInterface.PlayerManager.NewPlayer.NewPlayerMagicFkey
					GuiControlGet, new_player_cc,, % UserInterface.PlayerManager.NewPlayer.NewPlayerClanChatFkey
					GuiControlGet, new_player_fc,, % UserInterface.PlayerManager.NewPlayer.NewPlayerFriendListFkey
					GuiControlGet, new_player_accman,, % UserInterface.PlayerManager.NewPlayer.NewPlayerAccountManagementFkey
					GuiControlGet, new_player_logout,, % UserInterface.PlayerManager.NewPlayer.NewPlayerLogoutFkey
					GuiControlGet, new_player_options,, % UserInterface.PlayerManager.NewPlayer.NewPlayerOptionsFkey
					GuiControlGet, new_player_emotes,, % UserInterface.PlayerManager.NewPlayer.NewPlayerEmotesFkey
					GuiControlGet, new_player_music,, % UserInterface.PlayerManager.NewPlayer.NewPlayerMusicPlayerFkey

					new_player_login := Encryption.AES.Encrypt(new_player_login, AutoOS.PlayerManager.MasterPassword, 256)
					new_player_password := Encryption.AES.Encrypt(new_player_password, AutoOS.PlayerManager.MasterPassword, 256)
					new_player_pin_number := Encryption.AES.Encrypt(new_player_pin_number, AutoOS.PlayerManager.MasterPassword, 256)
					new_player_username := Encryption.AES.Encrypt(new_player_username, AutoOS.PlayerManager.MasterPassword, 256)
					
					AutoOS.PlayerManager.NewPlayer(new_player_client, new_player_login, new_player_password
												 , new_player_pin_number, new_player_username
												 , new_player_combat, new_player_skills
											  	 , new_player_quests, new_player_inventory
												 , new_player_equipment, new_player_prayer
												 , new_player_magic, new_player_cc
												 , new_player_fc, new_player_accman
												 , new_player_logout, new_player_options
												 , new_player_emotes, new_player_music)
					Gui, NewPlayer: Destroy
					UserInterface.PlayerManager.Viewer.State(true)
				return
				
				CancelNewPlayer:
					Gui, NewPlayer: Destroy
					UserInterface.PlayerManager.Viewer.State(true)
				return
				
				
			}
			
		}
		
		Class Editor
		{
			
			Static Player, Client, Login, Password, PinNumber, Username
			Static CombatFkey, SkillsFkey, QuestsFkey, InventoryFkey, EquipmentFkey, PrayerFkey, MagicFkey
			Static ClanChatFkey, FriendListFkey, AccountManagementFkey, LogoutFkey, OptionsFkey, EmotesFkey, MusicPlayerFkey
			
			Load(player)
			{
				UserInterface.PlayerManager.Editor.Player := player
				Gui, PlayerManager: Hide
				Gui, PlayerEditor: New, Player Editor
				Gui, PlayerEditor: Add, Text, x10 y10, % "Client:"
				Gui, PlayerEditor: Add, Text, x82 y10, % "Email/Login:"
				Gui, PlayerEditor: Add, Text, x164 y10, % "Password:"
				Gui, PlayerEditor: Add, Text, x246 y10, % "Pin number:"
				Gui, PlayerEditor: Add, Text, x318 y10, % "Username:"
				Gui, PlayerEditor: Add, ComboBox, x10 y25 w70 HwndEditPlayerClient, RuneLite||Official
				Gui, PlayerEditor: Add, Edit, x82 y25 w80 r0.8 HwndEditPlayerLogin, Optional
				Gui, PlayerEditor: Add, Edit, x164 y25 w80 r0.8 HwndEditPlayerPassword, Optional
				Gui, PlayerEditor: Add, Edit, x246 y25 w70 r0.8 Number Limit4 HwndEditPlayerPinNumber, Optional
				Gui, PlayerEditor: Add, Edit, x318 y25 w80 r0.8 Limit13 HwndEditPlayerUsername, Optional

				Gui, PlayerEditor: Add, GroupBox, x5 y60 h110 w400, F-Keys
				Gui, PlayerEditor: Add, Text, x10 y80, % "Combat:"
				Gui, PlayerEditor: Add, Text, x65 y80, % "Skills:"
				Gui, PlayerEditor: Add, Text, x120 y80, % "Quests:"
				Gui, PlayerEditor: Add, Text, x175 y80, % "Inventory:"
				Gui, PlayerEditor: Add, Text, x230 y80, % "Equip:"
				Gui, PlayerEditor: Add, Text, x285 y80, % "Prayer:"
				Gui, PlayerEditor: Add, Text, x340 y80, % "Magic:"
				Gui, PlayerEditor: Add, ComboBox, x10 y95 w50 HwndEditPlayerCombatFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x65 y95 w50 HwndEditPlayerSkillsFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x120 y95 w50 HwndEditPlayerQuestsFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x175 y95 w50 HwndEditPlayerInventoryFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x230 y95 w50 HwndEditPlayerEquipmentFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x285 y95 w50 HwndEditPlayerPrayerFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x340 y95 w50 HwndEditPlayerMagicFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, Text, x10 y120, % "Clan chat:"
				Gui, PlayerEditor: Add, Text, x65 y120, % "Friends:"
				Gui, PlayerEditor: Add, Text, x120 y120, % "Acc.Man.:"
				Gui, PlayerEditor: Add, Text, x175 y120, % "Logout:"
				Gui, PlayerEditor: Add, Text, x230 y120, % "Options:"
				Gui, PlayerEditor: Add, Text, x285 y120, % "Emotes:"
				Gui, PlayerEditor: Add, Text, x340 y120, % "Music:"
				Gui, PlayerEditor: Add, ComboBox, x10 y135 w50 HwndEditPlayerClanChatFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x65 y135 w50 HwndEditPlayerFriendListFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x120 y135 w50 HwndEditPlayerAccountManagementFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x175 y135 w50 HwndEditPlayerLogoutFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x230 y135 w50 HwndEditPlayerOptionsFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x285 y135 w50 HwndEditPlayerEmotesFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x340 y135 w50 HwndEditPlayerMusicPlayerFkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				
				Gui, PlayerEditor: Add, Button, x125 y180 w50 gSaveEditPlayer, Save
				Gui, PlayerEditor: Add, Button, x225 y180 w50 gCancelEditPlayer, Cancel
				
				
				AutoOS.PlayerManager.GetPlayer(player)
				If (masterpass := AutoOS.PlayerManager.MasterPassword)
					AutoOS.PlayerManager.GetPlayerSensitiveData(player, masterpass)
				
				GuiControl, Text, % EditPlayerClient, % AutoOS.PlayerManager.Client
				GuiControl, Text, % EditPlayerLogin, % AutoOS.PlayerManager.Login
				GuiControl, Text, % EditPlayerPassword, % AutoOS.PlayerManager.Password
				GuiControl, Text, % EditPlayerPinNumber, % AutoOS.PlayerManager.PinNumber
				GuiControl, Text, % EditPlayerUsername, % AutoOS.PlayerManager.Username

				GuiControl, Text, % EditPlayerCombatFKey, % AutoOS.PlayerManager.CombatFKey
				GuiControl, Text, % EditPlayerSkillsFKey, % AutoOS.PlayerManager.SkillsFKey
				GuiControl, Text, % EditPlayerQuestsFKey, % AutoOS.PlayerManager.QuestsFKey
				GuiControl, Text, % EditPlayerInventoryFKey, % AutoOS.PlayerManager.InventoryFKey
				GuiControl, Text, % EditPlayerEquipmentFKey, % AutoOS.PlayerManager.EquipmentFKey
				GuiControl, Text, % EditPlayerPrayerFKey, % AutoOS.PlayerManager.PrayerFKey
				GuiControl, Text, % EditPlayerMagicFKey, % AutoOS.PlayerManager.MagicFKey

				GuiControl, Text, % EditPlayerClanChatFKey, % AutoOS.PlayerManager.ClanChatFKey
				GuiControl, Text, % EditPlayerFriendListFKey, % AutoOS.PlayerManager.FriendListFKey
				GuiControl, Text, % EditPlayerAccountManagementFKey, % AutoOS.PlayerManager.AccountManagementFKey
				GuiControl, Text, % EditPlayerLogoutFKey, % AutoOS.PlayerManager.LogoutFKey
				GuiControl, Text, % EditPlayerOptionsFKey, % AutoOS.PlayerManager.OptionsFKey
				GuiControl, Text, % EditPlayerEmotesFKey, % AutoOS.PlayerManager.EmotesFKey
				GuiControl, Text, % EditPlayerMusicPlayerFKey, % AutoOS.PlayerManager.MusicPlayerFKey
				
				Gui, PlayerEditor: Show
				
				UserInterface.PlayerManager.Editor.Client := EditPlayerClient
				UserInterface.PlayerManager.Editor.Login := EditPlayerLogin
				UserInterface.PlayerManager.Editor.Password := EditPlayerPassword
				UserInterface.PlayerManager.Editor.PinNumber := EditPlayerPinNumber
				UserInterface.PlayerManager.Editor.Username := EditPlayerUsername
				UserInterface.PlayerManager.Editor.CombatFkey := EditPlayerCombatFkey
				UserInterface.PlayerManager.Editor.SkillsFkey := EditPlayerSkillsFkey
				UserInterface.PlayerManager.Editor.QuestsFkey := EditPlayerQuestsFkey
				UserInterface.PlayerManager.Editor.InventoryFkey := EditPlayerInventoryFkey
				UserInterface.PlayerManager.Editor.EquipmentFkey := EditPlayerEquipmentFkey
				UserInterface.PlayerManager.Editor.PrayerFkey := EditPlayerPrayerFkey
				UserInterface.PlayerManager.Editor.MagicFkey := EditPlayerMagicFkey
				UserInterface.PlayerManager.Editor.ClanChatFkey := EditPlayerClanChatFkey
				UserInterface.PlayerManager.Editor.FriendListFkey := EditPlayerFriendListFkey
				UserInterface.PlayerManager.Editor.AccountManagementFkey := EditPlayerAccountManagementFkey
				UserInterface.PlayerManager.Editor.LogoutFkey := EditPlayerLogoutFkey
				UserInterface.PlayerManager.Editor.OptionsFkey := EditPlayerOptionsFkey
				UserInterface.PlayerManager.Editor.EmotesFkey := EditPlayerEmotesFkey
				UserInterface.PlayerManager.Editor.MusicPlayerFkey := EditPlayerMusicPlayerFkey
				return
				
				SaveEditPlayer: ;NEED TO FIX THIS just copy pasted this from New player GUI
					GuiControlGet, edit_player_client,, % UserInterface.PlayerManager.Editor.Client
					GuiControlGet, edit_player_login,, % UserInterface.PlayerManager.Editor.Login
					GuiControlGet, edit_player_password,, % UserInterface.PlayerManager.Editor.Password
					GuiControlGet, edit_player_pin_number,, % UserInterface.PlayerManager.Editor.PinNumber
					GuiControlGet, edit_player_username,, % UserInterface.PlayerManager.Editor.Username
					GuiControlGet, edit_player_combat,, % UserInterface.PlayerManager.Editor.CombatFkey
					GuiControlGet, edit_player_skills,, % UserInterface.PlayerManager.Editor.SkillsFkey
					GuiControlGet, edit_player_quests,, % UserInterface.PlayerManager.Editor.QuestsFkey
					GuiControlGet, edit_player_inventory,, % UserInterface.PlayerManager.Editor.InventoryFkey
					GuiControlGet, edit_player_equipment,, % UserInterface.PlayerManager.Editor.EquipmentFkey
					GuiControlGet, edit_player_prayer,, % UserInterface.PlayerManager.Editor.PrayerFkey
					GuiControlGet, edit_player_magic,, % UserInterface.PlayerManager.Editor.MagicFkey
					GuiControlGet, edit_player_cc,, % UserInterface.PlayerManager.Editor.ClanChatFkey
					GuiControlGet, edit_player_fc,, % UserInterface.PlayerManager.Editor.FriendListFkey
					GuiControlGet, edit_player_accman,, % UserInterface.PlayerManager.Editor.AccountManagementFkey
					GuiControlGet, edit_player_logout,, % UserInterface.PlayerManager.Editor.LogoutFkey
					GuiControlGet, edit_player_options,, % UserInterface.PlayerManager.Editor.OptionsFkey
					GuiControlGet, edit_player_emotes,, % UserInterface.PlayerManager.Editor.EmotesFkey
					GuiControlGet, edit_player_music,, % UserInterface.PlayerManager.Editor.MusicPlayerFkey

					edit_player_login := Encryption.AES.Encrypt(edit_player_login, AutoOS.PlayerManager.MasterPassword, 256)
					edit_player_password := Encryption.AES.Encrypt(edit_player_password, AutoOS.PlayerManager.MasterPassword, 256)
					edit_player_pin_number := Encryption.AES.Encrypt(edit_player_pin_number, AutoOS.PlayerManager.MasterPassword, 256)
					edit_player_username := Encryption.AES.Encrypt(edit_player_username, AutoOS.PlayerManager.MasterPassword, 256)
					
					AutoOS.PlayerManager.EditPlayer(UserInterface.PlayerManager.Editor.Player, edit_player_client, edit_player_login, edit_player_password
												 , edit_player_pin_number, edit_player_username
												 , edit_player_combat, edit_player_skills
											  	 , edit_player_quests, edit_player_inventory
												 , edit_player_equipment, edit_player_prayer
												 , edit_player_magic, edit_player_cc
												 , edit_player_fc, edit_player_accman
												 , edit_player_logout, edit_player_options
												 , edit_player_emotes, edit_player_music)
												 
					Gui, PlayerEditor: Destroy
					UserInterface.PlayerManager.Editor.Player := ""
					UserInterface.PlayerManager.Viewer.State(true)
					
				return
				
				CancelEditPlayer:
					Gui, PlayerEditor: Destroy
					UserInterface.PlayerManager.Viewer.State(true)
				return
				
				
			}
			
		}
		
		Class Viewer
		{
			State(state)
			{
				If state
				{
					UserInterface.PlayerManager.Viewer.UpdatePlayersData()
					Gui, PlayerManager: Show
				}
				Else if !state
					Gui, PlayerManager: Hide
			}
			
			Load()
			{
				list_view_options := "y10 w600 -LV0x10 -Multi NoSortHdr"
				list_view_header := "Client|Email/Login|Password|Pin|Username|"
								  . "Combat|Skills|Quests|Inventory|Equipment|Prayer|Magic|"
								  . "Clan chat|Friend list|Acc. Management|Logout|Options|Emotes|Music"

				Gui, PlayerManager: New, Player Manager
				Gui, PlayerManager: Add, ListView, % list_view_options, % list_view_header
				LV_ModIfyCol(AutoHdr)
				LV_ModIfyCol(1, 75)
				LV_ModIfyCol(2, 75)
				LV_ModIfyCol(3, 120)
				LV_ModIfyCol(4, 75)
				LV_ModIfyCol(5, 40)
				UserInterface.PlayerManager.Viewer.UpdatePlayersData()
				Gui, PlayerManager: Add, Button, gSelectPlayer y+10, Continue
				Gui, PlayerManager: Add, Button, gAddPlayer x+20, Add Player
				Gui, PlayerManager: Add, Button, gEditPlayer x+10, Edit Player
				Gui, PlayerManager: Add, Button, gDeletePlayer x+10, Delete Player
				return
				
				SelectPlayer:
					UserInterface.PlayerManager.Viewer.State(false)
					player := LV_GetNext()
					AutoOS.PlayerManager.GetPlayer(player)
					If AutoOS.PlayerManager.MasterPassword
						AutoOS.PlayerManager.GetPlayerSensitiveData(player, AutoOS.PlayerManager.MasterPassword)
				return
				AddPlayer:
					UserInterface.PlayerManager.NewPlayer.Load()
				return
				EditPlayer:
					UserInterface.PlayerManager.Editor.Load(LV_GetNext())
				return
				DeletePlayer:
					Gui, PlayerManager: Default
					AutoOS.PlayerManager.DeletePlayer(LV_GetNext())
					UserInterface.PlayerManager.Viewer.UpdatePlayersData()
				return
				
			}
			
			UpdatePlayersData()
			{
				player_count := 1
				If FileExist("account.ini")
					player_count := Text.CountIniSections("account.ini")
				Else
					return
				Gui, PlayerManager: Default
				LV_Delete()
				Loop % player_count
				{
					AutoOS.PlayerManager.GetPlayer(A_Index)
					If AutoOS.PlayerManager.MasterPassword
						AutoOS.PlayerManager.GetPlayerSensitiveData(A_Index, AutoOS.PlayerManager.MasterPassword)
					LV_Add(, AutoOS.PlayerManager.Client, AutoOS.PlayerManager.Login, AutoOS.PlayerManager.Password
						   , AutoOS.PlayerManager.PinNumber, AutoOS.PlayerManager.Username, AutoOS.PlayerManager.CombatFKey
						   , AutoOS.PlayerManager.SkillsFKey, AutoOS.PlayerManager.QuestsFKey, AutoOS.PlayerManager.InventoryFKey
						   , AutoOS.PlayerManager.EquipmentFKey, AutoOS.PlayerManager.PrayerFKey, AutoOS.PlayerManager.MagicFKey
						   , AutoOS.PlayerManager.ClanChatFKey, AutoOS.PlayerManager.FriendListFKey, AutoOS.PlayerManager.AccountManagementFKey
						   , AutoOS.PlayerManager.LogoutFKey, AutoOS.PlayerManager.OptionsFKey, AutoOS.PlayerManager.EmotesFKey
						   , AutoOS.PlayerManager.MusicPlayerFKey)
				}
				LV_Modify(1, "Select")
				return
			}
		
		}
	
	}

	Class MainGUI
	{
		Load()
		{
			player_count := Text.CountIniSections("account.ini")
			main_gui_width := Math.DPIScale((AutoOS.Client.Coordinates[3] - AutoOS.Client.Coordinates[1]), "descale")
			main_gui_height := Math.DPIScale((A_ScreenHeight - AutoOS.Client.Coordinates[4] - 100), "descale")
			
			Gui, MainGUI: New,, AutoOS
			Gui, MainGUI: Add, Text,, Select Player:
			Loop % player_count
				player_list := "Player" . A_Index
			Gui, MainGUI: Add, DropDownList,, % player_list
			Gui, MainGUI: Add, Edit, r1 w500 -VScroll -border, TestESRWRRASD`n`rasdasd`n`rasdasd`n`rasdasd`n`rasdasd
			
			
			
			Gui, MainGUI: -border AlwaysOnTop
			;Gui, MainGUI: Margin, X0 Y0
			x := AutoOS.Client.Coordinates[1]
			y := AutoOS.Client.Coordinates[4]
			
			Gui, MainGUI: Show, X%x% Y%y% W%main_gui_width% H%main_gui_height%
			return
		}
	}



}


Class Debug
{
	Static LogFile := ""
	
	Benchmark(loops)	; Speed benchmark. 
	{
		starting_tick := A_TickCount
		
		Loop % loops
		{
			Tooltip % AutoOS.Core.GameTab.GetActiveFast2() ; Add funcion or label here.
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
	
	AddLine(line)
	{
		If !Debug.LogFile
			Debug.CreateLog()
		FormatTime, TIME_STAMP,, [dd-MM-yyyy HH:mm:ss]:
		FileAppend, % TIME_STAMP . " " . line . "`r`n",  % Debug.LogFile
	}
	
	
}

Class Input	; Core Class of our input
{	; TODO: Need to add a client check before every input I think, so we don't send input to the wrong place and mess the bot.
	
	Static AsyncMouse, AsyncKeyboard
	
	SendAsyncInput(ByRef StringToSend, ByRef TargetScriptTitle)
	{
		VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  ; Set up the structure's memory area.
		; First set the structure's cbData member to the size of the string, including its zero terminator:
		SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
		NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; OS requires that this be done.
		NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself.
		Prev_DetectHiddenWindows := A_DetectHiddenWindows
		Prev_TitleMatchMode := A_TitleMatchMode
		DetectHiddenWindows On
		SetTitleMatchMode 2
		TimeOutTime := 1  ; I set this to 0 so it doesn't hang waiting for a response... I don't like having a confirmation though
		SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%,,,, %TimeOutTime% ; 0x4a is WM_COPYDATA.
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
			;MsgBox % box[1]
			MouseMove, box[1], box[2], Math.Random(AutoOS.PlayerManager.MouseSlowSpeed, AutoOS.PlayerManager.MouseFastSpeed)
			If (action != "move")
				MouseClick, % action
		}
				
		Mid(x, y, w, h, action := "move")
		{
			mid := Math.GetPoint.Mid(x, y, w, h)
			MouseMove, mid[1], mid[2], Math.Random(AutoOS.PlayerManager.MouseSlowSpeed, AutoOS.PlayerManager.MouseFastSpeed)
			If (action != "move")
				MouseClick, % action
		}
		
		Circle(x, y, radius, action := "move")
		{
			circle := Math.GetPoint.Circle(x, y, radius)
			MouseMove, circle[1], circle[2], Math.Random(AutoOS.PlayerManager.MouseSlowSpeed, AutoOS.PlayerManager.MouseFastSpeed)
			If (action != "move")
				MouseClick, % action
		}
		
		CwBox(x, y, w, h, action := "move") ; CwBox := Circle within box
		{
			cwb := Math.GetPoint.CwBox(x, y, w, h)
			MouseMove, cwb[1], cwb[2], Math.Random(AutoOS.PlayerManager.MouseSlowSpeed, AutoOS.PlayerManager.MouseFastSpeed)
			If (action != "move")
				MouseClick, % action
		}
		
		HumanCoordinates(x, y, w, h, action := "move")
		{
			coord := Math.GetPoint.HumanCoordinates(x, y, w, h)
			MouseMove, coord[1], coord[2], Math.Random(AutoOS.PlayerManager.MouseSlowSpeed, AutoOS.PlayerManager.MouseFastSpeed)
			If (action != "move")
				MouseClick, % action
		}

		; MasterFocus's RandomBezier function.
		; Source at: https://github.com/MasterFocus/AutoHotkey/tree/master/Functions/RandomBezier
		; Slightly modIfied and simplIfied for my use... Would like to completely redo this later on as it's not very clear IMO.
		RandomBezier(X0, Y0, Xf, Yf, action := "move", p1 := 2, p2 := 5, speed1 := 3, speed2 := 8)
		{	
			x_distance := X0 - Xf
			y_distance := Y0 - Yf

			; speed1 and speed2 are mousespeeds. Like the ones we have with MouseMove, X, Y, *Speed*
			; Did some benchmarks with A_TickCount to figure more or less how do the mouse speed numbers translate to miliseconds.
			; This formula depending on the distance is what I came up with.
			speed_modIfier := Round(Math.GetLowest(Math.MakePositive(x_distance), Math.MakePositive(y_distance)) / 3.5)
			time := Math.Random((speed2 * speed_modIfier), (speed1 * speed_modIfier))
			N := Math.Random(p, p2)
			
			If (N > 20)
				N := 19
			Else if (N < 2)
				N := 2
			
			
			
			If (Math.Between(x_distance, -50, 50) or Math.Between(y_distance, -50, 50))	; If the distance is short, doesn't make sense having the
				N := 2																						; mouse doing crazy curves.
	
	
			OfT := 100, OfB := 100
			OfL := 100, OfR := 100
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
			MouseMove, X%N%, Y%N%, 0
			If (action != "move")
				MouseClick, % action,
			return N+1
		}
	
	}
	
	Class Keyboard ; Basic Keyboard functionality
	{
		PressKey(key, time := 30)
		{
			Send, {%key% Down}
			Sleep, time
			Send, {%key% Up}
		}
		
		MultiKeyPress(key1, key2, key3 := "", key4 := "", key5 := "", time := 30)
		{
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
				MouseGetPos, current_x, current_y
				Input.Mouse.RandomBezier(current_x, current_y, box[1], box[2], action, AutoOS.PlayerManager.MouseFastSpeed, AutoOS.PlayerManager.MouseSlowSpeed)
			}
		
			Mid(x, y, w, h, action := "move")
			{
				mid := Math.GetPoint.Mid(x, y, w, h)
				MouseGetPos, current_x, current_y
				Input.Mouse.RandomBezier(current_x, current_y, mid[1], mid[2], action, AutoOS.PlayerManager.MouseFastSpeed, AutoOS.PlayerManager.MouseSlowSpeed)
			}
			
			Circle(x, y, radius, action := "move")
			{
				circle := Math.GetPoint.Circle(x, y, radius)
				MouseGetPos, current_x, current_y
				Input.Mouse.RandomBezier(current_x, current_y, circle[1], circle[2], action, AutoOS.PlayerManager.MouseFastSpeed, AutoOS.PlayerManager.MouseSlowSpeed)
			}
			
			CwBox(x, y, w, h, action := "move") ; CwBox := Circle within box
			{
				cwb := Math.GetPoint.CwBox(x, y, w, h)
				MouseGetPos, current_x, current_y
				Input.Mouse.RandomBezier(current_x, current_y, cwb[1], cwb[2], action, AutoOS.PlayerManager.MouseFastSpeed, AutoOS.PlayerManager.MouseSlowSpeed)
			}
			
			HumanCoordinates(x, y, w, h, action := "move")
			{
				coord := Math.GetPoint.HumanCoordinates(x, y, w, h)
				MouseGetPos, current_x, current_y
				Input.Mouse.RandomBezier(current_x, current_y, coord[1], coord[2], action, AutoOS.PlayerManager.MouseFastSpeed, AutoOS.PlayerManager.MouseSlowSpeed)
			}

		}
	
		Class Keyboard ; Uses the keyboard in a more human convincing way.
		{
			PressKey(key, time := 30)	; This function mimics the auto-repeat feature most keyboards have.
			{
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
				return % Round(n * 1.25)
			Else if (A_ScreenDPI == 144)
				return % Round(n * 1.5)
			Else if (A_ScreenDPI == 168)
				return % Round(n * 1.75)
			Else if (A_ScreenDPI == 192)
				return % n * 2
		}
		Else if (operation == "descale")
		{
			If (A_ScreenDPI == 96)
				return % n
			Else if (A_ScreenDPI == 120)
				return % Round(n / 1.25)
			Else if (A_ScreenDPI == 144)
				return % Round(n / 1.5)
			Else if (A_ScreenDPI == 168)
				return % Round(n / 1.75)
			Else if (A_ScreenDPI == 192)
				return % Round(n / 2)
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
		HumanCoordinates(x, y, w, h)
		{
			Random, probability, 0, 99
			If (probability <= 49)
			{
				x_circle := Round(x + ((w - x) * 0.2))	; 50% probability the coordinates will be in the "eye" of the box.
				w_circle := Round(w + ((x - w) * 0.2))
				y_circle := Round(y + ((h - y) * 0.2))
				h_circle := Round(h + ((y - h) * 0.2))
			}
			Else if (probability <= 84)
			{
				x_circle := Round(x + ((w - x) * 0.35))	; 35% probability the coordinates will be in the inner circle inside of the box.
				w_circle := Round(w + ((x - w) * 0.35))	; This includes the "eye" above, so in reality the probability of having the coordinates closer to the center
				y_circle := Round(y + ((h - y) * 0.35))	; is higher than 50%.
				h_circle := Round(h + ((y - h) * 0.35))
			}
			Else if (probability >= 85)
			{
				x_circle := Round(x + ((w - x) * 0.45))	; 15% probability the coordinates will be in the outter parts of the circle inside of the box.
				w_circle := Round(w + ((x - w) * 0.45))	; This includes the "eye" and the inner circle above, so in reality the probability of having
				y_circle := Round(y + ((h - y) * 0.45))	; the coordinates closer to the center is higher than 50% for the "eye" and 35% for the inner circle.
				h_circle := Round(h + ((y - h) * 0.45))
			}
			return Math.GetPoint.CwBox(x_circle, y_circle, w_circle, h_circle)
		}

	}
	
	
}

Class Color
{
	
	Class Pixel
	{
		InBox(color_id, box, tolerance := 0)
		{
			PixelSearch, output_x, output_y, box[1], box[2], box[3], box[4], color_id, tolerance, Fast RGB
			If ErrorLevel
				return false
			Else
				return true
		}
		
		CountInBox(color_id, box, tolerance := 0)	; returns the number of pixels found with specIfied color within a box
		{
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
		
		ShIft(x, y, t := 100, tolerance := 0)	; Checks If the pixel at coordinates x and y shIfted color in t time. NEED TESTING!
		{
			PixelGetColor, output1, x, y, RGB
			Sleep % t
			PixelGetColor, output2, x, y, RGB
			If (output1 != output2)
				return true
			Else if (output1 == output2)
				return false
		}
		
		InBoxes(color_id, box1, box2, tolerance := 0, min := 2, box3 := "", box4 := "")	; Checks If color_id is present in the specIfied boxes. If the number of present pixels
		{																				; is above the minimum threshold (min)
			If (!IsObject(box1) or !IsObject(Box2) or !IsObject(Box3) or !IsObject(Box4))
				return "Boxes must be objects with 4 x, y, w and h."
			
			pixel_counter := 0
			
			PixelSearch, output_x, output_y, box1[1], box1[2], box1[3], box1[4], color_id, tolerance, Fast RGB
			If !ErrorLevel
				++pixel_counter
			
			PixelSearch, output_x, output_y, box2[1], box2[2], box2[3], box2[4], color_id, tolerance, Fast RGB
			If !ErrorLevel
				++pixel_counter
			
			If Box3	; Checks If Box3 exists.
			{
				PixelSearch, output_x, output_y, box3[1], box3[2], box3[3], box3[4], color_id, tolerance, Fast RGB
				If !ErrorLevel
					++pixel_counter
			}
			
			If Box4	; Box4 can be inside Box3 check because Box4 won't exist If 3 doesn't.
			{
				PixelSearch, output_x, output_y, box4[1], box4[2], box4[3], box4[4], color_id, tolerance, Fast RGB
				If !ErrorLevel
					++pixel_counter
			}
		
			If (pixel_counter < min)
				return false
			Else
				return true
		}
		
		Gdip_PixelSearch(pBitmap, ARGB, x1, y1, x2, y2) ; This is slow as heck... but I'll leave it here anyway in case it's useful.
		{
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
			
			ShIft(Obj1, Obj2, Obj3 := "", Obj4 := "", t := 100, tolerance := 0, min := 2) ; Checks If the pixels at coordinates x and y shIfted color in t time. NEED TESTING!
			{
				shIft_counter := 0
				
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
					++shIft_counter
				If (pixel2_start != pixel2_final)
					++shIft_counter
				If (pixel3_start != pixel3_final)	; I think doesn't need a check If the object exist because If it doesn't both will be the same. NEED TESTING!
					++shIft_counter
				If (pixel4_start != pixel4_final)	; I think doesn't need a check If the object exist because If it doesn't both will be the same. NEED TESTING!
					++shIft_counter
				
				If (shIft_counter >= 2)
					return true
				Else
					return false
			}
			
		}
	
	}

	ARGBtoRGB(ARGB) ; Don't know who made this function as it's in several places but it's not mine. Credits go to the original creator.
	{
		VarSetCapacity( RGB,6,0 )
		DllCall( "msvcrt.dll\sprintf", Str,RGB, Str,"%06X", UInt,ARGB<<8 )
		Return "0x" RGB
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

OnExit()
{
	Gdip_Shutdown(pToken)
	Input.SendAsyncInput("Exit", "AsyncMouse.ahk ahk_Class AutoHotkey")
	Input.SendAsyncInput("Exit", "AsyncKeyboard.ahk ahk_Class AutoHotkey")
	ExitApp	
}