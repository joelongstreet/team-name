EventEmitter = require('events').EventEmitter
Race = require './race'
Team = require './team'
ss = require('socketstream').api

class GameMaster extends EventEmitter

    constructor: (@teams = [], @races = [], @players = {}) ->
        setInterval () =>
            @pairUpTeams()
        , 5000

    pairUpTeams: () ->
        pair = []

        for k,p of @players
            if (p.ready and not p.inGame) and p.viewerId
                team = new Team(p.remoteId)
                team.addPerson p
                pair.push team

                if pair.length == 2
                    for t in pair
                        for p2 in t.persons
                            p2.inGame = true
                            p2.ready = false

                    @runGame pair
                    pair = []

    runGame: (pair) ->
        console.log 'rungame'
        race = @createRace pair
        
        @emitToRacerEverywhere race, 'start', race

        race.on 'coach', (team) =>
            @emitToTeamViewers team, 'coach'

        race.on 'surge', (team, data) =>
            @emitToRacerViewers race, 'surge', team, data
        
        race.on 'end', (winner) =>
            @emitToRacerEverywhere race, 'end',
                raceId: race.id,
                winner: winner
            p.inGame = false for p in pair
            @removeRace race

        # give the UI a few seconds to show a countdown then start
        # pumping out coach events and receiving rows
        setTimeout () =>
            race.start()
        , 3000

    emitToTeamViewers: (team) ->
        args = Array.prototype.slice.call arguments, 1

        for p in team.persons
            ss.publish.user.apply(ss, [p.viewerId].concat(args)) if p.viewerId

    emitToRacerEverywhere: () ->
        @emitToRacerRemotes.apply this, arguments
        @emitToRacerViewers.apply this, arguments

    emitToRacerRemotes: (race) ->
        args = Array.prototype.slice.call arguments, 1

        for t in race.teams
            console.log t.persons
            for p in t.persons
                console.log 'remoteEmit', p.remoteId
                ss.publish.user.apply(ss, [p.remoteId].concat(args)) if p.remoteId

    emitToRacerViewers: (race) ->
        args = Array.prototype.slice.call arguments, 1

        for t in race.teams
            console.log t.persons
            for p in t.persons
                console.log 'viewerEmit', p.viewerId
                ss.publish.user.apply(ss, [p.viewerId].concat(args)) if p.viewerId
    
    findTeamByRemoteId: (remoteId) ->
        for r in @races
            for t in r.teams
                for p in t.persons
                    if p.remoteId is remoteId
                        return t

        for t in @teams
            for p in t.persons
                if p.remoteId is remoteId
                    return t

    findTeam: (teamId) ->
        for r in @races
            for t in r.teams
                return t if t.id is teamId

        for t in @teams
            return t if t.id is teamId
    
    findPlayer: (remoteId) ->
        @players[remoteId]

    removePlayer: (remoteId) ->
        delete @players[remoteId]

    addPlayer: (remoteId) ->
        if not remoteId
            return

        player = @players[remoteId] 

        if not player
            @players[remoteId] = 
                remoteId: remoteId
                viewerId: undefined
                ready: false
                inGame: false

            player = @players[remoteId]
        
        player

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
        ss.publish.all 'mm.end', race

    createRace: (teams) ->
        race = new Race(teams)
        
        @races.push race
            
        data =
            raceId: race.id
            teams: teams

        t.start() for t in teams
        
        # let the match maker know we've started a new race        
        ss.publish.all 'mm.start', data
        
        race

module.exports = new GameMaster()