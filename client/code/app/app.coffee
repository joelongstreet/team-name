setInterval (->
    $('body').toggleClass 'wave'
), 1250

boats = [
    id : '0'
    people : ['11111', '11111', '11111', '11111']
,
    id : '1'
    people : ['22222', '22222', '22222', '22222', '22222', '22222']
,
    id : '2'
    people : ['33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333']
]

ss.event.on 'start', (data) ->
   window.game = new Game(data.teams)

#populate the game list
exports.updateSession = ->
    ss.rpc 'system.getSession', (res)->
        window.me = res