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
  setKey: (keyEvent) ->
    @event = keyEvent
    @identifier.text(@event.keyIdentifier + ' (' + charCodeFromKeyIdentifier(@event.keyIdentifier) + ')')
    @code.text(@event.keyCode || @event.which)
    @char.text(String.fromCharCode(@event.keyCode || @event.which))
    console.log keyEvent
  getKey: ->
    return @event
  clear: ->
    @event = null
    @identifier.text('')
    @code.text('')
    @char.text('')


module.exports =
class KeymapGeneratorView extends ScrollView
  pkg: 'keyboard-localization'

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

        @section class: 'modifier-panel', =>
          @subview 'ctrlView', new ModifierView(label: 'Ctrl')
          @subview 'altView', new ModifierView(label: 'Alt')
          @subview 'shiftView', new ModifierView(label: 'Shift')
          @subview 'altgrView', new ModifierView(label: 'AltGr')

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

  onKeyDown: (event) ->
    @input.val('')
    @keyDownView.clear()
    @keyPressView.clear()

    originalEvent = util._extend({}, event.originalEvent)
    @modifierStateHandler.handleKeyEvent(originalEvent)
    @updateModifiers()
    @keyDownView.setKey(originalEvent)

  onKeyPress: (event) ->
    originalEvent = util._extend({}, event.originalEvent)
    @keyPressView.setKey(originalEvent)

  onKeyUp: (event) ->
    originalEvent = util._extend({}, event.originalEvent)
    @modifierStateHandler.handleKeyEvent(originalEvent)
    @updateModifiers()

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
