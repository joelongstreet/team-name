# Example request middleware
char_set = 'abcdefghijklmnpqrstuvwxyz123456789'
exports = (req, res, next) ->
  
  req.randomizer.getString = (len)->
    rando = ''
    i = 0
    
    while i < len
      random_pos = Math.floor(Math.random() * char_set.length)
      rando += char_set.substring(random_pos, random_pos + 1)
      i++
      
    return "getString"
    
  req.randomizer.getNumber = ->
    return "getNumber"
  
  next()