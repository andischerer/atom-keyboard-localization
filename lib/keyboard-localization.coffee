util = require('util')
KeyMapper = require './key-mapper'
ModifierStateHandler = require './modifier-state-handler'

module.exports =
  pkg: 'keyboard-localization'
  keystrokeForKeyboardEventCb: null
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
      @keyMapper = new KeyMapper()
      @modifierStateHandler = new ModifierStateHandler()

      @keyMapper.setModifierStateHandler(@modifierStateHandler)

      # listen for config changes
      @changeUseKeyboardLayout = atom.config.onDidChange [@pkg, 'useKeyboardLayout'].join('.'), () =>
        @keyMapper.loadTranslationTable()
      @changeUseKeyboardLayoutFromPath = atom.config.onDidChange [@pkg, 'useKeyboardLayoutFromPath'].join('.'), () =>
        @keyMapper.loadTranslationTable()

      # KeymapManager no-binding-found subscription
      @didFailToMatchBinding = atom.keymaps.onDidFailToMatchBinding =>
        @keyMapper.didFailToMatchBinding(event)

      # Keyup-Event for ModifierStateHandler
      document.addEventListener 'keyup', (event) =>
        @onKeyUp(event)

      # Hijack KeymapManager
      # @TODO: Evil hack. Find an better way ...
      @orginalKeydownEvent = atom.keymaps.keystrokeForKeyboardEvent
      atom.keymaps.keystrokeForKeyboardEvent = (event) =>
        @onKeyDown event

  deactivate: ->
    if atom
      atom.keymaps.keystrokeForKeyboardEvent = @orginalKeydownEvent
      @orginalKeydownEvent = null

      document.removeEventListener 'keyup', @onKeyUp

      @changeUseKeyboardLayout.dispose()
      @changeUseKeyboardLayoutFromPath.dispose()
      @didFailToMatchBinding.dispose()

      @modifierStateHandler = null
      @keyMapper = null

  createNewKeyDownEvent: (event) ->
    keyDownEvent = util._extend({} , event)
    keyDownEvent.currentTarget = null
    keyDownEvent.eventPhase = 0
    keyDownEvent.keyTranslated = false
    return keyDownEvent

  onKeyDown: (event, cb) ->
    newKeyEvent = @createNewKeyDownEvent(event)
    @modifierStateHandler.onKeyDown(newKeyEvent)
    @keyMapper.remap(newKeyEvent)
    return @orginalKeydownEvent(newKeyEvent)

  onKeyUp: (event) ->
    @modifierStateHandler.onKeyUp(event)
