# Example request middleware
char_set = 'abcdefghijklmnpqrstuvwxyz123456789'

# Only let a request through if the session has been authenticated
exports.str = ->
  (req, res, next) ->
    req.randomizer = req.randomizer || require '../core/randomizer'
    next();

