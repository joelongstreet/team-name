teams = []

exports.actions = (req, res, ss) ->

    # Example of pre-loading sessions into req.session using internal middleware
    req.use 'session'
    req.use 'randomizer.str'
    
    ###
    id = team_id to join
    type = type of join (player, viewer)
    ###
    join: (id) ->
        if id isnt undefined
            found = false
            for i in teams
                if i is id
                    req.session.channel.subscribe("#{id}")
            res "joinTeam", id
        else
            new_team = req.randomizer.getString(5)
            teams.push new_team
            req.session.team = new_team
            req.session.save ->
                req.session.channel.subscribe(new_team)
                res "team.create", new_team
    
    create: () ->
        new_team = req.randomizer.getString(5)
        teams.push new_team
        req.session.team = new_team
        req.session.save ->
            req.session.channel.subscribe(new_team)
            res("team.create", new_team)
    
    list: ()->
        res "team.list", teams
        
    leave: (id)->
        req.session.channel.unsubscribe(id)
        res "team.leave", true
            
            
