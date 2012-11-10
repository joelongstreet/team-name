# Server-side Code

exports.actions = (req, res, ss) ->
    
    req.use('session')
    req.use('randomizer.str')
    
    #output all incoming requests
    req.use('debug', 'cyan')
    
    obj = {
        getSession: ()->
            res(req.session)
        
        updateSession: ()->
            req.session.clientId = req.session.id
            req.session.save (err)->
                console.log('Session data has been saved:', req.session)
                res(req.session)
                
        clearSession: ()->
            res(delete req.session)
    }
    
    return obj;

