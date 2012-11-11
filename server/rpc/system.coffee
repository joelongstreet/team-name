gameMaster = require('../core/gamemaster')
awaitingSync = {}

exports.actions = (req, res, ss) ->
    
    req.use('session')
    req.use('randomizer.str')
    
    games: () ->
        res gameMaster

    sync: (type, token) ->

        handleViewer = (token) ->
            s = awaitingSync[token]
            player = gameMaster.findPlayer s.remoteId

            if s or player
                if s.remoteId   
                    player.remoteId = s.remoteId
                else
                    player.remoteId = token

                player.viewerId = req.session.userId
                res null, player
                delete awaitingSync[token]
            else
                res "notFound"

        handleRemote = () ->
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
            res(req.session)
            
    clearSession: () ->