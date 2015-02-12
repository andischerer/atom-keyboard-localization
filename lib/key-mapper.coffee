path = require('path')
fs = require('fs-plus')

module.exports =
class KeyMapper
  translationTable: null

  constructor: ->
    deDE = path.resolve(__dirname, './keymaps/de_DE.json')
    @loadTranslationTable(deDE)

  destroy: ->
    @translationTable = null

  loadTranslationTable:(pathToTransTable) ->
    if fs.isFileSync(pathToTransTable)
      tansTableContentJson = fs.readFileSync(pathToTransTable, 'utf8')
      @translationTable = JSON.parse(tansTableContentJson)
    else
      console.log('atom-keymap-compatible: error loading keybindings from' +
        pathToTransTable)

  createNewKey: (event) ->
    return newKey =
      keyIdentifier: event.keyIdentifier
      keyCode: event.keyCode
      location: event.location
      which: event.which
      ctrlKey: event.ctrlKey
      altKey: event.altKey
      shiftKey: event.shiftKey
      metaKey: event.metaKey

  # copy from atom-keymap/helpers.coffee
  charCodeFromKeyIdentifier: (keyIdentifier) ->
    parseInt(keyIdentifier[2..], 16) if keyIdentifier.indexOf('U+') is 0

  charCodeToKeyIdentifier: (charCode) ->
    return 'U+00' + charCode.toString(16).toUpperCase()

  translateKeyBinding: (key) ->
    identifier = @charCodeFromKeyIdentifier(key.keyIdentifier)
    charCode = null
    if @translationTable? && identifier? && @translationTable[identifier]?
      if translation = @translationTable[identifier]
        if key.shiftKey && translation.shifted?
          charCode = translation.shifted
          key.shiftKey = false
        else if key.altKey && translation.alted?
          charCode = translation.alted
          key.altKey = false
        else if translation.unshifted?
          charCode = translation.unshifted

    if charCode?
      key.keyIdentifier = @charCodeToKeyIdentifier(charCode)
      key.keyCode = charCode
      key.which = charCode

    return key

  remap: (event) ->
    newKey = @createNewKey(event)
    newKey = @translateKeyBinding(newKey)
    return newKey
