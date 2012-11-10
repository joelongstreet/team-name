team = require '../core/team'

exports.actions = (req, res, ss) ->
  req.use('session')

  #req.use('debug', 'cyan');
  
  broDown: (message) ->
    console.log 'bro down!'
    
  rowBro: (message) ->
    team.row 'joe'