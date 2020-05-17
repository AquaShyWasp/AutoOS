<!-- PROJECT SHIELDS -->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GPL-3.0 License][license-shield]][license-url]


<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/AquaShyWasp/AutoOS">
    <img src="assets/logo.png" alt="Logo">
  </a>

  <p align="center">
    AutoHotkey color bot for OldSchool RuneScape.
  </p>
</p>


<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About AutoOS](#about-autoos)
  * [AutoOS features](#autoos-features)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Setup](#setup)
* [Make scripts for AutoOS](#make-scripts-for-autoos)
* [Roadmap](#roadmap)
* [Contributing](#contributing)
* [License](#license)
* [Contact](#contact)
* [Acknowledgements](#acknowledgements)



## About AutoOS
AutoOS is a pure color and math bot, it reads the
pixels on your screen, their color, their position,
your mouse position and uses math to figure out
everything.

Because AutoOS uses color only, you can use it
with any client though I only officially support
RuneLite and the official client at the moment.

Also, since AutoOS doesn't use reflection nor
injection, in theory, it's undetectable.

### AutoOS features:
- Script loader.
- Player manager.
  - Setup several accounts.
  - Accounts act different from each other.
  - Account sensitive data is encrypted.
- Asynchronous input.
  - Mouse and keyboard can move and press keys
    independent from each other and at the same
    time.
- <del>DPI scaling.
  - Everything should work and adapt to your
    screen DPI outside of the box.</del>
- Great Antiban.
  - Lot's of random variables and several random
    profiles for everyone.
- Easy to use.
- Easy to develop scripts.




## Getting Started

To use AutoOS is easy to use and setup.

### Prerequisites
1. Download and install
   [AutoHotkey](https://www.autohotkey.com/)
   current version (v1.1.32).
1. Download and run one of the supported osrs
   clients.
   - RuneLite.
   - OSRS official client.
   - Different clients should work but are not
     tested.
1. Download AutoOS and keep all of it's contents
   on the same folder.
   - You can optionally make a shortcut of
     AutoOS.ahk and place it on your desktop.

### Setup
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


## Make scripts for AutoOS

If you are a developer, AutoOS is basically a large framework with all the boring and hard work already done for you.

To make your own script for AutoOS, first create your script in the scripts folder.

You must name it this way:

`[Category]ScriptName.ahk`

In Category you can type whatever you want but would be nice if everyone uses
a set of standard categories.


Add this lines at the top of your script:

```
ScriptLoaded := true

RunScript()
{
	; Your script goes here.
	; From here you can either insert your script directly or call functions/methods/etc.
	return
}
```

Personally I'm a Scite4ahk user, but until you are familiar with AutoOS classes, methods and functions,
I would recommend you use AHKStudio.
This is because AHKStudio makes an excellent at autocompleting stuff that is included or is in a library while Scite4ahk doesn't do it so well.
This is the reason we add the code above at the top of our script, so your IDE/Text editor can fetch AutoOS classes and functions.

After that you can start develop your script.

AutoOS makes it very easy to develop a script, for example if you want your script to click the first inventory slot and turn pray melee on you can just type:

```
AutoOS.Core.GameTab.Inventory.ClickSlot(1)
AutoOS.Core.GameTab.Prayer.PrayMelee()
```

You will mostly be using AutoOS.Core class, so you should get familiar with all it's sub-classes and methods.
When making a script, AutoOS debug box can be very helpful. It can display all sorts of useful information, like mouse position, color under mouse, etc.
And gives you an easy way to copy paste useful data.

<!-- ROADMAP -->
## Roadmap
See the [open issues](https://github.com/AquaShyWasp/AutoOS/issues) for a list of proposed features (and known issues).
Click here to check the current [Roadmap](https://github.com/AquaShyWasp/AutoOS/ROADMAP.md).


<!-- CONTRIBUTING -->
## Contributing

Contributions are welcome though they should follow
this guidelines:
- Keep the current programming style.
  - `local my_variable`
  - `static MyVariable`
  - `global MY_VARIABLE`
  - `class MyClass`
  - `MyFunction(my_parameter, other_parameter)`
- Readability over speed.
  - Fast code is important but if it's hard to
    understand, it's also hard to fix something that is
    not working properly later on.
  - Fast code that is well explained with comments
    and/or is easy to grasp is very welcome though.
- There's no need for many way to do the same thing.
- Get familiar with my versioning.
- A bot is nothing without good scripts, if you
  have a script you would like to make public let
  me know! You can and should display your own ads!


<!-- LICENSE -->
## License

Distributed under the GNU GPLv3. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

[AquaShyWasp](https://join.status.im/u/0x04511f0beacc1f24f6af274e09915145791ac768109052007a6e383bb426632a6a65bf6dd28c5a0d61263d0c383e74f514f6baa985e1efeefcaf7fe079fdd60736)
on Status
AquaShyWasp@protonmail.com

Project Link: [https://github.com/AquaShyWasp/AutoOS](https://github.com/AquaShyWasp/AutoOS)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

* [SRL](https://github.com/SRL)
* [AutoHotkey](https://www.autohotkey.com)




<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/AquaShyWasp/AutoOS.svg?style=flat-square
[contributors-url]: https://github.com/AquaShyWasp/AutoOS/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/AquaShyWasp/AutoOS.svg?style=flat-square
[forks-url]: https://github.com/AquaShyWasp/AutoOS/network/members
[stars-shield]: https://img.shields.io/github/stars/AquaShyWasp/AutoOS.svg?style=flat-square
[stars-url]: https://github.com/AquaShyWasp/AutoOS/stargazers
[issues-shield]: https://img.shields.io/github/issues/AquaShyWasp/AutoOS.svg?style=flat-square
[issues-url]: https://github.com/AquaShyWasp/AutoOS/issues
[license-shield]: https://img.shields.io/badge/license-GPL--3.0-orange?style=flat-square
[license-url]: https://github.com/AquaShyWasp/AutoOS/blob/master/LICENSE
