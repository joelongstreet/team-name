# This file automatically gets called first by SocketStream and must always exist

# Make 'ss' available to all modules and the browser console
window.ss = require('socketstream')

ss.server.on 'disconnect', ->
  console.log('Connection down :-(')

ss.server.on 'reconnect', ->
  console.log('Connection back up :-)')

ss.server.on 'ready', ->
  console.log arguments
  # Wait for the DOM to finish loading
  $ ->
    
    # Load app
    require('/game/index')
    require('/game/fireworks')
    require('/game/boat')
    require('/game/miniBoat')
    require('/game/stats')

    require('/login')
    require('/remote')
    
    require('/app')