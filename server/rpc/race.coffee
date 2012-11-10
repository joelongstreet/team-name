races = []

exports.actions = (req, res, ss) ->

    # Example of pre-loading sessions into req.session using internal middleware
    req.use 'session'
    req.use 'randomizer.str'
    
    #output all incoming requests
    req.use 'debug', 'orange'
    
    create: ()->
        id = req.randomizer.getString(5)
        races.push id
        req.session.currentGame = id
        
    join: (id)->
        req.session.currentGame = id
        req.session.save (err)->
            console.log('User joined race:', req.session)
            res(req.session)
    
    list: ()->
        res('race.list', races)
    start: () ->
        this.startTime = (new Date()).getTime();
        res(true)
        
    end: () ->

        