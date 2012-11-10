
exports.actions = (req, res, ss) ->

    # Example of pre-loading sessions into req.session using internal middleware
    req.use 'session'

    # use middleware defined in server/middleware/example
    #req.use('example.authenticated')
    
    #output all incoming requests
    req.use 'debug', 'orange'
    
    ###
    id = team_id to join
    type = type of join (player, viewer)
    ###
    join: (id, type="player") ->
        req.session.channel.subscribe("#{id}")
        req.session.channel.subscribe("#{id}.#{type}")
        res("joinTeam",true)
    
    leave: (id)->
        req.session.channel.unsubscribe(id)
        res("joinTeam",true)
            
            
