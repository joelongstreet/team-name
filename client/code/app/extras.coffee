$monster    = $('#monster')

window.release_the_beast = ->

    walker = setInterval (->
        $monster.toggleClass 'walk'
    ), 200

    $monster.css 'top' : '-10%'

    setTimeout (->
        clearInterval walker
        $monster.hide()
        $monster.css 'top' : '100%'
        setTimeout (->
            $monster.show()
        ), 5000
    ), 5000


window.show_time = ->
    $('body').append '<div id="fireworks"></div>'
    fireworks = new Fireworks()