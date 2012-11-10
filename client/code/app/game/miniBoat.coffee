class window.MiniBoat

    constructor : (data) ->

        @$preview   = $('#preview').find('#boats')
        @people     = data.people
        @$view      = $(ss.tmpl['game-miniBoat'].render())

        @$preview.append @$view

        @$view.click =>
            new_boat        = new Boat(data)
            new_boat.render()


    update_position : (data) ->
