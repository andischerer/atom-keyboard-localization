path = require('path')
fs = require('fs-plus')

module.exports =
class KeyMapper
  pkg: 'keyboard-localization'
  translationTable: null,
  keymapName: '',
  loaded: false,

  destroy: ->
    @translationTable = null

  loadKeymap: ->
    @loaded = false
    @keymapName = ''

    useKeyboardLayout = atom.config.get([@pkg, 'useKeyboardLayout'].join('.'))
    if useKeyboardLayout?
      pathToTransTable = path.join(
        __dirname,
        'keymaps',
        useKeyboardLayout + '.json'
      )

    useKeyboardLayoutFromPath = atom.config.get([@pkg, 'useKeyboardLayoutFromPath'].join('.'))
    if useKeyboardLayoutFromPath?
      customPath = path.normalize(useKeyboardLayoutFromPath)
      if fs.isFileSync(customPath)
        pathToTransTable = customPath

    if fs.isFileSync(pathToTransTable)
      tansTableContentJson = fs.readFileSync(pathToTransTable, 'utf8')
      @translationTable = JSON.parse(tansTableContentJson)
      console.log(@pkg, 'Keymap loaded "' + pathToTransTable + '"')
      @keymapName = path.basename(pathToTransTable, '.json')
      @loaded = true
    else
      console.log(@pkg, 'Error loading keymap "' + pathToTransTable + '"')

  isLoaded: ->
    return @loaded

  getKeymapName: ->
    return @keymapName

  getKeymap: ->
    return @translationTable
