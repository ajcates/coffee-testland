#welcome to my test land
#here is the land where tests live.
#
#

preload = {}
#wether or not the preload will use the gloabal namespace.
useGlobal = true


preload.dumpVar = (obj, max, sep, level) ->
  level = level or 0
  max = max or 10
  sep = sep or ' '
  if level > max
    return '[WARNING: Too much recursion]\n'
  i = undefined
  result = ''
  tab = ''
  t = typeof obj
  if obj == null
    result += '(null)\n'
  else if t == 'object'
    level++
    i = 0
    while i < level
      tab += sep
      i++
    if obj and obj.length
      t = 'array'
    result += '(' + t + ') :\n'
    for i of obj
      `i = i`
      try
        result += tab + '[' + i + '] : ' + preload.dumpVar(obj[i], max, sep, level + 1)
      catch error
        return '[ERROR: ' + error + ']\n'
  else
    if t == 'string'
      if obj == ''
        obj = '(empty)'
    result += '(' + t + ') ' + obj + '\n'
  result

# External libraries
#--------------------

# Install underscore into `_` in the preload
preload._ = require 'underscore'
# The REPL uses `_` for the last result so create
# a synonym for `_` to help resolve conflicts.
preload.underscore = preload._

# Install coffeekup in the kup namespace
preload.kup = require 'coffeekup'

preload.l = console.log
preload.info = console.info

#
 
# Test if a file exists
preload.fileExists = (filename) ->
  try
    (require 'fs').statSync(filename).isFile()
  catch error
    return false

# Return contents of filename as UTF-8 text
preload.readTextFile = (filename) ->
  require('fs').readFileSync filename, 'utf8'
 

preload.serveIt = (content, port=8000) ->
  preload.server = (require 'http').createServer (req, res) ->
    if req.method is 'GET'
      if req.url is '/'
        res.writeHead 200, 'Content-Type': 'text/html'
        res.write content
        res.end()
        return
      res.writeHead 404, 'Content-Type': 'text/html'
      res.write '404 Not found'
      res.end()
  preload.server.listen port
  preload.info 'Server running at http://' + preload.server.address().address + ':' + port
                             
preload.globalize = (ns, target = global) ->
  target[name] = ns[name] for name of ns


 # See comment at definition of useGlobal                           
namespace = global
if useGlobal
  preload.globalize preload, namespace
  # Uncomment this to get underscore functions in global
  # preload.globalize preload.underscore, namespace
else
  namespace.preload = preload


