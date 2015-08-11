padZero = (strToPad, size) ->
  while strToPad.length < size
    strToPad = '0' + strToPad
  return strToPad

  # copy from atom-keymap/helpers.coffee
exports.charCodeFromKeyIdentifier = (keyIdentifier) ->
  parseInt(keyIdentifier[2..], 16) if keyIdentifier.indexOf('U+') is 0

exports.charCodeToKeyIdentifier = (charCode) ->
  return 'U+' + padZero(charCode.toString(16).toUpperCase(), 4)

exports.vimModeActive = (editor) ->
  if editor? and 'vim-mode' in editor.classList
    return true if 'operator-pending-mode' in editor.classList
    return true if 'normal-mode' in editor.classList
    return true if 'visual-mode' in editor.classList
  return false
