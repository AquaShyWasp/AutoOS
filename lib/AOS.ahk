﻿AOS_Start(player, async_input := true)
{
	AutoOS.Player := player
	AutoOS.PlayerManager.GetPlayer(player)
	Input.AsyncMouse := async_input, Input.AsyncKeyboard := async_input
	Run, "AutoHotkey.exe" "plugins/AsyncMouse.ahk" %player%
	Run, "AutoHotkey.exe" "plugins/AsyncKeyboard.ahk" %player%
	return
}

class AutoOS
{
	static Player := 1
	
	class PlayerManager
	{
		static MasterPassword := ""
		static Client := "RuneLite", Login, Password, PinNumber, Username := ""
		static CombatFKey, SkillsFKey, QuestsFKey, InventoryFKey, EquipmentFKey, PrayerFKey, MagicFKey := ""
		static ClanChatFKey, FriendListFKey, AccountManagementFKey, LogoutFKey, OptionsFKey, EmotesFKey, MusicPlayerFKey := ""
		static MouseSlowSpeed, MouseFastSpeed, FkeyProbability, InventoryPattern := ""
		
		NewPlayer(client, login, password, pin_number, user, combat_fkey, skills_fkey, quests_fkey, inventory_fkey, equipment_fkey, prayer_fkey, magic_fkey, clan_chat_fkey, friend_list_fkey, account_management_fkey, logout_fkey, options_fkey, emotes_fkey, music_player_fkey) ; Need to add default fkeys has optional parameters.
		{
			player_count := 1
			if FileExist("account.ini")
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
			if (PlayerMSpeed == 0) ; If 0 we get a fast player.
			{
				Random, fast, 2, 4
				Random, slow, 5, 7
			}
			else if (PlayerMSpeed == 1) ; If 1 we get a slower player.
			{
				Random, fast, 4, 5
				Random, slow, 6, 9
			}
			else if (PlayerMSpeed == 2) ; If 2 we get a player that moves fast sometimes, and slower other times.
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
		
		ClearPlayerSensitiveData()						; This should clear the player sensitive data from the variables and therefore,
		{												; from memory. The masterpass is still saved and I guess it could be extracted 
			AutoOS.PlayerManager.Login := ""			; from memory with the know how but this is the best I could come up with without
			AutoOS.PlayerManager.Password := ""			; making it troublesome to use. Either way, if someone got into your computer,
			AutoOS.PlayerManager.PinNumber := ""		; they will likely hack your account one way or another ¯\_(ツ)_/¯
			AutoOS.PlayerManager.Username := ""
		}
		
		DeletePlayer(n)
		{
			if !FileExist("account.ini")
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
	
	class Client
	{
		static ClientID := "", Coordinates := []
		
		BootstrapCoordinates()
		{
			if !WinExist("ahk_exe " . AutoOS.PlayerManager.Client ".exe")
			{
				MsgBox % "The client " . AutoOS.PlayerManager.Client . ".exe is not running."
				ExitApp
			}
			WinGet, ClientID, ID, % "ahk_exe " . AutoOS.PlayerManager.Client ".exe"
			ControlGetPos, control_x, control_y, control_w, control_h,  SunAwtCanvas2, % "ahk_exe " . AutoOS.PlayerManager.Client ".exe"
			
			AutoOS.Client.ClientID := ClientID
			AutoOS.Client.Coordinates := [control_x, control_y, control_w, control_h]
		}
		
	}
	
	class Coordinates	; This whole class is just a group of static variables for all the coordinates I could think of. The only 2 methods are used to convert 
	{					; Client coordinates to Screen coordinates.
		static GameScreen := AutoOS.Coordinates.ClientPosition(6, 5, 773, 505)
							
		static UpText := AutoOS.Coordinates.ClientPosition(6, 5, 300, 23)
						
		static GameTab1 := AutoOS.Coordinates.ClientPosition(522, 168, 559, 203)
		static GameTab2 := AutoOS.Coordinates.ClientPosition(560, 168, 592, 203)
		static GameTab3 := AutoOS.Coordinates.ClientPosition(593, 168, 625, 203)
		static GameTab4 := AutoOS.Coordinates.ClientPosition(626, 168, 658, 203)
		static GameTab5 := AutoOS.Coordinates.ClientPosition(659, 168, 691, 203)
		static GameTab6 := AutoOS.Coordinates.ClientPosition(692, 168, 724, 203)
		static GameTab7 := AutoOS.Coordinates.ClientPosition(725, 168, 762, 203)
		
		static GameTab8 := AutoOS.Coordinates.ClientPosition(522, 466, 559, 501)
		static GameTab9 := AutoOS.Coordinates.ClientPosition(560, 466, 592, 501)
		static GameTab10 := AutoOS.Coordinates.ClientPosition(593, 466, 625, 501)
		static GameTab11 := AutoOS.Coordinates.ClientPosition(626, 466, 658, 501)
		static GameTab12 := AutoOS.Coordinates.ClientPosition(659, 466, 691, 501)
		static GameTab13 := AutoOS.Coordinates.ClientPosition(692, 466, 724, 501)
		static GameTab14 := AutoOS.Coordinates.ClientPosition(725, 466, 762, 501)
		
		ClientPositionX(coordinate)	; Converts coordinates relative to the client to coordinates relative to the window on the X axis.
		{
			if AutoOS.Client.Coordinates[1] = ""
				AutoOS.Client.BootstrapCoordinates()
			return % (Math.DPIScale(coordinate) + AutoOS.Client.Coordinates[1])
		}
		
		ClientPositionY(coordinate)	; Converts coordinates relative to the client to coordinates relative to the window on the Y axis.
		{
			if AutoOS.Client.Coordinates[2] = ""
				AutoOS.Client.BootstrapCoordinates()
			return % Math.DPIScale(coordinate) + AutoOS.Client.Coordinates[2]
		}
		
		ClientPosition(x, y, w, h)	; Joins both methods above for an fast and easy to write/read way of converting coordinates.
		{
			return [AutoOS.Coordinates.ClientPositionX(x), AutoOS.Coordinates.ClientPositionY(y), AutoOS.Coordinates.ClientPositionX(w), AutoOS.Coordinates.ClientPositionY(h)]
		}
		
		class Minimap
		{
			static MidPoint := [AutoOS.Coordinates.ClientPositionX(643)	; Minimap center point.
							  , AutoOS.Coordinates.ClientPositionY(84)]
			
			static Radius := 70 ; Real radius is about 75 pixels but I think setting it up slightly smaller is probably better
			
			static Compass := AutoOS.Coordinates.ClientPosition(546, 6, 574, 34)
							
		}
		
		class StatOrbs
		{
			static Experience := AutoOS.Coordinates.ClientPosition(517, 21, 542, 47)
	
			; Health orb
			static Health := AutoOS.Coordinates.ClientPosition(544, 45, 567, 70)
			; Hitpoints number
			static Hitpoints := AutoOS.Coordinates.ClientPosition(520, 50, 540, 70)
				
			static QuickPray := AutoOS.Coordinates.ClientPosition(542, 80, 567, 105)
			static PrayPoints := AutoOS.Coordinates.ClientPosition(520, 85, 540, 105)
			
			static Energy := AutoOS.Coordinates.ClientPosition(553, 112, 578, 137)
			static EnergyPoints := AutoOS.Coordinates.ClientPosition(530, 120, 550, 135)
			
			static SpecialAttack := AutoOS.Coordinates.ClientPosition(575, 138, 600, 162)
			static SpecAttPoints := AutoOS.Coordinates.ClientPosition(551, 143, 574, 159)

		}
	
		class GameTab
		{
			
			class Combat	; TODO add staves.
			{
				static WeaponNCombat := AutoOS.Coordinates.ClientPosition(559, 208, 732, 246)
				static AttackStyle1 := AutoOS.Coordinates.ClientPosition(567, 250, 637, 296)
				static AttackStyle2 := AutoOS.Coordinates.ClientPosition(646, 250, 716, 296)
				static AttackStyle3 := AutoOS.Coordinates.ClientPosition(567, 304, 637, 350)
				static AttackStyle4 := AutoOS.Coordinates.ClientPosition(646, 304, 716, 350)
				static AutoRetaliate := AutoOS.Coordinates.ClientPosition(567, 358, 716, 401)
				static SpecAttackBar := AutoOS.Coordinates.ClientPosition(567, 409, 716, 434)
			}
		
			class Skills
			{
				static Skill1 := AutoOS.Coordinates.GameTab.Skills.GetSkill(1)
				static Skill2 := AutoOS.Coordinates.GameTab.Skills.GetSkill(2)
				static Skill3 := AutoOS.Coordinates.GameTab.Skills.GetSkill(3)
				
				static Skill4 := AutoOS.Coordinates.GameTab.Skills.GetSkill(4)
				static Skill5 := AutoOS.Coordinates.GameTab.Skills.GetSkill(5)
				static Skill6 := AutoOS.Coordinates.GameTab.Skills.GetSkill(6)
				
				static Skill7 := AutoOS.Coordinates.GameTab.Skills.GetSkill(7)
				static Skill8 := AutoOS.Coordinates.GameTab.Skills.GetSkill(8)
				static Skill9 := AutoOS.Coordinates.GameTab.Skills.GetSkill(9)
				
				static Skill10 := AutoOS.Coordinates.GameTab.Skills.GetSkill(10)
				static Skill11 := AutoOS.Coordinates.GameTab.Skills.GetSkill(11)
				static Skill12 := AutoOS.Coordinates.GameTab.Skills.GetSkill(12)
				
				static Skill13 := AutoOS.Coordinates.GameTab.Skills.GetSkill(13)
				static Skill14 := AutoOS.Coordinates.GameTab.Skills.GetSkill(14)
				static Skill15 := AutoOS.Coordinates.GameTab.Skills.GetSkill(15)
				
				static Skill16 := AutoOS.Coordinates.GameTab.Skills.GetSkill(16)
				static Skill17 := AutoOS.Coordinates.GameTab.Skills.GetSkill(17)
				static Skill18 := AutoOS.Coordinates.GameTab.Skills.GetSkill(18)
				
				static Skill19 := AutoOS.Coordinates.GameTab.Skills.GetSkill(19)
				static Skill20 := AutoOS.Coordinates.GameTab.Skills.GetSkill(20)
				static Skill21 := AutoOS.Coordinates.GameTab.Skills.GetSkill(21)
				
				static Skill22 := AutoOS.Coordinates.GameTab.Skills.GetSkill(22)
				static Skill23 := AutoOS.Coordinates.GameTab.Skills.GetSkill(23)
				static Skill24 := AutoOS.Coordinates.GameTab.Skills.GetSkill(24) ; Total level
								 
				GetSkill(n)	; For more info on what's going on on this function, check AutoOS.Coordinates.GameTab.Inventory.GetSlot()
				{
					
					if ((n >= 1) and (n <= 24))
						return AutoOS.Coordinates.ClientPosition((485 + (63 * ((n-(Floor(n/3)*3)) != 0 ? (n-(Floor(n/3)*3)) : 3))), (174 + (32 * Ceil(n/3)))
															    , (546 + (63 * ((n-(Floor(n/3)*3)) != 0 ? (n-(Floor(n/3)*3)) : 3))), (205 + (32 * Ceil(n/3))))
				}
				 
								 
								 
			}
		
			class Quests	; TODO
			{
				
			}
			
			class Inventory
			{				
				static Inventory := AutoOS.Coordinates.ClientPosition(563, 213, 720, 460)
				
				static Slot1 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(1)
				static Slot2 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(2)
				static Slot3 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(3)
				static Slot4 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(4)

				static Slot5 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(5)
				static Slot6 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(6)
				static Slot7 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(7)
				static Slot8 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(8)

				static Slot9 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(9)
				static Slot10 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(10)
				static Slot11 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(11)
				static Slot12 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(12)
				
				static Slot13 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(13)
				static Slot14 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(14)
				static Slot15 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(15)
				static Slot16 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(16)	

				static Slot17 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(17)
				static Slot18 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(18)
				static Slot19 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(19)
				static Slot20 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(20)

				static Slot21 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(21)
				static Slot22 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(22)
				static Slot23 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(23)
				static Slot24 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(24)

				static Slot25 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(25)
				static Slot26 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(26)
				static Slot27 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(27)
				static Slot28 := AutoOS.Coordinates.GameTab.Inventory.GetSlot(28)
						
				GetSlot(n)
				{
					/*	Alright this is hard to understand so I'm going to break it down as a comment.
						Even though I could leave it simplified as I have it in the comment, for the
						sake of performance I'll leave it the way it this way.
						
						First we need to get the row and column number of "n".
						
						row := Ceil(n/4)
						column := ((n-(Floor(n/4)*4)) != 0 ? (n-(Floor(n/4)*4)) : 4)
						
						Column is hard to understand but it pretty much means this:
													
						If (n-(Floor(n/4)*4)) != 0
							Column := (n-(Floor(n/4)*4))
						else
							Column := 4
						
						(n-(Floor(n/4)*4)) gives us 1, 2, 3 or 0 depending on the spell... That gives us the 3 first columns
						but when the slot is in the 4th column it gives us a 0 instead of a 4.
						So we use an else statement to get 4 when it gives us a 0.
						
						Now that we have a way to get both the rows and the columns we can just use simple math to get every slot:
						
						return [521 * (42 * column), 177 * (36 * row), 552 * (42 * column), 208 * (36 * row)]						
					*/
					
					if ((n >= 1) and (n <= 28))
						return AutoOS.Coordinates.ClientPosition((521 + (42 * ((n-(Floor(n/4)*4)) != 0 ? (n-(Floor(n/4)*4)) : 4))), (177 + (36 * Ceil(n/4)))
															    , (552 + (42 * ((n-(Floor(n/4)*4)) != 0 ? (n-(Floor(n/4)*4)) : 4))), (208 + (36 * Ceil(n/4))))
				}

			}
			
			class Equipment	; TODO
			{
				
			}
			
			class Prayer
			{
				static Pray1 := AutoOS.Coordinates.GameTab.Prayer.GetPray(1)				
				static Pray2 := AutoOS.Coordinates.GameTab.Prayer.GetPray(2)						
				static Pray3 := AutoOS.Coordinates.GameTab.Prayer.GetPray(3)								
				static Pray4 := AutoOS.Coordinates.GameTab.Prayer.GetPray(4)									
				static Pray5 := AutoOS.Coordinates.GameTab.Prayer.GetPray(5)			
				
				static Pray6 := AutoOS.Coordinates.GameTab.Prayer.GetPray(6)
				static Pray7 := AutoOS.Coordinates.GameTab.Prayer.GetPray(7)
				static Pray8 := AutoOS.Coordinates.GameTab.Prayer.GetPray(8)			
				static Pray9 := AutoOS.Coordinates.GameTab.Prayer.GetPray(9)			
				static Pray10 := AutoOS.Coordinates.GameTab.Prayer.GetPray(10)			
				
				static Pray11 := AutoOS.Coordinates.GameTab.Prayer.GetPray(11)
				static Pray12 := AutoOS.Coordinates.GameTab.Prayer.GetPray(12)			
				static Pray13 := AutoOS.Coordinates.GameTab.Prayer.GetPray(13)					
				static Pray14 := AutoOS.Coordinates.GameTab.Prayer.GetPray(14)
				static Pray15 := AutoOS.Coordinates.GameTab.Prayer.GetPray(15)			
						
				static Pray16 := AutoOS.Coordinates.GameTab.Prayer.GetPray(16)			
				static Pray17 := AutoOS.Coordinates.GameTab.Prayer.GetPray(17)
				static Pray18 := AutoOS.Coordinates.GameTab.Prayer.GetPray(18)
				static Pray19 := AutoOS.Coordinates.GameTab.Prayer.GetPray(19)
				static Pray20 := AutoOS.Coordinates.GameTab.Prayer.GetPray(20)
				
				static Pray21 := AutoOS.Coordinates.GameTab.Prayer.GetPray(21)
				static Pray22 := AutoOS.Coordinates.GameTab.Prayer.GetPray(22)
				static Pray23 := AutoOS.Coordinates.GameTab.Prayer.GetPray(23)		
				static Pray24 := AutoOS.Coordinates.GameTab.Prayer.GetPray(24)				
				static Pray25 := AutoOS.Coordinates.GameTab.Prayer.GetPray(25)
				
				static Pray26 := AutoOS.Coordinates.GameTab.Prayer.GetPray(26)
				static Pray27 := AutoOS.Coordinates.GameTab.Prayer.GetPray(27)
				static Pray28 := AutoOS.Coordinates.GameTab.Prayer.GetPray(28)
				static Pray29 := AutoOS.Coordinates.GameTab.Prayer.GetPray(29)
						 
				GetPray(n)	; For more info on what's going on on this function, check AutoOS.Coordinates.GameTab.Inventory.GetSlot()
				{
					if ((n >= 1) and (n <= 29))
						return AutoOS.Coordinates.ClientPosition((514 + (37 * ((n-(Floor(n/5)*5)) != 0 ? (n-(Floor(n/5)*5)) : 5))), (177 + (37 * Ceil(n/5)))
															    , (547 + (37 * ((n-(Floor(n/5)*5)) != 0 ? (n-(Floor(n/5)*5)) : 5))), (210 + (37 * Ceil(n/5))))
				}
				
			}
			
			class Magic
			{
				class Standard
				{
					static Spell1 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(1)
					static Spell2 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(2)
					static Spell3 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(3)
					static Spell4 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(4)
					static Spell5 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(5)
					static Spell6 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(6)
					static Spell7 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(7)
					 
					static Spell8 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(8)
					static Spell9 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(9)
					static Spell10 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(10)
					static Spell11 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(11)
					static Spell12 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(12)
					static Spell13 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(13)
					static Spell14 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(14)
					 
					static Spell15 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(15)
					static Spell16 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(16)
					static Spell17 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(17)
					static Spell18 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(18)
					static Spell19 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(19)
					static Spell20 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(20)
					static Spell21 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(21)
					 
					static Spell22 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(22)
					static Spell23 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(23)
					static Spell24 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(24)
					static Spell25 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(25)
					static Spell26 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(26)
					static Spell27 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(27)
					static Spell28 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(28)
					 
					static Spell29 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(29)
					static Spell30 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(30)
					static Spell31 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(31)
					static Spell32 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(32)
					static Spell33 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(33)
					static Spell34 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(34)
					static Spell35 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(35)
					 
					static Spell36 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(36)
					static Spell37 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(37)
					static Spell38 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(38)
					static Spell39 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(39)
					static Spell40 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(40)
					static Spell41 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(41)
					static Spell42 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(42)
					 
					static Spell43 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(43)
					static Spell44 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(44)
					static Spell45 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(45)
					static Spell46 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(46)
					static Spell47 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(47)
					static Spell48 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(48)
					static Spell49 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(49)
					 
					static Spell50 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(50)
					static Spell51 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(51)
					static Spell52 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(52)
					static Spell53 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(53)
					static Spell54 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(54)
					static Spell55 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(55)
					static Spell56 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(56)
					 
					static Spell57 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(57)
					static Spell58 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(58)
					static Spell59 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(59)
					static Spell60 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(60)
					static Spell61 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(61)
					static Spell62 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(62)
					static Spell63 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(63)
				
					static Spell64 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(64)
					static Spell65 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(65)
					static Spell66 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(66)
					static Spell67 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(67)
					static Spell68 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(68)
					static Spell69 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(69)
					static Spell70 := AutoOS.Coordinates.GameTab.Magic.Standard.GetSpell(70)

					GetSpell(n)	; For more info on what's going on on this function, check AutoOS.Coordinates.GameTab.Inventory.GetSlot()
					{
						if ((n >= 1) and (n <= 70))
							return AutoOS.Coordinates.ClientPosition((526 + (26 * ((n-(Floor(n/7)*7)) != 0 ? (n-(Floor(n/7)*7)) : 7))), (181 + (24 * Ceil(n/7)))
																   , (549 + (26 * ((n-(Floor(n/7)*7)) != 0 ? (n-(Floor(n/7)*7)) : 7))), (204 + (24 * Ceil(n/7))))
					}
	
				}

				class Ancient	; TODO
				{
					
				}

				class Lunar	; TODO
				{
					
				}

				class Arceuus	; TODO
				{
					
				}
								
			}
		
			class ClanChat	; TODO
			{
				
			}
			
			class FriendList	; TODO
			{
				
			}
			
			class AccountManagement	; TODO
			{
				
			}
			
			class Logout	; TODO
			{
				static WorldSwitcherButton := AutoOS.Coordinates.ClientPosition(570, 366, 713, 401)
				static LogoutButton := AutoOS.Coordinates.ClientPosition(570, 414, 713, 449)
									  
				class WorldSwitcher	; TODO
				{
					
				}
				
			}
			
			class Options	; TODO
			{
				static Display := AutoOS.Coordinates.ClientPosition(553, 206, 592, 245)
				static Audio := AutoOS.Coordinates.ClientPosition(599, 206, 638, 245)
				static Chat := AutoOS.Coordinates.ClientPosition(645, 206, 684, 245)
				static Controls := AutoOS.Coordinates.ClientPosition(691, 206, 730, 245)
					
				static ZoomIcon := AutoOS.Coordinates.ClientPosition(558, 256, 589, 287)
				static ZoomBar := AutoOS.Coordinates.ClientPosition(601, 265, 712, 280)
				
				static BrightnessIcon := AutoOS.Coordinates.ClientPosition(558, 290, 589, 321)
				static BrightnessBar := AutoOS.Coordinates.ClientPosition(593, 299, 720, 314)
				
				static FixedClient := AutoOS.Coordinates.ClientPosition(572, 325, 633, 378)
				static ScaleableClient := AutoOS.Coordinates.ClientPosition(650, 325, 711, 378)
				
				static AdvancedOptions := AutoOS.Coordinates.ClientPosition(572, 382, 711, 411)
				
				static AcceptAid := AutoOS.Coordinates.ClientPosition(553, 425, 592, 464)
				static RunButton := AutoOS.Coordinates.ClientPosition(599, 425, 638, 464)
				static HouseOptions := AutoOS.Coordinates.ClientPosition(645, 425, 684, 464)
				static BondPouch := AutoOS.Coordinates.ClientPosition(691, 425, 730, 464)
				
				class POH	; TODO
				{
					static Title := AutoOS.Coordinates.ClientPosition(589, 204, 691, 224)
					static Close := AutoOS.Coordinates.ClientPosition(710, 212, 735, 234)
					static Viewer := AutoOS.Coordinates.ClientPosition(557, 230, 661, 269)
					static BuildModeOn := AutoOS.Coordinates.ClientPosition(685, 273, 701, 289)
					static BuildModeOff := AutoOS.Coordinates.ClientPosition(710, 273, 726, 289)
					static TeleportInsideOn := AutoOS.Coordinates.ClientPosition(685, 293, 701, 309)
					static TeleportInsideOff := AutoOS.Coordinates.ClientPosition(710, 293, 726, 309)
					
					static DoorsClosed := AutoOS.Coordinates.ClientPosition(617, 318, 633, 334)
					static DoorsOpen := AutoOS.Coordinates.ClientPosition(665, 318, 681, 334)
					static DoorsOff := AutoOS.Coordinates.ClientPosition(712, 318, 728, 334)
					
					static ExpellGuests := AutoOS.Coordinates.ClientPosition(557, 340, 726, 374)
					static LeaveHouse := AutoOS.Coordinates.ClientPosition(557, 375, 726, 409)
					static CallServant := AutoOS.Coordinates.ClientPosition(557, 410, 726, 445)
				}
				
			}
		
			class Emotes	; TODO
			{
				
			}
		
			class MusicPlayer	; TODO
			{
				
			}
			
			
			GetTab(tab)	; Need to find a better way to get the tabs...
			{
				; Until I figure a way to call variables inside a class dynamically I need this... 
				; What I mean is... If I want to get the coordinates of a tab number I have stored in %var%. I can't call it
				; by with AutoOS.Coordinates.GameTab%var%... It throws an error because of the dot. I've tried several way nothing worked.
				; If anyone knows how to do it please tell me, thanks in advance!
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
		}
	
		class Chat
		{
			static ChatBox := AutoOS.Coordinates.ClientPosition(0, 338, 477, 520)
			static Scroll := AutoOS.Coordinates.ClientPosition(497, 343, 511, 455)
			static UserInput := AutoOS.Coordinates.ClientPosition(7, 455, 511, 473)
			static UITitle := AutoOS.Coordinates.ClientPosition(13, 355, 507, 374) ; I don't remember what's this lol.... need to check and probably name it better.
			
			static Option1 := AutoOS.Coordinates.ClientPosition(5, 480, 60, 501)
			static Option2 := AutoOS.Coordinates.ClientPosition(71, 480, 126, 501)
			static Option3 := AutoOS.Coordinates.ClientPosition(137, 480, 192, 501)
			static Option4 := AutoOS.Coordinates.ClientPosition(203, 480, 258, 501)
			static Option5 := AutoOS.Coordinates.ClientPosition(269, 480, 324, 501)
			static Option6 := AutoOS.Coordinates.ClientPosition(335, 480, 390, 501)
			static Option7 := AutoOS.Coordinates.ClientPosition(403, 480, 513, 501)
			
		}
	
	
	}
	
	class Core	; TODO
	{
		class GameTab	; TODO
		{
			IsActive(tab)
			{
				if Color.Multi.Pixel.InBox(AutoOS.Coordinates.GameTab.GetTab(tab), 0x75281e, 0x3b140f, 2, 5, 0x441812)
					return true
				else if ((tab == 4) and !AutoOS.Core.GameTab.GetActiveRow())	; If tab is inventory and no tab is active, we probably are at bank or shop.
					return true
				else
					return false
			}
			
			GetActive()	; This was my last attempt and the best attempt at this. This only uses pixel search a maximum
			{			; of 6 times and uses math to figure out which tab is active. Benchmarks were over 200 times faster sometimes than the other methods.
						; And I think this is the definitive best way to do it. Though if you can make it faster, I'll be happy to know how :)
				row := AutoOS.Core.GameTab.GetActiveRow()

				Loop, 14
				{
					if (Math.InBox(row[1], row[2], AutoOS.Coordinates.GameTab.GetTab(A_Index)) == true)
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
				if (row == "top")
				{
					Loop, 7
					{
						if (AutoOS.Core.GameTab.IsActive(A_Index) == true)
						{
							Debug.AddLine("Active Gametab is: " . A_Index)
							return A_Index
						}
					}
				}
				
				else if (row == "bottom")
				{
					Loop, 7
					{
						if (AutoOS.Core.GameTab.IsActive(A_Index+7) == true)
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
					if (AutoOS.Core.GameTab.IsActive(A_Index) == true)
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
				if (top_row := Color.Multi.Pixel.InBox([AutoOS.Coordinates.GameTab.GetTab(1)[1], AutoOS.Coordinates.GameTab.GetTab(1)[2]	; Checks for red
											  , AutoOS.Coordinates.GameTab.GetTab(7)[3], AutoOS.Coordinates.GameTab.GetTab(7)[4]], 0x75281e, 0x3b140f, 2, 5, 0x441812))
					return top_row
				else if (bottom_row := Color.Multi.Pixel.InBox([AutoOS.Coordinates.GameTab.GetTab(8)[1], AutoOS.Coordinates.GameTab.GetTab(8)[2] ; Checks for red
											   , AutoOS.Coordinates.GameTab.GetTab(14)[3], AutoOS.Coordinates.GameTab.GetTab(14)[4]], 0x75281e, 0x3b140f, 2, 5, 0x441812))
					return bottom_row
				else
					return false
			}
						
			class Combat	; TODO
			{
				
			}
		
			class Skills	; TODO
			{
				
			}
		
			class Quests	; TODO
			{
				
			}
			
			class Inventory	; TODO
			{

			}
			
			class Equipment	; TODO
			{
				
			}
			
			class Prayer	; TODO
			{
				
			}
			
			class Magic	; TODO
			{
				class Standard
				{
	
				}

				class Ancient	; TODO
				{
					
				}

				class Lunar	; TODO
				{
					
				}

				class Arceuus	; TODO
				{
					
				}
								
			}
		
			class ClanChat	; TODO
			{
				
			}
			
			class FriendList	; TODO
			{
				
			}
			
			class AccountManagement	; TODO
			{
				
			}
			
			class Logout	; TODO
			{
									  
				class WorldSwitcher	; TODO
				{
					
				}
				
			}
			
			class Options	; TODO
			{
				
			}
		
			class Emotes	; TODO
			{
				
			}
		
			class MusicPlayer	; TODO
			{
				
			}
			
			
			
			
		}
		
	}
	
	
	Setup()
	{
		if (A_CoordModePixel != "Screen")
			CoordMode, Pixel, Screen
		if (A_CoordModeMouse != "Screen")
			CoordMode, Mouse, Screen
	}
	
	
}

class UserInterface
{
	class PlayerManager
	{
		class NewPlayer
		{
			static NewPlayerUsername, NewPlayerLogin, NewPlayerPassword, NewPlayerPinNumber
			static NewPlayerCombatFkey, NewPlayerSkillsFkey, NewPlayerQuestsFkey, NewPlayerInventoryFkey
				 , NewPlayerEquipmentFkey, NewPlayerPrayerFkey, NewPlayerMagicFkey
			static NewPlayerClanChatFkey, NewPlayerFriendListFkey, NewPlayerAccManagerFkey, NewPlayerLogoutFkey
				 , NewPlayerOptionsFkey, NewPlayerEmotesFkey, NewPlayerMusicPlayerFkey
			Load()
			{	
				

				Gui, NewPlayer: Add, Text, x10 y10, % "Client:"
				Gui, NewPlayer: Add, Text, x82 y10, % "Username:"
				Gui, NewPlayer: Add, Text, x164 y10, % "Email/Login:"
				Gui, NewPlayer: Add, Text, x246 y10, % "Password:"
				Gui, NewPlayer: Add, Text, x328 y10, % "Pin:"
				Gui, NewPlayer: Add, ComboBox, x10 y25 w70 vNewPlayerClient, RuneLite||Official
				Gui, NewPlayer: Add, Edit, x82 y25 w80 r0.8 Limit13 vNewPlayerUsername, Optional
				Gui, NewPlayer: Add, Edit, x164 y25 w80 r0.8 vNewPlayerLogin, Optional
				Gui, NewPlayer: Add, Edit, x246 y25 w80 r0.8 vNewPlayerPassword, Optional
				Gui, NewPlayer: Add, Edit, x328 y25 w70 r0.8 Number Limit4 vNewPlayerPinNumber, Optional
				
				Gui, NewPlayer: Add, GroupBox, x5 y60 h110 w400, F-Keys
				Gui, NewPlayer: Add, Text, x10 y80, % "Combat:"
				Gui, NewPlayer: Add, Text, x65 y80, % "Skills:"
				Gui, NewPlayer: Add, Text, x120 y80, % "Quests:"
				Gui, NewPlayer: Add, Text, x175 y80, % "Inventory:"
				Gui, NewPlayer: Add, Text, x230 y80, % "Equip:"
				Gui, NewPlayer: Add, Text, x285 y80, % "Prayer:"
				Gui, NewPlayer: Add, Text, x340 y80, % "Magic:"
				Gui, NewPlayer: Add, ComboBox, x10 y95 w50 vNewPlayerCombatFkey, None||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x65 y95 w50 vNewPlayerSkillsFkey, None||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x120 y95 w50 vNewPlayerQuestsFkey, None||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x175 y95 w50 vNewPlayerInventoryFkey, None||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x230 y95 w50 vNewPlayerEquipmentFkey, None||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x285 y95 w50 vNewPlayerPrayerFkey, None||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x340 y95 w50 vNewPlayerMagicFkey, None||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				
				Gui, NewPlayer: Add, Text, x10 y120, % "Clan chat:"
				Gui, NewPlayer: Add, Text, x65 y120, % "Friends:"
				Gui, NewPlayer: Add, Text, x120 y120, % "Acc.Man.:"
				Gui, NewPlayer: Add, Text, x175 y120, % "Logout:"
				Gui, NewPlayer: Add, Text, x230 y120, % "Options:"
				Gui, NewPlayer: Add, Text, x285 y120, % "Emotes:"
				Gui, NewPlayer: Add, Text, x340 y120, % "Music:"
				Gui, NewPlayer: Add, ComboBox, x10 y135 w50 vNewPlayerClanChatFkey, None||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x65 y135 w50 vNewPlayerFriendListFkey, None||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x120 y135 w50 vNewPlayerAccManagerFkey, None||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x175 y135 w50 vNewPlayerLogoutFkey, None||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x230 y135 w50 vNewPlayerOptionsFkey, None||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x285 y135 w50 vNewPlayerEmotesFkey, None||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x340 y135 w50 vNewPlayerMusicPlayerFkey, None||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				
				Gui, NewPlayer: Add, Button, x125 y180 w50 HwndSaveNewPlayer, Save
				Gui, NewPlayer: Add, Button, x225 y180 w50 HwndCancelNewPlayer, Cancel
				SetButtonF(SaveNewPlayer, "UserInterface.PlayerManager.NewPlayer.Submit()")
				SetButtonF(CancelNewPlayer, "UserInterface.PlayerManager.NewPlayer.Cancel")
				Gui, NewPlayer: Show
			}
		
			Submit()
			{
				
				MsgBox % UserInterface.PlayerManager.NewPlayer.Load.NewPlayerClient
			}
			
			Cancel()
			{
				Gui, NewPlayer: Cancel
			}
			
		}
		
		
		MasterPassword()
		{
			masterpass_text := "This will be the password we will use "
							 . "to encrypt and decrypt your account details.`n`r`n`r"
							 . "Your password should be at least 4 characters long.`n`r`n`r"
							 . "AutoOS doesn't check if your password is right, if it's not, "
							 . "it simply won't be able to fecth your account sensitive data."
			
			InputBox, pass, % "Master Password", % masterpass_text, HIDE, 300, 280,
			AutoOS.PlayerManager.MasterPassword := pass
			UserInterface.PlayerManager.UpdatePlayersData()
			UserInterface.PlayerManager.Start()
		}
		
		
		State(state)
		{
			if state
				Gui, PlayerManager: Show
			else if !state
				Gui, PlayerManager: Hide
		}
		
		Start()
		{
			list_view_options := "y10 w600 Checked -LV0x10 -Multi NoSortHdr"
			list_view_header := "Client|Username|Email/Login|Password|Pin|"
							  . "Combat|Skills|Quests|Inventory|Equipment|Prayer|Magic|"
							  . "Clan chat|Friend list|Acc. Management|Logout|Options|Emotes|Music"

			Gui, PlayerManager: New,
			Gui, PlayerManager: Add, ListView, % list_view_options . "HwndPlayerViewer", % list_view_header

			LV_ModifyCol(AutoHdr)
			LV_ModifyCol(1, 75)
			LV_ModifyCol(2, 75)
			LV_ModifyCol(3, 120)
			LV_ModifyCol(4, 75)
			LV_ModifyCol(5, 40)

			UserInterface.PlayerManager.UpdatePlayersData()
			
			Gui, PlayerManager: Add, Button, HwndAddPlayer y+10, Add Player
			Gui, PlayerManager: Add, Button, HwndEditPlayer x+10, Edit Player
			Gui, PlayerManager: Add, Button, HwndDeletePlayer x+10, Delete Player
			SetButtonF(AddPlayer, "UserInterface.PlayerManager.NewPlayer.Load")
			SetButtonF(EditPlayer, "UserInterface.PlayerManager.EditPlayer")
			SetButtonF(DeletePlayer, "UserInterface.PlayerManager.DeletePlayer")
			return
		}
		
		UpdatePlayersData()
		{
			player_count := 1
			if FileExist("account.ini")
				player_count := Text.CountIniSections("account.ini")
			else
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
			return
		}
		
	
	}
}


class Debug
{
	static LogFile := ""
	
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
		if !Debug.LogFile
			Debug.CreateLog()
		FormatTime, TIME_STAMP,, [dd-MM-yyyy HH:mm:ss]:
		FileAppend, % TIME_STAMP . " " . line . "`r`n",  % Debug.LogFile
	}
	
	
}

class Input	; Core class of our input
{	; TODO: Need to add a client check before every input I think, so we don't send input to the wrong place and mess the bot.
	
	static AsyncMouse, AsyncKeyboard
	
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
		; When you call a input method through this, you need to declare all parameters. Haven't tested it but it's very likely it won't work well if you don't declare all params.
		params := Text.ExtractParams(StrSplit(StrSplit(string, "(")[2], ")")[1])

		if InStr(string, "Human.")	; need to include the period at the or it will be messed up by "HumanCoordinates" method.
		{
			if InStr(string, "Box")
				Input.Human.Mouse.Box(params[1], params[2], params[3], params[4], params[5])
			else if InStr(string, "Mid")
				Input.Human.Mouse.Mid(params[1], params[2], params[3], params[4], params[5])
			else if InStr(string, "Circle")
				Input.Human.Mouse.Circle(params[1], params[2], params[3], params[4])
			else if InStr(string, "CwBox")
				Input.Human.Mouse.CwBox(params[1], params[2], params[3], params[4], params[5])
			else if InStr(string, "HumanCoordinates")
				Input.Human.Mouse.HumanCoordinates(params[1], params[2], params[3], params[4], params[5])
		}
		else
		{
			if InStr(string, "Box")
				Input.Mouse.Box(params[1], params[2], params[3], params[4], params[5])
			else if InStr(string, "Mid")
				Input.Mouse.Mid(params[1], params[2], params[3], params[4], params[5])
			else if InStr(string, "Circle")
				Input.Mouse.Circle(params[1], params[2], params[3], params[4])
			else if InStr(string, "CwBox")
				Input.Mouse.CwBox(params[1], params[2], params[3], params[4], params[5])
			else if InStr(string, "HumanCoordinates")
				Input.Mouse.HumanCoordinates(params[1], params[2], params[3], params[4], params[5])
			else if InStr(string, "RandomBezier")
				Input.Mouse.RandomBezier(params[1], params[2], params[3], params[4], params[5], params[6], params[7])
		}



	}
	
	DynamicKeyboardMethod(string)	; Runs an input method dynamically (a method inside a variable).
	{
		; When you call a input method through this, you need to declare all parameters. Haven't tested it but it's very likely it won't work well if you don't declare all params.
		
		
		params := Text.ExtractParams(StrSplit(StrSplit(string, "(")[2], ")")[1])
		
		if InStr(string, "Human.")	; need to include the period at the or it will be messed up by "HumanCoordinates" method.
		{
			if InStr(string, "PressKey")
				Input.Human.Keyboard.PressKey(params[1], params[2])
			else if InStr(string, "MultiKeyPress")
				Input.Human.Keyboard.MultiKeyPress(params[1], params[2], params[3], params[4], params[5], params[6])
			else if InStr(string, "SendSentence")
				Input.Human.Keyboard.SendSentence()
		}
		else
		{
			if InStr(string, "PressKey")
				Input.Keyboard.PressKey(params[1], params[2])
			else if InStr(string, "MultiKeyPress")
				Input.Keyboard.MultiKeyPress(params[1], params[2], params[3], params[4], params[5], params[6])
			else if InStr(string, "SendSentence")
				Input.Keyboard.SendSentence()
		}

	}
	
	class Mouse	; Basic Mouse functionality
	{
		
		Box(x, y, w, h, action := "move")
		{
			box := Math.GetPoint.Box(x, y, w, h)
			;MsgBox % box[1]
			MouseMove, box[1], box[2], Math.Random(AutoOS.PlayerManager.MouseSlowSpeed, AutoOS.PlayerManager.MouseFastSpeed)
			if (action != "move")
				MouseClick, % action
		}
				
		Mid(x, y, w, h, action := "move")
		{
			mid := Math.GetPoint.Mid(x, y, w, h)
			MouseMove, mid[1], mid[2], Math.Random(AutoOS.PlayerManager.MouseSlowSpeed, AutoOS.PlayerManager.MouseFastSpeed)
			if (action != "move")
				MouseClick, % action
		}
		
		Circle(x, y, radius, action := "move")
		{
			circle := Math.GetPoint.Circle(x, y, radius)
			MouseMove, circle[1], circle[2], Math.Random(AutoOS.PlayerManager.MouseSlowSpeed, AutoOS.PlayerManager.MouseFastSpeed)
			if (action != "move")
				MouseClick, % action
		}
		
		CwBox(x, y, w, h, action := "move") ; CwBox := Circle within box
		{
			cwb := Math.GetPoint.CwBox(x, y, w, h)
			MouseMove, cwb[1], cwb[2], Math.Random(AutoOS.PlayerManager.MouseSlowSpeed, AutoOS.PlayerManager.MouseFastSpeed)
			if (action != "move")
				MouseClick, % action
		}
		
		HumanCoordinates(x, y, w, h, action := "move")
		{
			coord := Math.GetPoint.HumanCoordinates(x, y, w, h)
			MouseMove, coord[1], coord[2], Math.Random(AutoOS.PlayerManager.MouseSlowSpeed, AutoOS.PlayerManager.MouseFastSpeed)
			if (action != "move")
				MouseClick, % action
		}

		; MasterFocus's RandomBezier function.
		; Source at: https://github.com/MasterFocus/AutoHotkey/tree/master/Functions/RandomBezier
		; Slightly modified and simplified for my use... Would like to completely redo this later on as it's not very clear IMO.
		RandomBezier(X0, Y0, Xf, Yf, action := "move", p1 := 2, p2 := 5, speed1 := 3, speed2 := 8)
		{	
			x_distance := X0 - Xf
			y_distance := Y0 - Yf

			; speed1 and speed2 are mousespeeds. Like the ones we have with MouseMove, X, Y, *Speed*
			; Did some benchmarks with A_TickCount to figure more or less how do the mouse speed numbers translate to miliseconds.
			; This formula depending on the distance is what I came up with.
			speed_modifier := Round(Math.GetLowest(Math.MakePositive(x_distance), Math.MakePositive(y_distance)) / 3.5)
			time := Math.Random((speed2 * speed_modifier), (speed1 * speed_modifier))
			N := Math.Random(p, p2)
			
			if (N > 20)
				N := 19
			else if (N < 2)
				N := 2
			
			
			
			if (Math.Between(x_distance, -50, 50) or Math.Between(y_distance, -50, 50))	; If the distance is short, doesn't make sense having the
				N := 2																						; mouse doing crazy curves.
	
	
			OfT := 100, OfB := 100
			OfL := 100, OfR := 100
			MouseGetPos, XM, YM
			
			if (X0 < Xf)
				sX := X0-OfL, bX := Xf+OfR
			else
				sX := Xf-OfL, bX := X0+OfR
				
			if (Y0 < Yf)
				sY := Y0-OfT, bY := Yf+OfB
			else
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
			if (action != "move")
				MouseClick, % action,
			return N+1
		}
	
	}
	
	class Keyboard ; Basic Keyboard functionality
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
			if key3
				Send, {%key3% Down}
			if key4
				Send, {%key4% Down}
			if key5
				Send, {%key5% Down}
			Sleep, time
			Send, {%key1% Up}
			Send, {%key2% Up}
			if key3
				Send, {%key3% Up}
			if key4
				Send, {%key4% Up}
			if key5
				Send, {%key5% Up}
		}
		
		SendSentence()	; TODO. When done, need to finish async keyboard too.
		{
			
		}
		
	}
	
	class Human	; Uses input that looks more like a human.
	{
		class Mouse	; This class is an identical copy of Input.Mouse class but uses RandomBezier for all mouse movements. Making it look more like a human.
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
	
		class Keyboard ; Uses the keyboard in a more human convincing way.
		{
			PressKey(key, time := 30)	; This function mimics the auto-repeat feature most keyboards have.
			{
				Send, {%key% Down}
				if (time > 500)			; This might be different with other keyboards but mine holds the key down
				{						; for 500 miliseconds before starting the auto-repeat ¯\_(ツ)_/¯
					Sleep, 500
					time := time-500
					loop_counter := Round((time/30))
					Loop % loop_counter
					{
						Send, {%key% Down}
						Sleep, 30
					}
					
					if ((loop_counter * 30) < time)				; Fixes the rounding we've done before... there's probably
						Sleep, ((loop_counter * 30) - time)		; no need to be this precise, but I'm a perfectionist.
				}
				else
					Sleep, time
				Send, {%key% Up}
			}
			
			MultiKeyPress(key1, key2, key3 := "", key4 := "", key := "", time := 30) ; Haven't tested this yet. Should work though.
			{
				Send, {%key1% Down}
				Send, {%key2% Down}
				if key3
					Send, {%key3% Down}
				if key4
					Send, {%key4% Down}
				if key5
					Send, {%key5% Down}
				if (time > 500)
				{
					Sleep, 500
					time := time-500
					loop_counter := Round((time/30))
					Loop % loop_counter
					{
						Send, {%key1% Down}
						Send, {%key2% Down}
						if key3
							Send, {%key3% Down}
						if key4
							Send, {%key4% Down}
						if key5
							Send, {%key5% Down}
						Sleep, 30
					}
					
					if ((loop_counter * 30) < time)
						Sleep, ((loop_counter * 30) - time)
				}
				else
					Sleep, time
				Send, {%key1% Up}
				Send, {%key2% Up}
				if key3
					Send, {%key3% Up}
				if key4
					Send, {%key4% Up}
				if key5
					Send, {%key5% Up}
			}
		
			SendSentence()	; TODO. When done, need to finish async keyboard too.
			{
				
			}
		
		}
	}

}

class Math
{
	Random(n1, n2)
	{
		Random, r, %n1%, %n2%
		return %r%
	}
	
	Between(n, min, max)	; Between function that can be used in expressions. Checks if n is between min and max
	{
		if ((min <=  n) and (n <= max))
			return true
		else
			return false	
	}
	
	InBox(x, y, box)
	{
		if (Math.Between(x, box[1], box[3]) and Math.Between(y, box[2], box[4]))
			return true
		else
			return false
		
	}
	
	GetLowest(n1, n2)
	{
		if (n1 > n2)
			return n2
		else if (n1 < n2)
			return n1
	}
	
	GetHighest(n1, n2)
	{
		if (n1 > n2)
			return n1
		else if (n1 < n2)
			return n2
	}
	
	MakePositive(n)
	{
		if (n < 0)
			return (n * -1)
		else
			return n
	}
	
	MakeNegative(n)
	{
		if (n > 0)
			return (n * -1)
		else
			return n
	}
	
	DPIScale(n, operation := "scale")
	{
		if (operation == "scale")
		{
			if (A_ScreenDPI == 96)
				return % n
			else if (A_ScreenDPI == 120)
				return % Round(n * 1.25)
			else if (A_ScreenDPI == 144)
				return % Round(n * 1.5)
			else if (A_ScreenDPI == 168)
				return % Round(n * 1.75)
			else if (A_ScreenDPI == 192)
				return % n * 2
		}
		else if (operation == "descale")
		{
			if (A_ScreenDPI == 96)
				return % n
			else if (A_ScreenDPI == 120)
				return % Round(n / 1.25)
			else if (A_ScreenDPI == 144)
				return % Round(n / 1.5)
			else if (A_ScreenDPI == 168)
				return % Round(n / 1.75)
			else if (A_ScreenDPI == 192)
				return % Round(n / 2)
		}
	}
	
	class GetPoint
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
			if (!n3 and !n4)
				return Round((n1 + n2) / 2)
			else if (n3 and n4)			
				return Array(Round((n1 + n3) / 2), Round((n2 + n4) / 2))
			else if ((n3 and !n4) or (!n3 and n4))
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
			if ((x - w) <= (y - h))
				radius := Round((w - x) / 2)
			else if ((x -w) > (y - h))
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
			if (probability <= 49)
			{
				x_circle := Round(x + ((w - x) * 0.2))	; 50% probability the coordinates will be in the "eye" of the box.
				w_circle := Round(w + ((x - w) * 0.2))
				y_circle := Round(y + ((h - y) * 0.2))
				h_circle := Round(h + ((y - h) * 0.2))
			}
			else if (probability <= 84)
			{
				x_circle := Round(x + ((w - x) * 0.35))	; 35% probability the coordinates will be in the inner circle inside of the box.
				w_circle := Round(w + ((x - w) * 0.35))	; This includes the "eye" above, so in reality the probability of having the coordinates closer to the center
				y_circle := Round(y + ((h - y) * 0.35))	; is higher than 50%.
				h_circle := Round(h + ((y - h) * 0.35))
			}
			else if (probability >= 85)
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

class Color
{
	
	class Pixel
	{
		InBox(color_id, box, tolerance := 0)
		{
			PixelSearch, output_x, output_y, box[1], box[2], box[3], box[4], color_id, tolerance, Fast RGB
			if ErrorLevel
				return false
			else
				return true
		}
		
		CountInBox(color_id, box, tolerance := 0)	; returns the number of pixels found with specified color within a box
		{
			pixel_count := 0
			Loop
			{
				PixelSearch, output_x, output_y, box[1], box[2], box[3], box[4], color_id, tolerance, Fast RGB
				if !ErrorLevel
				{
					++pixel_count
					box[1] := output_x + 1
					box[2] := output_y
				}
				else if ErrorLevel
					return pixel_count
			}
		}
		
		Shift(x, y, t := 100, tolerance := 0)	; Checks if the pixel at coordinates x and y shifted color in t time. NEED TESTING!
		{
			PixelGetColor, output1, x, y, RGB
			Sleep % t
			PixelGetColor, output2, x, y, RGB
			if (output1 != output2)
				return true
			else if (output1 == output2)
				return false
		}
		
		InBoxes(color_id, box1, box2, tolerance := 0, min := 2, box3 := "", box4 := "")	; Checks if color_id is present in the specified boxes. If the number of present pixels
		{																				; is above the minimum threshold (min)
			if (!IsObject(box1) or !IsObject(Box2) or !IsObject(Box3) or !IsObject(Box4))
				return "Boxes must be objects with 4 x, y, w and h."
			
			pixel_counter := 0
			
			PixelSearch, output_x, output_y, box1[1], box1[2], box1[3], box1[4], color_id, tolerance, Fast RGB
			if !ErrorLevel
				++pixel_counter
			
			PixelSearch, output_x, output_y, box2[1], box2[2], box2[3], box2[4], color_id, tolerance, Fast RGB
			if !ErrorLevel
				++pixel_counter
			
			if Box3	; Checks if Box3 exists.
			{
				PixelSearch, output_x, output_y, box3[1], box3[2], box3[3], box3[4], color_id, tolerance, Fast RGB
				if !ErrorLevel
					++pixel_counter
			}
			
			if Box4	; Box4 can be inside Box3 check because Box4 won't exist if 3 doesn't.
			{
				PixelSearch, output_x, output_y, box4[1], box4[2], box4[3], box4[4], color_id, tolerance, Fast RGB
				if !ErrorLevel
					++pixel_counter
			}
		
			If (pixel_counter < min)
				return false
			else
				return true
		}
		
		Gdip_PixelSearch(pBitmap, ARGB, x1, y1, x2, y2) ; This is slow as heck... but I'll leave it here anyway in case it's useful.
		{
			While !(y1 >= y2)
			{
				While !(x1 >= x2)
				{
					pixel_color := Gdip_GetPixel(pBitmap, x1, y1)
					if (pixel_color == ARGB)
						return Array(x1, y1)
					else
					{
						if (x1 < x2)
							++x1
					}
				}
				
				x1 := 0
				if (y1 < y2)
					++y1
			}
			MsgBox % "we are here"
			return "Error"
		}
		
	}
	
	class Multi
	{
		class Pixel ; Pretty much the same thing as Color.Pixel class but with several pixels in mind.
		{
			InBox(box, color_id1, color_id2, min := 2, tolerance := 0, color_id3 := "", color_id4 := "", color_id5 := "")
			{
				pixel_counter := 0, final_x := 0, final_y := 0
				PixelSearch, output_x1, output_y1, box[1], box[2], box[3], box[4], color_id1, tolerance, Fast RGB
				if !ErrorLevel
				{
					++pixel_counter
					final_x += output_x1
					final_y += output_y1
				}
				
				PixelSearch, output_x2, output_y2, box[1], box[2], box[3], box[4], color_id2, tolerance, Fast RGB
				if !ErrorLevel
				{
					++pixel_counter
					final_x += output_x2
					final_y += output_y2
				}
				
				if color_id3
				{
					PixelSearch, output_x3, output_y3, x, y, w, h, color_id3, tolerance, Fast RGB
					if !ErrorLevel
					{
						++pixel_counter
						final_x += output_x3
						final_y += output_y3
					}
					
				}
				
				if color_id4
				{
					PixelSearch, output_x4, output_y4, x, y, w, h, color_id4, tolerance, Fast RGB
					if !ErrorLevel
					{
						++pixel_counter
						final_x += output_x4
						final_y += output_y4
					}
				}
				
				if color_id5
				{
					PixelSearch, output_x5, output_y5, x, y, w, h, color_id5, tolerance, Fast RGB
					if !ErrorLevel
					{
						++pixel_counter
						final_x += output_x5
						final_y += output_y5
					}
				}
				
				final_x := Round(final_x/pixel_counter)
				final_y := Round(final_y/pixel_counter)
				if (pixel_counter >= min)
					return Array(final_x, final_y)
				else
					return false
			}
			
			CountInBox(x, y, w, h, color_id1, color_id2, min := 2, tolerance := 0, color_id3 := "", color_id4 := "", color_id5 := "")
			{
				pixel_count := Color.Pixel.CountInBox(color_id1, x, y, w, h, tolerance)
				pixel_count += Color.Pixel.CountInBox(color_id2, x, y, w, h, tolerance)
				if color_id3
					pixel_count += Color.Pixel.CountInBox(color_id3, x, y, w, h, tolerance)
				if color_id4
					pixel_count += Color.Pixel.CountInBox(color_id4, x, y, w, h, tolerance)
				if color_id5
					pixel_count += Color.Pixel.CountInBox(color_id5, x, y, w, h, tolerance)
				return pixel_count
			}
			
			Shift(Obj1, Obj2, Obj3 := "", Obj4 := "", t := 100, tolerance := 0, min := 2) ; Checks if the pixels at coordinates x and y shifted color in t time. NEED TESTING!
			{
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
				
				if (pixel1_start != pixel1_final)
					++shift_counter
				if (pixel2_start != pixel2_final)
					++shift_counter
				if (pixel3_start != pixel3_final)	; I think doesn't need a check if the object exist because if it doesn't both will be the same. NEED TESTING!
					++shift_counter
				if (pixel4_start != pixel4_final)	; I think doesn't need a check if the object exist because if it doesn't both will be the same. NEED TESTING!
					++shift_counter
				
				if (shift_counter >= 2)
					return true
				else
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

class Encryption
{
	; Code by jNizM on GitHub modified to UTF-8 as it was causing some errors. Link: https://gist.github.com/jNizM/79aa6a4b8ec428bf780f
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
			static MS_ENH_RSA_AES_PROV := "Microsoft Enhanced RSA and AES Cryptographic Provider"
			static PROV_RSA_AES        := 24
			static CRYPT_VERIFYCONTEXT := 0xF0000000
			static CALG_SHA1           := 0x00008004
			static CALG_SHA_256        := 0x0000800c
			static CALG_SHA_384        := 0x0000800d
			static CALG_SHA_512        := 0x0000800e
			static CALG_AES_128        := 0x0000660e ; KEY_LENGHT := 0x80  ; (128)
			static CALG_AES_192        := 0x0000660f ; KEY_LENGHT := 0xC0  ; (192)
			static CALG_AES_256        := 0x00006610 ; KEY_LENGHT := 0x100 ; (256)
			static KP_BLOCKLEN         := 8

			if !(DllCall("advapi32.dll\CryptAcquireContext", "Ptr*", hProv, "Ptr", 0, "Ptr", 0, "Uint", PROV_RSA_AES, "UInt", CRYPT_VERIFYCONTEXT))
				MsgBox % "*CryptAcquireContext (" DllCall("kernel32.dll\GetLastError") ")"

			if !(DllCall("advapi32.dll\CryptCreateHash", "Ptr", hProv, "Uint", CALG_SHA1, "Ptr", 0, "Uint", 0, "Ptr*", hHash))
				MsgBox % "*CryptCreateHash (" DllCall("kernel32.dll\GetLastError") ")"

			passLen := this.StrPutVar(password, passBuf, 0, "UTF-8")
			if !(DllCall("advapi32.dll\CryptHashData", "Ptr", hHash, "Ptr", &passBuf, "Uint", passLen, "Uint", 0))
				MsgBox % "*CryptHashData (" DllCall("kernel32.dll\GetLastError") ")"
			
			if !(DllCall("advapi32.dll\CryptDeriveKey", "Ptr", hProv, "Uint", CALG_AES_%ALG_ID%, "Ptr", hHash, "Uint", (ALG_ID << 0x10), "Ptr*", hKey)) ; KEY_LENGHT << 0x10
				MsgBox % "*CryptDeriveKey (" DllCall("kernel32.dll\GetLastError") ")"

			if !(DllCall("advapi32.dll\CryptGetKeyParam", "Ptr", hKey, "Uint", KP_BLOCKLEN, "Uint*", BlockLen, "Uint*", 4, "Uint", 0))
				MsgBox % "*CryptGetKeyParam (" DllCall("kernel32.dll\GetLastError") ")"
			BlockLen /= 8

			if (CryptMode)
				DllCall("advapi32.dll\CryptEncrypt", "Ptr", hKey, "Ptr", 0, "Uint", 1, "Uint", 0, "Ptr", &encr_Buf, "Uint*", Buf_Len, "Uint", Buf_Len + BlockLen)
			else
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
			static CRYPT_STRING_BASE64 := 0x00000001
			static CRYPT_STRING_NOCRLF := 0x40000000
			DllCall("crypt32.dll\CryptBinaryToStringA", "Ptr", &VarIn, "UInt", SizeIn, "Uint", (CRYPT_STRING_BASE64 | CRYPT_STRING_NOCRLF), "Ptr", 0, "UInt*", SizeOut)
			VarSetCapacity(VarOut, SizeOut, 0)
			DllCall("crypt32.dll\CryptBinaryToStringA", "Ptr", &VarIn, "UInt", SizeIn, "Uint", (CRYPT_STRING_BASE64 | CRYPT_STRING_NOCRLF), "Ptr", &VarOut, "UInt*", SizeOut)
			return StrGet(&VarOut, SizeOut, "CP0")
		}
		b64Decode(ByRef VarIn, ByRef VarOut)
		{
			static CRYPT_STRING_BASE64 := 0x00000001
			static CryptStringToBinary := "CryptStringToBinary" (A_IsUnicode ? "W" : "A")
			DllCall("crypt32.dll\" CryptStringToBinary, "Ptr", &VarIn, "UInt", 0, "Uint", CRYPT_STRING_BASE64, "Ptr", 0, "UInt*", SizeOut, "Ptr", 0, "Ptr", 0)
			VarSetCapacity(VarOut, SizeOut, 0)
			DllCall("crypt32.dll\" CryptStringToBinary, "Ptr", &VarIn, "UInt", 0, "Uint", CRYPT_STRING_BASE64, "Ptr", &VarOut, "UInt*", SizeOut, "Ptr", 0, "Ptr", 0)
			return SizeOut
		}
	}
}

class Text
{
	CountIniSections(file)
	{
		Loop, Read, % file
		{
				if InStr(A_LoopReadLine, "[")
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
	Input.SendAsyncInput("Exit", "AsyncMouse.ahk ahk_class AutoHotkey")
	Input.SendAsyncInput("Exit", "AsyncKeyboard.ahk ahk_class AutoHotkey")
	ExitApp	
}




/*#####################################
FUNCTION: SetButtonF
DESCRIPTION: Set a button control to call a function instead of a label subroutine
PARAMETER(s):
	hButton := Button control's handle
	FunctionName := Name of fucntion to associate with button
USAGE:
	Setting a button:
		SetButtonF(hButton, FunctionName)
		
	Retrieving the function name associated with a particular button:
		Func := SetButtonF(hButton) ; note: 2nd parameter omitted
		
	Disabling a function for a particular button(similar to "GuiControl , -G" option):
		SetButtonF(hButton, "") ; note: 2nd parameter not omitted but explicitly blank
		
	Disabling all functions for all buttons:
		SetButtonF() ; No parameters
NOTES:
	The function/handler must have atleast two parameters, this function passes the GUI's hwnd as the 1st parameter and the button's hwnd as the 2nd.
######################################
*/

SetButtonF(p*) {
	static WM_COMMAND := 0x0111 , BN_CLICKED := 0x0000
	static IsRegCB := false , oldNotify := {CBA: "", FN: ""} , B := [] , tmr := []
	if(A_EventInfo == tmr.CBA) { ; Call from timer
		DllCall("KillTimer", "UInt", 0, "UInt", tmr.tmr) ; Kill timer, one time only
		, tmr.func.(tmr.params*) ; Call function
		return DllCall("GlobalFree", "Ptr", tmr.CBA, "Ptr") , tmr := []
	}
	if (p.3 <> WM_COMMAND) { ; Not a Windows message ; call from user
		if !ObjHasKey(p, 1) { ; No passed parameter ; Clear all button-function association
			if IsRegCB {
				if B.MinIndex()
					B.Remove(B.MinIndex(), B.MaxIndex())
				, IsRegCB := false
				, OnMessage(WM_COMMAND, oldNotify.FN) ; reset to previous handler(if any)
				, oldNotify.CBA := "" , oldNotify.FN := "" ; reset
				return true
			}
		}
		if !WinExist("ahk_id " p.1) ; or !DllCall("IsWindow", "Ptr", p.1) ; Check if handle is valid
			return false ; Not a valid handle, control does not exist
		WinGetClass, c, % "ahk_id " p.1 ; Check if it's a button control
		if (c == "Button") {
			if p.2 { ; function name/reference has been specified, store/associate it
				if IsFunc(p.2) ; Function name is specified
					B[p.1, "F"] := Func(p.2)
				if (IsObject(p.2) && IsFunc(p.2.Name)) ; Function reference/object is specified
					B[p.1, "F"] := p.2
				if !IsRegCB { ; No button(s) has been set yet , callback has not been registered
					fn := OnMessage(WM_COMMAND, A_ThisFunc)
					if (fn <> A_ThisFunc) ; if there's another handler
						oldNotify.CBA := RegisterCallback((oldNotify.FN := fn)) ; store it
					IsRegCB := true
				}
			} else { ; if 2nd parameter(Function name) is explicitly blank or omitted
				if ObjHasKey(B, p.1) { ; check if button is in the list
					if !ObjHasKey(p, 2) ; Omitted
						return B[p.1].F.Name ; return Funtion Name associated with button
					else { ; Explicitly blank
						B.Remove(p.1, "") ; Disassociate button with function, remove from internal array
						if !B.MinIndex() ; if last button in array
							SetButtonF() ; Reset everything
					}
				}
			}
			return true ; successful
		} else
			return false ; not a button control
	} else { ; WM_COMMAND
		if ObjHasKey(B, p.2) { ; Check if control is in internal array
			lo := p.1 & 0xFFFF ; Control identifier
			hi := p.1 >> 16 ; notification code
			if (hi == BN_CLICKED) { ; Normal, left button
				tmr := {func: B[p.2].F, params: [p.4, p.2]} ; store button's associated function ref and params
				, tmr.CBA := RegisterCallback(A_ThisFunc, "F", 4) ; create callback address
				; Create timer, this allows the function to finish processing the message immediately
				, tmr.tmr := DllCall("SetTimer", "UInt", 0, "UInt", 0, "Uint", 120, "UInt", tmr.CBA)
			}
		} else { ; Other control(s)
			if (oldNotify.CBA <> "") ; if there is a previous handler for WM_COMMAND, call it
				DllCall(oldNotify.CBA, "UInt", p.1, "UInt", p.2, "UInt", p.3, "UInt", p.4) 
		}
	}
}