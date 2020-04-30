<!-- PROJECT SHIELDS -->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GNU GPLv3 License][license-shield]][license-url]


<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/AquaShyWasp/AutoOS">
    <img src="assets/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">AutoOS</h3>

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
- DPI scaling.
  - Everything should work and adapt to your
    screen DPI outside of the box.
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
AutoOS.Core.GameTab.Prayer.PrayMelee()
```

You will mostly be using AutoOS.Core class, so you should get familiar with all it's sub-classes and methods.
When making a script, AutoOS debug box can be very helpful. It can display all sorts of useful information, like mouse position, color under mouse, etc.
And gives you an easy way to copy paste useful data.

<!-- ROADMAP -->
## Roadmap

WIP
See the [open issues](https://github.com/AquaShyWasp/AutoOS/issues) for a list of proposed features (and known issues).



<!-- CONTRIBUTING -->
## Contributing

Contributions are welcome though there are some rules.



<!-- LICENSE -->
## License

Distributed under the GNU GPLv3. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

AquaShyWasp - AquaShyWasp@protonmail.com

Project Link: [https://github.com/AquaShyWasp/AutoOS](https://github.com/AquaShyWasp/AutoOS)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

* []()
* []()
* []()





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
[license-shield]: https://img.shields.io/github/license/AquaShyWasp/AutoOS.svg?style=flat-square
[license-url]: https://github.com/AquaShyWasp/AutoOS/blob/master/LICENSE
[product-screenshot]: images/screenshot.png
