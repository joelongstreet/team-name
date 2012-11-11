window.me = null

$ ->
    exports.list_teams()
    
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
    
    ss.rpc 'team.list', null, (err, teams) ->
        console.log("team.list", teams)
        $container = $('.current_teams')
        html = "<div>no teams</div>"
        
        unless teams 
            $container.html(html)
            return
            
        if teams.length < 1
            $container.html(html)
            return
        
        html = ""
        for t in teams
            html += ss.tmpl['login-gamelist'].render(teams)
            
        $container.html( html )
    
    ss.rpc 'race.list', null, (err, races) ->
        console.log("race.list", races)
        $container = $('.current_races')
        html = "<div>no races</div>"
        
        unless races
            $container.html(html)
            return
        
        if races.length < 1
            $container.html(html)
            return
        
        html = ""
        for r in races
            html += ss.tmpl['login-racelist'].render({ teams: r.teams })
            
        $container.html( html )


exports.subscribe_team = (id)->
    ss.server.on 'start', (data) ->
        window.game = new Game(data)
    ss.server.on 'surge', ->
        console.log 'surge', arguments
    ss.server.on 'end', ->
        console.log 'end', arguments
    ss.server.on 'progress', ->
        console.log 'progress', arguments
