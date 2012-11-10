EventEmitter = require('events').EventEmitter

class Race extends EventEmitter

    constructor: (@ss) ->
        @teams = []

    addTeam: (team) ->
        @teams.push(team)

        team.on 'coach', (interval) =>
            #start showing the hud
            if @ss
                @ss.publish.all('coach')
                console.log('coach')

        team.on 'surge', () =>    
            #tell the client!   
            if @ss
                @ss.publish.all('surge')
                console.log('surge')        

        team.on 'interval', () =>    
            @ss.publish.all('interval') if @ss

module.exports = Race