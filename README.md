# AutoOS
AutoOS is a AutoHotkey color bot for OldSchool RuneScape.


AutoOS is a pure color and math bot, it reads the pixel colors on your screen, their position, your mouse position and uses math to figure everything out.
Because AutoOS only uses color, you can use AutoOS with any client though I only officially support RuneLite and the official client at the moment.

Also, since AutoOS doesn't use reflection nor injection, in theory, as long as the antiban is good enough it's undetectable.


### AutoOS features:
- Script loader.
- Player manager.
  - Setup several accounts.
  - Accounts act different from each other.
  - Account sensitive data is encrypted.
- Asynchronous input.
  - Mouse and keyboard can move and press keys independent from each other and at the same time.
- Great Antiban.
- Easy to develop scripts.



## How to use AutoOS

To use AutoOS you only need 3 things:
1. Download and install [AutoHotkey](https://www.autohotkey.com/) current version (v1.1.32).
1. Download and run one of the supported osrs clients.
   - RuneLite.
   - Official client.
   - Different clients should work but are not tested.
1. Download AutoOS and keep all of it's contents on the same folder.
   - You can make a shortcut of AutoOS.ahk and place it in your desktop if you want.

Once you have everything:
1. Start your osrs client and wait for it to finish loading.
1. Run AutoOS.ahk
1. If you want AutoOS to be able to login and unlock the bank by itself
 type a new master password on the prompt, otherwise you can just press enter leaving it empty.
1. Open the player manager and add a new player.
   - Your account info is optional.
   - If you want to add your account information the master password will keep your account details encrypted.
   - Add your FKeys the same way you have them setup on you account. This is important.
1. To use a script, simply press the script launcher and choose the script you want to run!
   - You can download or make new scripts yourself.
   - Place new scripts on the scripts folder.


## How to make scripts for AutoOS
If you are a developer, AutoOS is basically a large framework with all the boring and hard work already done for you.

To make your own script for AutoOS:
Create your script in the scripts folder.
Add this lines at the top:

```
If StrInclude(A_ScriptDir, "AutoOS/Scripts")
  #Include ./lib/AOS.ahk
```

This can be removed when you finish the script but it's useful to have while
you develop the script.

Personally I'm a Scite4ahk user, but until you are familiar with AutoOS classes, methods and functions,
 I would recommend you use AHKStudio.
This is because AHKStudio makes an excellent at autocompleting stuff that is included or is in a library while Scite4ahk doesn't do it so well.
This is the reason we add the code above at the top of our script, so your IDE/Text editor can fetch AutoOS classes and functions.

After that you can start develop your script.

AutoOS makes it very easy to develop a script, for example if you want your script to click the first inventory slot and turn pray melee on you can just type:

```
AutoOS.Core.GameTab.Inventory.ClickSlot(1)
AutoOS.Core.GameTab.Prayer.PrayMelee
```
