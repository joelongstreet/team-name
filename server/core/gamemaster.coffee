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
            ss.publish.channel 'mm', 'end', 
                winner: winner
            
            @removeRace race

            for t in pair
                ss.publish.channel t.id, 'end',                     
                    id: t.id,
                    winner: winner
        
        race.start()
        
        ss.publish.channel 'mm', 'start', 
            teams: pair
            
        for t in pair
            ss.publish.channel t.id, 'start', 
                id: t.id,
                teams: pair
        
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
    
    removeRace: (race) ->
        for r in @races
            index = @races.indexOf r
            @races.splice index, 1 if index >= 0
        
    createRace: (teams) ->
        race = new Race(teams)

        for t in teams
            t.start race.id

        @races.push race
        race

module.exports = new GameMaster()