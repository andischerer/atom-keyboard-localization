module.exports =
class ModifierState
  currentModifierState: {}
  keyEventQueueWorker: null
  keyEventQueue: []
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
    @currentModifierState = {}
    # @TODO: Use Task(https://atom.io/docs/api/v0.189.0/Task) for keyEventQueue processing
    @keyEventQueueWorker = setInterval((=>
      @processKeyEventQueue()
    ), 0)

  destroy: ->
    clearInterval(@keyEventQueueWorker)
    @keyEventQueueWorker = null

  processKeyEventQueue: () ->
    keyEvent = @keyEventQueue.shift()
    if keyEvent?
      if keyEvent.type == 'keydown'
        @addModifier(keyEvent)
      if keyEvent.type == 'keyup'
        @removeModifier(keyEvent)

  isModifier: (identifier) ->
    for key of @modifiers
      if @modifiers[key].indexOf(identifier) != -1
        return key
    false

  addModifier: (keyEvent) ->
    identifier = @isModifier(keyEvent.keyIdentifier)
    if identifier
      @currentModifierState[identifier] = keyEvent

  removeModifier: (keyEvent) ->
    identifier = @isModifier(keyEvent.keyIdentifier)
    if identifier
      delete @currentModifierState[identifier]

  isShift: ->
    return @currentModifierState.hasOwnProperty 'shift'

  isAlt: ->
    if process.platform == 'win32'
      return @currentModifierState.hasOwnProperty('alt') and @currentModifierState.alt.keyLocation != 2
    else
      return @currentModifierState.hasOwnProperty('alt')

  isAltGr: ->
    if process.platform == 'win32'
      return @currentModifierState.hasOwnProperty('alt') and @currentModifierState.alt.keyLocation == 2
    else
      return @currentModifierState.hasOwnProperty('altgr')

  isCtrl: ->
    if process.platform == 'win32'
      return @currentModifierState.hasOwnProperty('ctrl') and !@isAltGr()
    else
      @currentModifierState.hasOwnProperty('ctrl')

  onKeyDown: (keyEvent) ->
    @keyEventQueue.push(keyEvent)

  onKeyUp: (keyEvent) ->
    @keyEventQueue.push(keyEvent)

  logModifiers: ->
    mods =
      shift: @isShift()
      alt: @isAlt()
      altgr: @isAltGr()
      ctrl: @isCtrl()
    return JSON.stringify(mods)
