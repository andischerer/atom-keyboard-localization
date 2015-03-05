path = require('path')
fs = require('fs-plus')
util = require('util')

module.exports =
class KeyMapper
  pkg: 'keyboard-localization'
  translationTable: null
  newKeyDownEvent: null

  constructor: ->
    @loadTranslationTable()

  destroy: ->
    @translationTable = null

  loadTranslationTable: ->
    useKeyboardLayout = atom.config.get([@pkg,'useKeyboardLayout'].join('.'))
    if useKeyboardLayout?
      pathToTransTable = path.join(
        __dirname,
        'keymaps',
        useKeyboardLayout + '.json'
      )

    useKeyboardLayoutFromPath = atom.config.get([@pkg,'useKeyboardLayoutFromPath'].join('.'))
    if useKeyboardLayoutFromPath?
      customPath = path.normalize(useKeyboardLayoutFromPath)
      if fs.isFileSync(customPath)
        pathToTransTable = customPath

    if fs.isFileSync(pathToTransTable)
      tansTableContentJson = fs.readFileSync(pathToTransTable, 'utf8')
      @translationTable = JSON.parse(tansTableContentJson)
      console.log(@pkg, 'Keymap loaded "' + pathToTransTable + '"')
    else
      console.log(@pkg, 'Error loading keymap "' + pathToTransTable + '"')

  createNewKeyDownEvent: (event) ->
    keyDownEvent = util._extend({} , event)
    keyDownEvent.currentTarget = null
    keyDownEvent.eventPhase = 0
    keyDownEvent.keyTranslated = false
    return keyDownEvent

  # copy from atom-keymap/helpers.coffee
  charCodeFromKeyIdentifier: (keyIdentifier) ->
    parseInt(keyIdentifier[2..], 16) if keyIdentifier.indexOf('U+') is 0

  padZero: (strToPad, size) ->
    while strToPad.length < size
      strToPad = '0' + strToPad
    return strToPad

  charCodeToKeyIdentifier: (charCode) ->
    return 'U+' + @padZero(charCode.toString(16).toUpperCase(), 4)

  translateKeyBinding: (keyDownEvent) ->
    identifier = @charCodeFromKeyIdentifier(keyDownEvent.keyIdentifier)
    charCode = null
    if @translationTable? && identifier? && @translationTable[identifier]?
      if translation = @translationTable[identifier]
        if keyDownEvent.shiftKey && translation.shifted?
          charCode = translation.shifted
          keyDownEvent.shiftKey = false
        else if keyDownEvent.altKey && translation.alted?
          charCode = translation.alted
          keyDownEvent.altKey = false
          keyDownEvent.ctrlKey = false
        else if translation.unshifted?
          charCode = translation.unshifted

    if charCode?
      keyDownEvent.keyIdentifier = @charCodeToKeyIdentifier(charCode)
      keyDownEvent.keyCode = charCode
      keyDownEvent.which = charCode
      keyDownEvent.keyTranslated = true

  remap: (event) ->
    @newKeyDownEvent = @createNewKeyDownEvent(event)
    @translateKeyBinding(@newKeyDownEvent)
    return @newKeyDownEvent

  didFailToMatchBinding: (event) ->
    if @newKeyDownEvent.keyTranslated
      editor = atom.workspace.getActiveEditor()
      editorElement = atom.views.getView(editor)
      if editor && editorElement && editorElement.hasFocus()
        key = String.fromCharCode(@newKeyDownEvent.which)
        editor.insertText(key)
        event.preventDefault()
