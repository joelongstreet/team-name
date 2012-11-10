$ ->
  setInterval (->
      $('body').toggleClass 'wave'
  ), 1250
  
  $('.joinTeam').submit (e)->
    return false
