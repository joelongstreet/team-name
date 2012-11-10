window.me = null

$ ->
    
    #=== "remote" login screen
    
    $('body#login .start').click ->
        $('.modal').addClass('show')
    
    
    #=== "screen" login screen
    
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
    
    #populate my local session object
    ss.rpc 'system.getSession', (res)->
        window.me = res
        exports.list_teams()


# Shared Methods
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
    ss.server.on 'end', ->
        console.log 'end', arguments
    ss.server.on 'progress', ->
        console.log 'progress', arguments
