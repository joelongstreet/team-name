class window.Game

    constructor : () ->

        @$view = $(ss.tmpl['game-index'].render())

        # Reset the Entire Stage
        $('body').attr 'id', ''
        $('body').attr 'class', ''
        $('body').empty()
        $('body').append @$view

        # Build out Stats Module
        @stats = new Stats()
        @stats.render()

        ss.event.on 'start', (data) =>
            @start_game(data)

        # Listen and assign events
        ss.event.on 'surge', (surge_data) =>
            if surge_data.id == @da_boat.id
                @da_boat.move_forward()
                @stats.update(surge_data)
                @move_forward()
            else
                for boat in @mini_boats
                    if surge_data.id == boat.id
                        boat.update_position(surge_data.position)


    start_game : (data) ->
        @countdown()

        # Build out mini boats for preview section
        @mini_boats = []
        for boat in data.teams
            @mini_boats.push new MiniBoat(boat)

        # Set the default selected boat as the first mini boat
        @da_boat = new Boat(data.teams[0])
        @da_boat.render()
        @da_boat.$view.addClass 'start'

        # Row Call Out
        ss.event.on 'coach', () =>
            @da_boat.row_callout()
            

    end_game : ->
        $('#finish_line').addClass 'show'
        $('h1#row').fadeOut('fast')
        $('#checkered_flag').fadeIn('fast')

        # wave the flag
        iterator = 0
        wave_flags = setInterval (->
            if iterator == 5
                clearInterval wave_flags
                $('.boat').fadeOut('slow')
                $('#waiting').fadeIn('slow')
                $('#checkered_flag').fadeOut('fast')
            $('#checkered_flag').toggleClass 'wave'

            iterator++
        ), 750
        

    countdown : ->
        countdown_int = null
        $countdown  = $('#countdown')
        $line       = $('#starting_line')

        setTimeout (=>
            $countdown.text 'GO'

            countdown_int = setInterval (=>
                $countdown.toggleClass 'flash'
            ), 200

            setTimeout (=>
                $countdown.fadeOut 'fast'
                @da_boat.$view.removeClass 'start'
                $line.addClass 'go_away'
                clearInterval countdown_int
            ), 1500
        ), 4000

        setTimeout (=>
            $countdown.text '1'
        ), 3000

        setTimeout (=>
            $countdown.text '2'
        ), 2000

        setTimeout (=>
            $countdown.find('waiting').remove()
            $countdown.text '3'
        ), 1000