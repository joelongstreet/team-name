team = require '../core/team'
Race = require '../core/race'

race = new Race()

race.addTeam team

exports.actions = (req, res, ss) ->
	race.ss = ss
	broDown: (message) ->
		console.log 'bro down!'

	rowBro: (message) ->
		team.row 'joe'