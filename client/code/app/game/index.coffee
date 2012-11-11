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

        game_started = false
        ss.event.on 'start', (data) =>
            if game_started is false
                game_started = true
                @start_game(data)
                setTimeout (->
                    game_started = false
                ), 3000

        # Listen and assign events
        ss.event.on 'surge', (team, surge_data) =>

            if team.id == @da_boat.id
                @da_boat.move_forward()
                @stats.update(surge_data)
            else
                for boat in @mini_boats
                    if team.id == boat.id
                        boat.update_position(surge_data.surge)

        ss.event.on 'end', () =>
            @end_game()


    start_game : (data) ->
        @countdown()

        # Build out mini boats for preview section
        @mini_boats = []
        $('#boats').empty()
        for boat in data.teams
            if boat.id == token
                # Set the default selected boat as the first mini boat
                @da_boat = new Boat(data.teams[0])
                @da_boat.render()
                @da_boat.$view.addClass 'start'
            @mini_boats.push new MiniBoat(boat)

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
            $('#checkered_flag').toggleClass 'wave'
            if iterator == 5
                #clearInterval wave_flags
                #$('.boat').fadeOut('slow')
                #$('#checkered_flag').fadeOut('fast')
                window.location.reload()

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