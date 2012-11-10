EventEmitter = require('events').EventEmitter
randomizer = require './randomizer'

class Race extends EventEmitter

    constructor: (@teams) ->
        @id = randomizer.getString 5

    start: () ->
        for t in @teams
            t.on 'surge', () =>
                @analyzeTeam t

    analyzeTeam: (team) ->
        team.surge ||= 0
        team.surge++

        @emit 'surge', 
            team: team
            progress: team.surge

        if team.surge >= 100
            @emit 'end', team 
            t.disband() for t in @teams

    addTeam: (team) ->
        console.log 'added team'

module.exports = Race