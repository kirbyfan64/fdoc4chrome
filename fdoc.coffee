startsWith = (a, b) -> a.slice(0, b.length) is b

convertToHTML = (data) ->
  if startsWith data, '<pre'
    data = data.slice data.indexOf('>')+1
  # Substitute literal strings
  for lit in data.match(/\{.*\}/g) ? []
    lit = lit.slice(1, lit.length-1) # cut out braces
    data = data.replace url, "<code>#{lit}</code>"
  block = false
  title = document.title
  res = for line in data.replace(/\n/gm, '<br>').split '<br>'
    if startsWith line, '@'
      if block
        if line is '@'
          block = false
          "</code>"
        else
          line
      else if startsWith line, '@title '
        title = line.split(' ', 1)[1]
      else if startsWith line, '@h'
        id = line.charAt '2'
        data = line.split(' ', 2)[1]
        "<h#{id}>#{data}</h#{id}>"
      else if ["code", "felix", "c++"].indexOf line.slice 1
        block = true
        "<code>"
      else
        continue # ignore the error
    else
      line
  return [title, res.join '<br>']

[document.title, document.body.innerHTML] = convertToHTML document.body.innerHTML
