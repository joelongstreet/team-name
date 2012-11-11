window.me = null

$ ->

    #=== "screen" login screen
    
    # submit on click
    $('.login .btn').click (e)->
        e.preventDefault()
        token = $(this).siblings('input').val().toLowerCase()
        ss.rpc 'system.sync', 'viewer', token, (err, data) ->
            if err
                alert "no team remote found with token of '#{token}'"
            else
                window.game = new Game()

    # submit on enter
    $('.login input').keyup (e)->
        if e.which is 13 then $('.login .btn').trigger("click")
    
    #exports.list_teams()
    ss.server.on 'mm.start', ->
        console.log("game started")


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
