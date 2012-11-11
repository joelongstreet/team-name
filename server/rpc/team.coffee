gameMaster = require '../core/gamemaster'
Team = require '../core/team'

exports.actions = (req, res, ss) ->

    req.use 'session'
    req.use 'randomizer.str'
    
    join: () ->
        remoteId = req.session.userId

        player = gameMaster.findPlayer remoteId

        if not player
            player = gameMaster.addPlayer remoteId
        
        player.ready = true

        res null, player
        
    list: ()->
        res null, gameMaster.players
        
