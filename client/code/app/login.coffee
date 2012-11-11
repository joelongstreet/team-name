window.me = null

$ ->

    #=== "screen" login screen
    
    # submit create game on click
    $('#create_game').click (e)->
        e.preventDefault()
        exports.join_team()
    
    # submit on click    
    $('.login .btn').click (e)->
        e.preventDefault()
        token = $(this).siblings('input').val()
        ss.rpc 'system.sync', 'viewer', token, (err, data) ->
            if err
                alert 'no team remote found with specified token'

    # submit on enter
    $('.login input').keyup (e)->
        if e.which == 13 then $('.login .btn').trigger("click")
    
    # submit on enter
    $('.left').on 'click', '.game > .btn', (e)->
        e.preventDefault()
        exports.join_team $.trim($(this).siblings('.code').text())
    
    exports.list_teams()

# Shared Methods

exports.list_teams = ()-> 

    ss.rpc 'race.list', null, (err, races) ->
        $container = $('.current_games')
        html = ""
        
        if races.length < 1
            $container.html("<div>no games currently</div>")
            return
            
        for r in races
            html += ss.tmpl['login-gamelist'].render(r.teams)
            
        $('.current_games').html( html )


exports.subscribe_team = (id)->
    ss.server.on 'start', (data) ->
        window.game = new Game(data)
    ss.server.on 'surge', ->
        console.log 'surge', arguments
    ss.server.on 'end', ->
        console.log 'end', arguments
    ss.server.on 'progress', ->
        console.log 'progress', arguments
