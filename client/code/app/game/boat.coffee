class window.Boat

    constructor : (@people) ->

        ss.event.on 'surge', (data) =>
            @move_forward()

        ss.event.on 'coach', () =>
            @row_callout()

    render : () ->

        $people = ''
        for person in @people
            $people += ss.tmpl['game-person'].render(person)

        @$boat = $(ss.tmpl['game-boat'].render())
        @$boat.find('.people').append $people
        @$rowCallout = @$boat.find('#row')

        css_class = ''
        
        switch @people.length
            when 1 then css_class = 'one'
            when 2 then css_class = 'two'
            when 4 then css_class = 'four'
            when 6 then css_class = 'six'
            when 8 then css_class = 'eight'

        @$boat.addClass css_class
        setTimeout (=>
            @$boat.addClass 'show'
        ), 50
        
        #@$boat.addClass 'start'

        return @$boat

    move_forward : ->

        $boat.addClass 'row'
        setTimeout (->
            $boat.removeClass 'row'
        ), 500

    row_callout : ->
        @$rowCallout.removeClass 'call'
    
        setTimeout () =>
            @$rowCallout.addClass 'call'
        , 0