class window.Fireworks

    constructor : ->

        #setInterval (->
        x        = Math.floor(Math.random() * 200)
        y        = Math.floor(Math.random() * 300)
        firework = new Firework(x, y)
        firework.explode()
        #), 2500


class Firework

    constructor : (@x, @y) ->

        @$sparks = []
        i = 0
        while i < 5
            rando = Math.floor(Math.random() * 3)
            spark = "<div style='top:#{@y}px; left:#{@x}px',  class='spark spark_#{rando}'></div>"

            @$sparks.push spark

            $('body').append spark
            i++


    explode : ->
        for spark in @$sparks

            # do like a low and high thing here or something
            new_x = Math.floor(Math.random() * 200)
            new_y = Math.floor(Math.random() * 200)

            $(spark).addClass 'explode'
            $(spark).css
                'x' : new_x
                'y' : new_y

        setTimeout (=>
            for spark in @$sparks
                $(spark).remove()
        ), 1500