# Keyboard localization package for non US-Keyboard Layouts
This is a compatibility package for atom text editor which tries to remap keycodes for your given keyboard layout.
This package tries to fill the gap till [this issue](https://github.com/atom/atom-keymap/issues/37) is fixed.

## Whats working
* Keybindings in your foreign keyboard layout
* AltGr-Key (works for me on german layout)
* vim-mode keybindings
* tested on Windows and Linux

## Supported Keyboard Layouts atm
* [German 105-key "QWERTZ"](http://en.wikipedia.org/wiki/File:KB_Germany.svg) (`de_DE`)
* [German Neo-Layout](http://www.neo-layout.org/) (`de_DE-neo`) - thx [ScreenDriver](https://github.com/ScreenDriver)
* [Spanish](https://www.terena.org/activities/multiling/ml-mua/test/img/kbd_spanish.gif) (`es_ES`) - untested
* [French](https://www.terena.org/activities/multiling/ml-mua/test/img/kbd_french.gif) (`fr_FR`) - untested
* [Polish](https://www.terena.org/activities/multiling/ml-mua/test/img/kbd_polish.gif) (`pl_PL`) - untested

Feel free to send me Issues/PRs so i can add more keymaps.

## Generate your own keymap
You can generate your own localized key-translation-table for your keyboard layout.
Open the generator `keybinding-generator\generate-keybindings.html` included in this package in Chrome(other Browsers may not work) and press all keys(with and without modifiers Shift/Alt) from your keyboard who differ from the US-Layout. Copy the generated JSON-keybindings and create a Json-File.
Then set the package setting `UseKeyboardLayoutFromPath` to your given filename(absolute path).

## Todo
* add more foreign Keyboard-Layouts
* write tests
* ~~add custom path for keymap file~~

## Credits
All thanks go to original author -> [DavidBadura](https://github.com/DavidBadura)
