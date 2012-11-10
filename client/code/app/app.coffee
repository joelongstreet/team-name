$ ->
    setInterval (->
        $('body').toggleClass 'wave'
    ), 1250

    $('body#login .start').click ->
        $('.modal').addClass('show')
    
    # submit create game on click
    $('.create_game .btn').click ->
        ss.rpc 'team.join', null, (err, res)->
            console.log("create team", arguments)
            exports.list_teams()
        return false
    
    # submit on enter
    $('.login input').keyup (e)->
        if e.which == 13 then $('.login .btn').trigger("click")
    
    # submit on click    
    $('.login .btn').click ->
        id = $(this).siblings('input').val();
        
        ss.rpc 'team.join', id, (err, res)->
            if err
                throw(err)
            else
                exports.subscribeToTeam(id)
    
    #populate the game list
    exports.list_teams()
 
exports.list_teams = ()-> 
    ss.rpc 'team.list', null, (err, res)->
        $container = $('.current_games')
        html = ""
        
        if res.length < 1
            $container.html("<div>no games currently</div>")
            return
            
        for pair in res
            console.log(pair)
            html += ss.tmpl['login-gamelist'].render(pair)
            
        $('.current_games').html(html)
  
exports.subscribe_team = (id)->
    ss.server.on 'surge', ->
        console.log 'surge', arguments

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

