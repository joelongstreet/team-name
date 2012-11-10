EventEmitter = require('events').EventEmitter
Race = require './race'

class GameMaster extends EventEmitter

	constructor: (@teams = []) ->
		setInterval () =>
			@pairUpTeams()
		, 3000

	pairUpTeams: () ->
		pair = []

		for t in @teams
			pair.push t if t.isFull()
			if pair.length == 2
				@emit 'pair', pair
				@removeTeam	pair
				@runGame pair
				pair = []

		# push out stats
	runGame: (pair) ->
		race = @createRace pair

		#subscribe to race events
		race.on 'progress', (progress) ->
			@emit 'progress', race

		race.on 'end', (winner) =>
			@emit 'end', race, winner

		race.start()

		@emit 'start', race
		
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