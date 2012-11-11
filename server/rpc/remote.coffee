gameMaster = require '../core/gamemaster'
awaitingSync = {}

exports.actions = (req, res, ss) ->
    req.use 'session'

    sync: (id) ->
        subscribed = false

        subscribe: () ->
            subscribed = true
            req.session.channel.subscribe "remote-#{id}"
        
        for k,v of awaitingSync
            if v.id is id 
                subscribe()
                v.subscribe()

        if not subscribed
            awaitingSync[req.socketId] =
                id: id
                cb: subscribe

    broDown: (message) ->
        team = gameMaster.findTeam req.session.teamId
        team.broDown 
            sessionId: req.sessionId
            socketId: req.socketId

    rowBro: (message) ->
        team = gameMaster.findTeam req.session.teamId
        team.row 
            sessionId: req.sessionId
            socketId: req.socketId
