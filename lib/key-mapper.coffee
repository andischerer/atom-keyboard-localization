ModifierStateHandler = require './modifier-state-handler'
{charCodeFromKeyIdentifier, charCodeToKeyIdentifier} = require './helpers'

class KeyMapper
  translationTable: null
  keyDownEvent: null
  modifierStateHandler: null

  destroy: ->
    @translationTable = null
    @modifierStateHandler = null

  setModifierStateHandler: (modifierStateHandler) ->
    @modifierStateHandler = modifierStateHandler

  setKeymap: (keymap) ->
    @translationTable = keymap

  getKeymap: ->
    return @translationTable

  translateKeyBinding: (keyDownEvent) ->
    identifier = charCodeFromKeyIdentifier(keyDownEvent.keyIdentifier)
    charCode = null
    if @translationTable? && identifier? && @translationTable[identifier]? && @modifierStateHandler?
      if translation = @translationTable[identifier]
        if translation.altshifted? && @modifierStateHandler.isShift() && @modifierStateHandler.isAltGr()
          charCode = translation.altshifted
          keyDownEvent.altKey = false
          keyDownEvent.ctrlKey = false
          keyDownEvent.shiftKey = false
        else if translation.shifted? && @modifierStateHandler.isShift()
          charCode = translation.shifted
          keyDownEvent.shiftKey = false
        else if translation.alted? && @modifierStateHandler.isAltGr()
          # do not remove alt+ctrl states for linux
          # TODO: what about darwin?
          if process.platform != 'linux'
            keyDownEvent.altKey = false
            keyDownEvent.ctrlKey = false
        else if translation.unshifted?
          charCode = translation.unshifted

    if charCode?
      keyDownEvent.keyIdentifier = charCodeToKeyIdentifier(charCode)
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

keyMapper = null

getInstance = ->
  if keyMapper == null
    keyMapper = new KeyMapper()
  return keyMapper

module.exports =
  getInstance: getInstance
