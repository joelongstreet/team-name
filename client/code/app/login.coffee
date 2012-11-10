window.me = null

$ ->
    
    #=== "remote" login screen
    
    $('body#login .start').click (e)->
        e.preventDefault()
        $('.modal').addClass('show')
    
    
    #=== "screen" login screen
    
    # submit create game on click
    $('.create_game .btn').click (e)->
        e.preventDefault()
        exports.join_team()
    
    # submit on click    
    $('.login .btn').click (e)->
        e.preventDefault()
        exports.join_team $(this).siblings('input').val()
    
    # submit on enter
    $('.login input').keyup (e)->
        if e.which == 13 then $('.login .btn').trigger("click")
    
    # submit on enter
    $('.left').on 'click', '.game > .btn', (e)->
        e.preventDefault()
        exports.join_team $.trim($(this).siblings('.code').text())
    
    # populate my local session object
    ss.rpc 'system.getSession', (res)->
        window.me = res
        exports.list_teams()


# Shared Methods

exports.join_team = (id)->
    
    ss.rpc 'team.join', id, (err, res)->
        if err
            console.error(id, err)
        else
            exports.list_teams()
            exports.subscribe_team(id)


exports.list_teams = ()-> 

    ss.rpc 'team.list', null, (err, res)->
        $container = $('.current_games')
        html = ""
        
        if res.length < 1
            $container.html("<div>no games currently</div>")
            return
            
        for pair in res
            html += ss.tmpl['login-gamelist'].render(pair)
            
        $('.current_games').html( html )


exports.subscribe_team = (id)->
    
    ss.server.on 'surge', ->
        console.log 'surge', arguments
    ss.server.on 'end', ->
        console.log 'end', arguments
    ss.server.on 'progress', ->
        console.log 'progress', arguments
