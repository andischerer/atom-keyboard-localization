CompatibleView = require './compatible-view'

module.exports =
  compatibleView: null

  activate: (state) ->
    @compatibleView = new CompatibleView(state.compatibleViewState)

  deactivate: ->
    @compatibleView.destroy()

  serialize: ->
    compatibleViewState: @compatibleView.serialize()
