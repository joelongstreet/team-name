EventEmitter = require('events').EventEmitter

class Team extends EventEmitter

    constructor: (@id, @teamSize = 1) ->
        @periods = []
        @period = 0
        @interval = 1
        @trackCount = 5
        @persons = []
        @surge = 0
    
    start: () ->
        console.log "#{@id} started!"
        @setRowInterval @interval

    setRowInterval: (interval) ->
        @interval = interval
        newInterval = 1000 * @interval

        setInterval () =>
            @emit 'coach', @interval
            @evaluateRows()
            @startNewPeriod(++@period % @trackCount)
        , newInterval 

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
        screwUps = []
        for k,v of current.people
            if v is 1
                goodRows++ 
            else 
                screwUps.push k

        #did atleast 80% of people successfuly row?
        rowPercentage = goodRows / @persons.length

        if rowPercentage > .8
            current.success = true
            @emit 'surge', 
                accuracy: rowPercentage
                period: @period
                mph: @interval / 10
                surge: ++@surge
                screwUps: screwUps

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
    
    broDown: (person) ->

    row: (person) ->
        currentPeriod = @getCurrentPeriod()
        currentPeriod.people[person.socketId] ||= 0 
        currentPeriod.people[person.socketId]++
    
    disband: () ->
        @removeListeners()
        
    addPerson: (socketId, sessionId) ->
        full = @isFull() 
        return false if full
        
        person = 
            socketId: socketId
            sessionId: sessionId
        
        @persons.push person
        @emit 'full' if @isFull()  
        return true

    isFull: () ->
        @persons.length == @teamSize

module.exports = Team