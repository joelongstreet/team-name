Remote = require('/remote')

ss.server.on 'ready', ->
  $ ->    
    
    window.remote = new Remote()
    
    setInterval ->
        $('body').toggleClass 'wave'
    , 1250

    ss.rpc 'system.getSession', (res) ->
        window.me = res
