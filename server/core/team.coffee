class Team
    
    constructor: () ->
        @periods = []
        @period = 0
        @personCount = 1
        @setRowInterval 1

    setRowInterval: (interval) ->
        @interval = interval
        setInterval () =>
            @evaluateRows()
            @startNewPeriod(++@period % 10)
        , 1000 * @interval

        console.log "changed interval to #{@interval}"
    
    startNewPeriod: (position) ->
        @periods[position] = 
            people: {}
            success: false

    getCurrentPeriod: () ->
        @periods[@period % 10] ||= {}
        
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
            setInterval @interval * .8
        else if @interval < .1
            setInterval .1

    row: (client) ->
        current = @getCurrentPeriod()
        current.people[client] = 0 unless current.people[client]
        current.people[client]++

module.exports = new Team()