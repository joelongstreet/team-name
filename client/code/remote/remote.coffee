audio = require '/audio'

class window.Remote

    constructor : ->

        #stop the window from being scrolled
        document.addEventListener 'touchmove',
          (e)-> 
            e.preventDefault()
          false

        ss.rpc 'system.getUserId', (userId) =>
            $('.start').show()
            @identifier = userId
            $('span.code, .reminder').text(@identifier)
            ss.rpc 'system.sync', 'remote'
        
        $('.tapper').click (e) =>
            if @listener
                ss.rpc 'remote.rowBro'
        
        $('.start').click (e) =>
            $('.waiting').addClass('show')

            ss.rpc 'team.join', (err, data) =>
                console.log data
                @assign_team(data)

        game_started = false
        
        ss.event.on 'coach', () =>
            @listener = new RowListener() if !@listener
            game_started = true
            $('.playing').addClass('show')

        ss.event.on 'start', (data) =>
            if game_started is false
                game_started = true
                @start_game(data)

        ss.event.on 'end', (winner) =>
            @end_game(winner)


    assign_team : (data) ->
        if data.color
            $('.playing').find('.color').text data.color
            $('.playing').css 'backgroundColor' : data.hex

    start_game : (data) ->
        $('.waiting').show()
        $('.waiting').hide()
        $('.playing').addClass('show')
        @listener = new RowListener()

    end_game : (winner) ->
        @listener?.die()
        @listener = null
            
class RowListener

    constructor : ->

        lastAcceleration        = undefined;
        didAccelerationChange   = false;
        threshold               = 15;

        window.addEventListener 'touchstart', ->
            clearTimeout touchTimeout
            touchTimeout    = null;
            isHeldDown      = true;

        window.addEventListener 'touchend', ->
            if touchTimeout then return

            touchTimeout = setTimeout ->
                isHeldDown      = false;
                touchTimeout    = null;
                ss.rpc 'remote.broDown'
            , 3000

        window.ondevicemotion = (e) ->
            if didAccelerationChange then return
            
            if typeof lastAcceleration != 'undefined'
                currentSign = e.accelerationIncludingGravity.x >= 0 ? 1: 0
                lastSign = lastAcceleration >= 0 ? 1 : 0

                if (currentSign != lastSign && Math.abs(e.accelerationIncludingGravity.x) > threshold)
                    didAccelerationChange = true;
                    lastAcceleration = undefined;

            lastAcceleration = e.accelerationIncludingGravity.x;

        @listenerInterval = setInterval ->
            if didAccelerationChange
                ss.rpc 'remote.rowBro'

            didAccelerationChange = false;
        , 100

    die: ->
        window.location.reload()
