{View} = require 'atom-space-pen-views'

module.exports =
class ModifierView extends View

  @content: ->
    @div class: 'modifier'

  initialize: (params) ->
    @text(params.label)
    @addClass('modifier-' + params.label.toLowerCase())

  setActive: (active) ->
    if active then @addClass('modifier-active') else @removeClass('modifier-active')
