# Server-side Code
team = {}


# Define actions which can be called from the client using ss.rpc('demo.ACTIONNAME', param1, param2...)
exports.actions = (req, res, ss) ->

    # Example of pre-loading sessions into req.session using internal middleware
    req.use('session')

    # Uncomment line below to use the middleware defined in server/middleware/example
    #req.use('example.authenticated')
    
    #output all incoming requests
    req.use('debug', 'cyan');
    
    bindToTeam: (remote, game)->
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
        
    unbindTeam: (id)->
        if id is undefined
            delete req.session[id]
