$ ->
    setInterval (->
        $('body').toggleClass 'wave'
    ), 1250

    $('body#login .start').click ->
        $('.modal').addClass('show')
    
    $('.login .btn').click ->
        id = $(this).siblings('input').val();
        
        ss.rpc 'team.join', id, (err, res)->
            if err
                throw(err)
            else
                exports.subscribeToTeam(id)
        
    $('.create_game .btn').click ->
        ss.rpc 'team.join', null, (err, res)->
            console.log("create team", arguments)
            exports.list_teams()
        return false
    
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