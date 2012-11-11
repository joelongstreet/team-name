EventEmitter = require('events').EventEmitter
Race = require './race'
ss = require('socketstream').api

class GameMaster extends EventEmitter

    constructor: (@teams = [], @races = [], @players = []) ->
        setInterval () =>
            @pairUpTeams()
        , 3000

    pairUpTeams: () ->
        pair = []

        for t in @teams
            pair.push t if t and t.isFull()
            if pair.length == 2
                @runGame pair
                pair = []

    runGame: (pair) ->
        race = @createRace pair

        race.on 'surge', (data) =>
            @emitToRacerViewers race, 'surge', data
        
        race.on 'end', (winner) =>
            @emitToRacerViewers race, 'end',
                raceId: race.id,
                winner: winner
            @removeTeam pair
            @removeRace race

        race.start()

    emitToRacerEverywhere: () ->
        emitToRacerRemotes.apply this, arguments
        emitToRacerViewers.apply this, arguments

    emitToRacerRemotes: (race) ->
        args = arguments.slice 1

        for p in t.persons
            ss.publish.user.apply(ss, [p.remoteId].concat(args)) if p.remoteId

    emitToRacerViewers: (race) ->
        args = arguments.slice 1

        for p in t.persons
            ss.publish.user.apply(ss, [p.viewerId].concat(args))
    
    findTeamByPlayer: (userId) ->

    
    findTeam: (teamId) ->
        for r in @races
            for t in r.teams
                return t if t.id is teamId

        for t in @teams
            return t if t.id is teamId
    
    findPlayer: (userId) ->
        @players[userId]

    removePlayer: (userId) ->
        delete @players[userId]

    addPlayer: (userId) ->
        p = @players[userId] 

        @players[userId] = 
            remoteId: userId
            viewerId: p.viewerId if p

    addTeam: (team) ->
        @teams = @teams.concat team

    removeTeam: (team) ->
        team = [].concat team

        for t in team
            index = @teams.indexOf t
            @teams.splice index, 1 if index >= 0
    
    removeRace: (race) ->
        index = @races.indexOf race
        @races.splice index, 1 if index >= 0

    createRace: (teams) ->
        race = new Race(teams)
        
        @races.push race
            
        data =
            raceId: race.id
            teams: teams

        t.start() for t in teams
            
        @emitToRacers race, 'start', data

        # let the match maker know we've started a new race        
        ss.publish.channel 'mm', 'start', data
        
        race

module.exports = new GameMaster()