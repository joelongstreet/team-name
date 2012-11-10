EventEmitter = require('events').EventEmitter

class Team extends EventEmitter

    constructor: () ->
        @periods = []
        @period = 0
        @personCount = 1
        @setRowInterval 1
        @trackCount = 10
    
    setRowInterval: (interval) ->
        @interval = interval
        newInterval = 1000 * @interval

        setInterval () =>
            @emit 'coach', @interval
            @evaluateRows()
            @startNewPeriod(++@period % @trackCount)
        , newInterval 

        console.log "changed interval to #{newInterval}"
        @emit 'interval', newInterval
        
    startNewPeriod: (position) ->
        @periods[position] = 
            people: {}
            success: false

    getCurrentPeriod: () ->
        @periods[@period % @trackCount] ||= {}
        
    evaluateRows: () ->
        current = @getCurrentPeriod()
        goodRows = 0

        #did every person have exactly 1 row in this period?
        for k,v of current.people
            goodRows++ if v is 1

        #did atleast 80% of people successfuly row?
        rowPercentage = goodRows / @personCount

        if rowPercentage > .8
            current.success = true
            @emit 'surge', @period   

        @evaluateOverallPerformance()

    evaluateOverallPerformance: () ->
        isSuperDuper = true

        #have all periods being tracked been successful as a team?
        for k,v of @periods
            if !v.success
                isSuperDuper = false
                break

        #if the team has been awesome make them go faster!
        if isSuperDuper and @interval >= .1
            @setRowInterval @interval * .8
            for k,v of @periods
                v.success = false
        else if @interval < .1
            @setRowInterval .1

    row: (client) ->
        current = @getCurrentPeriod()
        current.people[client] = 0 unless current.people[client]
        current.people[client]++

module.exports = new Team()