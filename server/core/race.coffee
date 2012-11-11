EventEmitter = require('events').EventEmitter
randomizer = require './randomizer'

class Race extends EventEmitter

    constructor: (@teams) ->
        @id = "race-#{randomizer.getString(5)}"

    start: () ->
        for t in @teams
            t.on 'surge', (data) =>
                @onSurge t, data

    onSurge: (team, data) ->
        @emit 'surge', data

        if team.surge >= 100
            @emit 'end', team 
            t.disband() for t in @teams

module.exports = Race