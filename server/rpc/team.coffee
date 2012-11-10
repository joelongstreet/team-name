gameMaster = require '../core/gamemaster'
Team = require '../core/team'

exports.actions = (req, res, ss) ->
    
    req.use 'session'
    req.use 'randomizer.str'
    
    join: (id) ->
        
        if typeof id is 'undefined' or id is null
            team = new Team(req.randomizer.getString(5))
            gameMaster.addTeam team
        else
            team = gameMaster.findTeam id 
            unless team 
                res "notFound", id
                return
        
        joined = team.addPerson req.session.clientId, (raceId) ->
            req.session.channel.subscribe raceId

        unless joined
            res "full", id
            return

        req.session.channel.subscribe(team.id)
        req.session.team = team
        res null, team.id
        
    list: ()->
        res "team.list", gameMaster.teams
        
    leave: (id)->
        req.session.channel.unsubscribe(id)
        res "team.leave", true

