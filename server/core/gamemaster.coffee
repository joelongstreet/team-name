class Game
	
	row: (client) ->

class GameMaster

	constructor:
		@games = {}
		@clientToGame = {}

	onRow: (client) ->
		game = @clientToGame[client]
		game.row client
