setInterval (->
    $('body').toggleClass 'wave'
), 1250

boats = [
    id : '0'
    persons : ['11111', '11111', '11111', '11111']
,
    id : '1'
    persons : ['22222', '22222', '22222', '22222', '22222', '22222']
,
    id : '2'
    persons : ['33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333']
]

#window.game = new Game(boats)

ss.event.on 'start', (data) ->
   window.game = new Game(data.teams)
