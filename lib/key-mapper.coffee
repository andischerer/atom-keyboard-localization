module.exports =
class KeyMapper

  constructor: ->

  destroy: ->

  lastKey: []

  createNewKey: (event) ->
    return newKey =
      keyIdentifier: event.keyIdentifier
      keyCode: event.keyCode
      location: event.location
      which: event.which
      ctrlKey: event.ctrlKey
      altKey: event.altKey
      shiftKey: event.shiftKey
      metaKey: event.metaKey

  translate: (newKey) ->
    # TODO: This key mutation could be way more elegant. Do it with a mapping table ?

    # ^ Key
    if newKey.keyCode == 220 && !newKey.shiftKey
      newKey.keyIdentifier = 'U+0036'
      newKey.keyCode = 54
      newKey.which = 54
      newKey.shiftKey = true
      newKey.altKey = false
      newKey.ctrlKey = false
      return newKey

    # ~ Key => TODO: recheck: WindowsAndLinuxCharCodeTranslations => works for now
    if newKey.keyCode == 187 && newKey.altKey
      newKey.keyIdentifier = 'U+007E'
      newKey.keyCode = 126
      newKey.which = 126
      newKey.shiftKey = true
      newKey.altKey = false
      newKey.ctrlKey = false
      return newKey

    # " Key => TODO: recheck: WindowsAndLinuxCharCodeTranslations => works for now
    if newKey.keyCode == 50 && newKey.shiftKey
      newKey.keyIdentifier = 'U+0022'
      newKey.keyCode = 34
      newKey.which = 34
      newKey.shiftKey = true
      newKey.altKey = false
      newKey.ctrlKey = false
      return newKey

    # @ Key
    if newKey.keyCode == 81 && newKey.altKey
      newKey.keyIdentifier = 'U+0032'
      newKey.keyCode = 50
      newKey.which = 50
      newKey.shiftKey = true
      newKey.altKey = false
      newKey.ctrlKey = false
      return newKey

    # \ Key
    if newKey.keyCode == 219 && newKey.altKey
      newKey.keyIdentifier = 'U+0032'
      newKey.keyCode = 50
      newKey.which = 50
      newKey.shiftKey = true
      newKey.altKey = false
      newKey.ctrlKey = false
      return newKey

    return newKey

  remap: (event) ->
    newKey = @createNewKey(event)
    newKey = @translate(newKey)
    console.log(newKey)
    return newKey
