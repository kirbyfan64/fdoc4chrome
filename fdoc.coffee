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
  for lit in data.match(/@\{.*?\}/g) ? []
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
head = doc.getElementsByTagName('head')[0]

# add CSS
style = doc.createElement 'style'
style.type = 'text/css'
style.innerHTML = '''
div.expect {
  background-color: yellow;
  width: 100%;
}
'''
head.appendChild style

# load MathJax
scripts = [doc.createElement('script'), doc.createElement 'script']
scripts[0].type = 'text/x-mathjax-config'
# Taken from Felix's fdoc2html
scripts[0].text = '
MathJax.Hub.Config({
  tex2jax: {
    skipTags: ["script", "noscript", "style", "textarea"]
  }
})
'
scripts[1].type = 'text/javascript'
scripts[1].src =\
  'https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML'
for script in scripts
  head.appendChild script

chrome.storage.local.get {enabled: true}, (x) ->
  if x.enabled
    [doc.title,doc.body.innerHTML] = convertToHTML doc.body.innerHTML
