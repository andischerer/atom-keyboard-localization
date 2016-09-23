## 1.5.0
* Final release => package is deprecated

## 1.4.18
* fixed atom.engines atom-beta channel support 

## 1.4.17
* fixed altgr keyup listener on atom >1.7

## 1.4.16
* reverted: altgr-{ and altgr-} in es_LA
* fixed: tr_TR layout
* added uk_UA layout

## 1.4.15
* added tr_TR layout
* added ru_RU layout
* added en_EN layout
* fixed: AltGr + b should be { in Czech-qwerty
* fixed: altgr-{ and altgr-} in es_LA
* fixed: { output as \ in fr_CA

## 1.4.14
* fixed fi_FI layout
* added cs_CZ-qwertz layout
* upgraded package dependencies

## 1.4.13
* fixed de_CH layout
* prevent double translating of KeyboardEvents
* fixed shift modifier in vim-mode sequence

## 1.4.12
* add compatibility for vim-mode-plus package
* added fi_FI-mac layout
* Fixed curly braces for it_IT layout
* onKeyDown event check

## 1.4.11
* fixed fr_FR layout
* fixed fr_BE layout
* added sr_RS layout

## 1.4.10
* fixed danish keyboard layout - thx [nesizer]((https://github.com/nesizer)
* added finish keyboard layout - thx [kurkku]((https://github.com/kurkku)
* added estonian keyboard layout - thx [Ingramz]((https://github.com/Ingramz)
* added french bépo keyboard layout - thx [Dragnalith]((https://github.com/Dragnalith)
* fixed composing keys in sl_SL keyboard layout #55
* fixed pt_PT keycode 220 bug

## 1.4.9
* fixed #64
* fixed #67
* added de_CH keyboard layout - thx [AlexRRR](https://github.com/AlexRRR)
* added fr_CH Keyboard layout - thx [gpasa](https://github.com/gpasa)
* fixed #65. Replace `util._extend` with `jQuery.extend` - thx [zambotn](https://github.com/zambotn)
* updated atom-space-pen-views dependency

## 1.4.8
* fix for vim motions
* added cs_CZ-qwerty keyboard layout - thx [ivoszz](https://github.com/ivoszz)
* fixed #56

## 1.4.7
* fixes/refactoring for #49 #47 #46 #39
* fixed keycode 220 bug in es_ES, fr_FR, nb_NO, sv_SE - see pr #42
* added ja_JP keyboard layout - thx [nakashk](https://github.com/nakashk)

## 1.4.6
* fixed #43 accent keys work as expected

## 1.4.5
* fixed #43 autoflow and code folding being triggered

## 1.4.4
* fixed #43 Two characters when entered only one

## v1.4.3
* fixed pl_PL keymap

## v1.4.2
* fixed pl_PL keymap - thx [logity](https://github.com/logity), [macocha](https://github.com/macocha)

## v1.4.1
* added pt_BR keyboard layout - thx [juracy](https://github.com/juracy)

## v1.4.0
* Fix Linux AltGr handling
* Migration: Keymap Generator into Atom-View
* added el_LA keyboard layout - thx [dagonar](https://github.com/dagonar)

## v1.3.1
* reworked modifier-state-handler
* added lv_LV keyboard layout - thx [tomaac](https://github.com/tomaac)
* docs updated - thx [cyrilchapon](https://github.com/cyrilchapon)
* fixed fr_BE keymap - thx [Soofe](https://github.com/Soofe)

## v1.3.0
* support for Alt+Shift modifier bindings
* added altshifted-bindings for pl_PL layout

## v1.2.1
* Complete it_IT layout
* partially fix fr_FR layout
* partially fix for es_ES layout

## v1.2.0
* added fr_CA keyboard layout - thx [sportebois](https://github.com/sportebois)
* improved modifier handling
* fixed deprecation call
* fixed number row on "fr_FR" layout

## v1.1.7
* added fr_BE keyoard layout - thx [filoozom](https://github.com/filoozom)
* fixed: accent marks should not get doubled (e.g `^` key on german-layout)

## v1.1.6
* fixed the ">" character issue in fr_FR layout

## v1.1.5
* added danish keyboard layout
* added norwegian keyboard layout
* added swedish keyboard layout
* added hungarian keyboard layout
* added romanian keyboard layout
* added slovenian keyboard layout
* added italian keyboard layout
* added portuguese keyboard layout

## v1.1.4
* Bugfix: Issue #7 prevent default keybindings from being fired

## v1.1.3
* added spain keyboard layout
* added french keyboard layout
* added polish keyboard layout
* small fixes in keybinding-generator
* config: choose a locale or use a custom path

## v1.1.2:
* added German Neo-Layout - thx [ScreenDriver](https://github.com/ScreenDriver)

## v1.1.1:
* fixed wrong translation table path in config #4

## v1.1.0:
* complete rewrite
* added german key translations

## v1.0.1:
* fixes common atom core bindings
* fixes common vim-mode bindings

## v1.0.0:
* Initial Release from [DavidBadura](https://github.com/DavidBadura)
* fixes at-sign and backslash use
