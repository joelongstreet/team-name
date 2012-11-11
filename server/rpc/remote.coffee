gameMaster = require '../core/gamemaster'
awaitingSync = {}

exports.actions = (req, res, ss) ->
    req.use 'session'

    broDown: (message) ->
        team = gameMaster.findTeamByRemoteId req.session.userId
        team.broDown req.session.userId if team

    rowBro: (message) ->
        team = gameMaster.findTeamByRemoteId req.session.userId
        team.row req.session.userId if team
