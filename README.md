# Keyboard localization package for non US-Keyboard Layouts
This is a compatibility package for atom text editor which tries to remap keycodes for your given keyboard layout.
This package tries to fill the gap till [this issue](https://github.com/atom/atom-keymap/issues/37) is fixed.

## Generate your own keymap
You can generate your own localized key-translation-table for your keyboard layout.
Open the generator `keybinding-generator\generate-keybindings.html` included in this package in Chrome(other Browsers may not work) and press all keys(with and without modifiers Shift/Alt) from your keyboard who differ from the US-Layout. Copy the generated JSON-keybindings and place it as Json-File in `lib\keymaps\`.
Then set the package setting `useKeyboardLayout` to your given filename(without fileextension)

German keybindings are already included.

Feel free to send me PRs so i can add more bindings.



## Changelog
### v1.1.1:
- fixed wrong translation table path in config #4

### v1.1.0:
- complete rewrite
- added german key translations

### v1.0.1:
- fixes common atom core bindings
- fixes common vim-mode bindings

### v1.0.0:
- Initial Release from [DavidBadura](https://github.com/DavidBadura)
- fixes at-sign and backslash use


## Credits
All thanks go to original author -> [DavidBadura](https://github.com/DavidBadura)
