{View} = require 'atom'

module.exports =
class CompatibleView extends View
  @content: ->
    @div class: 'test overlay from-top', =>
      @div "The Test package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "compatible:at", @at
    atom.workspaceView.command "compatible:backslash", @backslash

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  at: (event) ->
    view = event.targetView()
    if view.editor
      view.editor.insertText('@')
    else if view.model
      view.model.selections[0]?.editor.insertText("@")

  backslash: (event) ->
    view = event.targetView()
    if view.editor
      view.editor.insertText('\\')
    else if view.model
      view.model.selections[0]?.editor.insertText("\\")
