gameMaster = require '../core/gamemaster'
awaitingSync = {}

exports.actions = (req, res, ss) ->
    req.use 'session'

    broDown: (message) ->
        team = gameMaster.findTeamByRemoteId req.session.userId
        team.broDown req.session.userId

    rowBro: (message) ->
        team = gameMaster.findTeamByRemoteId req.session.userId
        team.row req.session.userId
