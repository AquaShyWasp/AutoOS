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
				Gui, NewPlayer: New,, New Player
				Gui, NewPlayer: Add, Text, x10 y10, % "Client:"
				Gui, NewPlayer: Add, Text, x82 y10, % "Email/Login:"
				Gui, NewPlayer: Add, Text, x164 y10, % "Password:"
				Gui, NewPlayer: Add, Text, x246 y10, % "Pin number:"
				Gui, NewPlayer: Add, Text, x318 y10, % "Username:"
				Gui, NewPlayer: Add, ComboBox, x10 y25 w70 Hwndnew_player_client, RuneLite||Official
				Gui, NewPlayer: Add, Edit, x82 y25 w80 r0.8 Hwndnew_player_login, Optional
				Gui, NewPlayer: Add, Edit, x164 y25 w80 r0.8 Hwndnew_player_password, Optional
				Gui, NewPlayer: Add, Edit, x246 y25 w70 r0.8 Number Limit4 Hwndnew_player_pin_number, Optional
				Gui, NewPlayer: Add, Edit, x318 y25 w80 r0.8 Limit13 Hwndnew_player_username, Optional

				Gui, NewPlayer: Add, GroupBox, x5 y60 h110 w400, F-Keys
				Gui, NewPlayer: Add, Text, x10 y80, % "Combat:"
				Gui, NewPlayer: Add, Text, x65 y80, % "Skills:"
				Gui, NewPlayer: Add, Text, x120 y80, % "Quests:"
				Gui, NewPlayer: Add, Text, x175 y80, % "Inventory:"
				Gui, NewPlayer: Add, Text, x230 y80, % "Equip:"
				Gui, NewPlayer: Add, Text, x285 y80, % "Prayer:"
				Gui, NewPlayer: Add, Text, x340 y80, % "Magic:"
				Gui, NewPlayer: Add, ComboBox, x10 y95 w50 Hwndnew_player_combat_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x65 y95 w50 Hwndnew_player_skills_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x120 y95 w50 Hwndnew_player_quests_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x175 y95 w50 Hwndnew_player_inventory_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x230 y95 w50 Hwndnew_player_equipment_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x285 y95 w50 Hwndnew_player_prayer_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x340 y95 w50 Hwndnew_player_magic_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, Text, x10 y120, % "Clan chat:"
				Gui, NewPlayer: Add, Text, x65 y120, % "Friends:"
				Gui, NewPlayer: Add, Text, x120 y120, % "Acc.Man.:"
				Gui, NewPlayer: Add, Text, x175 y120, % "Logout:"
				Gui, NewPlayer: Add, Text, x230 y120, % "Options:"
				Gui, NewPlayer: Add, Text, x285 y120, % "Emotes:"
				Gui, NewPlayer: Add, Text, x340 y120, % "Music:"
				Gui, NewPlayer: Add, ComboBox, x10 y135 w50 Hwndnew_player_clan_chat_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x65 y135 w50 Hwndnew_player_friend_list_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x120 y135 w50 Hwndnew_player_account_management_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x175 y135 w50 Hwndnew_player_logout_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x230 y135 w50 Hwndnew_player_options_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x285 y135 w50 Hwndnew_player_emotes_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, NewPlayer: Add, ComboBox, x340 y135 w50 Hwndnew_player_music_player_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				
				Gui, NewPlayer: Add, Button, x125 y180 w50 gSaveNewPlayer, Save
				Gui, NewPlayer: Add, Button, x225 y180 w50 gCancelNewPlayer, Cancel
				Gui, NewPlayer: Show
				
				UserInterface.PlayerManager.NewPlayer.NewPlayerClient := new_player_client
				UserInterface.PlayerManager.NewPlayer.NewPlayerLogin := new_player_login
				UserInterface.PlayerManager.NewPlayer.NewPlayerPassword := new_player_password
				UserInterface.PlayerManager.NewPlayer.NewPlayerPinNumber := new_player_pin_number
				UserInterface.PlayerManager.NewPlayer.NewPlayerUsername := new_player_username
				UserInterface.PlayerManager.NewPlayer.NewPlayerCombatFkey := new_player_combat_fkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerSkillsFkey := new_player_skills_fkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerQuestsFkey := new_player_quests_fkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerInventoryFkey := new_player_inventory_fkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerEquipmentFkey := new_player_equipment_fkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerPrayerFkey := new_player_prayer_fkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerMagicFkey := new_player_magic_fkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerClanChatFkey := new_player_clan_chat_fkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerFriendListFkey := new_player_friend_list_fkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerAccountManagementFkey := new_player_account_management_fkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerLogoutFkey := new_player_logout_fkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerOptionsFkey := new_player_options_fkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerEmotesFkey := new_player_emotes_fkey
				UserInterface.PlayerManager.NewPlayer.NewPlayerMusicPlayerFkey := new_player_music_player_fkey
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
				Gui, PlayerEditor: New,, Player Editor
				Gui, PlayerEditor: Add, Text, x10 y10, % "Client:"
				Gui, PlayerEditor: Add, Text, x82 y10, % "Email/Login:"
				Gui, PlayerEditor: Add, Text, x164 y10, % "Password:"
				Gui, PlayerEditor: Add, Text, x246 y10, % "Pin number:"
				Gui, PlayerEditor: Add, Text, x318 y10, % "Username:"
				Gui, PlayerEditor: Add, ComboBox, x10 y25 w70 Hwndedit_player_client, RuneLite||Official
				Gui, PlayerEditor: Add, Edit, x82 y25 w80 r0.8 Hwndedit_player_login, Optional
				Gui, PlayerEditor: Add, Edit, x164 y25 w80 r0.8 Hwndedit_player_password, Optional
				Gui, PlayerEditor: Add, Edit, x246 y25 w70 r0.8 Number Limit4 Hwndedit_player_pin_number, Optional
				Gui, PlayerEditor: Add, Edit, x318 y25 w80 r0.8 Limit13 Hwndedit_player_username, Optional

				Gui, PlayerEditor: Add, GroupBox, x5 y60 h110 w400, F-Keys
				Gui, PlayerEditor: Add, Text, x10 y80, % "Combat:"
				Gui, PlayerEditor: Add, Text, x65 y80, % "Skills:"
				Gui, PlayerEditor: Add, Text, x120 y80, % "Quests:"
				Gui, PlayerEditor: Add, Text, x175 y80, % "Inventory:"
				Gui, PlayerEditor: Add, Text, x230 y80, % "Equip:"
				Gui, PlayerEditor: Add, Text, x285 y80, % "Prayer:"
				Gui, PlayerEditor: Add, Text, x340 y80, % "Magic:"
				Gui, PlayerEditor: Add, ComboBox, x10 y95 w50 Hwndedit_player_combat_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x65 y95 w50 Hwndedit_player_skills_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x120 y95 w50 Hwndedit_player_quests_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x175 y95 w50 Hwndedit_player_inventory_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x230 y95 w50 Hwndedit_player_equipment_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x285 y95 w50 Hwndedit_player_prayer_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x340 y95 w50 Hwndedit_player_magic_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, Text, x10 y120, % "Clan chat:"
				Gui, PlayerEditor: Add, Text, x65 y120, % "Friends:"
				Gui, PlayerEditor: Add, Text, x120 y120, % "Acc.Man.:"
				Gui, PlayerEditor: Add, Text, x175 y120, % "Logout:"
				Gui, PlayerEditor: Add, Text, x230 y120, % "Options:"
				Gui, PlayerEditor: Add, Text, x285 y120, % "Emotes:"
				Gui, PlayerEditor: Add, Text, x340 y120, % "Music:"
				Gui, PlayerEditor: Add, ComboBox, x10 y135 w50 Hwndedit_player_clan_chat_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x65 y135 w50 Hwndedit_player_friend_list_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x120 y135 w50 Hwndedit_player_account_management_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x175 y135 w50 Hwndedit_player_logout_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x230 y135 w50 Hwndedit_player_options_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x285 y135 w50 Hwndedit_player_emotes_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				Gui, PlayerEditor: Add, ComboBox, x340 y135 w50 Hwndedit_player_music_player_fkey, None||ESC|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12
				
				Gui, PlayerEditor: Add, Button, x125 y180 w50 gSaveEditPlayer, Save
				Gui, PlayerEditor: Add, Button, x225 y180 w50 gCancelEditPlayer, Cancel
				
				
				AutoOS.PlayerManager.GetPlayer(player)
				If (masterpass := AutoOS.PlayerManager.MasterPassword)
					AutoOS.PlayerManager.GetPlayerSensitiveData(player, masterpass)
				
				GuiControl, Text, % edit_player_Client, % AutoOS.PlayerManager.Client
				GuiControl, Text, % edit_player_login, % AutoOS.PlayerManager.Login
				GuiControl, Text, % edit_player_password, % AutoOS.PlayerManager.Password
				GuiControl, Text, % edit_player_pin_number, % AutoOS.PlayerManager.PinNumber
				GuiControl, Text, % edit_player_username, % AutoOS.PlayerManager.Username

				GuiControl, Text, % edit_player_combat_fkey, % AutoOS.PlayerManager.CombatFKey
				GuiControl, Text, % edit_player_skills_fkey, % AutoOS.PlayerManager.SkillsFKey
				GuiControl, Text, % edit_player_quests_fkey, % AutoOS.PlayerManager.QuestsFKey
				GuiControl, Text, % edit_player_inventory_fkey, % AutoOS.PlayerManager.InventoryFKey
				GuiControl, Text, % edit_player_equipment_fkey, % AutoOS.PlayerManager.EquipmentFKey
				GuiControl, Text, % edit_player_prayer_fkey, % AutoOS.PlayerManager.PrayerFKey
				GuiControl, Text, % edit_player_magic_fkey, % AutoOS.PlayerManager.MagicFKey

				GuiControl, Text, % edit_player_clan_chat_fkey, % AutoOS.PlayerManager.ClanChatFKey
				GuiControl, Text, % edit_player_friend_list_fkey, % AutoOS.PlayerManager.FriendListFKey
				GuiControl, Text, % edit_player_account_management_fkey, % AutoOS.PlayerManager.AccountManagementFKey
				GuiControl, Text, % edit_player_logout_fkey, % AutoOS.PlayerManager.LogoutFKey
				GuiControl, Text, % edit_player_options_fkey, % AutoOS.PlayerManager.OptionsFKey
				GuiControl, Text, % edit_player_emotes_fkey, % AutoOS.PlayerManager.EmotesFKey
				GuiControl, Text, % edit_player_music_player_fkey, % AutoOS.PlayerManager.MusicPlayerFKey
				
				Gui, PlayerEditor: Show
				
				UserInterface.PlayerManager.Editor.Client := edit_player_client
				UserInterface.PlayerManager.Editor.Login := edit_player_login
				UserInterface.PlayerManager.Editor.Password := edit_player_password
				UserInterface.PlayerManager.Editor.PinNumber := edit_player_pin_number
				UserInterface.PlayerManager.Editor.Username := edit_player_username
				UserInterface.PlayerManager.Editor.CombatFkey := edit_player_combat_fkey
				UserInterface.PlayerManager.Editor.SkillsFkey := edit_player_skills_fkey
				UserInterface.PlayerManager.Editor.QuestsFkey := edit_player_quests_fkey
				UserInterface.PlayerManager.Editor.InventoryFkey := edit_player_inventory_fkey
				UserInterface.PlayerManager.Editor.EquipmentFkey := edit_player_equipment_fkey
				UserInterface.PlayerManager.Editor.PrayerFkey := edit_player_prayer_fkey
				UserInterface.PlayerManager.Editor.MagicFkey := edit_player_magic_fkey
				UserInterface.PlayerManager.Editor.ClanChatFkey := edit_player_clan_chat_fkey
				UserInterface.PlayerManager.Editor.FriendListFkey := edit_player_friend_list_fkey
				UserInterface.PlayerManager.Editor.AccountManagementFkey := edit_player_account_management_fkey
				UserInterface.PlayerManager.Editor.LogoutFkey := edit_player_logout_fkey
				UserInterface.PlayerManager.Editor.OptionsFkey := edit_player_options_fkey
				UserInterface.PlayerManager.Editor.EmotesFkey := edit_player_emotes_fkey
				UserInterface.PlayerManager.Editor.MusicPlayerFkey := edit_player_music_player_fkey
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

				Gui, PlayerManager: New,, Player Manager
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
				PlayerManagerGuiClose:
					UserInterface.PlayerManager.Viewer.State(false)
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
		Static MouseScreenPosition, MouseClientPosition, ClientPosition, ScriptDebugger
		
		Load()
		{
			
			main_gui_x := AutoOS.Client.Coordinates[1]
			main_gui_y := AutoOS.Client.Coordinates[4]
			main_gui_w := Math.DPIScale((AutoOS.Client.Coordinates[3] - AutoOS.Client.Coordinates[1]), "descale")
			main_gui_h := 150
			
			Gui, MainGUI: New,, AutoOS
			;Gui, MainGUI: Color, Gray
			Gui, MainGUI: Font, s9
			Gui, MainGUI: -border AlwaysOnTop
			
			UserInterface.MainGUI.LeftSide()
			UserInterface.MainGUI.RightSide(main_gui_x, main_gui_y, main_gui_w, main_gui_h)
			
			
			Gui, MainGUI: Margin, X0 Y0
			Gui, MainGUI: Show, X%main_gui_x% Y%main_gui_y% W%main_gui_w% H%main_gui_h%
			return
		}
	
		LeftSide()
		{
			player_count := Text.CountIniSections("account.ini")
			Gui, Add, Picture, x50 w80 h-1 y0, % A_WorkingDir . "\assets\logo.png"
			Gui, MainGUI: Add, Text, x10 y33, Select Player:
			Loop % player_count
			{	
				player_list .= "Player" . A_Index . "|"
				if (A_Index == 1)
					player_list .= "|"
			}
			Gui, MainGUI: Add, DropDownList, x10 y50 r0.7 w70, % player_list
			Gui, MainGUI: Add, Button, x85 y49 r0.7 gPlayerManager, Player Manager
			Gui, MainGUI: Add, Button, x10 y75 w50 r0.7, Load
			Gui, MainGUI: Add, Button, x65 y75 w50 r0.7, Pause
			Gui, MainGUI: Add, Button, x127 y75 w50 r0.7, Stop
			return
			
			PlayerManager:
				If (AutoOS.PlayerManager.MasterPassword == "")
					UserInterface.PlayerManager.MasterPassword()
				UserInterface.PlayerManager.Viewer.Load()
				UserInterface.PlayerManager.Viewer.State(true)
			return
		}
		
		RightSide(main_gui_x, main_gui_y, main_gui_w, main_gui_h)
		{
			debug_tools_x := Round(main_gui_w/4)
			debug_tools_w := main_gui_w - debug_tools_x - 5
			debug_tools_h := main_gui_h - 10
			debug_tools_options := "x" . debug_tools_x . " y5 w" . debug_tools_w . " h" . debug_tools_h
			
			Gui, MainGUI: Add, GroupBox, % debug_tools_options, Debug tools
			UserInterface.MainGUI.MousePosition(main_gui_x, main_gui_y, main_gui_w, main_gui_h, debug_tools_x, debug_tools_h)
			UserInterface.MainGUI.CommandDebug(main_gui_x, main_gui_y, main_gui_w, main_gui_h, debug_tools_x, debug_tools_y, debug_tools_w, debug_tools_h)
			return
		}
		
		MousePosition(main_gui_x, main_gui_y, main_gui_w, main_gui_h, debug_tools_x, debug_tools_h)
		{			
			debug_col1 := debug_tools_x + 15
			
			Gui, MainGUI: Add, CheckBox, % "x" . debug_col1 . " y25 gMouseKeysToggle", Arrows mouse keys
			
			Gui, MainGUI: Add, GroupBox, % "x" . (debug_col1 - 5) . " y45 w150 h" . (debug_tools_h - 50),
			Gui, MainGUI: Add, Checkbox, % "x" . (debug_col1) . " y45 gMouseScreeenPositionToggle", Mouse position
			Gui, MainGUI: Font, s8
			Gui, MainGUI: Add, Text, % "x" . (debug_col1) . " y62", On Screen:
			Gui, MainGUI: Font, s9
			Gui, MainGUI: Add, Edit, % "x" . (debug_col1) . " y74 w100 r0.5 Hwndmouse_screen_position", % " "
			UserInterface.MainGUI.MouseScreenPosition := mouse_screen_position
			Gui, MainGUI: Font, s8
			Gui, MainGUI: Add, Text, % "x" . debug_col1 . " y90", On Client:
			Gui, MainGUI: Font, s9
			Gui, MainGUI: Add, Edit,  % "x" . (debug_col1) . " y102 w100 r0.5 Hwndmouse_client_position", % " "
			UserInterface.MainGUI.MouseClientPosition := mouse_client_position
			return
			
			MouseKeysToggle:
			if !toggle_mouse_keys
			{
				toggle_mouse_keys := true
				Hotkey, Left, LeftKey, On
				Hotkey, Up, UpKey, On
				Hotkey, Down, DownKey, On
				Hotkey, Right, RightKey, On
			}
			else if toggle_mouse_keys
			{
				toggle_mouse_keys := false
				Hotkey, Left, LeftKey, Off
				Hotkey, Up, UpKey, Off
				Hotkey, Down, DownKey, Off
				Hotkey, Right, RightKey, Off
			}
			return
			
			LeftKey:
				MouseGetPos, x, y
				x := --x
				MouseMove, x, y
			return
			
			UpKey:
				MouseGetPos, x, y
				y := --y
				MouseMove, x, y
			return
			
			DownKey:
				MouseGetPos, x, y
				y := ++y
				MouseMove, x, y
			return
			
			RightKey:
				MouseGetPos, x, y
				x := ++x
				MouseMove, x, y	
			return
			
			MouseScreeenPositionToggle:
				if !toggle_mouse_position
				{
					toggle_mouse_position := true
					Debug.AddLine("Unless you need this, you should keep it off.")
					Debug.AddLine("It might impact performance slightly.")
					SetTimer, MousePosition, 150
				}
				else if toggle_mouse_position
				{
					toggle_mouse_position := false
					SetTimer, MousePosition, Off
				}
			return
			MousePosition:
				MouseGetPos, x, y
				ControlSetText,, % "x: " . x . " y: " . y, % "ahk_id " . UserInterface.MainGUI.MouseScreenPosition
				ControlSetText,, % "x: " . (x - AutoOS.Client.Coordinates[1]) . " y: " . (y - AutoOS.Client.Coordinates[2])
							   , % "ahk_id " . UserInterface.MainGUI.MouseClientPosition
			return
		}
		
		CommandDebug(main_gui_x, main_gui_y, main_gui_w, main_gui_h, debug_tools_x, debug_tools_y, debug_tools_w, debug_tools_h)
		{
			debug_col2_x := Round((debug_tools_x + debug_tools_w)/2)-5
			debug_col2_w := 380
			debug_tools_h := main_gui_h - 10
			debug_tools_options := "x" . debug_col2_x . " y5 w" . debug_tools_w . " h" . debug_tools_h
			
			Gui, MainGUI: Add, Text, % "x" . debug_col2_x . " y15", % "Get box coordinates:"
			Gui, MainGUI: Font, s8
			Gui, MainGUI: Add, Edit, % "x" . (debug_col2_x + 110) . " y15 w265 r0.6 Hwndclient_position", % "AutoOS.Coordinates.ClientPosition(x, y, w, h)"
			UserInterface.MainGUI.ClientPosition := client_position
			Hotkey, ^a, ClientPosition, On
			
			Gui, MainGUI: Font, s7
			Gui, MainGUI: Add, Text, % "x" . debug_col2_x . " y32", % "Press CTRL+A on the box top-left corner and then again on the bottom-right corner."
			
			Gui, MainGUI: Font, s9
			Gui, MainGUI: Add, Text, % "x" . debug_col2_x . " y43 w" . debug_col2_w, Script debugger:
			
			Gui, MainGUI: Font, s8
			Gui, MainGUI: Add, Edit, % "x" . debug_col2_x . " y57 r4 Hwndscript_debugger w" . debug_col2_w, Script Debugger
			UserInterface.MainGUI.ScriptDebugger := script_debugger
			return
			
			ClientPosition:
				static x, y, w, h, toggle_client_position
				MouseGetPos, mouse_x, mouse_y
				if !toggle_client_position
				{
					toggle_client_position := true
					x := mouse_x, y := mouse_y
				}
				else if toggle_client_position
				{
					toggle_client_position := false
					w := mouse_x, h := mouse_y
				}
				saved_coordinates := "AutoOS.Coordinates.ClientPositionBox(" . (x - AutoOS.Client.Coordinates[1])
											      . ", " . (y - AutoOS.Client.Coordinates[2])
												  . ", " . (w - AutoOS.Client.Coordinates[1])
												  . ", " . (h - AutoOS.Client.Coordinates[2]) . ")"
				Clipboard := saved_coordinates
				ControlSetText,, % saved_coordinates, % "ahk_id " . UserInterface.MainGUI.ClientPosition
			return
		}
		
	}

}