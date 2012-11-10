

exports.actions = (req, res, ss) ->

    # Example of pre-loading sessions into req.session using internal middleware
    req.use 'session'

    # use middleware defined in server/middleware/example
    #req.use('example.authenticated')
    
    #output all incoming requests
    req.use 'debug', 'orange'
    
    create: ()->
        id = Math.rand(100)
        req.session.currentGame = id
        
    join: (id)->
        req.session.currentGame = id
        req.session.save (err)->
            console.log('User joined race:', req.session)
            res(req.session)
    
            
    start: () ->
        this.startTime = (new Date()).getTime();
        res(true)
        
    end: () ->

        