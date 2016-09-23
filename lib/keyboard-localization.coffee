#util = require('util')
#KeymapLoader = require './keymap-loader'
#KeyMapper = require './key-mapper'
#ModifierStateHandler = require './modifier-state-handler'
# {vimModeActive} = require './helpers'

#KeymapGeneratorView = null
#KeymapGeneratorUri = 'atom://keyboard-localization/keymap-manager'

#createKeymapGeneratorView = (state) ->
#  KeymapGeneratorView ?= require './views/keymap-generator-view'
#  new KeymapGeneratorView(state)

#atom.deserializers.add
#  name: 'KeymapGeneratorView'
#  deserialize: (state) -> createKeymapGeneratorView(state)

KeyboardLocalization =
  pkg: 'keyboard-localization'
  keystrokeForKeyboardEventCb: null
  keymapLoader: null
  keyMapper: null
  modifierStateHandler: null
  keymapGeneratorView: null

  ###
  config:
    useKeyboardLayout:
      type: 'string'
      default: 'de_DE'
      enum: [
        'cs_CZ-qwerty'
        'cs_CZ'
        'da_DK'
        'de_CH'
        'de_DE-neo'
        'de_DE'
        'en_GB'
        'es_ES'
        'es_LA'
        'et_EE'
        'fr_BE'
        'fr_CH'
        'fr_FR'
        'fr_FR-bepo'
        'fr_CA'
        'fi_FI'
        'fi_FI-mac'
        'hu_HU'
        'it_IT'
        'ja_JP'
        'lv_LV'
        'nb_NO'
        'pl_PL'
        'pt_BR'
        'pt_PT'
        'ro_RO'
        'ru_RU'
        'sl_SL'
        'sr_RS'
        'sv_SE'
        'tr_TR'
        'uk_UA'
      ]
      description: 'Pick your locale'
    useKeyboardLayoutFromPath:
      type: 'string'
      default: ''
      description: 'Provide an absolute path to your keymap-json file'
  ###
  
  activate: (state) ->
    options =
      dismissable: true
      detail: """The atom team has managed to integrate support for international\n
      keyboards into atom v1.12.x core.\n
      Feel free to uninstall this package.\n
      See details at:\n
      https://github.com/andischerer/atom-keyboard-localization
      """
    atom.notifications.addInfo('The "keyboard-localization" package has been deprecated!', options)

    ###
    atom.workspace.addOpener (filePath) ->
      createKeymapGeneratorView(uri: KeymapGeneratorUri) if filePath is KeymapGeneratorUri

    atom.commands.add 'atom-workspace',
      'keyboard-localization:keymap-generator': -> atom.workspace.open(KeymapGeneratorUri)

    @keymapLoader = new KeymapLoader()
    @keymapLoader.loadKeymap()
    @keyMapper = KeyMapper.getInstance()
    @modifierStateHandler = new ModifierStateHandler()

    # listen for config changes and load keymap
    @changeUseKeyboardLayout = atom.config.onDidChange [@pkg, 'useKeyboardLayout'].join('.'), () =>
      @keymapLoader.loadKeymap()
      if @keymapLoader.isLoaded()
        @keyMapper.setKeymap(@keymapLoader.getKeymap())
    @changeUseKeyboardLayoutFromPath = atom.config.onDidChange [@pkg, 'useKeyboardLayoutFromPath'].join('.'), () =>
      @keymapLoader.loadKeymap()
      if @keymapLoader.isLoaded()
        @keyMapper.setKeymap(@keymapLoader.getKeymap())

    if @keymapLoader.isLoaded()
      @keyMapper.setKeymap(@keymapLoader.getKeymap())
      @keyMapper.setModifierStateHandler(@modifierStateHandler)

      # Hijack KeymapManager
      # @TODO: Evil hack. Find an better way ...
      @orginalKeyEvent = atom.keymaps.keystrokeForKeyboardEvent
      atom.keymaps.keystrokeForKeyboardEvent = (event) =>
        @onKeyEvent event
    ###

  deactivate: ->
    ###
    if @keymapLoader.isLoaded()
      atom.keymaps.keystrokeForKeyboardEvent = @orginalKeyEvent
      @orginalKeyEvent = null

    @changeUseKeyboardLayout.dispose()
    @changeUseKeyboardLayoutFromPath.dispose()

    @keymapGeneratorView?.destroy()

    @modifierStateHandler = null
    @keymapLoader = null
    @keyMapper = null
    @keymapGeneratorView = null
    ###

  onKeyEvent: (event) ->
    return '' unless event
    @modifierStateHandler.handleKeyEvent(event)

    # check KeyboardEvent already translated:
    # vim-mode calls atom.keymaps.keystrokeForKeyboardEvent for command triggering
    if event.type == 'keydown' && (event.translated or @keyMapper.remap(event))
      character = String.fromCharCode(event.keyCode)
      if vimModeActive(event.target)
        # Shift destroys vim-mode sequence (e.g) 3w on fr_FR layout (shift modifier is needed for number)
        if @modifierStateHandler.isAltGr() or @modifierStateHandler.isShift()
          return character
      return @modifierStateHandler.getStrokeSequence(character)
    else
      return @orginalKeyEvent(event)

module.exports = KeyboardLocalization
