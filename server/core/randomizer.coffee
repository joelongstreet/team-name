char_set = 'abcdefghijklmnpqrstuvwxyz123456789'

module.exports = getString: (len) ->
	rando = ''
	i = 0

	while i < len
		random_pos = Math.floor(Math.random() * char_set.length)
		rando += char_set.substring(random_pos, random_pos + 1)
		i++

	return rando