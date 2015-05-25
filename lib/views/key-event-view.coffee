{View} = require 'atom-space-pen-views'
{charCodeFromKeyIdentifier} = require '../helpers'

module.exports =
class KeyEventView extends View
  event: null
  modifiers: null

  @content: (params) ->
    @div class: 'key-box', =>
      @div class: 'section-heading icon icon-keyboard', params.title
      @div class: 'key-attribute-row', =>
        @span 'Identifier: '
        @span outlet: 'identifier'
      @div class: 'key-attribute-row', =>
        @span 'Code: '
        @span outlet: 'code'
      @div class: 'key-attribute-row', =>
        @span 'Char: '
        @span outlet: 'char'
      @div class: 'key-attribute-row', =>
        @span 'Modifier: '
        @span outlet: 'modifier'

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
