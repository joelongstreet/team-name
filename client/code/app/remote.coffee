class window.Remote

    constructor : -> 

        $('.start').click =>
            ss.rpc 'team.join', (err, team_id) ->
                if err then alert err
                else
                    console.log team_id
                    $('.waiting').show()

        ss.event.on 'start', (data) ->
            console.log 'server start'
            console.log data
            my_team = data.id
            @listener = new RowListener()

        ss.event.on 'end', (winner) ->
            console.log 'server end'
            console.log winner
            @listener.die()
            @listener = null

        @listener = new RowListener()


class RowListener

    constructor : ->

        lastAcceleration        = undefined;
        didAccelerationChange   = false;
        threshold               = 3;

        window.addEventListener 'touchstart', ->
            clearTimeout touchTimeout
            touchTimeout    = null;
            isHeldDown      = true;

        window.addEventListener 'touchend', ->

            if touchTimeout then return

            touchTimeout = setTimeout (->
                isHeldDown      = false;
                touchTimeout    = null;
                    
                ss.rpc 'remote.broDown'
            ), 3000

        window.ondevicemotion = ->
                if didAccelerationChange then return

                if (typeof lastAcceleration != 'undefined')

                    currentSign = e.acceleration.x >= 0 ? 1: 0
                    lastSign = lastAcceleration >= 0 ? 1 : 0

                    if (currentSign != lastSign && Math.abs(e.acceleration.x) > threshold)
                        didAccelerationChange = true;
                        lastAcceleration = undefined;

                lastAcceleration = e.acceleration.x;

        setInterval (->
                
            if didAccelerationChange
                ss.rpc 'remote.rowBro'

            didAccelerationChange = false;

        ), 100

    die : ->
        console.log 'should die'