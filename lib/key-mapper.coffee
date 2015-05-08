module.exports =
class KeyMapper
  pkg: 'keyboard-localization'
  translationTable: null
  keyDownEvent: null
  modifierStateHandler: null

  destroy: ->
    @translationTable = null
    @modifierStateHandler = null

  setKeymap: (keymap) ->
    @translationTable = keymap

  setModifierStateHandler: (modifierStateHandler) ->
    @modifierStateHandler = modifierStateHandler

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
    if @translationTable? && identifier? && @translationTable[identifier]? && @modifierStateHandler?
      if translation = @translationTable[identifier]
        if @modifierStateHandler.isShift() && translation.shifted?
          charCode = translation.shifted
          keyDownEvent.shiftKey = false
        else if @modifierStateHandler.isAltGr() && translation.alted?
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
      keyDownEvent.accent = (translation.accent?) ? true : false

    return keyDownEvent

  remap: (event) ->
    @keyDownEvent = @translateKeyBinding(event)

  didFailToMatchBinding: (event) ->
    if @keyDownEvent.keyTranslated
      editor = atom.workspace.getActiveTextEditor()
      editorElement = atom.views.getView(editor)
      accent = (@keyDownEvent.accent? && @keyDownEvent.accent == true) ? true : false
      if editor && editorElement && editorElement.hasFocus() && !accent
        key = String.fromCharCode(@keyDownEvent.which)
        editor.insertText(key)
        event.preventDefault()
