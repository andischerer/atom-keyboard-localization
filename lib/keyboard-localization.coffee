util = require('util')
KeymapLoader = require './keymap-loader'
KeyMapper = require './key-mapper'
EventedModifierStateHandler = require './evented-modifier-state-handler'
KeymapGeneratorView = null

KeymapGeneratorUri = 'atom://keyboard-localization/keymap-manager'

createKeymapGeneratorView = (state) ->
  KeymapGeneratorView ?= require './keymap-generator-view'
  new KeymapGeneratorView(state)

atom.deserializers.add
  name: 'KeymapGeneratorView'
  deserialize: (state) -> createKeymapGeneratorView(state)

module.exports =
  pkg: 'keyboard-localization'
  keystrokeForKeyboardEventCb: null
  keymapLoader: null
  keyMapper: null
  modifierStateHandler: null
  keyUpEventListener: null
  clearModifierStateListener: null
  keymapGeneratorView: null

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
    atom.workspace.addOpener (filePath) ->
      createKeymapGeneratorView(uri: KeymapGeneratorUri) if filePath is KeymapGeneratorUri

    atom.commands.add 'atom-workspace',
      'keyboard-localization:keymap-generator': -> atom.workspace.open(KeymapGeneratorUri)

    @keymapLoader = new KeymapLoader()
    @keymapLoader.loadKeymap()
    @keyMapper = new KeyMapper()
    @modifierStateHandler = new EventedModifierStateHandler()

    # listen for config changes on useKeyboardLayout
    @changeUseKeyboardLayout = atom.config.onDidChange [@pkg, 'useKeyboardLayout'].join('.'), () =>
      @keymapLoader.loadKeymap()
      if @keymapLoader.isLoaded()
        @keyMapper.setKeymap(@keymapLoader.getKeymap())

    # listen for config changes on useKeyboardLayoutFromPath
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

      # clear modifiers on editor blur and focus
      @clearModifierStateListener = () =>
        @modifierStateHandler.clearModifierState()
      window.addEventListener 'blur', @clearModifierStateListener
      window.addEventListener 'focus', @clearModifierStateListener

      # Keyup-Event for EventedModifierStateHandler
      @keyUpEventListener = (event) =>
        @onKeyUp(event)
      document.addEventListener 'keyup', @keyUpEventListener

      # Hijack KeymapManager
      # @TODO: Evil hack. Find an better way ...
      @orginalKeydownEvent = atom.keymaps.keystrokeForKeyboardEvent
      atom.keymaps.keystrokeForKeyboardEvent = (event) =>
        @onKeyDown event

  deactivate: ->
    if @keymapLoader.isLoaded()

      atom.keymaps.keystrokeForKeyboardEvent = @orginalKeydownEvent
      @orginalKeydownEvent = null

      document.removeEventListener 'keyup', @keyUpEventListener

      window.removeEventListener 'blur', @clearModifierStateListener
      window.removeEventListener 'focus', @clearModifierStateListener

      @didFailToMatchBinding.dispose()

    @changeUseKeyboardLayout.dispose()
    @changeUseKeyboardLayoutFromPath.dispose()

    @keymapGeneratorView?.destroy()

    @modifierStateHandler = null
    @keymapLoader = null
    @keyMapper = null
    @keymapGeneratorView = null

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
