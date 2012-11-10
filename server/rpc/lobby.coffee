# Server-side Code


# Define actions which can be called from the client using ss.rpc('demo.ACTIONNAME', param1, param2...)
exports.actions = (req, res, ss) ->

  # Example of pre-loading sessions into req.session using internal middleware
  req.use('session')

  # Uncomment line below to use the middleware defined in server/middleware/example
  #req.use('example.authenticated')

  listChannels: () ->
    res("listChannels", req.session.channel.list())
  joinTeam: (id)->
    req.session.channel.subscribe(id)
    res("joinTeam",true)
  leaveTeam: (id)->
    req.session.channel.unsubscribe(id)
    res("joinTeam",true)
  joinGame: (id)->
    res("joinGames",true)