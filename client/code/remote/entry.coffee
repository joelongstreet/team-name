window.ss = require('socketstream')
require('/remote')

ss.server.on 'ready', ->
    $ ->    
        window.remote = new Remote()
        
        setInterval ->
            $('body').toggleClass 'wave'
        , 1250

