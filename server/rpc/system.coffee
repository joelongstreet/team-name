# Server-side Code

# Define actions which can be called from the client using ss.rpc('demo.ACTIONNAME', param1, param2...)
exports.actions = (req, res, ss) ->
  
  # Example of pre-loading sessions into req.session using internal middleware
  req.use('session')
  
  # Uncomment line below to use the middleware defined in server/middleware/example
  #req.use('example.authenticated')
  
  #output all incoming requests
  req.use('debug', 'cyan')
  
  return {
    getSession: ()->
      console.log 'The contents of my session is', req.session
      res(req.session)
    
    updateSession: ()->
      req.session.clientId = req.session.id
      req.session.cart = {items: 3, checkout: false}
      req.session.save (err)->
        console.log('Session data has been saved:', req.session)
        res(req.session)
  }

