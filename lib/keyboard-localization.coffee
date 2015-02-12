KeyMapper = require './key-mapper'

module.exports =
  keystrokeForKeyboardEventCb: null
  keyMapper: null
  configDefaults:
    useKeyboardLayout: 'de_DE'
    
  activate: (state) ->
    if atom
      # create Translator
      @keyMapper = new KeyMapper()

      @keystrokeForKeyboardEventCb = atom.keymap.keystrokeForKeyboardEvent
      self = @
      # Hijack KeymapManager
      # @TODO: Evil hack. Find an better way ...
      atom.keymap.keystrokeForKeyboardEvent = (event) ->
        self.keyDown event

  deactivate: ->
    if atom
      atom.keymap.keystrokeForKeyboardEvent = @keystrokeForKeyboardEventCb
      @keystrokeForKeyboardEventCb = null
      @keyMapper = null

  keyDown: (event, cb) ->
    newKeyEvent = @keyMapper.remap(event)
    return @keystrokeForKeyboardEventCb(newKeyEvent)
