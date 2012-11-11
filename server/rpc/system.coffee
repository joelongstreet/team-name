# Server-side Code
gameMaster = require('../core/gamemaster')
awaitingSync = {}

exports.actions = (req, res, ss) ->
    
    req.use('session')
    req.use('randomizer.str')
    
    sync: (type, token) ->

        handleViewer = (token) ->
            console.log 'syncing viewer'
            console.log awaitingSync
            s = awaitingSync[token]

            if s
                player = gameMaster.findPlayer s.remoteId
                player.remoteId = s.remoteId
                player.viewerId = req.session.userId
                res null, player
                delete awaitingSync[token]
                console.log 'pairing complete!', player
            else
                res "notFound"

        handleRemote = () ->
            console.log 'syncing remote'
            gameMaster.addPlayer req.session.userId

            awaitingSync[req.session.userId] = 
                remoteId: req.session.userId
        
        switch type
            when 'viewer' then handleViewer token
            when 'remote' then handleRemote token
    
    getUserId: () ->
        res req.session.userId
    
    updateSession: ()->
        req.session.save (err)->
            console.log('Session data has been saved:', req.session)
            res(req.session)
            
    clearSession: () ->