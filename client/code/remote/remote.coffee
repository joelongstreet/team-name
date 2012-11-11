class window.Remote

    constructor : ->

        ss.rpc 'system.getUserId', (userId) =>
            @identifier = userId
            $('span.code').text(@identifier)
            ss.rpc 'system.sync'

        $('.start').click (e) =>

            e.preventDefault()

            $('.waiting').addClass('show')

            ss.rpc 'team.join', (err, data) ->
                if err then alert err
                else
                    $('.waiting').find('h3').text data.sessionId
                    $('.waiting').show()

        ss.event.on 'start', (data) ->
            console.log 'server start'
            console.log data
            my_team = data.id
            @listener = new RowListener()
            $('.waiting').hide()
            $('.playing').addClass('show')

        ss.event.on 'end', (winner) ->
            console.log 'server end'
            console.log winner
            @listener.die()
            @listener = null
            

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

        window.ondevicemotion = (e) ->
                if didAccelerationChange then return

                if (typeof lastAcceleration != 'undefined')

                    currentSign = e.accelerationIncludingGravity.x >= 0 ? 1: 0
                    lastSign = lastAcceleration >= 0 ? 1 : 0

                    if (currentSign != lastSign && Math.abs(e.accelerationIncludingGravity.x) > threshold)
                        didAccelerationChange = true;
                        lastAcceleration = undefined;

                lastAcceleration = e.accelerationIncludingGravity.x;

        setInterval (->
                
            if didAccelerationChange
                ss.rpc 'remote.rowBro'


            didAccelerationChange = false;

        ), 100

    die : ->
        console.log 'should die'