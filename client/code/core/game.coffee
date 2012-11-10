$rowCallout = $('#row')

ss.event.on 'coach', () ->
	$rowCallout.removeClass 'call'
	$rowCallout.addClass 'call'
	console.log 'Row!'
