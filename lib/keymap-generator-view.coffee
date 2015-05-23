{Disposable} = require 'atom'
{$, ScrollView, View} = require 'atom-space-pen-views'
util = require 'util'
{charCodeFromKeyIdentifier, charCodeToKeyIdentifier} = require './helpers'
KeyMapper = require './key-mapper'
ModifierStateHandler = require './modifier-state-handler'


class ModifierView extends View
  @content: ->
    @div class: 'modifier'
  initialize: (params) ->
    @text(params.label)
    @addClass('modifier-' + params.label.toLowerCase())
  setActive: (active) ->
    if active then @addClass('modifier-active') else @removeClass('modifier-active')

#<atom-panel class='left'>
#    <div class="padded">
#        <div class="inset-panel">
#            <div class="panel-heading">An inset-panel heading</div>
#            <div class="panel-body padded">Some Content</div>
#        </div>
#    </div>
#</atom-panel>

class KeyEventView extends View
  @event = null
  @modifiers = null
  @content: (params) ->
    @div class: 'key-box block', =>
    #@tag 'atom-panel', class:'left', =>
      @div class: 'section-heading', outlet: 'title', params.title
      @div class: '', =>
        @span class: 'inline-block', 'Identifier: '
        @span class: 'inline-block', outlet: 'identifier'
      @div =>
        @span class: 'inline-block', 'Code: '
        @span class: 'inline-block', outlet: 'code'
      @div =>
        @span class: 'inline-block', 'Char: '
        @span class: 'inline-block', outlet: 'char'
      @div =>
        @span class: 'inline-block', 'Modifier: '
        @span class: 'inline-block', outlet: 'modifier'
  setKey: (keyEvent, modifiers) ->
    @event = keyEvent
    @modifiers = modifiers

    @event.code = charCodeFromKeyIdentifier(@event.keyIdentifier) || @event.keyCode || @event.which
    @event.char = String.fromCharCode(@event.code).toLowerCase()

    @identifier.text(@event.keyIdentifier)
    @code.text(@event.code)
    @char.text(@event.char)

    modifierStack = []
    for k, v of @modifiers
      if v == true then modifierStack.push(k)
    @modifier.text(modifierStack.join(' '))
    # console.log keyEvent
  getKey: ->
    return @event
  getModifiers: ->
    return @modifiers
  clear: ->
    @event = null
    @modifiers = null
    @identifier.text('')
    @code.text('')
    @char.text('')
    @modifier.text('')


module.exports =
class KeymapGeneratorView extends ScrollView
  pkg: 'keyboard-localization'

  mapping: {}
  modifierStateHandler: null
  keyMapper: null

  @content: ->
    @div class: 'keymap-generator', =>
      @div class: 'keymap-generator-container', =>

        @header class: 'keymap-generator-header', =>
          @h1 class: 'keymap-generator-title', 'Build your Keymap for your foreign keyboard layout.'

        @section class:'keys-panel block', =>
          @subview 'keyDownView', new KeyEventView(title: 'KeyDown Event')
          @subview 'keyPressView', new KeyEventView(title: 'KeyPress Event')

        @div class: 'block', =>
          @label class: 'inline-block text-smaller', 'Type something here: '
          @input class: 'inline-block input', type: 'text', keydown: 'onKeyDown', keypress: 'onKeyPress', keyup: 'onKeyUp', outlet: 'input'

        @section class: 'modifier-panel block', =>
          @subview 'ctrlView', new ModifierView(label: 'Ctrl')
          @subview 'altView', new ModifierView(label: 'Alt')
          @subview 'shiftView', new ModifierView(label: 'Shift')
          @subview 'altgrView', new ModifierView(label: 'AltGr')

        @section class: 'bindings-panel block', =>
          @pre class:'block', outlet: 'bindingsView'
          @div class: 'block', =>
            @button class: 'btn', click: 'clearMapping', 'clear Mapping'

  attached: ->
    @keyMapper = new KeyMapper()
    # @keyMapper.setKeymap(@keymapLoader.getKeymap())
    @modifierStateHandler = new ModifierStateHandler()

  detached: ->
    @keyMapper = null
    @modifierStateHandler = null

  updateModifiers: ->
    @ctrlView.setActive(@modifierStateHandler.isCtrl())
    @altView.setActive(@modifierStateHandler.isAlt())
    @shiftView.setActive(@modifierStateHandler.isShift())
    @altgrView.setActive(@modifierStateHandler.isAltGr())

  addMapping: ->
    down = @keyDownView.getKey()
    modifier = @keyDownView.getModifiers()
    press = @keyPressView.getKey()
    if press != null && down.char != press.char
      console.log 'addMapping'
      mod = 'unshifted'
      if modifier.shift
        mod = 'shifted'
      if modifier.altgr
        mod = 'alted'
      if modifier.shift && modifier.altgr
        mod = 'altshifted'
      if !@mapping[down.code]?
        @mapping[down.code] = {}
      @mapping[down.code][mod] = press.code
      @bindingsView.text(JSON.stringify(@mapping, undefined, 4))

  clearMapping: ->
    @mapping = {}
    @bindingsView.text('')

  onKeyDown: (event) ->
    @input.val('')
    @keyDownView.clear()
    @keyPressView.clear()

    originalEvent = util._extend({}, event.originalEvent)
    @modifierStateHandler.handleKeyEvent(originalEvent)
    @updateModifiers()
    @keyDownView.setKey(originalEvent, @modifierStateHandler.getState())

  onKeyPress: (event) ->
    originalEvent = util._extend({}, event.originalEvent)
    @keyPressView.setKey(originalEvent, @modifierStateHandler.getState())

  onKeyUp: (event) ->
    originalEvent = util._extend({}, event.originalEvent)
    @modifierStateHandler.handleKeyEvent(originalEvent)
    @updateModifiers()
    @addMapping()

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
