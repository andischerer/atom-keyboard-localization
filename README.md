# Keyboard localization package for non US-Keyboard Layouts
This is a compatibility package for atom text editor which tries to remap keycodes for your given keyboard layout.
This package tries to fill the gap till [this issue](https://github.com/atom/atom-keymap/issues/37) is fixed.

## Supported Keyboard Layouts atm
* German 105-key "QWERTZ"

Feel free to send me Issues/PRs so i can add more bindings.

## Generate your own keymap
You can generate your own localized key-translation-table for your keyboard layout.
Open the generator `keybinding-generator\generate-keybindings.html` included in this package in Chrome(other Browsers may not work) and press all keys(with and without modifiers Shift/Alt) from your keyboard who differ from the US-Layout. Copy the generated JSON-keybindings and place it as Json-File in `lib\keymaps\`.
Then set the package setting `useKeyboardLayout` to your given filename(without fileextension)

__IMPORTANT NOTE__: Please backup your generated JSON-keybindings. They could get lost on package update!

## Todo
* add more foreign Keyboard-Layouts

## Credits
All thanks go to original author -> [DavidBadura](https://github.com/DavidBadura)
