window.rpc = (evnt, opts)->
    ss.rpc evnt, (opts || {}), (d)->
        console.log( "called:\n  #{evnt}\nreceived:\n  ", d )
    
window.debug_tests = ()->
    console.log "Starting rpc debugging..."
    rpc 'system.clearSession'
    rpc 'system.updateSession'
    rpc 'system.getSession'

emitters = [
    "system.getSession",
    "surge",
    "progress",
    "end",
    "start"
]

generic_rpc_handle = (action)->
    console.log(action, arguments)

for action in emitters
    console.log("attaching 'ss.server.on' for #{action}")
    ss.server.on "#{action}", ()-> 
        generic_rpc_handle("#{action}")
    