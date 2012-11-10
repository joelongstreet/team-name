EventEmitter = require('events').EventEmitter

class Game < EventEmitter
    
    constructor: () ->
        @teams = []

    addTeam: (team) ->
        @teams.push(team)

        team.on 'coach', (interval) ->
            #start showing the hud

        team.on 'surge', () ->    
            #tell the client!           
