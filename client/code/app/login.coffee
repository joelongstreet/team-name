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
                window.token = token
                window.game = new Game()

    # submit on enter
    $('.login input').keyup (e)->
        if e.which is 13 then $('.login .btn').trigger("click")
    
    #exports.list_teams()
    ss.server.on 'mm.start', ->
        console.log("game started")


# Shared Methods
exports.list_teams = ()-> 
    
    ss.rpc 'team.list', (err, teams) ->
        $container = $('.current_teams')
        html = ""
        
        for i,team of teams
            if teams.hasOwnProperty(i)
                console.log(team)
                html += ss.tmpl['login-teamlist'].render({id: i, team:team})
        
        if html is ""
            html = "<div>no teams</div>"
          
        $container.html( html )
    
    ss.rpc 'race.list', (err, races) ->
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
            html += ss.tmpl['login-racelist'].render(races[0])
        
        $container.html( html )
        
window.list_teams = exports.list_teams

exports.subscribe_team = (id)->
    ss.server.on 'start', (data) ->
        window.game = new Game(data)
    ss.server.on 'surge', ->
        console.log 'surge', arguments
    ss.server.on 'end', ->
        console.log 'end', arguments
    ss.server.on 'progress', ->
        console.log 'progress', arguments
