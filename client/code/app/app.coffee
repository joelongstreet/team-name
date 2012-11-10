$ ->
  setInterval (->
    $('body').toggleClass 'wave'
  ), 1250

  $('body#login .start').click ->
    $('.modal').addClass('show')
  
  $('.login a').click (e)->
    ss.rpc('team.join', $(this).siblings('input').val())
    return false
    
  $('.create_game .btn').click (e)->
    ss.rpc('team.join', null)
    return false

  $boat       = $('.boat')
  $countdown  = $('#countdown')
  $line       = $('#starting_line')
  $monster    = $('#monster')

  window.animate_row = ->
    $boat.addClass 'row'
    setTimeout (->
      $boat.removeClass 'row'
    ), 500

  window.release_the_beast = ->

      walker = setInterval (->
        $monster.toggleClass 'walk'
      ), 200

      $monster.css 'top' : '-10%'

      setTimeout (->
        clearInterval walker
        $monster.hide()
        $monster.css 'top' : '100%'
        setTimeout (->
          $monster.show()
        ), 5000
      ), 5000


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

  window.show_time = ->
    $('body').append '<div id="fireworks"></div>'
    fireworks = new Fireworks()
