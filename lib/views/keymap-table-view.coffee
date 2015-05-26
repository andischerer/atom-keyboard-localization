{ScrollView} = require 'atom-space-pen-views'

module.exports =
class KeymapTableView extends ScrollView
  mapTable: {}
  keymapChangeCallback: null

  @content: ->
    @section class:'map-table-panel', =>
      @div class: 'section-heading pull-left icon icon-code', 'Key-Mappings'
      @div class:'btn-group pull-right', =>
        # @div class:'btn btn-save icon icon-arrow-down', click:'saveToFile', 'save'
        @div class:'btn btn-clipboard icon-clippy', click:'saveToClipboard', ' clipboard'
        # @div class:'btn btn-github icon icon-mark-github', click:'saveToGithub', 'create Issue'
        @div class:'btn btn-clear icon icon-trashcan', click:'clear', 'clear'
      @pre class:'map-table', outlet: 'mapTableView'

  addKeyMapping: (down, modifier, press, isAccentKey) ->
    modIdentifier = 'unshifted'
    if modifier.shift
      modIdentifier = 'shifted'
    if modifier.altgr
      modIdentifier = 'alted'
    if modifier.shift && modifier.altgr
      modIdentifier = 'altshifted'
    if !@mapTable[down.code]?
      @mapTable[down.code] = {}
    if isAccentKey
      @mapTable[down.code]['accent'] = true
    @mapTable[down.code][modIdentifier] = press.code
    if @keymapChangeCallback
      @keymapChangeCallback(@mapTable)
    @render()

  render: ->
    @mapTableView.text(JSON.stringify(@mapTable, undefined, 4))

  getKeymap: ->
    return @mapTable

  saveToClipboard: ->
    console.log 'clipboard'
    input = document.createElement('textarea')
    document.body.appendChild(input)
    input.value = JSON.stringify(@mapTable, undefined, 4)
    input.focus()
    input.select()
    document.execCommand('Copy')
    input.remove()

  ###
  saveToFile: ->
    console.log 'save'

  saveToGithub: ->
    console.log 'github'
  ###

  onKeymapChange: (keymapChangeCallback) ->
    @keymapChangeCallback = keymapChangeCallback

  clear: () ->
    @mapTable = {}
    @render()
    if @keymapChangeCallback
      @keymapChangeCallback(@mapTable)
