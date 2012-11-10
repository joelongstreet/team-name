class window.Game

    constructor : (data) ->

        $countdown  = $('#countdown')
        $line       = $('#starting_line')
        boats       = []

        #ss.event.on 'start', (data) ->

        for boat in data.boats
            boats.push boat
            miniView = new MiniBoat(boat)


    countdown : ->

        setTimeout (->
            $countdown.text 'GO'

            setInterval (->
                $countdown.toggleClass 'flash'
            ), 200

            setTimeout (->
                $countdown.fadeOut 'fast'
                $boat.removeClass 'start'
                $line.addClass 'go_away'
            ), 1500
        ), 4000

        setTimeout (->
            $countdown.text '1'
        ), 3000

        setTimeout (->
            $countdown.text '2'
        ), 2000

        setTimeout (->
            $countdown.text '3'
        ), 1000