# Example request middleware
char_set = 'abcdefghijklmnpqrstuvwxyz123456789'

getString = (len)->
  rando = ''
  i = 0
  
  while i < len
    random_pos = Math.floor(Math.random() * char_set.length)
    rando += char_set.substring(random_pos, random_pos + 1)
    i++
    
  return "getString"
# Example request middleware

# Only let a request through if the session has been authenticated
exports.str = ->
  (req, res, next) ->
    req.randomizer = req.randomizer || {}
    
    req.randomizer.getString = (len)->
      rando = ''
      i = 0
      
      while i < len
        random_pos = Math.floor(Math.random() * char_set.length)
        rando += char_set.substring(random_pos, random_pos + 1)
        i++
        
      return rando
    
    next();

