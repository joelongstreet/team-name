class window.Person

    constructor : (data) ->
        @$view = ss.tmpl['game-person'].render(data)