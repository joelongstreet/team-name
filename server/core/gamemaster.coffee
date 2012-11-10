EventEmitter = require('events').EventEmitter
Race = require './race'

class GameMaster extends EventEmitter

	constructor: (@teams = []) ->
		setInterval () =>
			@pairUpTeams()
		, 3000

	pairUpTeams: () ->
		console.log 'pairing teams'
		pair = []

		for t in @teams
			pair.push t if t.isFull()
			if pair.length == 2
				@removeTeam	pair
				race = @createRace pair
				@emit 'start', race
				race.start()
				race.on 'end', () =>
					@addTeam pair
					@emit 'end', race
				pair = []
	
	findTeam: (id) ->
		for t in @teams
			return t if t.id is id

	addTeam: (team) ->
		@teams = @teams.concat team

	removeTeam: (team) ->
		team = [].concat team

		for t in team
			index = @teams.indexOf t
			@teams.splice index, 1 if index >= 0
		
	createRace: (teams) ->
		new Race(teams)

module.exports = new GameMaster()