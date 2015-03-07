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
        'da_DK'
        'de_DE-neo'
        'de_DE'
        'es_ES'
        'fr_FR'
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
