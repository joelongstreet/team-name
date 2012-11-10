EventEmitter = require('events').EventEmitter
Race = require './race'
ss = require('socketstream').api

class GameMaster extends EventEmitter

    constructor: (@teams = [], @races = []) ->
        setInterval () =>
            @pairUpTeams()
        , 3000

    pairUpTeams: () ->
        pair = []

        for t in @teams
            pair.push t if t.isFull()
            if pair.length == 2
                @emit 'pair', pair
                @removeTeam pair
                @runGame pair
                pair = []

    runGame: (pair) ->
        race = @createRace pair

        race.on 'progress', (progress) ->
            for t in pair
                ss.publish.channel t.id, 'progress', 
                    id: t.id,
                    progress: progress
        
        race.on 'end', (winner) =>
            @endRace race

        race.start()

    findTeam: (id) ->
        for r in @races
            for t in r.teams
                return t if t.id is id

        for t in @teams
            return t if t.id is id

    addTeam: (team) ->
        @teams = @teams.concat team

    removeTeam: (team) ->
        team = [].concat team

        for t in team
            index = @teams.indexOf t
            @teams.splice index, 1 if index >= 0
    
    endRace: (race, winner) ->
        ss.publish.channel race.id, 'end',                     
            raceId: race.id,
            winner: winner

        for r in @races
            index = @races.indexOf r
            @races.splice index, 1 if index >= 0
        
    createRace: (teams) ->
        race = new Race(teams)
        @races.push race
       
        # put all people in the race channel for progress updates
        for t in teams
            for p in t.persons
                ss.session.find p.sessionId, p.socketId, (s) ->
                    s.channel.subscribe race.id if s
 
        # let the match maker know we've started a new race
        ss.publish.channel 'mm', 'start', 
            raceId: race.id
            teams: teams
        
        # tell those who are racing we've begun
        ss.publish.channel race.id, 'start', 
            raceId: race.id
            teams: teams
        
        race

module.exports = new GameMaster()