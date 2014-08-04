startsWith = (a, b) -> a.slice(0, b.length) is b
splitFirst = (str, sep = ' ') -> str.slice str.indexOf(sep)+1

escapeMap =
  lt: '<'
  gt: '>'
  quot: '"'

unescape = (s) ->
  res = s.replace /&amp;/g, "&"
  for value, repl of escapeMap
    res = res.replace (new RegExp "&#{value};", 'g'), repl
  return res

codeBlock = ['code', 'felix', 'felix-unchecked', 'c++', 'pre']

convertToHTML = (data) ->
  if startsWith data, '<pre'
    data = data.slice data.indexOf('>')+1
  data = unescape data
  # Substitute literal strings
  for lit in data.match(/\{.*?\}/g) ? []
    res = "<code>#{lit.slice(1, lit.length-1)}</code>" # cut out braces
    data = data.replace lit, res
  block = false
  title = document.title
  res = for line in data.replace(/\n/gm, '<br>').split '<br>'
    if startsWith line, '@'
      if block
        if line is '@'
          block = false
          '</code></div>'
        else if line is '@expect'
          '</code></div><br><br><div class="expect"><code>'
        else
          line
      else if startsWith line, '@title '
        title = splitFirst line
        continue
      else if startsWith line, '@h'
        id = line.charAt '2'
        data = splitFirst line
        "<h#{id}>#{data}</h#{id}>"
      else if codeBlock.indexOf(line.slice 1) != -1
        block = true
        '<div><code>'
      else
        continue # ignore the error
    else
      if block
        line.replace /( )/g, '&nbsp;'
      else
        line
  return [title, res.join '<br>']

doc = document

# add CSS
style = doc.createElement 'style'
style.type = 'text/css'
style.innerHTML = '''
div.expect {
  background-color: yellow;
  width: 100%;
}
'''
doc.getElementsByTagName('head')[0].appendChild style

chrome.storage.local.get {enabled: true}, (x) ->
  if x.enabled
    [doc.title,doc.body.innerHTML] = convertToHTML doc.body.innerHTML
