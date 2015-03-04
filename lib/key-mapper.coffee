path = require('path')
fs = require('fs-plus')
util = require('util')

module.exports =
class KeyMapper
  pkg: 'keyboard-localization'
  translationTable: null
  keyTranslated: false

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
    newKeyDownEvent = util._extend({} , event)
    newKeyDownEvent.currentTarget = null
    newKeyDownEvent.eventPhase = 0
    return newKeyDownEvent

  # copy from atom-keymap/helpers.coffee
  charCodeFromKeyIdentifier: (keyIdentifier) ->
    parseInt(keyIdentifier[2..], 16) if keyIdentifier.indexOf('U+') is 0

  padZero: (strToPad, size) ->
    while strToPad.length < size
      strToPad = '0' + strToPad
    return strToPad

  charCodeToKeyIdentifier: (charCode) ->
    return 'U+' + @padZero(charCode.toString(16).toUpperCase(), 4)

  fireKeydownEvent: (keyDownEvent) ->
    bubbles = keyDownEvent.bubbles
    cancelable = keyDownEvent.cancelable
    view = keyDownEvent.view
    keyIdentifier = keyDownEvent.keyIdentifier
    location = keyDownEvent.location
    ctrl = keyDownEvent.ctrlKey
    alt = keyDownEvent.altKey
    shift = keyDownEvent.shiftKey
    cmd = keyDownEvent.metaKey

    event = document.createEvent('KeyboardEvent')
    event.initKeyboardEvent(
      'keydown',
      bubbles,
      cancelable,
      view,
      keyIdentifier,
      location,
      ctrl,
      alt,
      shift,
      cmd
    )
    Object.defineProperty(event, 'target', get: -> keyDownEvent.target)
    Object.defineProperty(event, 'path', get: -> keyDownEvent.path)
    Object.defineProperty(event, 'keyCode', get: -> keyDownEvent.keyCode)
    Object.defineProperty(event, 'which', get: -> keyDownEvent.keyCode)
    keyDownEvent.target.dispatchEvent( event )
    console.log 'fireKeydownEvent', event

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
      @keyTranslated = true

  remap: (event) ->
    # @keyTranslated = false
    newKeyDownEvent = @createNewKeyDownEvent(event)
    @translateKeyBinding(newKeyDownEvent)

    # if @keyTranslated
      # event.preventDefault()
      # @fireKeydownEvent(newKeyDownEvent)

    return newKeyDownEvent
