class window.MiniBoat

    constructor : (data) ->

        @$preview   = $('#preview').find('#boats')
        @people     = data.people
        @$view      = $(ss.tmpl['game-miniBoat'].render())

        @$preview.append @$view

        @$view.click =>
            current_boat    = $('#watching').find('.boat')
            new_boat        = new Boat(data.people)

            if current_boat.length
                current_boat.addClass 'hide'
                setTimeout (=>
                    current_boat.remove()
                ), 500

            $('#watching').append new_boat.render()