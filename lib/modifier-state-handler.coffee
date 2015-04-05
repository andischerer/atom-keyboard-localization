module.exports =
class ModifierState
  stack: {}
  modifiers:
    shift: [
      'Shift'
      'U+00A0'
      'U+00A1'
    ]
    ctrl: [
      'Control'
      'U+00A2'
      'U+00A3'
    ]
    alt: [
      'Alt'
      'U+00A4'
      'U+00A5'
    ]
    altgr: [
      'U+00E1' # linux altgr identifier
    ]

  constructor: ->
    @stack = {}

  isModifier: (identifier) ->
    for key of @modifiers
      if @modifiers[key].indexOf(identifier) != -1
        return key
    false

  addModifier: (keyEvent) ->
    stackIdentifier = @isModifier(keyEvent.keyIdentifier)
    if stackIdentifier
      @stack[stackIdentifier] = keyEvent

  removeModifier: (keyEvent) ->
    stackIdentifier = @isModifier(keyEvent.keyIdentifier)
    if stackIdentifier
      delete @stack[stackIdentifier]

  isShift: ->
    return @stack.hasOwnProperty 'shift'

  isAlt: ->
    if process.platform == 'win32'
      return @stack.hasOwnProperty('alt') and @stack.alt.keyLocation != 2
    else
      return @stack.hasOwnProperty('alt')

  isAltGr: ->
    if process.platform == 'win32'
      return @stack.hasOwnProperty('alt') and @stack.alt.keyLocation == 2
    else
      return @stack.hasOwnProperty('altgr')

  isCtrl: ->
    if process.platform == 'win32'
      return @stack.hasOwnProperty('ctrl') and !@isAltGr()
    else
      @stack.hasOwnProperty('ctrl')

  onKeyDown: (keyEvent) ->
    @addModifier(keyEvent)

  onKeyUp: (keyEvent) ->
    @removeModifier(keyEvent)

  logModifiers: ->
    mods =
      shift: @isShift()
      alt: @isAlt()
      altgr: @isAltGr()
      ctrl: @isCtrl()
    console.log(JSON.stringify(mods))
