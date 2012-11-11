gameMaster = require '../core/gamemaster'
awaitingSync = {}

exports.actions = (req, res, ss) ->
    req.use 'session'

    broDown: (message) ->
        team = gameMaster.findTeamByPlayer req.session.teamId
        team.broDown 
            sessionId: req.sessionId
            socketId: req.socketId

    rowBro: (message) ->
        team = gameMaster.findTeamByPlayer req.session.userId
        team.row 
            sessionId: req.sessionId
            socketId: req.socketId
