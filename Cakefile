{print} = require 'sys'
{spawn} = require 'child_process'

run = (cmd) ->
  print "#{cmd}\n"
  cmdl = cmd.split ' '
  prog = cmdl[0]
  argl = cmdl.slice(1)
  pipe = spawn prog, argl
  pipe.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  pipe.stdout.on 'data', (data) ->
    print data.toString()

task 'icon', 'generate the icon', ->
  run 'convert -fill red -font Arial-Regular -transparent white label:f4c icon.png'

task 'build', 'build fdoc4chrome', ->
  # generate icon
  run 'coffee -c fdoc.coffee'
