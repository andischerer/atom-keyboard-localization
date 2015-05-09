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
          @h1 class: 'eymap-generator-title', 'Build your Keymaps!!!!!! Yo'

  attached: ->
    console.log "I have been attached."
    ###
    @eventedModifierStateHandler = new EventedModifierStateHandler()

    # clear modifiers on editor blur and focus
    @clearModifierStateListener = () =>
      @eventedModifierStateHandler.clearModifierState()
    window.addEventListener 'blur', @clearModifierStateListener
    window.addEventListener 'focus', @clearModifierStateListener

    # Keyup-Event for EventedModifierStateHandler
    @keyUpEventListener = (event) =>
      @onKeyUp(event)
    document.addEventListener 'keyup', @keyUpEventListener

    # Hijack KeymapManager
    # @TODO: Evil hack. Find an better way ...
    @orginalKeydownEvent = atom.keymaps.keystrokeForKeyboardEvent
    atom.keymaps.keystrokeForKeyboardEvent = (event) =>
      @onKeyDown event
    ###

  detached: ->
    console.log "I have been detached."
    ###
    if @keymapLoader.isLoaded()

      atom.keymaps.keystrokeForKeyboardEvent = @orginalKeydownEvent
      @orginalKeydownEvent = null

      document.removeEventListener 'keyup', @keyUpEventListener

      window.removeEventListener 'blur', @clearModifierStateListener
      window.removeEventListener 'focus', @clearModifierStateListener

      @didFailToMatchBinding.dispose()

    @eventedModifierStateHandler = null
    ###


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
