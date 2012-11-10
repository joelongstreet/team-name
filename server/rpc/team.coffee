
exports.actions = (req, res, ss) ->

    # Example of pre-loading sessions into req.session using internal middleware
    req.use 'session'

    # use middleware defined in server/middleware/example
    #req.use('example.authenticated')
    
    #output all incoming requests
    req.use 'debug', 'orange'
    
    join: () ->
        res(true)
        
    leave: (id)->
        connected   = false

        for connection in connections
            if connection.secret == query.secret
                
                connection.listen_id = query.listen_id
                req.the_one = connection
                
                if connection.actions then req.actions = connection.actions
                connected = true
                next()
                
        if connected == false
            req.err = 'Could not find code, did you enter it correctly?'
            next()
        
        res(id)
        
    row: (id)->
        if id is undefined
            delete req.session[id]
            
            
