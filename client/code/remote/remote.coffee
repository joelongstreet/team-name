class window.Remote

    constructor : ->

        ss.rpc 'system.getUserId', (userId) =>
            @identifier = userId
            $('span.code').text(@identifier)
            ss.rpc 'system.sync', 'remote'


        $('.start').click (e) =>
            $('.waiting').addClass('show')

            ss.rpc 'team.join', (err, data) =>
                console.log data
                @assign_team(data)


        ss.event.on 'start', (data) =>
            alert 'game starting'
            @start_game(data)


        ss.event.on 'end', (winner) =>
            @end_game(winner)


    assign_team : (data) ->
        if data.color
            $('.playing').find('.color').text data.color
            $('.playing').css 'backgroundColor' : data.hex

    start_game : (data) ->
        #my_team = data.id
        $('.waiting').show()
        @listener = new RowListener()
        $('.waiting').hide()
        $('.playing').addClass('show')

    end_game : (winner) ->
        #@listener.die()
        #@listener = null
            

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