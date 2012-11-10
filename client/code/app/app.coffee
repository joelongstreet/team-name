$ ->
    $boat       = $('.boat')
    $countdown  = $('#countdown')
    $line       = $('#starting_line')
    $monster    = $('#monster')
    
    setInterval (->
        $('body').toggleClass 'wave'
    ), 1250

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


#populate the game list
exports.updateSession = ->
    ss.rpc 'system.getSession', (res)->
        window.me = res