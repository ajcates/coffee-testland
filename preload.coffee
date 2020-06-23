#welcome to my test land
#here is the land where tests live.
#
#

preload = {}
#wether or not the preload will use the gloabal namespace.
useGlobal = false

# External libraries
#--------------------

# Install underscore into `_` in the preload
preload._ = require './underscore'
# The REPL uses `_` for the last result so create
# a synonym for `_` to help resolve conflicts.
preload.underscore = preload._

# Install coffeekup in the kup namespace
preload.kup = require './coffeekup'


 # See comment at definition of useGlobal                                                        
namespace = global
if useGlobal
  preload.globalize preload, namespace
  # Uncomment this to get underscore functions in global
  # preload.globalize preload.underscore, namespace
else
  namespace.preload = preload


