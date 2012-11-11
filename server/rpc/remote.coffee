gameMaster = require '../core/gamemaster'

exports.actions = (req, res, ss) ->
    req.use 'session'

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
