class window.Stats

    constructor : ->

    render : ->
        @$view = $(ss.tmpl['game-stats'].render())
        $('#stats').append @$view

    update : (data) ->
        console.log data