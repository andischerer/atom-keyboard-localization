# Keyboard localization package for non US-Keyboard Layouts
This is a compatibility package for atom text editor which tries to remap keycodes for your given keyboard layout.

## Installation ##
### From atom GUI
Go in Atom's **Settings** page, through **packages** section. Under **Community Packages** search for "*keyboard-localization*" and Install it.

### From commandline
Open commandline and install this package by executing the following command:
```
apm install keyboard-localization
```

## Usage ##
Inside Atom's packages management, click **Settings**, and in the freshly opened panel, either choose an existing Keyboard Layout from the list, or pick a keymap file from the filepicker.

## Whats working
* Prevent default keybindings from being fired
* Keybindings in your local keyboard layout
* AltGr-Key
* vim-mode/vim-mode-plus keybindings
* tested on Windows and Linux
* Multi-combo bindings (AltGr+Shift)

## Supported Keyboard Layouts atm
* [German 105-key "QWERTZ"](http://en.wikipedia.org/wiki/File:KB_Germany.svg) (`de_DE`)
* [German Neo-Layout](http://www.neo-layout.org/) (`de_DE-neo`)
* [Spanish](https://www.terena.org/activities/multiling/ml-mua/test/img/kbd_spanish.gif) (`es_ES`)
* [Spanish Latin](http://mylingos.com/keyboards/images/latinamerican.gif) (`es_LA`)
* [Finnish](http://i.stack.imgur.com/leHzl.png) (`fi_FI`)
* [Finnish(Mac)](http://i.stack.imgur.com/leHzl.png) (`fi_FI-mac`)
* [French](https://www.terena.org/activities/multiling/ml-mua/test/img/kbd_french.gif) (`fr_FR`)
* [French BÉPO](http://download.tuxfamily.org/dvorak/wiki/images/Carte-bepo-complete.png) (`fr_FR`)
* [Belgian French](https://upload.wikimedia.org/wikipedia/commons/9/93/Belgian_keyboard_layout.png) (`fr_BE`)
* [Swiss German](https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/KB_Swiss.svg/450px-KB_Swiss.svg.png) (`de_CH`)
* [Swiss French](https://support.apple.com/en-us/HT201794)(`fr_CH` fr_ML)
* [Canadian French](http://i.stack.imgur.com/ryQxs.png) (`fr_CA`)
* [Polish Programmer](http://upload.wikimedia.org/wikipedia/commons/6/6e/Polish_programmer%27s_layout.PNG) (`pl_PL`)
* [Danish](http://fontmeme.com/images/danish-keyboard-550x183.png) (`da_DK`)
* [Norwegian](http://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/KB_Norway.svg/2000px-KB_Norway.svg.png) (`nb_NO`) - untested
* [Swedish](http://frontype.com/keyboarding/540px-Computer-keyboard-Sweden.svg.png) (`sv_SE`)
* [Hungarian](https://www.terena.org/activities/multiling/ml-mua/test/img/kbd_hungary.gif) (`hu_HU`)
* [Romanian](http://upload.wikimedia.org/wikipedia/commons/f/f0/Romanian-keyboard-layout.png) (`ro_RO`) - untested
* [Slovenian](http://smotko.si/assets/pics/keyboard.png) (`sl_SL`)
* [Italian](https://www.terena.org/activities/multiling/ml-mua/test/img/kbd_italian.gif) (`it_IT`)
* [Portuguese](https://www.terena.org/activities/multiling/ml-mua/test/img/kbd_portug.gif) (`pt_PT`) - untested
* Latvian (`lv_LV`)
* [Portuguese Brazilian (ABNT2)](http://upload.wikimedia.org/wikipedia/commons/thumb/1/17/KB_Portuguese_Brazil.svg/1280px-KB_Portuguese_Brazil.svg.png) (`pt_BR`)
* Japanese (`ja_JP`)
* Czech-qwertz (`cs_CZ`)
* [Czech-qwerty](https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Qwerty_cz.svg/1000px-Qwerty_cz.svg.png) (`cs_CZ-qwerty`)
* [Estonian](https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/KB_Estonian.svg/900px-KB_Estonian.svg.png) (`et_EE`)
* Serbian (`sr_RS`)
* [United Kingdom](https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/KB_United_Kingdom.svg/900px-KB_United_Kingdom.svg.png) (`en_GB`)
* Turkish (`tr_TR`)
* Russian (`ru_RU`)
* Ukrainian (`uk_UA`)

## Generate your own keymap
![](https://raw.github.com/andischerer/atom-keyboard-localization/master/screenshots/keymap-generator.gif)
You can generate your own localized key-translation-table for your keyboard layout.
The generator is available in from the command palette(`Keyboard Localization: Keymap Generator`)
Generate your mapping by tapping every key in combination with modifiers from your keyboard who differ from the US-Layout.
Copy the generated JSON-keybindings and create a Json-File.
Then set the package setting `useKeyboardLayoutFromPath` to your given filename(absolute path).

Feel free to send me Issues/PRs so i can add more keymaps.

## Todo
* add more foreign Keyboard-Layouts
* write tests
* ~~add custom path for keymap file~~

## This package tries to fill the gap till the following issues are fixed
* [Chromium Issue 263724: KeyboardEvent does not match the latest specification](https://code.google.com/p/chromium/issues/detail?id=263724)
* [Chromium Issue 300475: Issues with non US keyboard layout keyboard events or editing](https://code.google.com/p/chromium/issues/detail?id=300475)
* [Chromium Issue 168971: Implement 'locale' attribute in KeyboardEvent](https://code.google.com/p/chromium/issues/detail?id=168971)
* [Atom Issue 35: Right ALT not supported (bad for International Keyboards)](https://github.com/atom/atom-keymap/issues/35)
* [Atom Issue 37: Foreign keyboard layouts not working](https://github.com/atom/atom-keymap/issues/37)

## Credits
All thanks go to original author -> [DavidBadura](https://github.com/DavidBadura)
