class exports.Fireworks

    constructor : ->

        setInterval (->
            x        = Math.floor(Math.random() * 200)
            y        = Math.floor(Math.random() * 300)
            firework = new Firework(x, y)
            firework.explode()
        ), 1500


class Firework

    constructor : (@x, @y) ->

        @$sparks = []
        i = 0
        while i < 5
            rando = Math.floor(Math.random() * 3)
            spark = "<div style='top:#{@y}; left:#{@x}',  class='spark spark_#{rando}'></div>"

            @$sparks.push spark

            $('#fireworks').append spark


    explode : ->
        for spark in @$sparks

            # do like a low and high thing here or something
            new_x = Math.floor(Math.random() * 200)
            new_y = Math.floor(Math.random() * 200)

            spark.addClass 'explode'
            spark.css
                'x' : new_x
                'y' : new_y

        setTimeout (=>
            for spark in @$sparks
                spark.remove()
        ), 1500