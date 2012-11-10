gameMaster = require '../core/gamemaster'

exports.actions = (req, res, ss) ->
    req.use 'session'

    broDown: (message) ->
        console.log 'bro down!'

    rowBro: (message) ->
        console.log gameMaster
        team = gameMaster.findTeam req.session.team.id
        team.row req.session.id
