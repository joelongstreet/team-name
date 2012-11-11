# Server-side Code
awaitingSync = {}

exports.actions = (req, res, ss) ->
    
    req.use('session')
    req.use('randomizer.str')
    
    sync: (type, token) ->
        subscribed = false

        # the remote represents the primary user
        if type is 'remote'
            gameMaster.addPlayer req.session.userId

        for k,v of awaitingSync
            if k is token 
                switch type
                    when 'viewer' then v.viewerId = req.session.userId
                    when 'remote' then v.remoteId = req.session.userId

                player = gameMaster.findPlayer v.remoteId

                player.remoteId = v.remoteId
                player.viewerId = v.viewerId

                subscribed = true

        if not subscribed
            awaitingSync[token] = 
                viewerId: if type is 'viewer' then req.session.userId
                remoteId: if type is 'remote' then req.session.userId

    getUserId: () ->
        res req.session.userId
    
    updateSession: ()->
        req.session.save (err)->
            console.log('Session data has been saved:', req.session)
            res(req.session)
            
    clearSession: () ->