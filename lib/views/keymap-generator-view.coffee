{Disposable} = require 'atom'
{ScrollView, TextEditorView} = require 'atom-space-pen-views'
util = require 'util'

KeyMapper = require '../key-mapper'
ModifierStateHandler = require '../modifier-state-handler'

ModifierView = require './modifier-view'
KeyEventView = require './key-event-view'
KeymapTableView = require './keymap-table-view'

module.exports =
class KeymapGeneratorView extends ScrollView
  previousMapping: null
  modifierStateHandler: null
  keyMapper: null

  @content: ->
    @div class: 'keymap-generator', =>

      @header class: 'header', =>
        @h1 class: 'title', 'Build a Keymap for your foreign keyboard layout'

      @section class:'keys-events-panel', =>
        @subview 'keyDownView', new KeyEventView(title: 'KeyDown Event')
        @subview 'keyPressView', new KeyEventView(title: 'KeyPress Event')

      @section class: 'modifier-bar-panel', =>
        @subview 'ctrlView', new ModifierView(label: 'Ctrl')
        @subview 'altView', new ModifierView(label: 'Alt')
        @subview 'shiftView', new ModifierView(label: 'Shift')
        @subview 'altgrView', new ModifierView(label: 'AltGr')

      @section class: 'key-input-panel', =>
        @div class: 'key-label', 'Capture Key-Events from input and create Key-Mappings'
        @input class: 'key-input', type: 'text', focus:'clearInput', keydown: 'onKeyDown', keypress: 'onKeyPress', keyup: 'onKeyUp', outlet: 'keyInput'

      @section class: 'test-key-panel', =>
        @div class: 'test-key-label', 'Test your generated Key-Mappings'
        @subview 'testKeyInput', new TextEditorView(mini: true)

      @subview 'keymapTableView', new KeymapTableView()

  attached: ->
    @keyMapper = KeyMapper.getInstance()
    @modifierStateHandler = new ModifierStateHandler()

    @previousMapping = @keyMapper.getKeymap()
    @keymapTableView.onKeymapChange((keymap) =>
      @keyMapper.setKeymap(keymap)
    )

    @keymapTableView.clear()

    @keymapTableView.render()

  detached: ->
    if @previousMapping != null
      @keyMapper.setKeymap(@previousMapping)
    @keyMapper = null
    @modifierStateHandler = null

  updateModifiers: (modifierState) ->
    @ctrlView.setActive(modifierState.ctrl)
    @altView.setActive(modifierState.alt)
    @shiftView.setActive(modifierState.shift)
    @altgrView.setActive(modifierState.altgr)

  addMapping: ->
    down = @keyDownView.getKey()
    modifier = @keyDownView.getModifiers()
    press = @keyPressView.getKey()
    if press != null && down.char != press.char
      @keymapTableView.addKeyMapping(down, modifier, press, @keyInput.val().length > 1)
      @keyMapper.setKeymap(@keymapTableView.getKeymap())

  clearInput: ->
    @keyInput.val('')

  onKeyDown: (event) ->
    @clearInput()
    @keyDownView.clear()
    @keyPressView.clear()

    originalEvent = util._extend({}, event.originalEvent)
    @modifierStateHandler.handleKeyEvent(originalEvent)
    modifierState = @modifierStateHandler.getState()
    @updateModifiers(modifierState)
    @keyDownView.setKey(originalEvent, modifierState)

  onKeyPress: (event) ->
    originalEvent = util._extend({}, event.originalEvent)
    @keyPressView.setKey(originalEvent, @modifierStateHandler.getState())

  onKeyUp: (event) ->
    originalEvent = util._extend({}, event.originalEvent)
    @modifierStateHandler.handleKeyEvent(originalEvent)
    @addMapping()

    # wait for quitAltGrMode
    setTimeout(() =>
      modifierState = @modifierStateHandler.getState()
      @updateModifiers(modifierState)
    , 50)


  @deserialize: (options={}) ->
    new KeymapGeneratorView(options)

  serialize: ->
    deserializer: @constructor.name
    uri: @getURI()

  getURI: -> @uri

  getTitle: -> "Keymap-Generator"

  onDidChangeTitle: -> new Disposable ->
  onDidChangeModified: -> new Disposable ->

  isEqual: (other) ->
    other instanceof KeymapGeneratorView
