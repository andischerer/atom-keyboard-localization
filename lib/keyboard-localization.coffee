KeyMapper = require './key-mapper'

module.exports =
  pkg: 'keyboard-localization'
  keystrokeForKeyboardEventCb: null
  keyMapper: null

  config:
    useKeyboardLayout:
      type: 'string'
      default: 'de_DE'
      enum: [
        'de_DE'
        'de_DE-neo'
        'es_ES'
        'fr_FR'
        'pl_PL'
      ]
      description: 'Pick your locale'
    useKeyboardLayoutFromPath:
      type: 'string'
      default: ''
      description: 'Provide an absolute path to your keymap-json file'

  activate: (state) ->
    if atom
      # create Translator
      @keyMapper = new KeyMapper()

      #config changes
      @changeUseKeyboardLayout = atom.config.onDidChange [@pkg,'useKeyboardLayout'].join('.'), () =>
        @keyMapper.loadTranslationTable()
      @changeUseKeyboardLayoutFromPath = atom.config.onDidChange [@pkg,'useKeyboardLayoutFromPath'].join('.'), () =>
        @keyMapper.loadTranslationTable()

      # KeymapManager no-binding found subscription
      @didFailToMatchBinding = atom.keymaps.onDidFailToMatchBinding =>
        @keyMapper.didFailToMatchBinding(event)

      @keystrokeForKeyboardEventCb = atom.keymaps.keystrokeForKeyboardEvent
      # Hijack KeymapManager
      # @TODO: Evil hack. Find an better way ...
      atom.keymaps.keystrokeForKeyboardEvent = (event) =>
        @keyDown event

  deactivate: ->
    if atom
      atom.keymaps.keystrokeForKeyboardEvent = @keystrokeForKeyboardEventCb
      @keystrokeForKeyboardEventCb = null
      @changeUseKeyboardLayout.dispose()
      @changeUseKeyboardLayoutFromPath.dispose()
      @didFailToMatchBinding.dispose()
      @keyMapper = null

  keyDown: (event, cb) ->
    newKeyEvent = @keyMapper.remap(event)
    return @keystrokeForKeyboardEventCb(newKeyEvent)
