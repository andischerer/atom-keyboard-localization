###
 * Modifierhandling shamelessly stolen and customized from brackets:
 * https://github.com/adobe/brackets/blob/master/src/command/KeyBindingManager.js
###

KeyEvent = require './key-event'

module.exports =
class ModifierStateHandler
  ###*
   * States of Ctrl key down detection
   * @enum {number}
  ###
  CtrlDownStates:
    'NOT_YET_DETECTED': 0
    'DETECTED': 1
    'DETECTED_AND_IGNORED': 2

  ###*
   * Flags used to determine whether right Alt key is pressed. When it is pressed,
   * the following two keydown events are triggered in that specific order.
   *
   *    1. ctrlDown - flag used to record { ctrlKey: true, keyIdentifier: "Control", ... } keydown event
   *    2. altGrDown - flag used to record { ctrlKey: true, altKey: true, keyIdentifier: "Alt", ... } keydown event
   *
   * @type {CtrlDownStates|boolean}
  ###
  ctrlDown: 0 # initialize with CtrlDownState => NOT_YET_DETECTED
  altGrDown: false

  hasShift: false
  hasCtrl: false
  hasAltGr: false
  hasAlt: false
  hasCmd: false

  ###*
   * Constant used for checking the interval between Control keydown event and Alt keydown event.
   * If the right Alt key is down we get Control keydown followed by Alt keydown within 30 ms. if
   * the user is pressing Control key and then Alt key, the interval will be larger than 30 ms.
   * @type {number}
  ###
  MAX_INTERVAL_FOR_CTRL_ALT_KEYS: 30

  ###*
   * Constant used for identifying AltGr on Linux
   * @type {String}
  ###
  LINUX_ALTGR_IDENTIFIER = 'U+00E1'

  ###*
   * Used to record the timeStamp property of the last keydown event.
   * @type {number}
  ###
  lastTimeStamp: null

  ###*
   * Used to record the keyIdentifier property of the last keydown event.
   * @type {string}
  ###
  lastKeyIdentifier: null

  ###*
   * keyUpListener for AltGrMode recognition
   * @type {event}
  ###
  keyUpEventListener: null

  ###*
   * clear modifiers listener on editor blur and focus
   * @type {event}
  ###
  clearModifierStateListener: null

  constructor: ->
    # clear modifiers on editor blur and focus
    @clearModifierStateListener = () =>
      @clearModifierState()
    window.addEventListener 'blur', @clearModifierStateListener
    window.addEventListener 'focus', @clearModifierStateListener

  destroy: ->
    window.removeEventListener 'blur', @clearModifierStateListener
    window.removeEventListener 'focus', @clearModifierStateListener

  clearModifierState: ->
    if process.platform == 'win32'
      @quitAltGrMode()
    @hasShift = false
    @hasCtrl = false
    @hasAltGr = false
    @hasAlt = false
    @hasCmd = false

  ###*
   * Resets all the flags and removes onAltGrUp event listener.
  ###
  quitAltGrMode: ->
    @ctrlDown = @CtrlDownStates.NOT_YET_DETECTED
    @altGrDown = false
    @hasAltGr = false
    @lastTimeStamp = null
    @lastKeyIdentifier = null
    document.removeEventListener 'keyup', @keyUpEventListener

  ###*
   * Detects the release of AltGr key by checking all keyup events
   * until we receive one with ctrl key code. Once detected, reset
   * all the flags and also remove this event listener.
   *
   * @param {KeyboardEvent} e keyboard event object
  ###
  onAltGrUp: (e) ->
    if process.platform == 'win32'
      key = e.keyCode || e.which
      if @altGrDown && key == KeyEvent.DOM_VK_CONTROL
        @quitAltGrMode()
    if process.platform == 'linux'
      if e.keyIdentifier == LINUX_ALTGR_IDENTIFIER
        @quitAltGrMode()

  ###*
   * Detects whether AltGr key is pressed. When it is pressed, the first keydown event has
   * ctrlKey === true with keyIdentifier === "Control". The next keydown event with
   * altKey === true, ctrlKey === true and keyIdentifier === "Alt" is sent within 30 ms. Then
   * the next keydown event with altKey === true, ctrlKey === true and keyIdentifier === "Control"
   * is sent. If the user keep holding AltGr key down, then the second and third
   * keydown events are repeatedly sent out alternately. If the user is also holding down Ctrl
   * key, then either keyIdentifier === "Control" or keyIdentifier === "Alt" is repeatedly sent
   * but not alternately.
   *
   * @param {KeyboardEvent} e keyboard event object
  ###
  detectAltGrKeyDown: (e) ->
    if process.platform == 'win32'
      if !@altGrDown
        if @ctrlDown != @CtrlDownStates.DETECTED_AND_IGNORED && e.ctrlKey && e.keyIdentifier == 'Control'
          @ctrlDown = @CtrlDownStates.DETECTED
        else if e.repeat && e.ctrlKey && e.keyIdentifier == 'Control'
          # We get here if the user is holding down left/right Control key. Set it to false
          # so that we don't misidentify the combination of Ctrl and Alt keys as AltGr key.
          @ctrlDown = @CtrlDownStates.DETECTED_AND_IGNORED
        else if @ctrlDown == @CtrlDownStates.DETECTED && e.altKey && e.ctrlKey && e.keyIdentifier == 'Alt' && e.timeStamp - @lastTimeStamp < @MAX_INTERVAL_FOR_CTRL_ALT_KEYS && (e.location == 2 or e.keyLocation == 2)
          @altGrDown = true
          @lastKeyIdentifier = 'Alt'
          @keyUpEventListener = (e) =>
            @onAltGrUp(e)
          document.addEventListener 'keyup', @keyUpEventListener
        else
          # Reset ctrlDown so that we can start over in detecting the two key events
          # required for AltGr key.
          @ctrlDown = @CtrlDownStates.NOT_YET_DETECTED
        @lastTimeStamp = e.timeStamp
      else if e.keyIdentifier == 'Control' || e.keyIdentifier == 'Alt'
        # If the user is NOT holding down AltGr key or is also pressing Ctrl key,
        # then lastKeyIdentifier will be the same as keyIdentifier in the current
        # key event. So we need to quit AltGr mode.
        if e.altKey && e.ctrlKey && e.keyIdentifier == @lastKeyIdentifier
          @quitAltGrMode()
        else
          @lastKeyIdentifier = e.keyIdentifier
    if process.platform == 'linux'
      if !@altGrDown
        if e.keyIdentifier == LINUX_ALTGR_IDENTIFIER
          @altGrDown = true
          @keyUpEventListener = (e) =>
            @onAltGrUp(e)
          document.addEventListener 'keyup', @keyUpEventListener
    else
      return

  ###*
   * Handle key event
   *
   * @param {KeyboardEvent} e keyboard event object
  ###
  handleKeyEvent: (e) ->
    @detectAltGrKeyDown(e)

    if process.platform == 'win32'
      @hasCtrl = !@altGrDown && e.ctrlKey
      @hasAltGr = @altGrDown
      @hasAlt = !@altGrDown && e.altKey
    else if process.platform == 'linux'
      @hasCtrl = e.ctrlKey
      @hasAltGr = @altGrDown
      @hasAlt = e.altKey
    else
      @hasCtrl = e.ctrlKey
      @hasAltGr = e.altKey
      @hasAlt = e.altKey

    @hasShift = e.shiftKey
    @hasCmd = e.metaKey

  ###*
   * determine if shift key is pressed
  ###
  isShift: ->
    return @hasShift

  ###*
   * determine if altgr key is pressed
  ###
  isAltGr: ->
    return @hasAltGr

  ###*
   * determine if alt key is pressed
  ###
  isAlt: ->
    return @hasAlt

  ###*
   * determine if ctrl key is pressed
  ###
  isCtrl: ->
    return @hasCtrl

  ###*
   * determine if cmd key is pressed
  ###
  isCmd: ->
    return @hasCmd


  ###*
   * get the state of all modifiers
   * @return {object}
  ###
  getState: ->
    shift: @isShift()
    altgr: @isAltGr()
    alt: @isAlt()
    ctrl: @isCtrl()
    cmd: @isCmd()

  ###*
   * get the modifier sequence string.
   * Additionally with a character
   * @param {String} character
   * @return {String}
  ###
  getStrokeSequence: (character) ->
    sequence = []
    if @isCtrl()
      sequence.push('ctrl')
    if @isAlt()
      sequence.push('alt')
    if @isAltGr()
      sequence.push('altgr')
    if @isShift()
      sequence.push('shift')
    if @isCmd()
      sequence.push('cmd')
    if character
      sequence.push(character)
    return sequence.join('-')
