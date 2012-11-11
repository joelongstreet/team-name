class window.Stats

    constructor : ->

    render : ->
        @$view      = $(ss.tmpl['game-stats'].render())
        @$stats     = $('#stats')
        @$stats.append @$view

        @$accuracy  = @$stats.find('.accuracy')
        @$mph       = @$stats.find('.mph')
        @$distance  = @$stats.find('.distance')
        @$screws    = @$stats.find('.screw_ups')
        

    update : (data) ->
        @$accuracy.text data.accuracy
        @$mph.text data.mph
        @$distance.text data.distance
        @$screws.text data.screwUps