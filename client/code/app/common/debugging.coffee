window.rpc = (evnt, opts)->
  ss.rpc evnt, (opts || {}), (d)->
    console.log( "RECEIVED: #{evnt}    \n", d )
    
window.debug_tests = ()->
  rpc 'system.clearSession'
  rpc 'system.updateSession'
  rpc 'system.getSession'
  rpc 'system.getSession'
  
  console.log "Starting rpc debugging..."
