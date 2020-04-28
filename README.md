# AutoOS
AutoOS is a AutoHotkey color bot for OldSchool RuneScape.


AutoOS is a pure color and math bot, it reads the pixels colors on your screen, their position, your mouse position and uses math to figure everything.
Because AutoOS only uses color, you can use AutoOS with any client though I only support RuneLite and the official client at the moment.

Also, since AutoOS doesn't use reflection nor injection, in theory, as long as the antiban is good enough it's undetectable.


AutoOS features:
script loader
text reading (under work)
Asynchronous mouse
Asynchronous keyboard


To use a script with AutoOS, you only need to add it to the scripts folder,
run AutoOS and launch your script from AutoOS.



If you are a developer, AutoOS is basically a large framework with all the boring and hard work already done for you.
To make your own script for AutoOS:

Create your script in the scripts folder.
add this line at the top:

#Include ./lib/AOS.ahk

