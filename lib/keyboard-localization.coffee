util = require('util')
KeymapLoader = require './keymap-loader'
KeyMapper = require './key-mapper'
ModifierStateHandler = require './modifier-state-handler'

module.exports =
  pkg: 'keyboard-localization'
  keystrokeForKeyboardEventCb: null
  keymapLoader: null
  keyMapper: null
  modifierStateHandler: null

  config:
    useKeyboardLayout:
      type: 'string'
      default: 'de_DE'
      enum: [
        'da_DK'
        'de_DE-neo'
        'de_DE'
        'es_ES'
        'fr_BE'
        'fr_FR'
        'fr_CA'
        'hu_HU'
        'it_IT'
        'nb_NO'
        'pl_PL'
        'pt_PT'
        'ro_RO'
        'sl_SL'
        'sv_SE'
      ]
      description: 'Pick your locale'
    useKeyboardLayoutFromPath:
      type: 'string'
      default: ''
      description: 'Provide an absolute path to your keymap-json file'

  activate: (state) ->
    if atom
      @keymapLoader = new KeymapLoader()
      @keymapLoader.loadKeymap()
      @keyMapper = new KeyMapper()
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

        # KeymapManager no-binding-found subscription
        @didFailToMatchBinding = atom.keymaps.onDidFailToMatchBinding =>
          @keyMapper.didFailToMatchBinding(event)

        # Hijack KeymapManager
        # @TODO: Evil hack. Find an better way ...
        @orginalKeydownEvent = atom.keymaps.keystrokeForKeyboardEvent
        atom.keymaps.keystrokeForKeyboardEvent = (event) =>
          @onKeyDown event

  deactivate: ->
    if atom
      if @keymapLoader.isLoaded()

        atom.keymaps.keystrokeForKeyboardEvent = @orginalKeydownEvent
        @orginalKeydownEvent = null

        @didFailToMatchBinding.dispose()

      @changeUseKeyboardLayout.dispose()
      @changeUseKeyboardLayoutFromPath.dispose()

      @modifierStateHandler = null
      @keymapLoader = null
      @keyMapper = null

  createNewKeyDownEvent: (event) ->
    keyDownEvent = util._extend({} , event)
    keyDownEvent.currentTarget = null
    keyDownEvent.eventPhase = 0
    keyDownEvent.keyTranslated = false
    return keyDownEvent

  onKeyDown: (event, cb) ->
    newKeyEvent = @createNewKeyDownEvent(event)
    @modifierStateHandler.handleKeyEvent(newKeyEvent)
    @keyMapper.remap(newKeyEvent)
    return @orginalKeydownEvent(newKeyEvent)
