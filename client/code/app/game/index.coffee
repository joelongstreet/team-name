class window.Game

    constructor : (boats) ->

        #ss.event.on 'start', (boats) ->

        @mini_boats = []
        for boat in boats
            @mini_boats.push new MiniBoat(boat)

        # the default selected boat is the first
        @da_boat = new Boat(boats[0])
        @da_boat.render()
        @da_boat.$view.addClass 'start'

        ss.event.on 'surge', (surge_data) =>
            if surge_data.id == @da_boat.id
                @da_boat.move_forward()
                @move_forward()
            else
                for boat in @mini_boats
                    if surge_data.id == boat.id
                        boat.update_position(surge_data.position)


        ss.event.on 'coach', () =>
            @da_boat.row_callout()

        @countdown()


    countdown : ->

        $countdown  = $('#countdown')
        $line       = $('#starting_line')

        setTimeout (=>
            $countdown.text 'GO'

            setInterval (=>
                $countdown.toggleClass 'flash'
            ), 200

            setTimeout (=>
                $countdown.fadeOut 'fast'
                @da_boat.$view.removeClass 'start'
                $line.addClass 'go_away'
            ), 1500
        ), 4000

        setTimeout (=>
            $countdown.text '1'
        ), 3000

        setTimeout (=>
            $countdown.text '2'
        ), 2000

        setTimeout (=>
            $countdown.text '3'
        ), 1000