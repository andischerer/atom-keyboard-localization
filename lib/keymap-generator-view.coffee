{Disposable} = require 'atom'
{$, ScrollView} = require 'atom-space-pen-views'
EventedModifierStateHandler = require './evented-modifier-state-handler'

module.exports =
class KeymapGeneratorView extends ScrollView
  pkg: 'keyboard-localization'
  eventedModifierStateHandler: null

  @content: ->
    @div class: 'keymap-generator', =>
      @div class: 'keymap-generator-container', =>
        @header class: 'keymap-generator-header', =>
          @h1 class: 'keymap-generator-title', 'Build your Keymap for your foreign keyboard layout.'
        @section class:'keys-panel', =>
          @div class: 'key-box', =>
            @p 'KeyDown-Event:', =>
              @div outlet: 'keydown'
          @div class:'key-box', =>
            @p 'KeyPress-Event:', =>
              @div outlet: 'keypress'
        @textarea keydown: 'onKeyDown', keypress: 'onKeyPress', keyup: 'onKeyUp', class: 'keymap-generator'

  attached: ->
    console.log "I have been attached."

  detached: ->
    console.log "I have been detached."

  onKeyDown: (event) ->
    console.log event

  onKeyPress: (event) ->
    console.log event

  onKeyUp: (event) ->
    console.log event

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
