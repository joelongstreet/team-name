EventEmitter = require('events').EventEmitter
randomizer = require './randomizer'

class Race extends EventEmitter

    constructor: (@teams) ->
        @id = randomizer.getString 5

    start: () ->
        for t in @teams
            t.on 'surge', () ->
                # get this back to client
                # set new position who's now winning?
        winningCondition = false
        #analyze where the teams are and if there's a winnning condition we emit end
        if winningCondition
            @emit 'end'

    addTeam: (team) ->
        console.log 'added team'

module.exports = Race