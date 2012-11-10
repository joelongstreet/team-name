exports.actions = (req, res, ss) ->

    req.use 'session'

	broDown: (message) ->
		console.log 'bro down!'

	rowBro: (message) ->
        console.log req.session
        req.session.team.row 'joe'