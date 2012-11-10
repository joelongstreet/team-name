$ ->
  ###
  setInterval (->
      $('body').toggleClass 'wave'
  ), 1250
  ###
  
  $('.login').submit (e)->
    ss.rpc('team.join', $(this).children('input').val())
    return false
    
  $('.create_game .btn').click (e)->
    ss.rpc('team.join', null)
    return false
