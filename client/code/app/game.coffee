$rowCallout = $('#row')
$ores = $('.ore')

ss.event.on 'coach', () ->
	$rowCallout.removeClass 'call'
	
	setTimeout () ->
		$rowCallout.addClass 'call'
	, 0

ss.event.on 'surge', () ->
	$ores.removeClass 'row'
	
	setTimeout () ->
		$ores.addClass 'row'
	, 0

ss.event.on 'interval', (interval) ->
	console.log interval