gameMaster = require '../core/gamemaster'
Team = require '../core/team'

exports.actions = (req, res, ss) ->

    req.use 'session'
    req.use 'randomizer.str'
    
    join: (id) ->
        
        if typeof id is 'undefined' or id is null
            team = new Team("team-#{req.randomizer.getString(5)}")
            gameMaster.addTeam team
        else
            team = gameMaster.findTeam id 
            unless team 
                res "notFound", id
                return
        
        joined = team.addPerson 
            userId: req.session.userId

        unless joined
            res "full", id
            return

        req.session.teamId = team.id

        res null, 
            teamId: team.id
            userId: req.session.userId
        
    list: ()->
        res "team.list", gameMaster.teams
        
