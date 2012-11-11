EventEmitter = require('events').EventEmitter
randomizer = require './randomizer'

class Race extends EventEmitter

    constructor: (@teams) ->
        @id = "race-#{randomizer.getString(5)}"

    start: () ->
        for t in @teams
            t.on 'surge', (team, data) =>
                @onSurge team, data

            t.on 'coach', (team) =>
                @emit 'coach', team

    onSurge: (team, data) ->
        @emit 'surge', team, data

        if data.surge >= 100
            @emit 'end', team 
            t.disband() for t in @teams

module.exports = Race