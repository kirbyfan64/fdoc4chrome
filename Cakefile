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

coffee = (x) ->
  run "coffee -c #{x}.coffee"

task 'icon', 'generate the icon', ->
  for n in [16, 48, 128]
    run "convert -size #{n}x#{n} -fill red -font Arial-Regular -transparent white label:f4c icon#{n}.png"

task 'build:fdoc', 'build fdoc4chrome core script', ->
  coffee 'fdoc'

task 'build:popup', 'build the popup script', ->
  coffee 'popup'

task 'build', 'build fdoc4chrome', ->
  invoke 'build:fdoc'
  invoke 'build:popup'
