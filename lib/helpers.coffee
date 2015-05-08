padZero = (strToPad, size) ->
  while strToPad.length < size
    strToPad = '0' + strToPad
  return strToPad

  # copy from atom-keymap/helpers.coffee
exports.charCodeFromKeyIdentifier = (keyIdentifier) ->
  parseInt(keyIdentifier[2..], 16) if keyIdentifier.indexOf('U+') is 0

exports.charCodeToKeyIdentifier = (charCode) ->
  return 'U+' + padZero(charCode.toString(16).toUpperCase(), 4)
