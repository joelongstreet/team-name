$ ->
  setInterval (->
    $('body').toggleClass 'wave'
  ), 1250

  $('body#login .start').click ->
    $('.modal').addClass('show')
  
  $('.login').submit (e)->
    ss.rpc('team.join', $(this).children('input').val())
    return false
    
  $('.create_game .btn').click (e)->
    ss.rpc('team.join', null)
    return false

  $boat       = $('.boat')
  $countdown  = $('#countdown')
  $line       = $('#starting_line')

  window.animate_row = ->
    $boat.addClass 'row'
    setTimeout (->
      $boat.removeClass 'row'
    ), 500

  window.countdown = ->

    setTimeout (->
      $countdown.text 'GO'
      setInterval (->
        $countdown.toggleClass 'flash'
      ), 200
      setTimeout (->
        $countdown.fadeOut 'fast'
        $boat.removeClass 'start'
        $line.addClass 'go_away'
      ), 1500
    ), 4000

    setTimeout (->
      $countdown.text '1'
    ), 3000

    setTimeout (->
      $countdown.text '2'
    ), 2000

    setTimeout (->
      $countdown.text '3'
    ), 1000