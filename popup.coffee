document.addEventListener 'DOMContentLoaded', ->
  checkbox = document.getElementById 'switch'
  chrome.storage.local.get {enabled: true}, (x) ->
    checkbox.checked = x.enabled
  checkbox.onchange = () ->
    chrome.storage.local.set enabled: checkbox.checked
