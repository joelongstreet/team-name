EventEmitter = require('events').EventEmitter

class Race extends EventEmitter

    constructor: (@teams = []) ->

    start: () ->

    addTeam: (team) ->
        console.log 'added team'

module.exports = Race